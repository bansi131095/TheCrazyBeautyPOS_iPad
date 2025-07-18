//
//  SalesReportHistory_VC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 18/07/25.
//

import UIKit
import FSCalendar

class SalesReportHistory_VC: UIViewController {

    @IBOutlet weak var txt_FromDate: UITextField!
    @IBOutlet weak var txt_ToDate: UITextField!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var lbl_NoDataFound: UILabel!
    @IBOutlet weak var tbl_vw: UITableView!
    
    
    
    //MARK: Popup
    @IBOutlet weak var vw_Back: UIView!
    @IBOutlet weak var vw_Popup: UIView!
    
    
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var lbl_ServiceName: UILabel!
    @IBOutlet weak var lbl_Type: UILabel!
    @IBOutlet weak var lbl_Staff: UILabel!
    @IBOutlet weak var lbl_Status: UILabel!
    @IBOutlet weak var lbl_CouponCode: UILabel!
    @IBOutlet weak var lbl_MiscellaneousNote: UILabel!
    @IBOutlet weak var lbl_Payment: UILabel!
    @IBOutlet weak var lbl_MiscellaneousPrice: UILabel!
    @IBOutlet weak var lbl_Tip: UILabel!
    @IBOutlet weak var lbl_OriginalAmount: UILabel!
    @IBOutlet weak var lbl_Discount: UILabel!
    @IBOutlet weak var lbl_Total: UILabel!
    
    
    var calendarVC: UIViewController?
    var firstDate: Date?
    var lastDate: Date?
    var datesRange: [Date] = []
    var selectingDateFor: UITextField?
    var calendar: FSCalendar!
    
    var salesHistoryList: [SalesHistoryDateModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentViewWidthConstraint.constant = 1000
        setTableView()
        salesHistoryData()
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
    
    @IBAction func btn_ClosePopup(_ sender: Any) {
        self.vw_Back.isHidden = true
        self.vw_Popup.isHidden = true
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

        if let popover = calendarVC?.popoverPresentationController {
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
            popover.permittedArrowDirections = .up
        }
        self.present(calendarVC!, animated: true, completion: nil)
    }
    
    func salesHistoryData() {
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

            // Show/Hide No Data Label
            if self.salesHistoryList.isEmpty {
                self.lbl_NoDataFound.isHidden = false
            } else {
                self.lbl_NoDataFound.isHidden = true
            }
            
            self.tbl_vw.reloadData()
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
            salesHistoryData()
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
        cell.lbl_Status.text = data.booking_status.capitalized
        cell.lbl_Payment.text = data.payment_type.capitalized
        if data.tip == 0 {
            cell.lbl_Tip.text = "N/A"
        }else{
            cell.lbl_Tip.text = String(data.tip)
        }
        cell.lbl_Total.text = String(data.sub_total)
        
        cell.Act_Action = {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "Appointment_DetailsVC") as? Appointment_DetailsVC {
                vc.model = data
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }

            
            
            /*self.vw_Back.isHidden = false
            self.vw_Popup.isHidden = false
            
            self.lbl_Name.text = data.name.capitalized
            self.lbl_Date.text = data.booking_date
            self.lbl_Time.text = data.booking_time
            self.lbl_ServiceName.text = data.services.capitalized
            self.lbl_Type.text = data.customer_type.capitalized
            self.lbl_Staff.text = data.staff_names.capitalized
            self.lbl_Status.text = data.booking_status.capitalized
            
            if data.coupon_code == ""{
                self.lbl_CouponCode.text = "N/A"
            }else{
                self.lbl_CouponCode.text = data.coupon_code
            }
            
            if data.miscellaneous_notes == ""{
                self.lbl_MiscellaneousNote.text = "N/A"
            }else{
                self.lbl_MiscellaneousNote.text = data.miscellaneous_notes
            }
            
            self.lbl_MiscellaneousPrice.text = data.miscellaneous_price
            self.lbl_Tip.text = "\(data.tip)"
            self.lbl_OriginalAmount.text =  data.grand_total
            self.lbl_Discount.text = data.discount_amount
            self.lbl_Total.text = data.grand_total*/
        }
        
        
        
        return cell
    }
    
}

