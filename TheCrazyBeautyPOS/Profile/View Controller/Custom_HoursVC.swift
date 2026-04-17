//
//  Custom_HoursVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 02/12/25.
//

import UIKit
import FSCalendar
import DropDown

class Custom_HoursVC: UIViewController {

    //MARK: - Outlet
    
    @IBOutlet weak var tbl_TimeList: UITableView!
    @IBOutlet weak var tbl_Height: NSLayoutConstraint!
    @IBOutlet weak var btnSave: GradientButton!
    
    
    @IBOutlet weak var vw_AddNew: UIView!
    
    //MARK: - Global Variable
    var calendarVC: UIViewController?
    var SelectedDate: Date?
    var SalonTiming: [SalonTiming] = []
    var customScheduleFromTo: [customScheduleFromTo] = []
    
    var deletedTimingIds: [String] = []
    var notificationList: [MessageData] = []
    let fromTime = "00:00"
    let toTime = "23:45"
    
    var totalCount = 0
    var currentPage = 1
    var isLoadingMore = false
    var hasMoreData = true
    
    var editingIndexes: Set<Int> = []
    
    var selectedIndexPath: IndexPath?
    var isSelectingFromDate: Bool = true
    
    
    var editingDateRangeIndex: Int? = nil
    // temp hold (NOT directly save)
    var tempFromDate: String?
    var tempToDate: String?
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = NSLocalizedString("Save", comment: "")
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 18.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        btnSave.setAttributedTitle(attributedTitle, for: .normal)
        let attributedTitleAdd = NSAttributedString(
            string: NSLocalizedString("Add", comment: ""),
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 18.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        setTableView()
        DispatchQueue.main.async {
            self.tbl_TimeList.reloadData()
            self.tbl_TimeList.layoutIfNeeded()
            self.tbl_Height.constant = self.tbl_TimeList.contentSize.height
        }
        api_getSalonTimings()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tbl_TimeList.layoutIfNeeded()
        tbl_Height.constant = tbl_TimeList.contentSize.height
    }

    //MARK: Custom Function
    func setTableView(){
        tbl_TimeList.register(UINib(nibName: "TimeCustomeDate_Cell", bundle: nil), forCellReuseIdentifier: "TimeCustomeDate_Cell")
        tbl_TimeList.delegate = self
        tbl_TimeList.dataSource = self
        tbl_TimeList.rowHeight = UITableView.automaticDimension
        tbl_TimeList.estimatedRowHeight = 200
        tbl_TimeList.reloadData()
    }
    
    
    func generateTimeSlots(start: String, end: String, interval: Int) -> [String] {
        var result: [String] = []

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        guard let startDate = formatter.date(from: start),
              let endDate = formatter.date(from: end) else { return result }

        var currentTime = startDate
        while currentTime <= endDate {
            result.append(formatter.string(from: currentTime))
            currentTime = Calendar.current.date(byAdding: .minute, value: interval, to: currentTime)!
        }

        return result
    }
    
