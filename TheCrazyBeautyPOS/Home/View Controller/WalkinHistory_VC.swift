//
//  WalkinHistory_VC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 21/07/25.
//

import UIKit
import FSCalendar


class WalkinHistory_VC: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var txt_FromDate: UITextField!
    @IBOutlet weak var txt_ToDate: UITextField!
    
    @IBOutlet weak var scroll_vw: UIScrollView!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lbl_NoDataFound: UILabel!
    @IBOutlet weak var tbl_vw: UITableView!
    
    var calendarVC: UIViewController?
    var firstDate: Date?
    var lastDate: Date?
    var datesRange: [Date] = []
    var selectingDateFor: UITextField?
    var calendar: FSCalendar!
    
    var WalkingList: [WalkinHistoryDateModel] = []
    var deleteShownSales = false
    var years: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentYear = Calendar.current.component(.year, from: Date())
        years = Array(1900...currentYear)
        contentViewWidthConstraint.constant = 880
        self.setTableView()
        setDefaultDateRangeAndFetch()
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
    
    //MARK: -  Function
    func setDefaultDateRangeAndFetch() {
        let currentDate = Date()
        let calendar = Calendar.current
        
//        guard let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: currentDate) else { return }
        
        guard let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: currentDate),
              let fromDate = calendar.date(byAdding: .day, value: 1, to: oneMonthAgo)
        else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy" // Match your existing format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        txt_FromDate.text = formatter.string(from: fromDate)
        txt_ToDate.text = formatter.string(from: currentDate)

        firstDate = fromDate
        lastDate = currentDate

        self.WalkinHistory()
    }
    
    func setTableView(){
        tbl_vw.register(UINib(nibName: "WalkinHistoryCell", bundle: nil), forCellReuseIdentifier: "WalkinHistoryCell")
        tbl_vw.register(UINib(nibName: "WalkinHistoryHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "WalkinHistoryHeaderCell")
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
        
    }
    
    @objc func headerTapped() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }

            let alert = UIAlertController(title: NSLocalizedString("Select Month & Year", comment: ""), message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)

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
            let doneAction = UIAlertAction(title: NSLocalizedString("Done",comment: ""), style: .default) { _ in
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
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel",comment: ""), style: .cancel, handler: nil))

            // ✅ Present the alert safely from calendarVC
            self.calendarVC?.present(alert, animated: true)
        }
    }
    
    func WalkinHistory() {
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
        APIService.shared.WalkinHistoryGet(vendor_id: LocalData.userId, limt: "100000", page: "1", start_date: formattedFrom, end_date: formattedTo) { result in
            self.hideLoader()
            guard let model = result else {
                print("API failed or empty response")
                self.WalkingList = []
                self.tbl_vw.reloadData()
                self.lbl_NoDataFound.isHidden = false
                return
            }

            self.WalkingList = model.data
            
            if let parentVC = self.parent as? ReportVC {
                parentVC.updateTotalAmount(text: "\(SharedPrefs.getSymbol())" + (result?.total_sales ?? ""))
            }
        
            
            if self.WalkingList.isEmpty {
                self.lbl_NoDataFound.isHidden = false
            } else {
                self.lbl_NoDataFound.isHidden = true
            }
            
            self.tbl_vw.reloadData()
        }
    }
    
    func deleteWalkingHistory(walkinId: Int){
        APIService.shared.deleteWalkin(WalkinId: walkinId) { result in
            guard let model = result else {
                return
            }
            self.hideLoader()
            if model.error == "" || model.error == nil {
                DispatchQueue.main.async {
                    self.alertWithMessageOnly(NSLocalizedString("Walkin appointment deleted successfully",comment: ""))
                }
                self.WalkinHistory()
            } else {
                self.alertWithMessageOnly(NSLocalizedString("Failed to delete walkin appointment",comment: ""))
            }
        }
    }
}

extension WalkinHistory_VC: FSCalendarDelegate, FSCalendarDataSource {
    
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

            WalkinHistory()
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
    
    func localizedPaymentTypes(from paymentString: String) -> String {
        let types = paymentString.split(separator: ",")
        
        let localizedTypes = types.map { type -> String in
            let key = type
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()   // giftcard, cash, card
            
            return NSLocalizedString(key, comment: "")
        }
        
        return localizedTypes.joined(separator: ", ")
    }



}

