//
//  Team_ReportVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 17/07/25.
//

import UIKit
import DropDown
import FSCalendar


class Team_ReportVC: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var txt_SelectStaff: UITextField!
    @IBOutlet weak var txt_FromDate: UITextField!
    @IBOutlet weak var txt_ToDate: UITextField!
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var lbl_NoDataFound: UILabel!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    var TeamDetails: [TeamDetailsModel] = []
    let dropDown = DropDown()
    
    var salesData: [SalesDateModel] = []
    
    var calendarVC: UIViewController?
    var firstDate: Date?
    var lastDate: Date?
    
    var datesRange: [Date] = []
    var selectingDateFor: UITextField?
    var calendar: FSCalendar!
    var years: [Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentYear = Calendar.current.component(.year, from: Date())
        years = Array(1900...currentYear)
        contentViewWidthConstraint.constant = 50
        txt_SelectStaff.text = NSLocalizedString("Select Staff", comment: "")
        get_TeamDetails()
        setDefaultDateRangeAndFetch()
        setTableView()
    }
    
    func get_TeamDetails(){
        showLoader()
        APIService.shared.fetchTeamDetails(vendorId: LocalData.userId) { result in
            self.hideLoader()
            self.TeamDetails = result?.data ?? []
            var names = self.TeamDetails.map { $0.first_name }
//            names.insert("Select Staff", at: 0)
            names.insert(NSLocalizedString("Select Staff", comment: ""), at: 0)
            self.dropDown.dataSource = names
            self.dropDown.textFont = UIFont(name: "Lato-Regular", size: 18.0)!
            self.dropDown.backgroundColor = .white
        }
    }
    
    func get_SalesData(staff_id: String){
        guard let fromDateString = self.txt_FromDate.text,
              let toDateString = self.txt_ToDate.text,
              let fromDate = convertStringToDate(fromDateString),
              let toDate = convertStringToDate(toDateString) else {
            print("Invalid date format")
            return
        }

        let formattedFrom = formatDateToString(fromDate)
        let formattedTo = formatDateToString(toDate)
        showLoader()
        APIService.shared.SalesDataGet(vendor_id: LocalData.userId, staff_id: staff_id, limt: "10", page: "1", start_date: formattedFrom, end_date: formattedTo) { result in
            self.hideLoader()
            guard let model = result else {
                print("API failed or empty response")
                self.salesData = []
                self.tbl_vw.reloadData()
                self.lbl_NoDataFound.isHidden = false
                return
            }

            self.salesData = model.data
            if let parentVC = self.parent as? ReportVC {
                parentVC.updateTotalAmount(text: "\(SharedPrefs.getSymbol())" + "\(result?.totalsales ?? 0).00")
            }
            // Show/Hide No Data Label
            if self.salesData.isEmpty {
                self.lbl_NoDataFound.isHidden = false
            } else {
                self.lbl_NoDataFound.isHidden = true
            }
            self.tbl_vw.reloadData()
        }
    }
    
    @IBAction func btn_SelectStaff(_ sender: Any) {
        dropDown.anchorView = txt_SelectStaff
        
        dropDown.bottomOffset = CGPoint(x: 0, y: txt_SelectStaff.bounds.height)
        dropDown.direction = .bottom
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_SelectStaff.text = item
            
            if index == 0 {
                get_SalesData(staff_id: "")
            } else {
                let selectedStaff = TeamDetails[index - 1]
                self.get_SalesData(staff_id: "\(selectedStaff.id)")
            }
        }
        dropDown.show()
    }
    
    @IBAction func btn_Calender(_ sender: UIButton) {
        if sender.tag == 1 {
            selectingDateFor = txt_FromDate
        } else {
            selectingDateFor = txt_ToDate
        }
        showCalendarPopup(sourceView: sender as! UIView)
    }
    
    //MARK: -  Function
    func setDefaultDateRangeAndFetch() {
        let currentDate = Date()
        let calendar = Calendar.current
        
        guard let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: currentDate) else { return }

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy" // Match your existing format
        formatter.locale = Locale(identifier: "en_US_POSIX")