    @IBAction func btn_Save(_ sender: Any) {
        
        var jsonArray: [[String: Any]] = []
                
            for item in SalonTiming {
                var dict: [String: Any] = [:]
              
                dict["id"] = item.id ?? ""
                dict["date"] = item.date ?? ""
                dict["day"] = item.day ?? ""
                
                dict["working_hours"] = [
                    "day": item.working_hours?.day ?? "",
                    "from": item.working_hours?.from ?? "",
                    "to": item.working_hours?.to ?? ""
                ]
                
                jsonArray.append(dict)
            }
                
            let deleteString = deletedTimingIds.joined(separator: ",")
            
            print("Final Payload:")
            print("salon_timing:", jsonArray)
            print("delete_timing:", deleteString)
        
            let jsonString = String(data: jsonArray.convertToJSONString().data(using: .utf8)!, encoding: .utf8)
        
            print("jsonString:", jsonString!)
        
            // 🚀 Call API with ARRAY (not string)
            APIService.shared.UpdateSalonTimings(salonTimingArray: jsonArray.convertToJSONString(),
                delete_timing: deleteString) { result in
                
                if let success = result?.data {
                    self.alertWithMessageOnly(NSLocalizedString("Salon timings updated successfully",comment: ""))
                } else {
                    self.alertWithMessageOnly(NSLocalizedString("Failed to add salon timing",comment: ""))
                }
            }
        
        /*var jsonArray: [[String: Any]] = []
            
        for item in SalonTiming {
            var dict: [String: Any] = [:]
          
            dict["id"] = item.id ?? ""
            dict["date"] = item.date ?? ""
            dict["day"] = item.day ?? ""
            
            dict["working_hours"] = [
                "day": item.working_hours?.day ?? "",
                "from": item.working_hours?.from ?? "",
                "to": item.working_hours?.to ?? ""
            ]
            
            jsonArray.append(dict)
        }
            
        let deleteString = deletedTimingIds.joined(separator: ",")
        
        let finalParams: [String: Any] = [
            "salon_timing": jsonArray,
            "delete_timing": deleteString  // ← When delete used, send IDs here comma separated
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("JSON String:\n\(jsonString ?? "")")
            APIService.shared.UpdateSalonTimings(salonTimingArray: jsonString ?? "", delete_timing: deleteString) { result in
                if result?.data != nil{
                    self.alertWithMessageOnly(result?.data ?? "")
                }else{
                    self.alertWithMessageOnly(result?.error ?? "")
                }
            }
        } catch {
            print("Error converting to JSON:", error)
        }*/
        
    }
    
    
    @IBAction func btn_AddNewSlot(_ sender: Any) {
        guard let newSlot = TheCrazyBeautyPOS.customScheduleFromTo(JSON: [:]) else { return }
            
        newSlot.from_time = "09:00"
        newSlot.to_time = "17:00"
        newSlot.dates = []
        
        customScheduleFromTo.append(newSlot)
        let newIndex = customScheduleFromTo.count - 1
        
        editingIndexes.insert(newIndex)
        
        tbl_TimeList.reloadData()
        tbl_TimeList.layoutIfNeeded()
        
        updateTableViewreload()
        
//        let lastIndex = IndexPath(row: customScheduleFromTo.count - 1, section: 0)
        let indexPath = IndexPath(row: newIndex, section: 0)
        tbl_TimeList.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            self.tbl_TimeList.scrollToRow(at: indexPath, at: .bottom, animated: true)
            if let cell = self.tbl_TimeList.cellForRow(at: indexPath) as? TimeCustomeDate_Cell {
                cell.vw_Time.isHidden = true
                cell.vw_FromToTime.isHidden = false
                cell.vw_Date.isHidden = false
                cell.vw_UpdateCancel.isHidden = false
                cell.lbl_Line.isHidden = true
                cell.lbl_Dates.isHidden = true
                cell.txt_FromDate.text = ""
                cell.txt_ToDate.text = ""
                cell.btn_Update.setTitle("Add Dates", for: .normal)
                cell.reloadTable()
            }
            self.updateTableViewreload()
        }
    }
    
    //MARK: - Web Api Calling
    func getNotificationData(isPagination: Bool = false) {
        if isPagination {
            self.isLoadingMore = true
        } else {
            self.currentPage = 1
            self.notificationList.removeAll()
            self.hasMoreData = true
            showLoader()
        }
        
        APIService.shared.getNotificationList(page: "\(currentPage)", limit: "10") { activityResult in
            self.hideLoader()
            guard let model = activityResult else {
                self.isLoadingMore = false
                return
            }

            let newItems = model.data
            if newItems.isEmpty || self.notificationList.count + newItems.count >= self.totalCount {
                self.hasMoreData = false
            }

            self.notificationList += newItems
            self.currentPage += 1
            self.isLoadingMore = false
            self.tbl_TimeList.reloadData()
            self.tbl_TimeList.backgroundView = self.notificationList.isEmpty ? self.getNoDataLabel() : nil
        }
    }
    
    
    func getNoDataLabel() -> UILabel {
        let noDataLabel = UILabel()
        noDataLabel.text = NSLocalizedString("No Data Found", comment: "")
        noDataLabel.textAlignment = .center
        noDataLabel.textColor = .gray
        noDataLabel.font = UIFont(name: "Lato-Bold", size: 20.0)
        return noDataLabel
    }
    
    func api_getSalonTimings() {
        showLoader()
        APIService.shared.getSalonTimingsV1 { [weak self] result in
            self?.hideLoader()
            guard let self = self else { return }
            customScheduleFromTo = result?.data ?? []
//            self.txt_Date.showLabel()
            DispatchQueue.main.async {
                self.tbl_TimeList.reloadData()
                self.updateTableViewreload()
            }
        }
    }

    func updateTableViewreload() {
        DispatchQueue.main.async {
            self.tbl_TimeList.reloadData()
            self.tbl_TimeList.layoutIfNeeded()
            self.tbl_Height.constant = self.tbl_TimeList.contentSize.height + 20
        }
    }
    
    func groupConsecutiveDates(_ dates: [SalonDate]) -> [DateRange] {
        
        if dates.isEmpty { return [] }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        // Step 1: Parse + sort
        let parsed = dates.enumerated().compactMap { (index, d) -> (index: Int, date: Date, original: SalonDate)? in
            if let dateObj = formatter.date(from: d.date ?? "") {
                return (index, dateObj, d)
            }
            return nil
        }.sorted { $0.date < $1.date }
        
        var ranges: [DateRange] = []
        var start = 0
        
        // Step 2: Loop and find gaps
        for i in 1...parsed.count {
            
            let isLast = i == parsed.count
            
            var gap = 0
            
            if !isLast {
                let diff = Calendar.current.dateComponents([.day], from: parsed[i - 1].date, to: parsed[i].date)
                gap = diff.day ?? 0
            } else {
                gap = 2 // force break
            }
            
            // 🔥 Gap found
            if gap != 1 {
                
                let slice = parsed[start..<i]
                
                let fromDate = formatter.string(from: slice.first!.date)
                let toDate   = formatter.string(from: slice.last!.date)
                let indices  = slice.map { $0.index }
                
                let range = DateRange(from: fromDate, to: toDate, indices: indices)
                ranges.append(range)
                
                start = i
            }
        }
        
        return ranges
    }
    
    
    func showCalendarPopup(sourceView: UIView) {
    
        calendarVC = UIViewController()
        calendarVC?.modalPresentationStyle = .popover
        calendarVC?.preferredContentSize = CGSize(width: 500, height: 400)

        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 500, height: 400))
        calendar.delegate = self
        calendar.dataSource = self
        calendar.appearance.titleDefaultColor = .black
        calendar.appearance.selectionColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
        calendar.appearance.todayColor = #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        calendarVC?.view.addSubview(calendar)

        if let popover = calendarVC?.popoverPresentationController {
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
            popover.permittedArrowDirections = .up
        }
        self.present(calendarVC!, animated: true, completion: nil)
    }
}

