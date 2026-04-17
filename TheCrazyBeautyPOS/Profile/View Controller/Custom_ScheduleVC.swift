//
//  Custom_ScheduleVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 16/04/26.
//

import UIKit
import DropDown
import FSCalendar

class Custom_ScheduleVC: UIViewController, FSCalendarDataSource, FSCalendarDelegate {

    
    //MARK: - Outlet
    @IBOutlet weak var tbl_TimeList: UITableView!
    @IBOutlet weak var tbl_Height: NSLayoutConstraint!
    @IBOutlet weak var btnSave: GradientButton!
    
    //MARK: - Global Variable
    var customScheduleFromTo: [customScheduleFromTo] = []
    var mainIndex = 2
    
    var arr_selectIndex: [Int] = []
    
    let fromTime = "00:00"
    let toTime = "23:45"
    
    // Calendar state
    var calendarVC: UIViewController?
    var fsCalendar: FSCalendar?          // retained ref so we can select a date after present
    var selectedIndexPath: IndexPath?
    var isSelectingFromDate: Bool = true
    var tempFromDate: String?
    var tempToDate: String?
    var calendarPreselectedDate: Date?   // month/date to jump to when opening picker
    
    // Edit state – stored in the VC so cell reuse never corrupts it
    var editingOuterRow: Int? = nil
    var editingInnerRangeIndex: Int? = nil
    var editingFromDate: String? = nil
    var editingToDate: String? = nil
    
    // Snapshot of all original SalonDate IDs for building delete_timing
    var originalDateIds: Set<Int> = []
    
    // Holiday dates (dd-MM-yyyy) fetched from server — disabled in calendar picker
    var holidayDates: Set<String> = []
    
    // Dynamic minimum date for FSCalendar — set before presenting popup
    var calendarMinimumDate: Date = Calendar.current.startOfDay(for: Date())
    
