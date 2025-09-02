//
//  WalkinHistory_VC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 21/07/25.
//

import UIKit
import FSCalendar


class WalkinHistory_VC: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        guard let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: currentDate) else { return }

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy" // Match your existing format

        txt_FromDate.text = formatter.string(from: oneMonthAgo)
        txt_ToDate.text = formatter.string(from: currentDate)

        firstDate = oneMonthAgo
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

        calendar.reloadData()
        if let from = firstDate, let to = lastDate {
            let selectedDates = getDateRange(from: from, to: to)
            for date in selectedDates {
                calendar.select(date)
            }
        }
        calendarVC?.view.addSubview(calendar)

        if let popover = calendarVC?.popoverPresentationController {
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
            popover.permittedArrowDirections = .up
        }
        self.present(calendarVC!, animated: true, completion: nil)
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
        APIService.shared.WalkinHistoryGet(vendor_id: LocalData.userId, limt: "100000", page: "", start_date: formattedFrom, end_date: formattedTo) { result in
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
                    // safe UI code here
                    self.showToast(message: model.data)
                }
                self.WalkinHistory()
            } else {
                self.show_alert(msg: model.error ?? "", title: "Delete Team")
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
            cell.lbl_ServiceName.text = "N/A"
        }else{
            cell.lbl_ServiceName.text = data.service_names
        }
        
        if data.payment_type == ""{
            cell.lbl_PaymentType.text = "N/A"
        }else{
            cell.lbl_PaymentType.text = data.payment_type.capitalized
        }
        
        
        if data.coupon_code == ""{
            cell.lbl_CouponCode.text = "N/A"
        }else{
            cell.lbl_CouponCode.text = data.coupon_code
        }
        
        if data.tip == 0{
            cell.lbl_Tip.text = "N/A"
        }else{
            cell.lbl_Tip.text = "\(SharedPrefs.getSymbol())" + "\(Double(data.tip))"
        }
        
        cell.lbl_Discount.text = "\(SharedPrefs.getSymbol())" + "\(data.discount_amount)"
        if data.giftCardDisplayString == ""{
            cell.lbl_GiftCard?.text = "N/A"
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
            popup.titleText = "Are you sure you want to delete this booking?"
            popup.onConfirm = {
                print("Inventory confirmed delete")
                // Call your delete logic here
                self.deleteWalkingHistory(walkinId: data.id)
            }
            self.present(popup, animated: true, completion: nil)
        }
        
        cell.lbl_Total.text = "\(SharedPrefs.getSymbol())" + "\(Double(data.sub_total))"
        cell.lbl_GrandTotal.text = "\(SharedPrefs.getSymbol())" + "\(Double(data.total))"
        cell.lbl_MisPrice.text = "\(SharedPrefs.getSymbol())" + "\(data.miscellaneous_price)"
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
                self.alertWithMessageOnly("Download failed")
                return
            }

            let urlPath = "\(global.reportUrl)\(filename)"
            self.downloadAndSaveFile(urlString: urlPath, in: self)
        }
    }
}