extension Custom_HoursVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customScheduleFromTo.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200 // Important for smooth animations
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl_TimeList.dequeueReusableCell(withIdentifier: "TimeCustomeDate_Cell") as! TimeCustomeDate_Cell
        let data = customScheduleFromTo[indexPath.row]
        
        if editingIndexes.contains(indexPath.row){
            cell.vw_Time.isHidden = true
            cell.vw_FromToTime.isHidden = false
            cell.vw_Date.isHidden = false
            cell.vw_UpdateCancel.isHidden = false
            
            cell.lbl_Line.isHidden = true
            cell.lbl_Dates.isHidden = true
            
            //cell.btn_Update.setTitle("Add Dates", for: .normal)

        } else {
            cell.lbl_Line.isHidden = false
            cell.vw_Time.isHidden = false
            cell.lbl_Dates.isHidden = false
            
            cell.vw_FromToTime.isHidden = true
            cell.vw_Date.isHidden = true
            cell.vw_UpdateCancel.isHidden = true
        }
        let ranges = groupConsecutiveDates(data.dates)
        
        cell.lbl_Time.text = "\(data.from_time ?? "")" + " - " + "\(data.to_time ?? "")"
        cell.lbl_FromTime.text = data.from_time
        cell.lbl_ToTime.text = data.to_time
        cell.dateRanges = ranges
        
        cell.onEditTapped = { [weak self] from,to, rangeIndex in
            guard let self = self else { return }

            self.editingIndexes.insert(indexPath.row)
            
            self.selectedIndexPath = indexPath
            
            DispatchQueue.main.async {
                self.tbl_TimeList.beginUpdates()
                self.tbl_TimeList.endUpdates()
                self.updateTableViewreload()
            }
        }
        
        if selectedIndexPath == indexPath {
            cell.txt_FromDate.text = cell.editFromDate
            cell.txt_ToDate.text = cell.editToDate
            cell.btn_Update.setTitle("Update", for: .normal)
        }
        
        cell.tbl_Dates.reloadData()
        cell.tbl_Dates.layoutIfNeeded()
        cell.tbl_DateHeight.constant = cell.tbl_Dates.contentSize.height
        
        cell.Act_From = { [weak self] in
            guard let self = self else { return }
            
            let slots = self.generateTimeSlots(start: self.fromTime, end: self.toTime, interval: 15)
            let slotDuration = DropDown()
            
            slotDuration.anchorView = cell.lbl_FromTime
            slotDuration.dataSource = slots
            slotDuration.bottomOffset = CGPoint(x: 0, y:(slotDuration.anchorView?.plainView.bounds.height)!)
            slotDuration.direction = .bottom
            slotDuration.cellHeight = 35
            slotDuration.textFont = UIFont(name: "Lato-Regular", size: 16.0)!
            slotDuration.backgroundColor = .white
            slotDuration.show()
            
            slotDuration.selectionAction = { (index: Int, item: String) in
                print("Selected From: \(item)")
                cell.lbl_FromTime.text = item
                
                self.customScheduleFromTo[indexPath.row].from_time = item
            }
        }
        
        cell.Act_To = { [weak self] in
            guard let self = self else { return }
            
            let slots = self.generateTimeSlots(start: self.fromTime, end: self.toTime, interval: 15)
            let slotDuration = DropDown()
            
            slotDuration.anchorView = cell.lbl_ToTime
            slotDuration.dataSource = slots
            slotDuration.bottomOffset = CGPoint(x: 0, y:(slotDuration.anchorView?.plainView.bounds.height)!)
            slotDuration.direction = .bottom
            slotDuration.cellHeight = 35
            slotDuration.textFont = UIFont(name: "Lato-Regular", size: 16.0)!
            slotDuration.backgroundColor = .white
            slotDuration.show()
            
            slotDuration.selectionAction = { (index: Int, item: String) in
                print("Selected To: \(item)")
                cell.lbl_ToTime.text = item
                self.customScheduleFromTo[indexPath.row].to_time = item
            }
        }
        
        if cell.btn_Update.title(for: .normal) == "Add Dates"{
            cell.Act_Update = { [weak self] in
                guard let self = self,
                      let indexPath = self.selectedIndexPath else { return }

                guard let from = self.tempFromDate,
                      let to = self.tempToDate else {
                    print("⚠️ Select both dates first")
                    return
                }

                var dates = self.customScheduleFromTo[indexPath.row].dates

                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"

                if let fromDate = formatter.date(from: from),
                   let toDate = formatter.date(from: to) {

                    var current = fromDate

                    while current <= toDate {
                        let dateStr = formatter.string(from: current)

                        if let newDate = SalonDate(JSON: ["date": dateStr]) {
                            dates.append(newDate)
                        }

                        current = Calendar.current.date(byAdding: .day, value: 1, to: current)!
                    }
                }

                self.customScheduleFromTo[indexPath.row].dates = dates

                // clear temp
                self.tempFromDate = nil
                self.tempToDate = nil
                cell.txt_ToDate.text = ""
                cell.txt_FromDate.text = ""
                
                self.tbl_TimeList.reloadRows(at: [indexPath], with: .automatic)
            }
            
            
        }else{
            
        }
        
        
        /*cell.Act_Cancel = {
//            [weak self] in
//            guard let self = self else { return }
            
            cell.lbl_Line.isHidden = false
            cell.vw_Time.isHidden = false
            cell.lbl_Dates.isHidden = false
            
            cell.vw_FromToTime.isHidden = true
            cell.vw_Date.isHidden = true
            cell.vw_UpdateCancel.isHidden = true
            cell.reloadTable()
            
            // Update table height after cancel
            DispatchQueue.main.async {
                self.tbl_TimeList.beginUpdates()
                self.tbl_TimeList.endUpdates()
                self.updateTableViewreload()
            }
            
        }*/
        
        
        cell.Act_Cancel = { [weak self] in
            guard let self = self else { return }

            // 🔥 REMOVE from editing state
            self.editingIndexes.remove(indexPath.row)

            DispatchQueue.main.async {
                self.tbl_TimeList.beginUpdates()
                self.tbl_TimeList.endUpdates()
                self.updateTableViewreload()
            }
        }
        
        cell.Act_FromDate = { [weak self] in
            guard let self = self else { return }
            self.selectedIndexPath = indexPath
            self.isSelectingFromDate = true
            showCalendarPopup(sourceView: cell.txt_FromDate)
        }
        
        cell.Act_ToDate = { [weak self] in
            guard let self = self else { return }
            self.selectedIndexPath = indexPath
            self.isSelectingFromDate = false
            showCalendarPopup(sourceView: cell.txt_ToDate)
        }
            
        return cell
    }
}

