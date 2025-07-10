//
//  EditScheduleVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 04/07/25.
//

import UIKit
import ObjectMapper
import FSCalendar

class EditScheduleVC: UIViewController {

    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var vw_schedule: UIView!
    @IBOutlet weak var vwSchedule_height_const: NSLayoutConstraint!
    @IBOutlet weak var lbl_schedule: UILabel!
    @IBOutlet weak var btn_schedule: GradientButton!
    @IBOutlet weak var vw_selectDate: UIView!
    @IBOutlet weak var vwselectDate_height_const: NSLayoutConstraint!
    @IBOutlet weak var txt_date: TextInputLayout!
    @IBOutlet weak var btn_continue: GradientButton!
    
    
    var isEdit: Bool = false
    var salonItems: [ScheduleModel] = []
    var scheduleList: [Schedule] = []
    var customSchedules: [Schedule] = []
    var staffShiftlist: [StaffSchedule] = []
    var WorkingHours: String = ""
    var shiftTiming: String = ""
    var TeamName: String = ""
    var TeamId: String = ""
    var calendarVC: UIViewController?
    var selectedDate: Date = Date.now
    var dropdownTableView: UITableView?
    var activeTextField: UITextField?
    var activeDay: String = ""
    var activeDate: String = ""
    var activeIsFrom: Bool = true
    var activeIndex: Int = 0
    var times:[String] = []
    var isCustomSchedule:Bool = false
    var isSwitched: [String: Bool] = [:]
    var fromTimes: [String: [String]] = [:]
    var toTimes: [String: [String]] = [:]
    var startTime: [String: String] = [:]
    var endTime: [String: String] = [:]
    var deleteShiftList: [String] = []

