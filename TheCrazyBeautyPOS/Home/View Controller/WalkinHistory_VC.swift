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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentViewWidthConstraint.constant = 1500
        self.setTableView()
        self.WalkinHistory()
        print(LocalData.currency)
        print(LocalData.symbol)
        print(LocalData.selectedSymbol as Any)
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
        
        
        APIService.shared.WalkinHistoryGet(vendor_id: LocalData.userId, limt: "10", page: "1", start_date: formattedFrom, end_date: formattedTo) { result in
            guard let model = result else {
                print("API failed or empty response")
                self.WalkingList = []
                self.tbl_vw.reloadData()
                self.lbl_NoDataFound.isHidden = false
                return
            }

            self.WalkingList = model.data

            // Show/Hide No Data Label
            if self.WalkingList.isEmpty {
                self.lbl_NoDataFound.isHidden = false
            } else {
                self.lbl_NoDataFound.isHidden = true
            }
            
            self.tbl_vw.reloadData()
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
        cell.lbl_ServiceName.text = data.service_names
        if data.payment_type == ""{
            cell.lbl_PaymentType.text = "N/A"
        }else{
            cell.lbl_PaymentType.text = data.payment_type
        }
        
        if data.coupon_code == ""{
            cell.lbl_CouponCode.text = "N/A"
        }else{
            cell.lbl_CouponCode.text = data.coupon_code
        }
        
        if data.tip == 0{
            cell.lbl_Tip.text = "N/A"
        }else{
            cell.lbl_Tip.text = "\(data.tip)"
        }
        cell.lbl_Discount.text = "\(data.discount_amount)"
        
        cell.lbl_Total.text = "\(data.sub_total)"
        cell.lbl_GrandTotal.text = "\(data.total)"
        cell.lbl_MisPrice.text = "\(data.miscellaneous_price)"
        return cell
    }
    
}