extension Array {
    func convertToJSONString() -> String {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            return String(data: jsonData, encoding: .utf8) ?? "[]"
        }
        return "[]"
    }
}


extension Custom_HoursVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {

        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let formattedDate = formatter.string(from: date)

        guard let indexPath = selectedIndexPath,
              let cell = tbl_TimeList.cellForRow(at: indexPath) as? TimeCustomeDate_Cell else {
            calendarVC?.dismiss(animated: true)
            return
        }

        if isSelectingFromDate {
            tempFromDate = formattedDate
            cell.txt_FromDate.text = formattedDate
        } else {
            tempToDate = formattedDate
            cell.txt_ToDate.text = formattedDate
        }

        calendarVC?.dismiss(animated: true)
    }
}




/*
//  Custom_HoursVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 02/12/25.
//

import UIKit
import FSCalendar
import DropDown

class Custom_HoursVC: UIViewController {

    //MARK: - Outlet
    
    @IBOutlet weak var tbl_TimeList: UITableView!
    @IBOutlet weak var tbl_Height: NSLayoutConstraint!
    @IBOutlet weak var btnSave: GradientButton!
    
    
    //MARK: - Global Variable
    var calendarVC: UIViewController?
    var SelectedDate: Date?
    var SalonTiming: [SalonTiming] = []
    var deletedTimingIds: [String] = []
    var notificationList: [MessageData] = []
    let fromTime = "00:00"
    let toTime = "23:45"
    
    var totalCount = 0
    var currentPage = 1
    var isLoadingMore = false
    var hasMoreData = true
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let title = NSLocalizedString("Save", comment: "")
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 18.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        btnSave.setAttributedTitle(attributedTitle, for: .normal)
        let attributedTitleAdd = NSAttributedString(
            string: NSLocalizedString("Add", comment: ""),
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 18.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        setTableView()
//        btnAdd.setAttributedTitle(attributedTitleAdd, for: .normal)
//        setCustomFont()
//        setCollectCategory()
        api_getSalonTimings()
    }
    
    //MARK: Custom Function
    /*func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Medium", size: 18.0) {
            txt_Date.font = customFont
        }
    }*/
    
    /*func setCollectCategory() {
        self.cv_Time.register(UINib(nibName: "Customschedule_Cell", bundle: nil), forCellWithReuseIdentifier: "Customschedule_Cell")
        self.cv_Time.dataSource = self
        self.cv_Time.delegate = self
    }*/
    
    
    func setTableView(){
        tbl_TimeList.register(UINib(nibName: "TimeCustomeDate_Cell", bundle: nil), forCellReuseIdentifier: "TimeCustomeDate_Cell")
        tbl_TimeList.delegate = self
        tbl_TimeList.dataSource = self
        tbl_TimeList.rowHeight = UITableView.automaticDimension
        tbl_TimeList.estimatedRowHeight = 200
        tbl_TimeList.reloadData()
    }
    
    /*func showCalendarPopup(sourceView: UIView) {
    
        calendarVC = UIViewController()
        calendarVC?.modalPresentationStyle = .popover
        calendarVC?.preferredContentSize = CGSize(width: 500, height: 400)

        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 500, height: 400))
        calendar.delegate = self
        calendar.dataSource = self
        calendar.appearance.titleDefaultColor = .black
        calendar.appearance.selectionColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
        calendar.appearance.todayColor = #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        calendarVC?.view.addSubview(calendar)

        if let popover = calendarVC?.popoverPresentationController {
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
            popover.permittedArrowDirections = .up
        }

        self.present(calendarVC!, animated: true, completion: nil)
    }*/
    
    func generateTimeSlots(start: String, end: String, interval: Int) -> [String] {
        var result: [String] = []

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        guard let startDate = formatter.date(from: start),
              let endDate = formatter.date(from: end) else { return result }

        var currentTime = startDate
        while currentTime <= endDate {
            result.append(formatter.string(from: currentTime))
            currentTime = Calendar.current.date(byAdding: .minute, value: interval, to: currentTime)!
        }

        return result
    }
    
    /*func removeTiming(at index: Int) {
        guard index >= 0 && index < SalonTiming.count else { return }

        let item = SalonTiming[index]

        if let id = item.id, (id != 0) {
            deletedTimingIds.append(String(id))
        }
        
        SalonTiming.remove(at: index)
        cv_Time.reloadData()

        if !SalonTiming.isEmpty {
            let lastIndex = IndexPath(item: SalonTiming.count - 1, section: 0)
            self.cv_Time.reloadData()
            self.updateCollectionHeight()
            cv_Time.scrollToItem(at: lastIndex, at: .centeredHorizontally, animated: true)
        }
    }*/
    
    //MARK: -  Button Action
    /*@IBAction func btn_Add(_ sender: Any) {
        guard let selectedDate = txt_Date.text, !selectedDate.isEmpty else {
            self.alertWithMessageOnly(NSLocalizedString("Please Select Date.",comment: ""))
            return
        }

        if SalonTiming.contains(where: { $0.date == selectedDate }) {
            self.alertWithMessageOnly(NSLocalizedString("This date already exists.",comment: ""))
            return
        }
        
        let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEEE"
        
        let selectedDateObj = formatter.date(from: selectedDate)!
        let dayName = dayFormatter.string(from: selectedDateObj)
        
        let newItem = TheCrazyBeautyPOS.SalonTiming(JSON: [
                "date": selectedDate,
                "day": dayName,
                "working_hours": [
                    "from": "00:00",
                    "to": "23:30",
                    "day": dayName
                ]
            ])!
        SalonTiming.append(newItem)
        
        DispatchQueue.main.async {
            self.cv_Time.reloadData()
            self.updateCollectionHeight()
            let lastIndex = IndexPath(item: self.SalonTiming.count - 1, section: 0)
            self.cv_Time.scrollToItem(at: lastIndex, at: .centeredHorizontally, animated: true)
        }
    }*/
    
    @IBAction func btn_Save(_ sender: Any) {
        
        var jsonArray: [[String: Any]] = []
                
            for item in SalonTiming {
                var dict: [String: Any] = [:]
              
                dict["id"] = item.id ?? ""
                dict["date"] = item.date ?? ""
                dict["day"] = item.day ?? ""
                
                dict["working_hours"] = [
                    "day": item.working_hours?.day ?? "",
                    "from": item.working_hours?.from ?? "",
                    "to": item.working_hours?.to ?? ""
                ]
                
                jsonArray.append(dict)
            }
                
            let deleteString = deletedTimingIds.joined(separator: ",")
            
            print("🧾 Final Payload:")
            print("salon_timing:", jsonArray)
            print("delete_timing:", deleteString)
        
            let jsonString = String(data: jsonArray.convertToJSONString().data(using: .utf8)!, encoding: .utf8)
        
            print("jsonString:", jsonString!)
        
            // 🚀 Call API with ARRAY (not string)
            APIService.shared.UpdateSalonTimings(salonTimingArray: jsonArray.convertToJSONString(),
                delete_timing: deleteString) { result in
                
                if let success = result?.data {
                    self.alertWithMessageOnly(NSLocalizedString("Salon timings updated successfully",comment: ""))
                } else {
                    self.alertWithMessageOnly(NSLocalizedString("Failed to add salon timing",comment: ""))
                }
            }
        
        /*var jsonArray: [[String: Any]] = []
            
        for item in SalonTiming {
            var dict: [String: Any] = [:]
          
            dict["id"] = item.id ?? ""
            dict["date"] = item.date ?? ""
            dict["day"] = item.day ?? ""
            
            dict["working_hours"] = [
                "day": item.working_hours?.day ?? "",
                "from": item.working_hours?.from ?? "",
                "to": item.working_hours?.to ?? ""
            ]
            
            jsonArray.append(dict)
        }
            
        let deleteString = deletedTimingIds.joined(separator: ",")
        
        let finalParams: [String: Any] = [
            "salon_timing": jsonArray,
            "delete_timing": deleteString  // ← When delete used, send IDs here comma separated
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("JSON String:\n\(jsonString ?? "")")
            APIService.shared.UpdateSalonTimings(salonTimingArray: jsonString ?? "", delete_timing: deleteString) { result in
                if result?.data != nil{
                    self.alertWithMessageOnly(result?.data ?? "")
                }else{
                    self.alertWithMessageOnly(result?.error ?? "")
                }
            }
        } catch {
            print("Error converting to JSON:", error)
        }*/
        
    }
    
    //MARK: - Web Api Calling
    func getNotificationData(isPagination: Bool = false) {
        if isPagination {
            self.isLoadingMore = true
        } else {
            self.currentPage = 1
            self.notificationList.removeAll()
            self.hasMoreData = true
            showLoader()
        }
        
        APIService.shared.getNotificationList(page: "\(currentPage)", limit: "10") { activityResult in
            self.hideLoader()
            guard let model = activityResult else {
                self.isLoadingMore = false
                return
            }

            let newItems = model.data
            if newItems.isEmpty || self.notificationList.count + newItems.count >= self.totalCount {
                self.hasMoreData = false
            }

            self.notificationList += newItems
            self.currentPage += 1
            self.isLoadingMore = false
            self.tbl_TimeList.reloadData()
            self.tbl_TimeList.backgroundView = self.notificationList.isEmpty ? self.getNoDataLabel() : nil
        }
    }
    
    func getNoDataLabel() -> UILabel {
        let noDataLabel = UILabel()
        noDataLabel.text = NSLocalizedString("No Data Found", comment: "")
        noDataLabel.textAlignment = .center
        noDataLabel.textColor = .gray
        noDataLabel.font = UIFont(name: "Lato-Bold", size: 20.0)
        return noDataLabel
    }
    
    func api_getSalonTimings() {
        showLoader()
        APIService.shared.getSalonTimings { [weak self] result in
            self?.hideLoader()
            guard let self = self else { return }
            SalonTiming = result?.data ?? []
//            self.txt_Date.showLabel()
            DispatchQueue.main.async {
                self.tbl_TimeList.reloadData()
                self.updateTableViewreload()
            }
        }
    }
    
    
    func updateTableViewreload() {
        DispatchQueue.main.async {
            self.tbl_TimeList.reloadData()
            self.tbl_TimeList.layoutIfNeeded()
            self.tbl_Height.constant = self.tbl_TimeList.contentSize.height
        }
    }
    
    /*func updateCollectionHeight() {
        self.cv_Time.layoutIfNeeded()
        self.cv_Height.constant =
            self.cv_Time.collectionViewLayout.collectionViewContentSize.height
    }
    
    func updateCollectionHeight() {
        DispatchQueue.main.async {
            self.tbl_TimeList.layoutIfNeeded()
            let height = self.cv_Time.collectionViewLayout.collectionViewContentSize.height
            self.cv_Height.constant = height
        }
    }*/
}