    var onDataReturn: ((String, String) -> Void)?
    var salonHolidaysList: [SalonHolidayData] = []
    var disabledWeekdays: [Int] = []

    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTableView()
        self.scheduleList = self.parseScheduleData()
        self.updateSchedule()
        self.api_getHolidays()
        if !self.TeamId.isEmpty {
            self.api_getstaffShifts()
        }
        if isEdit {
            self.lbl_title.text = "Schedule For \(self.TeamName)"
            self.vw_schedule.isHidden = false
            self.vwSchedule_height_const.constant = 80.0
            self.vw_selectDate.isHidden = true
            self.vwselectDate_height_const.constant = 0.0
            self.lbl_schedule.text = "Regular Schedule"
            self.btn_schedule.setTitle("Add/Edit Custom Schedule", for: .normal)
            self.isCustomSchedule = false
        } else {
            self.lbl_title.text = "Assign Timing to New Team Member"
            self.vw_schedule.isHidden = true
            self.vwSchedule_height_const.constant = 0.0
        }
        selectedDate = Date.now
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        self.txt_date.text = formatter.string(from: selectedDate)
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: Button Action
    @IBAction func act_close(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func act_continue(_ sender: GradientButton) {
        if isCustomSchedule {
            self.showLoader()
            self.api_updatestaffShifts()
        } else {
            var workingHoursJson: String = ""
            var shiftTimingJson: String = ""
            
            workingHoursJson = getWorkingHoursJson(from: scheduleList)
            shiftTimingJson = getShiftTimingsJson(from: scheduleList)
            
            onDataReturn?(workingHoursJson, shiftTimingJson)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func act_schedule(_ sender: GradientButton) {
        if self.lbl_schedule.text == "Regular Schedule" {
            self.lbl_schedule.text = "Custom Schedule"
            self.btn_schedule.setTitle("Edit Regular Schedule", for: .normal)
            self.btn_continue.setTitle("Save", for: .normal)
            self.vw_selectDate.isHidden = false
            self.vwselectDate_height_const.constant = 80.0
            self.isCustomSchedule = true
            self.setCustomTableView()
            self.updateCustomSchedule()
//            self.api_getstaffShifts()
            self.tbl_vw.reloadData()
        } else {
            self.lbl_schedule.text = "Regular Schedule"
            self.btn_schedule.setTitle("Add/Edit Custom Schedule", for: .normal)
            self.btn_continue.setTitle("Continue", for: .normal)
            self.vw_selectDate.isHidden = true
            self.vwselectDate_height_const.constant = 0.0
            self.setTableView()
            self.scheduleList = self.parseScheduleData()
            self.updateSchedule()
            self.isCustomSchedule = false
            self.tbl_vw.reloadData()
        }
    }
    
    @IBAction func act_addShift(_ sender: UIButton) {
//        let isoFormatter = ISO8601DateFormatter()
//        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
//        let isoString = isoFormatter.string(from: selectedDate)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekdayName = dateFormatter.string(from: selectedDate)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "dd/MM/yyyy"
        let weekdate = dateFormatter1.string(from: selectedDate)

        guard let salonSchedule = salonItems.first(where: { $0.day == weekdayName }) else {
            print("No salon schedule found for day: \(weekdayName)")
            return
        }

        if let customSchedule = customSchedules.first(where: { $0.date == weekdate }) {
            let shift = ShiftTiming(map: Map(mappingType: .fromJSON, JSON: [:]))!
            shift.day = weekdayName
            shift.from = salonSchedule.from
            shift.to = salonSchedule.to
            shift.regular = 1
            
            customSchedule.shifts.append(shift)
        } else {
            print("No salon schedule found for date: \(weekdate)")
            let workingHour = WorkingHour(map: Map(mappingType: .fromJSON, JSON: [:]))!
            workingHour.day = weekdayName
            workingHour.from = salonSchedule.from
            workingHour.to = salonSchedule.to
            workingHour.off = false

            let shift = ShiftTiming(map: Map(mappingType: .fromJSON, JSON: [:]))!
            shift.day = weekdayName
            shift.from = salonSchedule.from
            shift.to = salonSchedule.to
            shift.regular = 1

            let schedule = Schedule(map: Map(mappingType: .fromJSON, JSON: [:]))!
            schedule.startTime = salonSchedule.from
            schedule.endTime = salonSchedule.to
            schedule.day = weekdayName
            schedule.date = weekdate
            schedule.workingHours = workingHour
            schedule.shifts = [shift]
            schedule.isSwitched = true

            customSchedules.append(schedule)
            print("Custom List: \(customSchedules)")
        }
        updateCustomSchedule()
    }
    
    
    //MARK: Setup Table view
    func setTableView(){
        tbl_vw.register(UINib(nibName: "teamScheduleCell", bundle: nil), forCellReuseIdentifier: "teamScheduleCell")
        tbl_vw.delegate = self
        tbl_vw.dataSource = self
        tbl_vw.rowHeight = UITableView.automaticDimension
        tbl_vw.estimatedRowHeight = 60
        tbl_vw.reloadData()
    }
    
    func setCustomTableView(){
        tbl_vw.register(UINib(nibName: "customScheduleCell", bundle: nil), forCellReuseIdentifier: "customScheduleCell")
        tbl_vw.delegate = self
        tbl_vw.dataSource = self
        tbl_vw.rowHeight = UITableView.automaticDimension
        tbl_vw.estimatedRowHeight = 60
        tbl_vw.reloadData()
    }
    

    func updateSchedule() {
        for schedule in self.scheduleList {
            self.isSwitched[schedule.day] = schedule.shifts.count > 0
            self.startTime[schedule.day] = schedule.startTime
            self.endTime[schedule.day] = schedule.endTime

            if schedule.shifts.count > 1 {
                self.fromTimes[schedule.day] = schedule.shifts.map { $0.from ?? "" }
                self.toTimes[schedule.day] = schedule.shifts.map { $0.to ?? "" }
            } else {
                let firstFrom = schedule.shifts.first?.from ?? ""
                let firstTo = schedule.shifts.first?.to ?? ""
                self.fromTimes[schedule.day] = [firstFrom]
                self.toTimes[schedule.day] = [firstTo]
            }
        }
        self.tbl_vw.reloadData()
    }
    
    func updateCustomSchedule() {
        for schedule in customSchedules {
            let day = schedule.date
            
            startTime[day] = schedule.startTime
            endTime[day] = schedule.endTime

            if schedule.shifts.count > 1 {
                var listFromShift: [String] = []
                var listToShift: [String] = []

                for shift in schedule.shifts {
                    if let from = shift.from {
                        listFromShift.append(from)
                    }
                    if let to = shift.to {
                        listToShift.append(to)
                    }
                }

                fromTimes[day] = !listFromShift.isEmpty ? listFromShift : []
                toTimes[day] = !listToShift.isEmpty ? listToShift : []

            } else {
                if let firstShift = schedule.shifts.first {
                    fromTimes[day] = firstShift.from != nil ? [firstShift.from!] : []
                    toTimes[day] = firstShift.to != nil ? [firstShift.to!] : []
                } else {
                    fromTimes[day] = []
                    toTimes[day] = []
                }
            }

            print("FromTime: \(fromTimes)")
            self.tbl_vw.reloadData()
        }

    }
    
    
    func parseScheduleData() -> [Schedule] {
        var workingHoursList: [WorkingHour] = []
        var shiftTimingsList: [ShiftTiming] = []

        if isEdit {
            // Parse WorkingHours JSON string
            if !WorkingHours.isEmpty,
               let workingHoursArray = try? JSONSerialization.jsonObject(with: Data(WorkingHours.utf8), options: []) as? [[String: Any]] {
                workingHoursList = Mapper<WorkingHour>().mapArray(JSONArray: workingHoursArray)
            }

            // Parse ShiftTiming JSON string
            if !shiftTiming.isEmpty,
               let shiftTimingArray = try? JSONSerialization.jsonObject(with: Data(shiftTiming.utf8), options: []) as? [[String: Any]] {
                shiftTimingsList = Mapper<ShiftTiming>().mapArray(JSONArray: shiftTimingArray)
            }

        } else {
            for schedule in salonItems {
                if schedule.isSwitched {
                    let workingHour = WorkingHour(map: Map(mappingType: .fromJSON, JSON: [:]))!
                    workingHour.day = schedule.day
                    workingHour.from = schedule.from
                    workingHour.to = schedule.to
                    workingHour.off = false
                    workingHoursList.append(workingHour)

                    let shift = ShiftTiming(map: Map(mappingType: .fromJSON, JSON: [:]))!
                    shift.day = schedule.day
                    shift.from = schedule.from
                    shift.to = schedule.to
                    shift.regular = 1
                    shiftTimingsList.append(shift)
                }
            }
        }

        print("Working Hours: \(workingHoursList)")
        print("Shift Timings: \(shiftTimingsList)")
        
        let workingHoursMap: [String: WorkingHour] = workingHoursList.reduce(into: [:]) { dict, item in
            if let day = item.day {
                dict[day] = item
            }
        }

        let weekDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

        var schedules: [Schedule] = []

        for day in weekDays {
            let workingHour = workingHoursMap[day] ?? {
                let defaultHour = WorkingHour(map: Map(mappingType: .fromJSON, JSON: [:]))!
                defaultHour.day = day
                defaultHour.from = ""
                defaultHour.to = ""
                defaultHour.off = true
                return defaultHour
            }()

            let shiftsForDay = shiftTimingsList.filter { $0.day == day }

            guard let salonSchedule = salonItems.first(where: { $0.day == day }) else {
                continue
            }

            let schedule = Schedule(map: Map(mappingType: .fromJSON, JSON: [:]))!
            schedule.startTime = salonSchedule.from
            schedule.endTime = salonSchedule.to
            schedule.isSwitched = shiftsForDay.count > 0 ? true : salonSchedule.isSwitched
            schedule.day = day
            schedule.workingHours = workingHour
            schedule.shifts = shiftsForDay

            schedules.append(schedule)
        }

        return schedules
    }
    
    func parseCustomScheduleData(from staffShifts: [StaffSchedule]) -> [Schedule] {
        var result: [Schedule] = []

        for item in staffShifts {
            // Decode working_hours
            var workingHour: WorkingHour?
            if let workingHoursData = item.workingHours.data(using: .utf8),
               let decoded = try? JSONSerialization.jsonObject(with: workingHoursData, options: []) as? [[String: Any]],
               let first = decoded.first {
                workingHour = WorkingHour(JSON: first)
            }

            // Decode shift_timings
            var shifts: [ShiftTiming] = []
            if let shiftTimingsData = item.shiftTimings.data(using: .utf8),
               let decoded = try? JSONSerialization.jsonObject(with: shiftTimingsData, options: []) as? [[String: Any]] {
                shifts = Mapper<ShiftTiming>().mapArray(JSONArray: decoded)
            }

            // Find corresponding salon schedule
            guard let salonSchedule = salonItems.first(where: { $0.day == item.day }) else { continue }

            // Create Schedule object
            let schedule = Schedule(map: Map(mappingType: .fromJSON, JSON: [:]))!
            schedule.startTime = salonSchedule.from
            schedule.endTime = salonSchedule.to
            schedule.day = item.day ?? ""
            schedule.date = formatDateString(item.date ?? "")
            schedule.shiftId = "\(item.id ?? 0)"
            schedule.workingHours = workingHour ?? WorkingHour(map: Map(mappingType: .fromJSON, JSON: [:]))!
            schedule.shifts = shifts
            schedule.isSwitched = true

            result.append(schedule)
        }

        return result
    }

    
    func getWorkingHoursJson(from schedules: [Schedule]) -> String {
        let workingHoursArray: [[String: Any]] = schedules
            .filter { !($0.workingHours.off ?? false) }
            .compactMap { schedule in
                guard let day = schedule.workingHours.day,
                      let from = schedule.workingHours.from,
                      let to = schedule.workingHours.to,
                      let off = schedule.workingHours.off else {
                    return nil
                }
                return [
                    "day": day,
                    "from": from,
                    "to": to,
                    "off": off
                ]
            }

        if let data = try? JSONSerialization.data(withJSONObject: workingHoursArray, options: []),
           let jsonString = String(data: data, encoding: .utf8) {
            return jsonString
        }

        return "[]"
    }

    func getShiftTimingsJson(from schedules: [Schedule]) -> String {
        let shiftTimingsArray: [[String: String]] = schedules
            .filter { !$0.shifts.isEmpty }
            .flatMap { schedule in
                schedule.shifts.compactMap { shift in
                    guard let day = shift.day,
                          let from = shift.from,
                          let to = shift.to else {
                        return nil
                    }
                    return [
                        "day": day,
                        "from": from,
                        "to": to
                    ]
                }
            }

        if let data = try? JSONSerialization.data(withJSONObject: shiftTimingsArray, options: []),
           let jsonString = String(data: data, encoding: .utf8) {
            return jsonString
        }

        return "[]"
    }
    
    func updateHolidayModel(_ sequenceList: [SalonHolidayData]) {
        salonHolidaysList.removeAll()

        for sequenceData in sequenceList {
            let data = SalonHolidayData(map: Map(mappingType: .fromJSON, JSON: [:]))!
            data.from = sequenceData.from
            data.to = sequenceData.to
            salonHolidaysList.append(data)
        }

        print("Selected Description: \(salonHolidaysList)")
    }

    //MARK: API Call
    func api_getstaffShifts() {
        APIService.shared.getstaffShift(staffId: self.TeamId) { result in
            if let data = result?.data, !data.isEmpty {
                self.staffShiftlist = data
                self.customSchedules = self.parseCustomScheduleData(from: self.staffShiftlist)
            }
        }
    }
    
    func api_getHolidays() {
        APIService.shared.getHolidays() { result in
            let holidayDates = result
            if !holidayDates.isEmpty {
                if let data = holidayDates.data(using: .utf8),
                   let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {

                    let staffList = Mapper<SalonHolidayData>().mapArray(JSONArray: jsonArray)
                    self.updateHolidayModel(staffList)
                } else {
                    print("❌ Failed to decode holidayDates JSON")
                }
            }
        }
    }
    
    func api_updatestaffShifts() {
        
        var staffShiftMap: [[String: Any]] = []

        for selectedStaff in customSchedules {
            let teamId = self.TeamId
            let date = convertToDate1(selectedStaff.date) // implement same format as Dart
            var workingHoursString = ""
            var shiftTimingString = ""

            // Prepare working hours map
            var workingHoursMap: [[String: Any]] = []
            let val1: [String: Any] = [
                "day": selectedStaff.workingHours.day ?? "",
                "from": selectedStaff.workingHours.from ?? "",
                "to": selectedStaff.workingHours.to ?? "",
                "off": selectedStaff.workingHours.off ?? false
            ]
            workingHoursMap.append(val1)

            if let data = try? JSONSerialization.data(withJSONObject: workingHoursMap, options: []),
               let jsonStr = String(data: data, encoding: .utf8) {
                workingHoursString = jsonStr
                print("Working Hours: \(workingHoursString)")
            }

            // Prepare shifts
            var shiftMap: [[String: Any]] = []
            for shift in selectedStaff.shifts {
                let val: [String: Any] = [
                    "day": shift.day ?? "",
                    "from": shift.from ?? "",
                    "to": shift.to ?? ""
                ]
                shiftMap.append(val)
            }

            if let data = try? JSONSerialization.data(withJSONObject: shiftMap, options: []),
               let jsonStr = String(data: data, encoding: .utf8) {
                shiftTimingString = jsonStr
                print("Shift: \(shiftTimingString)")
            }

            // Final map for this schedule
            let val: [String: Any] = [
                "staff_id": teamId,
                "date": date,
                "day": selectedStaff.day,
                "working_hours": workingHoursString,
                "shift_timings": shiftTimingString
            ]

            staffShiftMap.append(val)
        }
        let deleteShift = deleteShiftList.joined(separator: ",")
        print("Staff Shift Delete: \(deleteShift)")
        // Encode full list
        if let staffShiftData = try? JSONSerialization.data(withJSONObject: staffShiftMap, options: []),
           let staffShiftJson = String(data: staffShiftData, encoding: .utf8) {
            print("Staff Shift Update: \(staffShiftJson)")
            APIService.shared.updateStaffShift(staffShift: staffShiftJson, deleteShift: deleteShift) { result in
                guard let model = result else {
                    return
                }
                self.hideLoader()
                if model.error == "" || model.error == nil {
                    self.showToast(message: model.data)
            
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.dismiss(animated: true)
                    }
                } else {
                    self.show_alert(msg: model.error ?? "", title: "Delete Client")
                }
            }
        }

        // Deleted shift IDs
        
    }
    
    func formatDateString(_ dateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = isoFormatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "dd/MM/yyyy"
            displayFormatter.timeZone = TimeZone.current
            return displayFormatter.string(from: date)
        }
        return ""
    }

    func convertToDate1(_ isoDate: String) -> String {
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "dd/MM/yyyy"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"

        if let date = displayFormatter.date(from: isoDate) {
            return formatter.string(from: date)
        }
        return isoDate
    }
    
    // MARK: - Dropdown Handling
    func showDropdown(below textField: UITextField, timess: [String]) {
        removeDropdown()
        self.view.endEditing(true)
        guard let window = self.view.window else { return }

        let screenHeight = UIScreen.main.bounds.height
        let textFieldFrame = textField.convert(textField.bounds, to: window)
        let maxDropdownHeight: CGFloat = 400
        let preferredDropdownHeight = CGFloat(timess.count * 40)
        let dropdownHeight = min(preferredDropdownHeight, maxDropdownHeight)

        var dropdownY: CGFloat = textFieldFrame.maxY // Default: show below

        // If dropdown goes off-screen, flip it above
        if textFieldFrame.maxY + dropdownHeight > screenHeight - 20 {
            // Show above if enough space
            if textFieldFrame.minY - dropdownHeight > 100 {
                dropdownY = textFieldFrame.minY - dropdownHeight
            }
        }

        let dropdownFrame = CGRect(
            x: textFieldFrame.origin.x,
            y: dropdownY,
            width: textFieldFrame.width,
            height: dropdownHeight
        )
        
        // Add transparent overlay for dismiss
            let overlay = UIButton(frame: window.bounds)
            overlay.backgroundColor = .clear
            overlay.addTarget(self, action: #selector(removeDropdown), for: .touchUpInside)
            overlay.tag = 998
            window.addSubview(overlay)


        let dropdown = UITableView(frame: dropdownFrame)
        dropdown.dataSource = self
        dropdown.delegate = self
        dropdown.tag = 999
        dropdown.rowHeight = 40
        dropdown.layer.cornerRadius = 8
        dropdown.layer.borderWidth = 1
        dropdown.layer.borderColor = UIColor.lightGray.cgColor
        dropdown.separatorStyle = .none
        dropdown.backgroundColor = .white
        dropdown.isScrollEnabled = true

        window.addSubview(dropdown)
        self.dropdownTableView = dropdown
        self.times = timess
    }


    @objc func removeDropdown() {
        dropdownTableView?.removeFromSuperview()
        dropdownTableView = nil

        if let window = self.view.window {
            // Remove the transparent overlay too
            window.viewWithTag(998)?.removeFromSuperview()
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeDropdown()
        view.endEditing(true)
    }
    
    //MARK: Custom Function
    func showCalendarPopup(sourceView: UIView) {
        let offDays: [String] = salonItems
            .filter { !$0.isSwitched }
            .map { $0.day }

        let weekdayMap: [String: Int] = [
            "Sunday": 1,
            "Monday": 2,
            "Tuesday": 3,
            "Wednesday": 4,
            "Thursday": 5,
            "Friday": 6,
            "Saturday": 7
        ]

        disabledWeekdays = offDays.compactMap { weekdayMap[$0] }

        print("Disabled Weekdays: \(disabledWeekdays)")
        
        calendarVC = UIViewController()
        calendarVC?.modalPresentationStyle = .popover
        calendarVC?.preferredContentSize = CGSize(width: 500, height: 400)

        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 500, height: 400))
        calendar.delegate = self
        calendar.dataSource = self
        calendar.appearance.titleDefaultColor = .black
        calendar.appearance.selectionColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
        calendar.appearance.todayColor = #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
        calendar.select(selectedDate)
        calendarVC?.view.addSubview(calendar)

        if let popover = calendarVC?.popoverPresentationController {
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
            popover.permittedArrowDirections = .up
        }

        self.present(calendarVC!, animated: true, completion: nil)
    }
    
    func generateTimeSlots(from start: Double = 6.5, to end: Double = 22.0, interval: Double = 0.5) -> [String] {
        return stride(from: start, through: end, by: interval).map {
            let hour = Int($0)
            let minutes = Int(($0 - Double(hour)) * 60)
            return String(format: "%02d:%02d", hour, minutes)
        }
    }

    func timeStringToDouble(_ timeString: String) -> Double? {
        let components = timeString.split(separator: ":")
        guard components.count == 2,
              let hour = Double(components[0]),
              let minute = Double(components[1]) else {
            return nil
        }
        return hour + (minute / 60.0)
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
    
    func generateFilteredTimeSlots(fullStart: String, fullEnd: String, from: String, to: String, interval: Int) -> [String] {
        let fullSlots = generateTimeSlots(start: fullStart, end: fullEnd, interval: interval)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        guard let fromTime = formatter.date(from: from),
              let toTime = formatter.date(from: to) else {
            return fullSlots
        }

        let filtered = fullSlots.filter { timeString in
            guard let time = formatter.date(from: timeString) else { return true }
            return time < fromTime || time > toTime
        }

        return filtered
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK: - UITableView Delegate & DataSource
extension EditScheduleVC: UITableViewDelegate, UITableViewDataSource {

    // Dropdown Data Source
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == dropdownTableView {
            let cell = UITableViewCell()
            cell.textLabel?.text = times[indexPath.row]
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            return cell
        } else {
            if isCustomSchedule {
                guard let cell = self.tbl_vw.dequeueReusableCell(withIdentifier: "customScheduleCell", for: indexPath) as? customScheduleCell else {
                    return UITableViewCell()
                }
                
                let schedule = customSchedules[indexPath.row]
                let day = schedule.date
                cell.lbl_day.text = schedule.day
                let formattedDate = day
                cell.lbl_date.text = formattedDate
                // Dropdowns
                let froms = fromTimes[day] ?? [""]
                let tos = toTimes[day] ?? [""]

                cell.txt_from.text = froms.first ?? ""
                cell.txt_to.text = tos.first ?? ""
                
                cell.onTextFieldTap = { [weak self] textField in
                    guard let self = self else { return }
                    self.activeTextField = textField
                    self.activeDay = day
                    self.activeDate = schedule.date
                    if textField == cell.txt_from {
                        self.activeIsFrom = true
                        self.activeIndex = 0
                    } else if textField == cell.txt_to {
                        self.activeIsFrom = false
                        self.activeIndex = 0
                    } else if textField == cell.txt_from1 {
                        self.activeIsFrom = true
                        self.activeIndex = 1
                    } else if textField == cell.txt_to1 {
                        self.activeIsFrom = false
                        self.activeIndex = 1
                    }
                    
                    guard let fromList = self.fromTimes[day],
                          let toList = self.toTimes[day] else {
                        return
                    }

                    let currentFrom = fromList[0]
                    let currentTo = toList[0]
                    let originalStart = self.startTime[day] ?? ""
                    let originalEnd = self.endTime[day] ?? ""

                    let fromChanged = currentFrom != originalStart
                    let toChanged = currentTo != originalEnd
                    
                    if fromChanged && toChanged {
                        let start = (self.activeIndex == 1) ?  fromChanged ? (self.fromTimes[day]?[1] ?? "00:00") : (self.toTimes[day]?[0] ?? "00:00") : (self.startTime[day] ?? "00:00")
                        let end = (self.activeIndex == 0 && (self.fromTimes[day]?.count ?? 0) > 1)
                            ? (self.fromTimes[day]?[1] ?? "23:00")
                            : (self.endTime[day] ?? "23:00")
                        if self.activeIndex == 1 {
                            self.activeTextField?.text = ""
                            
                            let slots = self.generateFilteredTimeSlots(fullStart: start, fullEnd: end, from: currentFrom, to: currentTo, interval: 30)
                            self.showDropdown(below: textField, timess: slots)
                        } else {
                            let slots = self.generateTimeSlots(start: start, end: end, interval: 30)
                            self.showDropdown(below: textField, timess: slots)
                        }
                    } else if fromChanged {
                        let start = (self.startTime[day] ?? "00:00")
                        let end = (self.activeIndex == 0 && (self.fromTimes[day]?.count ?? 0) > 1)
                            ? (self.fromTimes[day]?[1] ?? "23:00")
                        : self.activeIndex == 1 ? (self.toTimes[day]?[1] ?? "23:00") : (self.endTime[day] ?? "23:00")
                        let slots = self.generateTimeSlots(start: start, end: end, interval: 30)
                        self.showDropdown(below: textField, timess: slots)
                    } else if toChanged {
                        let start = (self.activeIndex == 1) ? (self.toTimes[day]?[0] ?? "00:00") : (self.startTime[day] ?? "00:00")
                        let end = (self.activeIndex == 0 && (self.fromTimes[day]?.count ?? 0) > 1)
                            ? (self.fromTimes[day]?[1] ?? "23:00")
                            : (self.endTime[day] ?? "23:00")
                        let slots = self.generateTimeSlots(start: start, end: end, interval: 30)
                        self.showDropdown(below: textField, timess: slots)
                    } else {
                        let start = (self.activeIndex == 1) ? (self.toTimes[day]?[0] ?? "00:00") : (self.startTime[day] ?? "00:00")
                        let end = (self.activeIndex == 0 && (self.fromTimes[day]?.count ?? 0) > 1)
                            ? (self.fromTimes[day]?[1] ?? "23:00")
                            : (self.endTime[day] ?? "23:00")
                        let slots = self.generateTimeSlots(start: start, end: end, interval: 30)
                        self.showDropdown(below: textField, timess: slots)
                    }
                }
                
                if froms.count > 1 {
                    cell.vw_2.isHidden = false
                    cell.vw2_height_const.constant = 60.0
                    cell.txt_from1.text = froms[1]
                    cell.txt_to1.text = tos[1]
                } else {
                    cell.vw_2.isHidden = true
                    cell.vw2_height_const.constant = 0.0
                    cell.txt_from1.text = ""
                    cell.txt_to1.text = ""
                }

                cell.Act_Cancel = { [weak self] in
                    guard let self = self else { return }
                    if !schedule.shiftId.isEmpty {
                        self.deleteShiftList.append(schedule.shiftId)
                    }
                    self.customSchedules.remove(at: indexPath.row)
                    self.tbl_vw.reloadData()
                }
                cell.Act_Add = { [weak self] in
                    
                    guard let self = self else { return }

                    guard let fromList = self.fromTimes[day],
                          let toList = self.toTimes[day],
                          fromList.count == 1,
                          toList.count == 1 else {
                        return
                    }

                    let currentFrom = fromList[0]
                    let currentTo = toList[0]
                    let originalStart = self.startTime[day] ?? ""
                    let originalEnd = self.endTime[day] ?? ""

                    let fromChanged = currentFrom != originalStart
                    let toChanged = currentTo != originalEnd
                    
                    if fromChanged && toChanged {
                        // ✅ Add second shift
                        let secondFrom = self.startTime[day] ?? "00:00"
                        let secondTo = self.endTime[day] ?? "23:00"
                        
                        self.fromTimes[day]?.insert(secondFrom, at: 1)
                        self.toTimes[day]?.append(secondTo)
                        
                        let newShift = ShiftTiming(map: Map(mappingType: .fromJSON, JSON: [:]))!
                        newShift.day = day
                        newShift.from = secondFrom
                        newShift.to = secondTo
                        newShift.regular = 1
                        
                        schedule.shifts.append(newShift)
                        
                    } else if fromChanged {
                        self.fromTimes[day]?.insert(originalStart, at: 1)
                        self.toTimes[day]?.append(currentFrom)
                        let shift = ShiftTiming(map: Map(mappingType: .fromJSON, JSON: [:]))!
                        shift.day = day
                        shift.from = originalStart
                        shift.to = currentFrom
                        shift.regular = 1
                        schedule.shifts.append(shift)
                    } else if toChanged {
                        self.fromTimes[day]?.insert(currentTo, at: 1)
                        self.toTimes[day]?.append(originalEnd)
                        let shift = ShiftTiming(map: Map(mappingType: .fromJSON, JSON: [:]))!
                        shift.day = day
                        shift.from = currentTo
                        shift.to = originalEnd
                        shift.regular = 1
                        schedule.shifts.append(shift)
                    }
                    self.tbl_vw.reloadData()
                }
 
                cell.Act_Remove = { [weak self] in
                    guard let self = self else { return }
                    guard self.fromTimes[day]?.count ?? 0 > 1 else { return }
                    self.fromTimes[day]?.removeLast()
                    self.toTimes[day]?.removeLast()
                    if schedule.shifts.count > 1 {
                        schedule.shifts.removeLast()
                    }
                    self.tbl_vw.reloadData()
                }
                
                return cell
            } else {
                guard let cell = self.tbl_vw.dequeueReusableCell(withIdentifier: "teamScheduleCell", for: indexPath) as? teamScheduleCell else {
                    return UITableViewCell()
                }
                
                let schedule = scheduleList[indexPath.row]
                let day = schedule.day
                cell.lbl_day.text = day

                // Dropdowns
                let froms = fromTimes[day] ?? [""]
                let tos = toTimes[day] ?? [""]

                cell.txt_from.text = froms.first ?? ""
                cell.txt_to.text = tos.first ?? ""
                
                cell.onTextFieldTap = { [weak self] textField in
                    guard let self = self else { return }
                    self.activeTextField = textField
                    self.activeDay = day

                    if textField == cell.txt_from {
                        self.activeIsFrom = true
                        self.activeIndex = 0
                    } else if textField == cell.txt_to {
                        self.activeIsFrom = false
                        self.activeIndex = 0
                    } else if textField == cell.txt_from1 {
                        self.activeIsFrom = true
                        self.activeIndex = 1
                    } else if textField == cell.txt_to1 {
                        self.activeIsFrom = false
                        self.activeIndex = 1
                    }
                    
                    guard let fromList = self.fromTimes[day],
                          let toList = self.toTimes[day] else {
                        return
                    }

                    let currentFrom = fromList[0]
                    let currentTo = toList[0]
                    let originalStart = self.startTime[day] ?? ""
                    let originalEnd = self.endTime[day] ?? ""

                    let fromChanged = currentFrom != originalStart
                    let toChanged = currentTo != originalEnd
                    
                    if fromChanged && toChanged {
                        let start = (self.activeIndex == 1) ?  fromChanged ? (self.fromTimes[day]?[1] ?? "00:00") : (self.toTimes[day]?[0] ?? "00:00") : (self.startTime[day] ?? "00:00")
                        let end = (self.activeIndex == 0 && (self.fromTimes[day]?.count ?? 0) > 1)
                            ? (self.fromTimes[day]?[1] ?? "23:00")
                            : (self.endTime[day] ?? "23:00")
                        if self.activeIndex == 1 {
                            self.activeTextField?.text = ""
                            
                            let slots = self.generateFilteredTimeSlots(fullStart: start, fullEnd: end, from: currentFrom, to: currentTo, interval: 30)
                            self.showDropdown(below: textField, timess: slots)
                        } else {
                            let slots = self.generateTimeSlots(start: start, end: end, interval: 30)
                            self.showDropdown(below: textField, timess: slots)
                        }
                    } else if fromChanged {
                        let start = (self.startTime[day] ?? "00:00")
                        let end = (self.activeIndex == 0 && (self.fromTimes[day]?.count ?? 0) > 1)
                            ? (self.fromTimes[day]?[1] ?? "23:00")
                        : self.activeIndex == 1 ? (self.toTimes[day]?[1] ?? "23:00") : (self.endTime[day] ?? "23:00")
                        let slots = self.generateTimeSlots(start: start, end: end, interval: 30)
                        self.showDropdown(below: textField, timess: slots)
                    } else if toChanged {
                        let start = (self.activeIndex == 1) ? (self.toTimes[day]?[0] ?? "00:00") : (self.startTime[day] ?? "00:00")
                        let end = (self.activeIndex == 0 && (self.fromTimes[day]?.count ?? 0) > 1)
                            ? (self.fromTimes[day]?[1] ?? "23:00")
                            : (self.endTime[day] ?? "23:00")
                        let slots = self.generateTimeSlots(start: start, end: end, interval: 30)
                        self.showDropdown(below: textField, timess: slots)
                    } else {
                        let start = (self.activeIndex == 1) ? (self.toTimes[day]?[0] ?? "00:00") : (self.startTime[day] ?? "00:00")
                        let end = (self.activeIndex == 0 && (self.fromTimes[day]?.count ?? 0) > 1)
                            ? (self.fromTimes[day]?[1] ?? "23:00")
                            : (self.endTime[day] ?? "23:00")
                        let slots = self.generateTimeSlots(start: start, end: end, interval: 30)
                        self.showDropdown(below: textField, timess: slots)
                    }
                }
                
                if froms.count > 1 {
                    cell.vw_2.isHidden = false
                    cell.vw2_height_const.constant = 60.0
                    cell.txt_from1.text = froms[1]
                    cell.txt_to1.text = tos[1]
                } else {
                    cell.vw_2.isHidden = true
                    cell.vw2_height_const.constant = 0.0
                    cell.txt_from1.text = ""
                    cell.txt_to1.text = ""
                }

                let isDaySwitched = isSwitched[day] ?? false
                if schedule.isSwitched {
                    cell.btn_switch.setImage(#imageLiteral(resourceName: isDaySwitched ? "rdCheck.png" : "rdUncheck"), for: .normal)
                    cell.lbl_salonOff.isHidden = isDaySwitched
                    cell.vw_1.isHidden = !isDaySwitched
                    cell.vw1_height_const.constant = isDaySwitched ? 60.0 : 0.0
                    cell.img_add.image = froms.count > 1 ? #imageLiteral(resourceName: "plus-disable") : #imageLiteral(resourceName: "plus")
                } else {
                    cell.btn_switch.setImage(#imageLiteral(resourceName: "rdUncheck"), for: .normal)
                    cell.vw_1.isHidden = true
                    cell.vw2_height_const.constant = 0.0
                    cell.vw_2.isHidden = true
                    cell.lbl_salonOff.isHidden = false
                    cell.lbl_salonOff.text = "Salon Off"
                }

                cell.Act_Switch = { [weak self] in
                    guard let self = self else { return }
                    let current = self.isSwitched[day] ?? false
                    self.isSwitched[day] = !current

                    if !current {
                        // Turn on
                        let start = self.startTime[day] ?? "00:00"
                        let end = self.endTime[day] ?? "23:00"
                        fromTimes[day] = [start]
                        toTimes[day] = [end]
                        let shift = ShiftTiming(map: Map(mappingType: .fromJSON, JSON: [:]))!
                        shift.day = day
                        shift.from = start
                        shift.to = end
                        shift.regular = 1
                        schedule.shifts.append(shift)
                        schedule.isSwitched = !current
                    } else {
                        fromTimes[day] = []
                        toTimes[day] = []
                        schedule.shifts = []
                        schedule.isSwitched = !current
                    }
                    self.tbl_vw.reloadData()
                }
                
                cell.Act_Add = { [weak self] in
                    
                    guard let self = self else { return }

                    guard let fromList = self.fromTimes[day],
                          let toList = self.toTimes[day],
                          fromList.count == 1,
                          toList.count == 1 else {
                        return
                    }

                    let currentFrom = fromList[0]
                    let currentTo = toList[0]
                    let originalStart = self.startTime[day] ?? ""
                    let originalEnd = self.endTime[day] ?? ""

                    let fromChanged = currentFrom != originalStart
                    let toChanged = currentTo != originalEnd
                    
                    if fromChanged && toChanged {
                        // ✅ Add second shift
                        let secondFrom = self.startTime[day] ?? "00:00"
                        let secondTo = self.endTime[day] ?? "23:00"
                        
                        self.fromTimes[day]?.insert(secondFrom, at: 1)
                        self.toTimes[day]?.append(secondTo)
                        
                        let newShift = ShiftTiming(map: Map(mappingType: .fromJSON, JSON: [:]))!
                        newShift.day = day
                        newShift.from = secondFrom
                        newShift.to = secondTo
                        newShift.regular = 1
                        
                        schedule.shifts.append(newShift)
                        
                    } else if fromChanged {
                        self.fromTimes[day]?.insert(originalStart, at: 1)
                        self.toTimes[day]?.append(currentFrom)
                        let shift = ShiftTiming(map: Map(mappingType: .fromJSON, JSON: [:]))!
                        shift.day = day
                        shift.from = originalStart
                        shift.to = currentFrom
                        shift.regular = 1
                        schedule.shifts.append(shift)
                    } else if toChanged {
                        self.fromTimes[day]?.insert(currentTo, at: 1)
                        self.toTimes[day]?.append(originalEnd)
                        let shift = ShiftTiming(map: Map(mappingType: .fromJSON, JSON: [:]))!
                        shift.day = day
                        shift.from = currentTo
                        shift.to = originalEnd
                        shift.regular = 1
                        schedule.shifts.append(shift)
                    }
                    self.tbl_vw.reloadData()
                }

                cell.Act_Remove = { [weak self] in
                    guard let self = self else { return }
                    guard self.fromTimes[day]?.count ?? 0 > 1 else { return }
                    self.fromTimes[day]?.removeLast()
                    self.toTimes[day]?.removeLast()
                    if schedule.shifts.count > 1 {
                        schedule.shifts.removeLast()
                    }
                    self.tbl_vw.reloadData()
                }
                return cell
            }
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == dropdownTableView {
            return times.count
        } else {
            if isCustomSchedule {
                return self.customSchedules.count
            } else {
                return self.scheduleList.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == dropdownTableView {
            let selectedValue = times[indexPath.row]
            activeTextField?.text = selectedValue
            removeDropdown()
            activeTextField?.resignFirstResponder()

            // ✅ Update internal state maps
            if activeIsFrom {
                fromTimes[activeDay]?[activeIndex] = selectedValue
            } else {
                toTimes[activeDay]?[activeIndex] = selectedValue
            }
            if self.isCustomSchedule {
                if let scheduleIndex = customSchedules.firstIndex(where: { $0.date == activeDay }) {
                    let schedule = customSchedules[scheduleIndex]
                    if activeIndex < schedule.shifts.count {
                        if activeIsFrom {
                            schedule.shifts[activeIndex].from = selectedValue
    //                        if activeIndex == 1, schedule.shifts.indices.contains(0) {
    //                            schedule.shifts[0].from = ""
    //                            schedule.shifts[0].to = ""
    //                        }
                        } else {
                            schedule.shifts[activeIndex].to = selectedValue
    //                        if activeIndex == 1, schedule.shifts.indices.contains(0) {
    //                            schedule.shifts[0].to = ""
    //                            schedule.shifts[0].from = ""
    //                        }
                        }
                    }
                }
                self.updateCustomSchedule()
            } else {
                if let scheduleIndex = scheduleList.firstIndex(where: { $0.day == activeDay }) {
                    let schedule = scheduleList[scheduleIndex]
                    if activeIndex < schedule.shifts.count {
                        if activeIsFrom {
                            schedule.shifts[activeIndex].from = selectedValue
    //                        if activeIndex == 1, schedule.shifts.indices.contains(0) {
    //                            schedule.shifts[0].from = ""
    //                            schedule.shifts[0].to = ""
    //                        }
                        } else {
                            schedule.shifts[activeIndex].to = selectedValue
    //                        if activeIndex == 1, schedule.shifts.indices.contains(0) {
    //                            schedule.shifts[0].to = ""
    //                            schedule.shifts[0].from = ""
    //                        }
                        }
                    }
                }
                self.updateSchedule()
            }
            tbl_vw.reloadData()
        }
    }


    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        removeDropdown()
    }
    
        
}

extension EditScheduleVC: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == txt_date) {
            self.view.endEditing(true)
            showCalendarPopup(sourceView: textField)
            return false // Prevent keyboard
        } else {
            return true
        }
    }
    
}

extension EditScheduleVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        self.txt_date.text = formatter.string(from: selectedDate)
//        self.txt_date.showLabel()
        calendarVC?.dismiss(animated: true)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
// || disabledDates.contains(where: { calendar.isDate($0, inSameDayAs: date) })
        
        if disabledWeekdays.contains(weekday)  {
            return .lightGray
        }

        return .black
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)

        // Disable if in disabled weekdays
        if disabledWeekdays.contains(weekday) {
            return false
        }

//        // Disable if in disabled dates
//        if disabledDates.contains(where: { calendar.isDate($0, inSameDayAs: date) }) {
//            return false
//        }

        return true
    }

    
}
