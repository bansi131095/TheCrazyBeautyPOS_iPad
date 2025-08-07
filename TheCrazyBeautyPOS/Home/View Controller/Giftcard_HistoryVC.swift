//
//  Giftcard_HistoryVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 17/07/25.
//

import UIKit
import FSCalendar

class Giftcard_HistoryVC: UIViewController {

    
    @IBOutlet weak var txt_FromDate: UITextField!
    @IBOutlet weak var txt_ToDate: UITextField!
    
    @IBOutlet weak var lbl_NoDataFound: UILabel!
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    
    var calendarVC: UIViewController?
    var firstDate: Date?
    var lastDate: Date?
    var datesRange: [Date] = []
    var selectingDateFor: UITextField?
    var calendar: FSCalendar!
    
    var giftList: [GiftDateModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentViewWidthConstraint.constant = 200
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
    
    // MARK: - Function
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

        setGiftcardHistoryData()
    }
    
    func setTableView(){
        tbl_vw.register(UINib(nibName: "Giftcard_Cell", bundle: nil), forCellReuseIdentifier: "Giftcard_Cell")
        tbl_vw.register(UINib(nibName: "GiftCard_HeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "GiftCard_HeaderCell")
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

    func setGiftcardHistoryData() {
        guard let fromDateString = self.txt_FromDate.text,
              let toDateString = self.txt_ToDate.text,
              let fromDate = convertStringToDate(fromDateString),
              let toDate = convertStringToDate(toDateString) else {
            print("Invalid date format")
            return
        }

        let formattedFrom = formatDateToString(fromDate)
        let formattedTo = formatDateToString(toDate)
        
        APIService.shared.GiftCardGet(vendor_id: LocalData.userId, limt: "10", page: "1", start_date: formattedFrom, end_date: formattedTo) { result in
            guard let model = result else {
                print("API failed or empty response")
                self.giftList = []
                self.tbl_vw.reloadData()
                self.lbl_NoDataFound.isHidden = false
                return
            }

            self.giftList = model.data
            if let parentVC = self.parent as? ReportVC {
                parentVC.updateTotalAmount(text: "\(SharedPrefs.getSymbol())" + (result?.totalSales ?? ""))
            }
            // Show/Hide No Data Label
            if self.giftList.isEmpty {
                self.lbl_NoDataFound.isHidden = false
            } else {
                self.lbl_NoDataFound.isHidden = true
            }
            
            self.tbl_vw.reloadData()
        }
    }
}

extension Giftcard_HistoryVC: FSCalendarDelegate, FSCalendarDataSource {
    
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

            setGiftcardHistoryData()
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

extension Giftcard_HistoryVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.giftList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "GiftCard_HeaderCell") as? GiftCard_HeaderCell else {
                return nil
            }
            return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbl_vw.dequeueReusableCell(withIdentifier: "Giftcard_Cell", for: indexPath) as? Giftcard_Cell else {
            return UITableViewCell()
        }
        let data = self.giftList[indexPath.item]
        
        if data.gift_name != "" {
            cell.lbl_Name.text = data.gift_name
        }else{
            cell.lbl_Name.text = "N/A"
        }
        
        if data.gift_code != "" {
            cell.lbl_GiftCard.text = data.gift_code
        }else{
            cell.lbl_GiftCard.text = "N/A"
        }
        
        if data.used_date != "" {
            cell.lbl_UsedDate.text = data.used_date
        }else{
            cell.lbl_UsedDate.text = "N/A"
        }
        
        if data.expiry_date != "" {
            cell.lbl_ExpiryDate.text = data.expiry_date
        }else{
            cell.lbl_ExpiryDate.text = "N/A"
        }
        
        cell.lbl_Amount.text = "\(SharedPrefs.getSymbol())" +  String(data.amount)
        
        return cell
    }
    
}

protocol GiftcardDownloadable {
    var fromDate: String? { get }
    var toDate: String? { get }
    func downloadGiftReport(startDate: String, endDate: String)
}


extension Giftcard_HistoryVC: GiftcardDownloadable {
    
    var fromDate: String? {
        return txt_FromDate.text
    }
    
    var toDate: String? {
        return txt_ToDate.text
    }

    func downloadGiftReport(startDate: String, endDate: String) {
        let vendorID = LocalData.userId
        
        APIService.shared.downloadGiftReport(vendor_id: vendorID,start_date: startDate,end_date: endDate) { model in
            guard let filename = model?.filename else {
                self.alertWithMessageOnly("Download failed")
                return
            }

            let urlPath = "\(global.reportUrl)\(filename)"
            self.downloadAndSaveFile(urlString: urlPath, in: self)
        }
    }
}