/*
extension Custom_HoursVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    /*func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SalonTiming.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv_Time.dequeueReusableCell(withReuseIdentifier: "Customschedule_Cell", for: indexPath) as! Customschedule_Cell
        let data = SalonTiming[indexPath.row]
        cell.lbl_Date.text = data.date
        cell.lbl_FromTime.text = data.working_hours?.from
        cell.lbl_ToTime.text = data.working_hours?.to
        
        cell.Act_From = { [weak self] in
            guard let self = self else { return }
            
            let slots = self.generateTimeSlots(start: self.fromTime, end: self.toTime, interval: 30)
            let slotDuration = DropDown()
            
            slotDuration.anchorView = cell.lbl_FromTime
            slotDuration.dataSource = slots
            slotDuration.bottomOffset = CGPoint(x: 0, y:(slotDuration.anchorView?.plainView.bounds.height)!)
            slotDuration.direction = .bottom
            slotDuration.cellHeight = 35
            slotDuration.textFont = UIFont(name: "Lato-Regular", size: 16.0)!
            slotDuration.backgroundColor = .white
            slotDuration.show()
            
            slotDuration.selectionAction = { (index: Int, item: String) in
                print("Selected From: \(item)")
                cell.lbl_FromTime.text = item
                
                self.SalonTiming[indexPath.row].working_hours?.from = item
            }
        }
        
        cell.Act_To = { [weak self] in
            guard let self = self else { return }
            
            let slots = self.generateTimeSlots(start: self.fromTime, end: self.toTime, interval: 30)
            let slotDuration = DropDown()
            
            slotDuration.anchorView = cell.lbl_ToTime
            slotDuration.dataSource = slots
            slotDuration.bottomOffset = CGPoint(x: 0, y:(slotDuration.anchorView?.plainView.bounds.height)!)
            slotDuration.direction = .bottom
            slotDuration.cellHeight = 35
            slotDuration.textFont = UIFont(name: "Lato-Regular", size: 16.0)!
            slotDuration.backgroundColor = .white
            slotDuration.show()
            
            slotDuration.selectionAction = { (index: Int, item: String) in
                print("Selected To: \(item)")
                cell.lbl_ToTime.text = item
                
                self.SalonTiming[indexPath.row].working_hours?.to = item
            }
        }

        cell.Act_Close = { [weak self] in
            guard let self = self else { return }
            self.removeTiming(at: indexPath.item)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cv_Time.frame.size.width, height: 70)
    }*/
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SalonTiming.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv_Time.dequeueReusableCell(withReuseIdentifier: "Customschedule_Cell", for: indexPath) as! Customschedule_Cell
        
        let data = SalonTiming[indexPath.row]
