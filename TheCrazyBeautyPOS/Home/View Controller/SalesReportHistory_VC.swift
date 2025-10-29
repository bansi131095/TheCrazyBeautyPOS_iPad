//
//  SalesReportHistory_VC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 18/07/25.
//

import UIKit
import FSCalendar

class SalesReportHistory_VC: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var txt_FromDate: UITextField!
    @IBOutlet weak var txt_ToDate: UITextField!
    @IBOutlet weak var txt_search: UITextField!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var lbl_NoDataFound: UILabel!
    @IBOutlet weak var tbl_vw: UITableView!
    
    var calendarVC: UIViewController?
    var firstDate: Date?
    var lastDate: Date?
    var datesRange: [Date] = []
    var selectingDateFor: UITextField?
    var calendar: FSCalendar!
    
    var salesHistoryList: [SalesHistoryDateModel] = []
    
    var searchWorkItem: DispatchWorkItem?
    var currentPage = 1
    var isLoadingMore = false
    var hasMoreData = true
    var deleteShownSales = false
    var years: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentYear = Calendar.current.component(.year, from: Date())
        years = Array(1900...currentYear)
        contentViewWidthConstraint.constant = 600
        setTableView()
        self.txt_search.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        setDefaultDateRangeAndFetch()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Button Action
    @IBAction func btn_Calender(_ sender: UIButton) {
        if sender.tag == 1 {
            selectingDateFor = txt_FromDate
        } else {
            selectingDateFor = txt_ToDate
        }
        showCalendarPopup(sourceView: sender as! UIView)
    }
    
    
    
    func setDefaultDateRangeAndFetch() {
        let currentDate = Date()
        let calendar = Calendar.current
        
        guard let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: currentDate) else { return }

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy" // Match your existing format

        txt_FromDate.text = formatter.string(from: oneMonthAgo)
        txt_ToDate.text = formatter.string(from: currentDate)

        firstDate = oneMonthAgo
        lastDate = currentDate

        salesHistoryData(Search: "")
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        /*searchWorkItem?.cancel()

        let newWorkItem = DispatchWorkItem { [weak self] in
            self?.salesHistoryData(Search: textField.text ?? "")
        }

        searchWorkItem = newWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: newWorkItem)*/
        self.salesHistoryData(Search: textField.text ?? "")
    }
    
    func setTableView(){
        tbl_vw.register(UINib(nibName: "SalesHistoryCell", bundle: nil), forCellReuseIdentifier: "SalesHistoryCell")
        tbl_vw.register(UINib(nibName: "SalesHistoryHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "SalesHistoryHeaderCell")
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

        calendar.reloadData()
        if let from = firstDate, let to = lastDate {
            let selectedDates = getDateRange(from: from, to: to)
            for date in selectedDates {
                calendar.select(date)
            }
        }
        calendarVC?.view.addSubview(calendar)

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
    
    /*func salesHistoryData() {
        guard let fromDateString = self.txt_FromDate.text,
              let toDateString = self.txt_ToDate.text,
              let fromDate = convertStringToDate(fromDateString),
              let toDate = convertStringToDate(toDateString) else {
            print("Invalid date format")
            return
        }

        let formattedFrom = formatDateToString(fromDate)
        let formattedTo = formatDateToString(toDate)
        
        
        APIService.shared.SalesPaymentHistory(vendor_id: LocalData.userId, start_date: formattedFrom, end_date: formattedTo, limit: "10", page: "1", customer_type: "", search: "", staff_id: "") { result in
            guard let model = result else {
                print("API failed or empty response")
                self.salesHistoryList = []
                self.tbl_vw.reloadData()
                self.lbl_NoDataFound.isHidden = false
                return
            }

            self.salesHistoryList = model.data
            if let parentVC = self.parent as? ReportVC {
                parentVC.updateTotalAmount(text: "\(SharedPrefs.getSymbol())" + (result?.totalAmount ?? ""))
            }
            // Show/Hide No Data Label
            if self.salesHistoryList.isEmpty {
                self.lbl_NoDataFound.isHidden = false
            } else {
                self.lbl_NoDataFound.isHidden = true
            }
            
            self.tbl_vw.reloadData()
        }
    }*/
    
    func salesHistoryData(Search: String, isPagination: Bool = false) {
        guard let fromDateString = self.txt_FromDate.text,
              let toDateString = self.txt_ToDate.text,
              let fromDate = convertStringToDate(fromDateString),
              let toDate = convertStringToDate(toDateString) else {
            print("Invalid date format")
            return
        }

        let formattedFrom = formatDateToString(fromDate)
        let formattedTo = formatDateToString(toDate)

        if isPagination {
            self.isLoadingMore = true
        } else {
            self.currentPage = 1
            self.salesHistoryList.removeAll()
            self.hasMoreData = true
//            showLoader()
        }

        APIService.shared.SalesPaymentHistory(vendor_id: LocalData.userId,start_date: formattedFrom,end_date: formattedTo,limit: "10",page: "\(currentPage)",customer_type: "",search: Search,staff_id: "") { result in
            self.hideLoader()
            self.isLoadingMore = false

            guard let model = result else {
                self.salesHistoryList = []
                self.lbl_NoDataFound.isHidden = false
                self.tbl_vw.reloadData()
                return
            }

            self.salesHistoryList += model.data
            self.currentPage += 1
            self.hasMoreData = !model.data.isEmpty

            if let parentVC = self.parent as? ReportVC {
                parentVC.updateTotalAmount(text: "\(SharedPrefs.getSymbol())" + (result?.totalAmount ?? ""))
            }

            self.lbl_NoDataFound.isHidden = !self.salesHistoryList.isEmpty
            self.tbl_vw.reloadData()
        }
    }

    func deleteBookings(Booking_Id: String){
        APIService.shared.DeleteBooking(vendor_id: LocalData.userId, booking_id: Booking_Id) { result in
            guard let model = result else {
                return
            }
            self.hideLoader()
            if model.error == "" || model.error == nil {
                DispatchQueue.main.async {
                    // safe UI code here
                    self.showToast(message: model.data)
                }
                self.salesHistoryData(Search: "")
            } else {
                self.show_alert(msg: model.error ?? "", title: "Delete Team")
            }
        }
    }
}

extension SalesReportHistory_VC: FSCalendarDelegate, FSCalendarDataSource {
    
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
            txt_FromDate.text = formatter.string(from: firstDate!)
            txt_ToDate.text = formatter.string(from: lastDate!)

//            serviceReport()
//            salesHistoryData()
            salesHistoryData(Search: "")
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
    
    /*func deleteWalkingHistory(walkinId: Int){
        APIService.shared.deleteWalkin(WalkinId: walkinId) { result in
            guard let model = result else {
                return
            }
            self.hideLoader()
            if model.error == "" || model.error == nil {
                DispatchQueue.main.async {
                    // safe UI code here
                    self.showToast(message: model.data)
                }
                self.WalkinHistory()
            } else {
                self.show_alert(msg: model.error ?? "", title: "Delete Team")
            }
        }
    }*/
    
    
    
}

extension SalesReportHistory_VC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.salesHistoryList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SalesHistoryHeaderCell") as? SalesHistoryHeaderCell else {
                return nil
            }
            return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbl_vw.dequeueReusableCell(withIdentifier: "SalesHistoryCell", for: indexPath) as? SalesHistoryCell else {
            return UITableViewCell()
        }
        let data = self.salesHistoryList[indexPath.item]
        cell.lbl_ID.text = data.booking_number
        cell.lbl_Name.text = data.name.capitalized
        cell.lbl_Date.text = data.booking_date
        cell.lbl_Time.text = data.booking_time
        cell.lbl_Type.text = data.customer_type.capitalized
        cell.lbl_Staff.text = data.staff_names.capitalized
        
        if data.booking_status.capitalized == "Completed"{
            cell.lbl_Status.textColor = UIColor.green
            cell.btn_Mail.isHidden = false
//            cell.btn_Delete.isHidden = false
        }else{
            cell.lbl_Status.textColor = #colorLiteral(red: 1, green: 0.2941176471, blue: 0.3333333333, alpha: 1)
            cell.btn_Mail.isHidden = true
//            cell.btn_Delete.isHidden = true
        }
        cell.lbl_Status.text = data.booking_status.capitalized
        
        if data.payment_type == ""{
            cell.lbl_Payment.text = "N/A"
        }else{
            cell.lbl_Payment.text = data.payment_type.capitalized
        }
        
        if data.tip == 0 {
            cell.lbl_Tip.text = "N/A"
        }else{
//            cell.lbl_Tip.text = "\(SharedPrefs.getSymbol())" + String(Double(data.tip))
            cell.lbl_Tip.text = "\(SharedPrefs.getSymbol())" + String(format: "%.2f", Double(data.tip))
        }
//        cell.lbl_Total.text = "\(SharedPrefs.getSymbol())" +  String(Double(data.grand_total)!)
        cell.lbl_Total.text = "\(SharedPrefs.getSymbol())" +  String(format: "%.2f", Double(data.grand_total) ?? 0.0)
        
        if deleteShownSales && data.booking_status.capitalized == "Completed" && data.payment_type.capitalized == "Cash"{
            cell.btn_Delete.isHidden = false
        } else {
            cell.btn_Delete.isHidden = true
        }

        cell.Act_Action = {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "Appointment_DetailsVC") as? Appointment_DetailsVC {
                vc.model = data
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true)
            }
        }
        
        cell.Act_Delete = {
            let popup = ConfirmDeletePopupVC()
            popup.modalPresentationStyle = .overFullScreen
            popup.modalTransitionStyle = .crossDissolve
            popup.titleText = "Are you sure you want to delete this booking?"
            popup.onConfirm = {
                // Call your delete logic here
                self.deleteBookings(Booking_Id: String(data.id))
            }
            self.present(popup, animated: true, completion: nil)
        }
        
        cell.Act_Mail = {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "Email_InvoiceVC") as? Email_InvoiceVC {
                vc.booking_ID = "\(data.id)"
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true)
            }
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if offsetY > contentHeight - frameHeight - 400 {
            if !isLoadingMore && hasMoreData {
                self.salesHistoryData(Search: txt_search.text ?? "", isPagination: true)
            }
        }
    }

    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if isLoadingMore {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            return spinner
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return isLoadingMore ? 50 : 0
    }
    
}


protocol SalesReportDownloadable {
    var fromDate: String? { get }
    var toDate: String? { get }
    func downloadSalesReport(startDate: String, endDate: String)
}


extension SalesReportHistory_VC: SalesReportDownloadable {
    
    var fromDate: String? {
        return txt_FromDate.text
    }
    
    var toDate: String? {
        return txt_ToDate.text
    }

    func downloadSalesReport(startDate: String, endDate: String) {
        let vendorID = LocalData.userId
        
        APIService.shared.downloadBookingHistoryReport(vendor_id: vendorID,start_date: startDate,end_date: endDate,customer_type: "") { model in
            guard let filename = model?.filename else {
                self.alertWithMessageOnly("Download failed")
                return
            }

            let urlPath = "\(global.reportUrl)\(filename)"
            self.downloadAndSaveFile(urlString: urlPath, in: self)
        }
    }
}

extension SalesReportHistory_VC: UIPickerViewDelegate, UIPickerViewDataSource {

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