extension WalkinHistory_VC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.WalkingList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "WalkinHistoryHeaderCell") as? WalkinHistoryHeaderCell else {
                return nil
            }
            return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbl_vw.dequeueReusableCell(withIdentifier: "WalkinHistoryCell", for: indexPath) as? WalkinHistoryCell else {
            return UITableViewCell()
        }
        let data = self.WalkingList[indexPath.item]
        cell.lbl_ID.text = data.booking_number
        cell.lbl_Date.text = data.created_at
        
        if data.service_names == ""{
            cell.lbl_ServiceName.text = "-"
        }else{
            cell.lbl_ServiceName.text = data.service_names
        }
        
        if data.payment_type == ""{
            cell.lbl_PaymentType.text = "-"
        }else{
            cell.lbl_PaymentType.text = localizedPaymentTypes(from: data.payment_type)
        }
        
        
        if data.coupon_code == ""{
            cell.lbl_CouponCode.text = "-"
        }else{
            cell.lbl_CouponCode.text = data.coupon_code
        }
        
        if data.tip == 0{
            cell.lbl_Tip.text = "-"
        }else{
            cell.lbl_Tip.text = "\(SharedPrefs.getSymbol())" + String(format: "%.2f", data.tip)
        }
        
        cell.lbl_Discount.text = "\(SharedPrefs.getSymbol())" + String(format: "%.2f", Double(data.discount_amount))
        
        if data.giftCardDisplayString == ""{
            cell.lbl_GiftCard?.text = "-"
        }else{
            cell.lbl_GiftCard?.text = data.giftCardDisplayString
        }
        
        if deleteShownSales && data.payment_type.capitalized == "Cash"{
            cell.btn_Delete.isHidden = false
        } else {
            cell.btn_Delete.isHidden = true
        }
        
        cell.Act_Delete = {
            let popup = ConfirmDeletePopupVC()
            popup.modalPresentationStyle = .overFullScreen
            popup.modalTransitionStyle = .crossDissolve
            popup.titleText = NSLocalizedString("Are you sure you want to delete this booking?", comment: "")
            popup.onConfirm = {
                self.deleteWalkingHistory(walkinId: data.id)
            }
            self.present(popup, animated: true, completion: nil)
        }
        
        cell.lbl_Total.text = "\(SharedPrefs.getSymbol())" + "\(data.sub_total)"
        cell.lbl_GrandTotal.text = "\(SharedPrefs.getSymbol())" + "\(data.total)"
        cell.lbl_MisPrice.text = "\(SharedPrefs.getSymbol())" + "\(data.miscellaneous_price)"
        
        /*cell.lbl_Total.text = "\(SharedPrefs.getSymbol())" + String(format: "%.2f", Double(data.sub_total))
        cell.lbl_GrandTotal.text = "\(SharedPrefs.getSymbol())" + String(format: "%.2f", Double(data.total))
        cell.lbl_MisPrice.text = "\(SharedPrefs.getSymbol())" + String(format: "%.2f", Double(data.miscellaneous_price))*/
        
        
        return cell
    }
    
}

protocol WalkinHistoryDownloadable {
    var fromDate: String? { get }
    var toDate: String? { get }
    func downloadWalkinHistoryReport(startDate: String, endDate: String)
}


extension WalkinHistory_VC: WalkinHistoryDownloadable {
    
    var fromDate: String? {
        return txt_FromDate.text
    }
    
    var toDate: String? {
        return txt_ToDate.text
    }

    func downloadWalkinHistoryReport(startDate: String, endDate: String) {
        let vendorID = LocalData.userId
        
        APIService.shared.downloadWalkinHistoryReport(vendor_id: vendorID,start_date: startDate,end_date: endDate) { model in
            guard let filename = model?.filename else {
                self.alertWithMessageOnly(NSLocalizedString("Download failed",comment: ""))
                return
            }

            let urlPath = "\(global.reportUrl)\(filename)"
            self.downloadAndSaveFile(urlString: urlPath, in: self)
        }
    }
}

extension WalkinHistory_VC: UIPickerViewDelegate, UIPickerViewDataSource {

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