//        cell.lbl_Date.text = data.date
        cell.lbl_FromTime.text = data.working_hours?.from
        cell.lbl_ToTime.text = data.working_hours?.to
        
        cell.onHeightUpdate = {
            self.updateCollectionHeight()
        }
        cell.reloadTable()
        cell.Act_From = { [weak self] in
            guard let self = self else { return }
            
            let slots = self.generateTimeSlots(start: self.fromTime, end: self.toTime, interval: 30)
            let slotDuration = DropDown()
            
            slotDuration.anchorView = cell.lbl_FromTime
            slotDuration.dataSource = slots
            slotDuration.bottomOffset = CGPoint(x: 0, y:(slotDuration.anchorView?.plainView.bounds.height)!)
            slotDuration.direction = .bottom
            slotDuration.cellHeight = 35
            slotDuration.textFont = UIFont(name: "Lato-Regular", size: 16.0)!
            slotDuration.backgroundColor = .white
            slotDuration.show()
            
            slotDuration.selectionAction = { (index: Int, item: String) in
                print("Selected From: \(item)")
                cell.lbl_FromTime.text = item
                
                self.SalonTiming[indexPath.row].working_hours?.from = item
            }
        }
        
        cell.Act_To = { [weak self] in
            guard let self = self else { return }
            
            let slots = self.generateTimeSlots(start: self.fromTime, end: self.toTime, interval: 30)
            let slotDuration = DropDown()
            
            slotDuration.anchorView = cell.lbl_ToTime
            slotDuration.dataSource = slots
            slotDuration.bottomOffset = CGPoint(x: 0, y:(slotDuration.anchorView?.plainView.bounds.height)!)
            slotDuration.direction = .bottom
            slotDuration.cellHeight = 35
            slotDuration.textFont = UIFont(name: "Lato-Regular", size: 16.0)!
            slotDuration.backgroundColor = .white
            slotDuration.show()
            
            slotDuration.selectionAction = { (index: Int, item: String) in
                print("Selected To: \(item)")
                cell.lbl_ToTime.text = item
                self.SalonTiming[indexPath.row].working_hours?.to = item
            }
        }

        cell.Act_Close = { [weak self] in
            guard let self = self else { return }
            self.removeTiming(at: indexPath.item)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cv_Time.frame.size.width, height: cv_Time.frame.size.height)
    }
    
}*/