//        formatter.locale = Locale(identifier: L102Language.currentAppleLanguage())
        txt_FromDate.text = formatter.string(from: oneMonthAgo)
        txt_ToDate.text = formatter.string(from: currentDate)

        firstDate = oneMonthAgo
        lastDate = currentDate

        get_SalesData(staff_id: "")
    }

    
    func setTableView(){
        tbl_vw.register(UINib(nibName: "TeamReportCell", bundle: nil), forCellReuseIdentifier: "TeamReportCell")
        tbl_vw.register(UINib(nibName: "TeamReportHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "TeamReportHeaderCell")
        tbl_vw.delegate = self
        tbl_vw.dataSource = self
        tbl_vw.rowHeight = UITableView.automaticDimension
        tbl_vw.estimatedRowHeight = 60
    }
    
    func showCalendarPopup(sourceView: UIView) {
        calendarVC = UIViewController()
        calendarVC?.modalPresentationStyle = .popover
        calendarVC?.preferredContentSize = CGSize(width: 500, height: 400)

        calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 500, height: 400))
        calendar.delegate = self
        calendar.dataSource = self
        calendar.allowsMultipleSelection = true
        calendar.appearance.titleDefaultColor = .black
        calendar.appearance.selectionColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
        calendar.appearance.todayColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
        calendar.today = nil
        calendar.locale = Locale(identifier: "en_US_POSIX")
//        calendar.locale = Locale(identifier: L102Language.currentAppleLanguage())
        calendar.reloadData()
        if let from = firstDate, let to = lastDate {
            let selectedDates = getDateRange(from: from, to: to)
            for date in selectedDates {
                calendar.select(date)
            }
        }
        guard let calendarVC = calendarVC else { return }
        calendarVC.view.addSubview(calendar)

        // ✅ Year tap area over calendar header
        let headerTapButton = UIButton()
        headerTapButton.backgroundColor = .clear
        headerTapButton.translatesAutoresizingMaskIntoConstraints = false
        headerTapButton.addTarget(self, action: #selector(headerTapped), for: .touchUpInside)
        calendarVC.view.addSubview(headerTapButton)

        // 📌 Constraints
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: calendarVC.view.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: calendarVC.view.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: calendarVC.view.trailingAnchor),
            calendar.bottomAnchor.constraint(equalTo: calendarVC.view.bottomAnchor),

            headerTapButton.topAnchor.constraint(equalTo: calendar.topAnchor, constant: 20),
            headerTapButton.leadingAnchor.constraint(equalTo: calendar.leadingAnchor),
            headerTapButton.trailingAnchor.constraint(equalTo: calendar.trailingAnchor),
            headerTapButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        if let popover = calendarVC.popoverPresentationController {
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
            popover.permittedArrowDirections = .any
            popover.delegate = self
        }

        self.present(calendarVC, animated: true)
        
        /*calendarVC?.view.addSubview(calendar)

        if let popover = calendarVC?.popoverPresentationController {
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
            popover.permittedArrowDirections = .up
        }
        self.present(calendarVC!, animated: true, completion: nil)*/
    }
    
    @objc func headerTapped() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }

            let alert = UIAlertController(title: "Select Month & Year", message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)

            let picker = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 160))
            picker.dataSource = self
            picker.delegate = self
            alert.view.addSubview(picker)

            // ✅ Get current month and year from calendar
            let currentDate = self.calendar.currentPage
            let currentMonth = Calendar.current.component(.month, from: currentDate)
            let currentYear = Calendar.current.component(.year, from: currentDate)

            // ✅ Set picker default position
            if let yearIndex = self.years.firstIndex(of: currentYear) {
                picker.selectRow(currentMonth - 1, inComponent: 0, animated: false)
                picker.selectRow(yearIndex, inComponent: 1, animated: false)
            }

            // ✅ Add Done & Cancel buttons
            let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
                let selectedMonth = picker.selectedRow(inComponent: 0) + 1
                let selectedYear = self.years[picker.selectedRow(inComponent: 1)]

                var components = DateComponents()
                components.year = selectedYear
                components.month = selectedMonth
                components.day = 1

                if let newDate = Calendar.current.date(from: components) {
                    self.calendar.setCurrentPage(newDate, animated: true)
                }
            }

            alert.addAction(doneAction)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            // ✅ Present the alert safely from calendarVC
            self.calendarVC?.present(alert, animated: true)
        }
    }

}