    // Stash of SalonDate objects removed from a group during an edit,
    // keyed by outer row index — mirrors React's pendingEditIds pattern.
    // On cancel they are restored; on confirm they are dropped.
    var pendingEditDates: [Int: [SalonDate]] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customFont()
        setTableView()
        StaffSalonHolidays()
        DispatchQueue.main.async {
            self.tbl_TimeList.reloadData()
            self.tbl_TimeList.layoutIfNeeded()
            self.tbl_Height.constant = self.tbl_TimeList.contentSize.height
        }
        api_getSalonTimings()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tbl_TimeList.layoutIfNeeded()
        tbl_Height.constant = tbl_TimeList.contentSize.height
    }
    
    //MARK: Custom Font
    func customFont(){
        let title = NSLocalizedString("Save", comment: "")
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 18.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        btnSave.setAttributedTitle(attributedTitle, for: .normal)
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
    
    //MARK: - Web Api Calling
    func api_getSalonTimings() {
        showLoader()
        APIService.shared.getSalonTimingsV1 { [weak self] result in
            self?.hideLoader()
            guard let self = self else { return }
            customScheduleFromTo = result?.data ?? []
            // Snapshot every date ID that came from the server
            self.originalDateIds = Set(
                self.customScheduleFromTo.flatMap { $0.dates }.compactMap { $0.id }
            )
            DispatchQueue.main.async {
                self.tbl_TimeList.reloadData()
                self.tbl_TimeList.layoutIfNeeded()
                self.tbl_TimeList.beginUpdates()
                self.tbl_TimeList.endUpdates()
                self.tbl_Height.constant = self.tbl_TimeList.contentSize.height
            }
        }
    }
    
    
    func StaffSalonHolidays() {
        showLoader()
        APIService.shared.getStaffSalonHolidays(vendor_id: LocalData.userId) { [weak self] result in
            self?.hideLoader()
            guard let self = self else { return }
            if let dates = result?.data {
                // Normalise to dd-MM-yyyy regardless of what format the API returns
                // Supports yyyy-MM-dd and dd-MM-yyyy input formats
                let inputFormatters: [DateFormatter] = [
                    { let f = DateFormatter(); f.dateFormat = "yyyy-MM-dd"; f.locale = Locale(identifier: "en_US_POSIX"); return f }(),
                    { let f = DateFormatter(); f.dateFormat = "dd-MM-yyyy"; f.locale = Locale(identifier: "en_US_POSIX"); return f }()
                ]
                let outputFormatter: DateFormatter = {
                    let f = DateFormatter()
                    f.dateFormat = "dd-MM-yyyy"
                    f.locale = Locale(identifier: "en_US_POSIX")
                    return f
                }()
                self.holidayDates = Set(dates.compactMap { raw -> String? in
                    for fmt in inputFormatters {
                        if let d = fmt.date(from: raw) { return outputFormatter.string(from: d) }
                    }
                    return raw   // keep as-is if neither parser matched
                })
                print("🗓️ Holiday dates (normalised): \(self.holidayDates)")
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
        
        // Enable/disable the update button based on both dates being selected
        let hasFrom = !(tempFromDate ?? "").isEmpty
        let hasTo   = !(tempToDate   ?? "").isEmpty
        cell.btn_Update.isEnabled = hasFrom && hasTo
        cell.btn_Update.alpha     = (hasFrom && hasTo) ? 1.0 : 0.5
        
        calendarVC?.dismiss(animated: true)
    }
    
    /// Reload a single row and update height – use this for edit-state changes.
    func reloadRow(_ indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tbl_TimeList.reloadRows(at: [indexPath], with: .none)
            self.tbl_TimeList.layoutIfNeeded()
            self.tbl_Height.constant = self.tbl_TimeList.contentSize.height
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

    func showCalendarPopup(sourceView: UIView, preselectedDate: Date? = nil) {
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
        // Set dynamic minimum — read by minimumDate(for:) delegate method
        calendarMinimumDate = Calendar.current.startOfDay(for: Date())
        // When picking the To-date, minimum is the already-chosen From-date
        if !isSelectingFromDate,
           let fromStr = tempFromDate,
           let fromDate = calendarDateFormatter.date(from: fromStr) {
            calendarMinimumDate = Calendar.current.startOfDay(for: fromDate)
        }
        fsCalendar = calendar
        calendarVC?.view.addSubview(calendar)

        if let popover = calendarVC?.popoverPresentationController {
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
            popover.permittedArrowDirections = .up
        }
        self.present(calendarVC!, animated: true) { [weak self] in
            if let date = preselectedDate ?? self?.calendarPreselectedDate {
                self?.fsCalendar?.setCurrentPage(date, animated: false)
                self?.fsCalendar?.select(date, scrollToDate: false)
            }
        }
    }

    @IBAction func btn_AddSlot(_ sender: Any) {
        guard let newSlot = TheCrazyBeautyPOS.customScheduleFromTo(JSON: [:]) else { return }
        newSlot.from_time = "09:00"
        newSlot.to_time   = "17:00"
        customScheduleFromTo.append(newSlot)
        let newIndex = customScheduleFromTo.count - 1
        let newIndexPath = IndexPath(row: newIndex, section: 0)
        // Immediately enter edit mode so time/date pickers are visible
        editingOuterRow        = newIndex
        editingInnerRangeIndex = nil
        editingFromDate        = nil
        editingToDate          = nil
        tempFromDate           = nil
        tempToDate             = nil
        tbl_TimeList.insertRows(at: [newIndexPath], with: .automatic)
        tbl_TimeList.layoutIfNeeded()
        tbl_Height.constant = tbl_TimeList.contentSize.height
        tbl_TimeList.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
    }

    @IBAction func btn_Save(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // Build salon_timing array
        var salonTimingArray: [[String: Any]] = []
        for slot in customScheduleFromTo {
            var dateArray: [[String: Any]] = []
            for salonDate in slot.dates {
                var dateDict: [String: Any] = [:]
                if let id = salonDate.id   { dateDict["id"]   = id }
                if let day  = salonDate.day  { dateDict["day"]  = day }
                if let date = salonDate.date { dateDict["date"] = date }
                dateArray.append(dateDict)
            }
            let entry: [String: Any] = [
                "time": [
                    "from": slot.from_time ?? "",
                    "to":   slot.to_time   ?? ""
                ],
                "date": dateArray
            ]
            salonTimingArray.append(entry)
        }
        
        // Build delete_timing: original IDs no longer present in any slot
        let currentIds = Set(customScheduleFromTo.flatMap { $0.dates }.compactMap { $0.id })
        let deletedIds = originalDateIds.subtracting(currentIds)
        let deleteTimingString = deletedIds.sorted().map { String($0) }.joined(separator: ",")
        
        let payload: [String: Any] = [
            "salon_timing":   salonTimingArray,
            "delete_timing":  deleteTimingString
        ]
        
        APIService.shared.update_CustomSchedule(salonTimingArray: salonTimingArray.convertToJSONString(),
                            delete_timing: deleteTimingString) { result in
            
            if let success = result?.data {
                self.alertWithMessageOnly(NSLocalizedString("Salon timings updated successfully",comment: ""))
            } else {
                self.alertWithMessageOnly(NSLocalizedString("Failed to add salon timing",comment: ""))
            }
        }
    }
    
    /// Restore any stashed SalonDate objects back into a group (used by cancel & remove).
    private func restorePendingDates(for row: Int) {
        guard let stashed = pendingEditDates[row], !stashed.isEmpty else { return }
        customScheduleFromTo[row].dates.append(contentsOf: stashed)
        pendingEditDates.removeValue(forKey: row)
    }

}

// MARK: - FSCalendar holiday appearance & selection blocking
extension Custom_ScheduleVC {
    
    private var calendarDateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "dd-MM-yyyy"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date,
                  at monthPosition: FSCalendarMonthPosition) -> Bool {
        let str = calendarDateFormatter.string(from: date)
        // Block holidays
        if holidayDates.contains(str) { return false }
        // Block past dates (before today, calendar-day precision)
        let today = Calendar.current.startOfDay(for: Date())
        if Calendar.current.startOfDay(for: date) < today { return false }
        // When picking To-date, block anything before the selected From-date
        if !isSelectingFromDate,
           let fromStr = tempFromDate,
           let fromDate = calendarDateFormatter.date(from: fromStr) {
            if Calendar.current.startOfDay(for: date) < Calendar.current.startOfDay(for: fromDate) {
                return false
            }
        }
        return true
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance,
                  fillDefaultColorFor date: Date) -> UIColor? {
        let str = calendarDateFormatter.string(from: date)
        let today = Calendar.current.startOfDay(for: Date())
        let isPast = Calendar.current.startOfDay(for: date) < today
        let isHoliday = holidayDates.contains(str)
        return (isPast || isHoliday) ? UIColor.lightGray.withAlphaComponent(0.25) : nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance,
                  titleDefaultColorFor date: Date) -> UIColor? {
        let str = calendarDateFormatter.string(from: date)
        let today = Calendar.current.startOfDay(for: Date())
        let isPast = Calendar.current.startOfDay(for: date) < today
        let isHoliday = holidayDates.contains(str)
        return (isPast || isHoliday) ? UIColor.lightGray.withAlphaComponent(0.4) : nil
    }
}

extension Custom_ScheduleVC: UITableViewDelegate, UITableViewDataSource {
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
        let ranges = groupConsecutiveDates(data.dates)
        
        cell.lbl_Time.text = "\(data.from_time ?? "")" + " - " + "\(data.to_time ?? "")"
        cell.lbl_FromTime.text = data.from_time
        cell.lbl_ToTime.text = data.to_time
        cell.dateRanges = ranges
        
        // ── Apply edit state driven purely from VC properties ──────────────────
        let isThisRowEditing = (editingOuterRow == indexPath.row)
        cell.vw_Time.isHidden        = isThisRowEditing
        cell.vw_FromToTime.isHidden  = !isThisRowEditing
        cell.vw_Date.isHidden        = !isThisRowEditing
        cell.vw_UpdateCancel.isHidden = !isThisRowEditing
        cell.lbl_Line.isHidden       = isThisRowEditing
        cell.lbl_Dates.isHidden      = isThisRowEditing
        
        if isThisRowEditing {
            cell.txt_FromDate.text   = editingFromDate ?? ""
            cell.txt_ToDate.text     = editingToDate ?? ""
            cell.selectedEditIndex   = editingInnerRangeIndex
        } else {
            cell.txt_FromDate.text   = ""
            cell.txt_ToDate.text     = ""
            cell.selectedEditIndex   = nil
        }
        
        // Button title: "Update" when editing existing range, "Add Dates" for new
        let isEditingExistingRange = isThisRowEditing && (editingInnerRangeIndex != nil)
        cell.btn_Update.setTitle(isEditingExistingRange ? "Update" : "Add Dates", for: .normal)
        
        // Disable update button until both from and to dates are chosen
        let hasFrom = isThisRowEditing && !(tempFromDate ?? "").isEmpty
        let hasTo   = isThisRowEditing && !(tempToDate   ?? "").isEmpty
        cell.btn_Update.isEnabled = hasFrom && hasTo
        cell.btn_Update.alpha     = (hasFrom && hasTo) ? 1.0 : 0.5
        // ───────────────────────────────────────────────────────────────────────
        
        cell.tbl_Dates.reloadData()
        cell.tbl_Dates.layoutIfNeeded()
        cell.tbl_DateHeight.constant = cell.tbl_Dates.contentSize.height
        
        // Called when user taps the edit icon on an inner date range row.
        cell.onEdit_NEW_Tapped = { [weak self] in
            guard let self = self else { return }
            let outerRow = indexPath.row
            
            // If switching from a different row, restore its stash first
            if let prev = self.editingOuterRow, prev != outerRow {
                self.restorePendingDates(for: prev)
                self.editingOuterRow        = nil
                self.editingInnerRangeIndex = nil
                self.editingFromDate        = nil
                self.editingToDate          = nil
                self.tempFromDate           = nil
                self.tempToDate             = nil
            }
            
            // Restore any previous stash for THIS row (from a prior cancelled edit)
            self.restorePendingDates(for: outerRow)
            
            // Stash the dates that belong to the range being edited
            if let rangeIdx = cell.selectedEditIndex, rangeIdx < ranges.count {
                let oldRange = ranges[rangeIdx]
                let oldIndices = Set(oldRange.indices)
                let stashed = self.customScheduleFromTo[outerRow].dates
                    .enumerated()
                    .filter { oldIndices.contains($0.offset) }
                    .map { $0.element }
                self.pendingEditDates[outerRow] = stashed
                // Remove those dates from live array
                self.customScheduleFromTo[outerRow].dates = self.customScheduleFromTo[outerRow].dates
                    .enumerated()
                    .filter { !oldIndices.contains($0.offset) }
                    .map { $0.element }
            }
            
            self.editingOuterRow        = outerRow
            self.editingInnerRangeIndex = cell.selectedEditIndex
            self.editingFromDate        = cell.editFromDate
            self.editingToDate          = cell.editToDate
            self.tempFromDate           = cell.editFromDate
            self.tempToDate             = cell.editToDate
            self.reloadRow(indexPath)
        }
        
        cell.Act_From = { [weak self] in
            guard let self = self else { return }
            let slots = self.generateTimeSlots(start: self.fromTime, end: self.toTime, interval: 15)
            let slotDuration = DropDown()
            slotDuration.anchorView = cell.lbl_FromTime
            slotDuration.dataSource = slots
            slotDuration.bottomOffset = CGPoint(x: 0, y: (slotDuration.anchorView?.plainView.bounds.height)!)
            slotDuration.direction = .bottom
            slotDuration.cellHeight = 35
            slotDuration.textFont = UIFont(name: "Lato-Regular", size: 16.0)!
            slotDuration.backgroundColor = .white
            slotDuration.show()
            slotDuration.selectionAction = { (index: Int, item: String) in
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
            slotDuration.bottomOffset = CGPoint(x: 0, y: (slotDuration.anchorView?.plainView.bounds.height)!)
            slotDuration.direction = .bottom
            slotDuration.cellHeight = 35
            slotDuration.textFont = UIFont(name: "Lato-Regular", size: 16.0)!
            slotDuration.backgroundColor = .white
            slotDuration.show()
            slotDuration.selectionAction = { (index: Int, item: String) in
                cell.lbl_ToTime.text = item
                self.customScheduleFromTo[indexPath.row].to_time = item
            }
        }
        
        cell.Act_FromDate = { [weak self] in
            guard let self = self else { return }
            self.selectedIndexPath = indexPath
            self.isSelectingFromDate = true
            // Pre-navigate to the existing from-date if any
            let existing = self.tempFromDate ?? self.editingFromDate
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            self.calendarPreselectedDate = existing.flatMap { formatter.date(from: $0) }
            self.showCalendarPopup(sourceView: cell.txt_FromDate)
        }
        
        cell.Act_ToDate = { [weak self] in
            guard let self = self else { return }
            self.selectedIndexPath = indexPath
            self.isSelectingFromDate = false
            // Pre-navigate to the existing to-date if any
            let existing = self.tempToDate ?? self.editingToDate
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            self.calendarPreselectedDate = existing.flatMap { formatter.date(from: $0) }
            self.showCalendarPopup(sourceView: cell.txt_ToDate)
        }
        
        cell.Act_Update = { [weak self] in
            guard let self = self else { return }
            guard let from = self.tempFromDate, let to = self.tempToDate else {
                //print("⚠️ Select both From and To dates")
                self.alertWithMessageOnly(NSLocalizedString("Please select both From Date and To Date",comment: ""))
                return
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            guard let fromDate = formatter.date(from: from),
                  let toDate   = formatter.date(from: to),
                  fromDate <= toDate else {
                //print("⚠️ Invalid date range")
                self.alertWithMessageOnly(NSLocalizedString("Custom Schedule for these dates already exists",comment: ""))
                return
            }
            
            // Build the full set of date strings in the new chosen range, skipping holidays
            var newDateStrings: [String] = []
            var cur = fromDate
            while cur <= toDate {
                let ds = formatter.string(from: cur)
                if !self.holidayDates.contains(ds) {
                    newDateStrings.append(ds)
                }
                cur = Calendar.current.date(byAdding: .day, value: 1, to: cur)!
            }
            let newDateSet = Set(newDateStrings)
            
            let dayNames = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
            
            if let rangeIndex = self.editingInnerRangeIndex, rangeIndex < ranges.count {
                let oldRange = ranges[rangeIndex]
                let oldIndices = Set(oldRange.indices)
                
                // Build lookup: dateString -> existing SalonDate (preserves server ID)
                var existingByDate: [String: SalonDate] = [:]
                for (offset, salonDate) in self.customScheduleFromTo[indexPath.row].dates.enumerated() {
                    if oldIndices.contains(offset), let ds = salonDate.date {
                        existingByDate[ds] = salonDate
                    }
                }
                
                // Strip all old-range dates from the array
                self.customScheduleFromTo[indexPath.row].dates = self.customScheduleFromTo[indexPath.row].dates
                    .enumerated()
                    .filter { !oldIndices.contains($0.offset) }
                    .map { $0.element }
                
                // Re-add: keep existing entry (with ID) if still in range, or create new entry
                for dateStr in newDateStrings {
                    if let existing = existingByDate[dateStr] {
                        self.customScheduleFromTo[indexPath.row].dates.append(existing)
                    } else if let dateObj = formatter.date(from: dateStr) {
                        let weekdayIndex = Calendar.current.component(.weekday, from: dateObj)
                        let dayName = dayNames[weekdayIndex - 1]
                        if let newDate = SalonDate(JSON: ["date": dateStr, "day": dayName]) {
                            self.customScheduleFromTo[indexPath.row].dates.append(newDate)
                        }
                    }
                }
            } else {
                // No existing range — adding fresh dates for a new slot
                for dateStr in newDateStrings {
                    if let dateObj = formatter.date(from: dateStr) {
                        let weekdayIndex = Calendar.current.component(.weekday, from: dateObj)
                        let dayName = dayNames[weekdayIndex - 1]
                        if let newDate = SalonDate(JSON: ["date": dateStr, "day": dayName]) {
                            self.customScheduleFromTo[indexPath.row].dates.append(newDate)
                        }
                    }
                }
            }
            
            // Clear edit state and stash
            self.pendingEditDates.removeValue(forKey: indexPath.row)
            self.editingOuterRow        = nil
            self.editingInnerRangeIndex = nil
            self.editingFromDate        = nil
            self.editingToDate          = nil
            self.tempFromDate           = nil
            self.tempToDate             = nil
            
            self.reloadRow(indexPath)
        }
        
        cell.Act_Cancel = { [weak self] in
            guard let self = self else { return }
            let outerRow = indexPath.row
            // Safety: if the row no longer exists (e.g. deleted by another action), bail
            guard outerRow < self.customScheduleFromTo.count else {
                self.editingOuterRow        = nil
                self.editingInnerRangeIndex = nil
                self.editingFromDate        = nil
                self.editingToDate          = nil
                self.tempFromDate           = nil
                self.tempToDate             = nil
                return
            }
            // Restore any dates that were stashed when this edit began
            self.restorePendingDates(for: outerRow)
            // Determine if there are now any dates remaining in this group
            let hasDates = !self.customScheduleFromTo[outerRow].dates.isEmpty
            if hasDates {
                // Dates exist — close the editor and show them
                self.editingOuterRow        = nil
                self.editingInnerRangeIndex = nil
                self.editingFromDate        = nil
                self.editingToDate          = nil
                self.tempFromDate           = nil
                self.tempToDate             = nil
            } else {
                // No dates — stay in "Add Dates" mode (new empty group)
                self.editingInnerRangeIndex = nil
                self.editingFromDate        = nil
                self.editingToDate          = nil
                self.tempFromDate           = nil
                self.tempToDate             = nil
            }
            self.reloadRow(indexPath)
        }
        
        // Remove a date range: strip its dates; only enter add-mode if group becomes empty
        cell.onRemove_Tapped = { [weak self] range in
            guard let self = self else { return }
            // If currently editing this row, restore stash first
            if self.editingOuterRow == indexPath.row {
                self.restorePendingDates(for: indexPath.row)
                self.editingOuterRow        = nil
                self.editingInnerRangeIndex = nil
                self.editingFromDate        = nil
                self.editingToDate          = nil
                self.tempFromDate           = nil
                self.tempToDate             = nil
            }
            let indicesToRemove = Set(range.indices)
            self.customScheduleFromTo[indexPath.row].dates = self.customScheduleFromTo[indexPath.row].dates
                .enumerated()
                .filter { !indicesToRemove.contains($0.offset) }
                .map { $0.element }
            let remaining = self.groupConsecutiveDates(self.customScheduleFromTo[indexPath.row].dates)
            if remaining.isEmpty {
                // Group is now empty — enter "Add Dates" mode
                self.editingOuterRow        = indexPath.row
                self.editingInnerRangeIndex = nil
                self.editingFromDate        = nil
                self.editingToDate          = nil
                self.tempFromDate           = nil
                self.tempToDate             = nil
            }
            // else: dates remain — stay in normal display mode, no edit panel
            self.reloadRow(indexPath)
        }
        
        // Remove the entire group (close/delete button on the group header)
        cell.Act_Close = { [weak self] in
            guard let self = self else { return }
            guard indexPath.row < self.customScheduleFromTo.count else { return }
            if self.editingOuterRow == indexPath.row {
                self.editingOuterRow        = nil
                self.editingInnerRangeIndex = nil
                self.editingFromDate        = nil
                self.editingToDate          = nil
                self.tempFromDate           = nil
                self.tempToDate             = nil
            } else if let editRow = self.editingOuterRow, editRow > indexPath.row {
                self.editingOuterRow = editRow - 1
            }
            self.customScheduleFromTo.remove(at: indexPath.row)
            // Perform deletion synchronously — we are already on the main thread here
            self.tbl_TimeList.deleteRows(at: [indexPath], with: .automatic)
            self.tbl_TimeList.layoutIfNeeded()
            self.tbl_Height.constant = self.tbl_TimeList.contentSize.height
        }
        
        return cell
    }
}

// MARK: - FSCalendarDataSource
extension Custom_ScheduleVC {
    func minimumDate(for calendar: FSCalendar) -> Date {
        return calendarMinimumDate
    }
}