/*extension Custom_HoursVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        SelectedDate = date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        txt_Date.text = formatter.string(from: date)
        txt_Date.showLabel()
        calendarVC?.dismiss(animated: true)
    }

    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return date >= Calendar.current.startOfDay(for: Date()) // Allow only today and future dates
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return date < Calendar.current.startOfDay(for: Date()) ? .lightGray : nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return #colorLiteral(red: 0.7686, green: 0.4, blue: 0.8902, alpha: 1)
    }
}*/


/*extension Custom_HoursVC: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txt_Date {
            view.endEditing(true)
            showCalendarPopup(sourceView: textField)
            return false
        }
        return true
    }
}*/

extension Array {
    func convertToJSONString() -> String {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            return String(data: jsonData, encoding: .utf8) ?? "[]"
        }
        return "[]"
    }
}


extension Custom_HoursVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SalonTiming.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl_TimeList.dequeueReusableCell(withIdentifier: "TimeCustomeDate_Cell") as! TimeCustomeDate_Cell
        let data = SalonTiming[indexPath.row]
        cell.lbl_FromTime.text = data.working_hours?.from
        cell.lbl_ToTime.text = data.working_hours?.to
        cell.tbl_Dates.reloadData()
        self.tbl_TimeList.layoutIfNeeded()
        cell.tbl_DateHeight.constant = cell.tbl_Dates.contentSize.height