extension Team_ReportVC: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if firstDate == nil {
            firstDate = date
            calendar.select(date)
        } else if firstDate != nil && lastDate == nil {
            if date < firstDate! {
                lastDate = firstDate
                firstDate = date
            } else {
                lastDate = date
            }

            // Select range
            let range = getDateRange(from: firstDate!, to: lastDate!)
            for d in range {
                calendar.select(d)
            }

            // 👇 Update here: Format as "MMM d, yyyy"
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            txt_FromDate.text = formatter.string(from: firstDate!)
            txt_ToDate.text = formatter.string(from: lastDate!)

            get_SalesData(staff_id: "")
            calendarVC?.dismiss(animated: true, completion: nil)
            
        } else {
            for selected in calendar.selectedDates {
                calendar.deselect(selected)
            }
            firstDate = date
            lastDate = nil
            calendar.select(date)

            txt_FromDate.text = ""
            txt_ToDate.text = ""
        }
    }

    func getDateRange(from: Date, to: Date) -> [Date] {
        var dates: [Date] = []
        var currentDate = from
        let calendar = Calendar.current

        while currentDate <= to {
            dates.append(currentDate)
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDate
        }
        return dates
    }
}


extension Team_ReportVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.salesData.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TeamReportHeaderCell") as? TeamReportHeaderCell else {
                return nil
            }
            return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbl_vw.dequeueReusableCell(withIdentifier: "TeamReportCell", for: indexPath) as? TeamReportCell else {
            return UITableViewCell()
        }
        let data = self.salesData[indexPath.item]
        cell.lbl_Id.text = "\(indexPath.row+1)"
        cell.lbl_CustomerName.text = data.customer_name.capitalized
        cell.lbl_StaffName.text = data.staff_name
        cell.lbl_ServiceName.text = data.service_name
//        cell.lbl_Price.text = "\(SharedPrefs.getSymbol())" + String(Double(data.price))
        cell.lbl_Price.text = "\(SharedPrefs.getSymbol())" + String(format: "%.2f", Double(data.price))
        return cell
    }
}

protocol ReportDownloadable {
    var fromDate: String? { get }
    var toDate: String? { get }
    func downloadReport(startDate: String, endDate: String)
}


extension Team_ReportVC: ReportDownloadable {
    
    var fromDate: String? {
        return txt_FromDate.text
    }
    
    var toDate: String? {
        return txt_ToDate.text
    }

    func downloadReport(startDate: String, endDate: String) {
        let vendorID = LocalData.userId
        let staff_id = "" // If dynamic, pass it accordingly
        showLoader()
        APIService.shared.downloadSalesReport(vendor_id: vendorID,start_date: startDate,end_date: endDate,
        staff_id: staff_id) { model in
            self.hideLoader()
            guard let filename = model?.filename else {
                self.alertWithMessageOnly(NSLocalizedString("Download failed",comment: ""))
                return
            }

            let urlPath = "\(global.reportUrl)\(filename)"
            self.downloadAndSaveFile(urlString: urlPath, in: self)
        }
    }
}

extension Team_ReportVC: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}


/*extension Team_ReportVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    var months: [String] {
        return [
            "January", "February", "March", "April", "May", "June",
            "July", "August", "September", "October", "November", "December"
        ]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2 // Month + Year
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? months.count : years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? months[row] : "\(years[row])"
    }
}*/



/*extension Team_ReportVC: UIPickerViewDelegate, UIPickerViewDataSource {

    var months: [String] {
        return [
            "January", "February", "March", "April", "May", "June",
            "July", "August", "September", "October", "November", "December"
        ]
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2 // Month + Year
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? months.count : years.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? months[row] : "\(years[row])"
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return component == 0 ? 140 : 80
    }
}*/

extension Team_ReportVC: UIPickerViewDelegate, UIPickerViewDataSource {

    var months: [String] {
        return [
            "January", "February", "March", "April", "May", "June",
            "July", "August", "September", "October", "November", "December"
        ]
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2 // Month + Year
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? months.count : years.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? months[row] : "\(years[row])"
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return component == 0 ? 140 : 80
    }
}