//        cell.reloadTable()
        cell.Act_From = { [weak self] in
            guard let self = self else { return }
            
            let slots = self.generateTimeSlots(start: self.fromTime, end: self.toTime, interval: 30)
            let slotDuration = DropDown()
            
            slotDuration.anchorView = cell.lbl_FromTime
            slotDuration.dataSource = slots
            slotDuration.bottomOffset = CGPoint(x: 0, y:(slotDuration.anchorView?.plainView.bounds.height)!)
            slotDuration.direction = .bottom
            slotDuration.cellHeight = 35
            slotDuration.textFont = UIFont(name: "Lato-Regular", size: 16.0)!
            slotDuration.backgroundColor = .white
            slotDuration.show()
            
            slotDuration.selectionAction = { (index: Int, item: String) in
                print("Selected From: \(item)")
                cell.lbl_FromTime.text = item
                
                self.SalonTiming[indexPath.row].working_hours?.from = item
            }
        }
        
        cell.Act_To = { [weak self] in
            guard let self = self else { return }
            
            let slots = self.generateTimeSlots(start: self.fromTime, end: self.toTime, interval: 30)
            let slotDuration = DropDown()
            
            slotDuration.anchorView = cell.lbl_ToTime
            slotDuration.dataSource = slots
            slotDuration.bottomOffset = CGPoint(x: 0, y:(slotDuration.anchorView?.plainView.bounds.height)!)
            slotDuration.direction = .bottom
            slotDuration.cellHeight = 35
            slotDuration.textFont = UIFont(name: "Lato-Regular", size: 16.0)!
            slotDuration.backgroundColor = .white
            slotDuration.show()
            
            slotDuration.selectionAction = { (index: Int, item: String) in
                print("Selected To: \(item)")
                cell.lbl_ToTime.text = item
                self.SalonTiming[indexPath.row].working_hours?.to = item
            }
        }

        return cell
    }
}
*/
