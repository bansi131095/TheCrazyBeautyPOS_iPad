//
//  TeamRosterVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 25/06/25.
//

import UIKit
import DropDown
import FSCalendar
import ObjectMapper


class TeamRosterVC: UIViewController {
    
    @IBOutlet weak var txt_FromDate: UITextField!
    @IBOutlet weak var txt_ToDate: UITextField!
    @IBOutlet weak var txt_search: UITextField!

    var workingHoursJson: String = ""
    var shiftTimingJson: String = ""
    var salonItems: [ScheduleModel] = []
    var TeamList: [StaffMember] = []
    
    var calendarVC: UIViewController?
    var firstDate: Date?
    var lastDate: Date?
    var datesRange: [Date] = []
    var dates: [String] = []
    var selectingDateFor: UITextField?
    var calendar: FSCalendar!
    var teamRosterItem: [TeamRosterItem] = []

    var searchWorkItem: DispatchWorkItem?
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let headerRow = UIStackView()
    let tableView = UITableView()
    var tableHeightConstraint: NSLayoutConstraint?

    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.api_getBusinessHours()
        setDefaultDateRangeAndFetch()
        self.setupTable()
        self.txt_search.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        // Then later after getting `TeamList` and `dates`

        // Do any additional setup after loading the view.
    }
    
    
    
    //MARK: Button Action
    @IBAction func act_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func act_sendEmail(_ sender: GradientButton) {
    }
    
    @IBAction func act_download(_ sender: GradientButton) {
    }
    
    @IBAction func btn_Calender(_ sender: UIButton) {
        if sender.tag == 1 {
            selectingDateFor = txt_FromDate
        } else {
            selectingDateFor = txt_ToDate
        }
        showCalendarPopup(sourceView: sender as! UIView)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        searchWorkItem?.cancel()

        let newWorkItem = DispatchWorkItem { [weak self] in
            self?.getShiftData()
        }

        searchWorkItem = newWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: newWorkItem)
    }
    
    //MARK: Table View
    func setupTable() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(headerRow)
        contentView.addSubview(tableView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        headerRow.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let screenWidth = UIScreen.main.bounds.width
        let totalAvailableWidth = screenWidth - 60 // 30 left + 30 right
        let columnWidth = totalAvailableWidth / 9
        let totalColumns = dates.count + 2 // Team + Total Hours + days count
        let contentWidth = columnWidth * CGFloat(totalColumns)
        let contentHeight = teamRosterItem.count * 75 + 85
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 180),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            contentView.widthAnchor.constraint(equalToConstant: contentWidth),
            
            headerRow.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerRow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerRow.heightAnchor.constraint(equalToConstant: 80),

        ])
        
        
        // Set table height constraint (will update later)
        tableHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 1)
        tableHeightConstraint?.isActive = true

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerRow.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: -20)

//            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: >=20),
            
            // Do NOT constrain bottomAnchor here
        ])
        
        headerRow.axis = .horizontal
        headerRow.spacing = 0
        headerRow.distribution = .fill
        
        for view in buildHeaderLabels() {
            headerRow.addArrangedSubview(view)
        }
      
        tableView.register(TeamRosterCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.rowHeight = 75
        tableView.isScrollEnabled = true // Important: disable internal scroll
        tableView.separatorStyle = .none

        // Optional: border only around actual data
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
        tableView.layer.masksToBounds = true
        
        
    }
        
    func buildHeaderLabels() -> [UIView] {
        var views: [UIView] = []
        
        views.append(makeHeaderLabel(title: "Team"))
        for date in dates {
            views.append(makeHeaderLabel(title: date))
        }
        views.append(makeHeaderLabel(title: "Total Hours"))
        
        return views
    }
    
    func makeHeaderLabel(title: String) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        // Total width: screen - 60 (30 padding on both sides)
        let screenWidth = UIScreen.main.bounds.width
        let totalAvailableWidth = screenWidth - 60
        let columnWidth = totalAvailableWidth / 9 // 9 columns

        container.widthAnchor.constraint(equalToConstant: columnWidth).isActive = true

        let label = UILabel()
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.borderWidth = 0.5
        label.borderColor = #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
        container.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            label.topAnchor.constraint(equalTo: container.topAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        return container
    }
        
   /* func makeHeaderLabel(title: String, width: CGFloat) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.backgroundColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            label.topAnchor.constraint(equalTo: container.topAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        return container
    } */

    
    //MARK: -  Function
    func setDefaultDateRangeAndFetch() {
        let calendar = Calendar.current
        let currentDate = Date()
        
        // 🔹 Find the weekday index (1 = Sunday, 2 = Monday, ..., 7 = Saturday)
        let weekday = calendar.component(.weekday, from: currentDate)

        // 🔹 Calculate how many days to subtract to get to Monday (weekday = 2)
        let daysToSubtract = (weekday == 1) ? 6 : weekday - 2
        
        // 🔹 Start of the week (Monday)
        guard let weekStart = calendar.date(byAdding: .day, value: -daysToSubtract, to: currentDate),
              let weekEnd = calendar.date(byAdding: .day, value: 6, to: weekStart) else { return }

        // 🔹 Format for UI
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"

        txt_FromDate.text = formatter.string(from: weekStart)
        txt_ToDate.text = formatter.string(from: weekEnd)

        // 🔹 Store for logic
        firstDate = weekStart
        lastDate = weekEnd

        // 🔹 Generate your weekday blocks
        dates = generateWeekDates(start: firstDate, end: lastDate)

        // 🔹 Fetch shift data
        self.getShiftData()
    }

    
    func showCalendarPopup(sourceView: UIView) {
        calendarVC = UIViewController()
        calendarVC?.modalPresentationStyle = .popover
        calendarVC?.preferredContentSize = CGSize(width: 500, height: 400)

        calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 500, height: 400))
        calendar.delegate = self
        calendar.dataSource = self
        calendar.firstWeekday = 2
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

    
    func generateWeekDates(start: Date?, end: Date?) -> [String] {
        guard let start = start, let end = end else { return [] }

        var dates: [String] = []
        let calendar = Calendar.current

        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "E" // Mon, Tue, etc.

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"

        var current = start

        while current <= end {
            let formatted = "\(dayFormatter.string(from: current))\n\(dateFormatter.string(from: current))"
            dates.append(formatted)

            guard let nextDay = calendar.date(byAdding: .day, value: 1, to: current) else { break }
            current = nextDay
        }

        return dates
    }

    func buildRosterFromJson(dates: [String], items: [StaffMember]) -> [TeamRosterItem] {
        var roster: [TeamRosterItem] = []

        for team in items {
            let fullName = "\(team.firstName) \(team.lastName)".capitalized
            let totalHours = team.totalHours

            let holidayDatesStr = team.holidayDates
            let shiftTimingsStr = team.shiftTimings
            let workingHoursStr = team.workingHours

            // 👉 Parse schedule
            let schedule = buildScheduleForDates(
                dates: dates,
                holidayDatesStr: holidayDatesStr,
                shiftTimingsStr: shiftTimingsStr
            )

            let item = TeamRosterItem(name: fullName, totalHours: totalHours, schedule: schedule)
            roster.append(item)
        }

        return roster
    }

    func buildScheduleForDates(
        dates: [String],
        holidayDatesStr: String,
        shiftTimingsStr: String
    ) -> [DaySchedule] {
        var holidayRanges: [DateTimeRange] = []
        var shiftTimings: [[String: String]] = []

        // Decode holiday JSON
        if let data = holidayDatesStr.data(using: .utf8) {
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: String]] {
                    holidayRanges = jsonArray.compactMap { dict in
                        guard let from = dict["from"], let to = dict["to"] else { return nil }
                        return DateTimeRange(start: from, end: to)
                    }
                }
            } catch {
                print("Holiday JSON error: \(error)")
            }
        }

        // Decode shift timing JSON
        if let data = shiftTimingsStr.data(using: .utf8) {
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: String]] {
                    shiftTimings = jsonArray
                }
            } catch {
                print("ShiftTiming JSON error: \(error)")
            }
        }

        // Check if a date is in any holiday range
        func isHoliday(_ date: Date) -> Bool {
            for range in holidayRanges {
                if isDate(date, between: range.start, and: range.end) {
                    return true
                }
            }
            return false
        }

        var schedule: [DaySchedule] = []

        for dateStr in dates {
            let parts = dateStr.components(separatedBy: "\n")
            guard parts.count == 2 else { continue }

            let datePart = parts[1]
            guard let date = DateFormatter.ddMMyyyy.date(from: datePart) else { continue }

            let dayName = getWeekdayString(from: date) // e.g., "Monday"

            guard let workingDay = salonItems.first(where: { $0.day == dayName }) else {
                schedule.append(DaySchedule(timeText: "Closed", status: "closed"))
                continue
            }

            if !workingDay.isSwitched {
                schedule.append(DaySchedule(timeText: "Closed", status: "closed"))
                continue
            }

            if isHoliday(date) {
                schedule.append(DaySchedule(timeText: "Off", status: "holiday"))
                continue
            }

            let shiftsForDay = shiftTimings.filter { $0["day"] == dayName }

            if !shiftsForDay.isEmpty {
                let shiftText = shiftsForDay.compactMap {
                    guard let from = $0["from"], let to = $0["to"] else { return nil }
                    return "\(from) - \(to)"
                }.joined(separator: "\n")

                schedule.append(DaySchedule(timeText: shiftText, status: "open"))
            } else {
                schedule.append(DaySchedule(timeText: "Off", status: "holiday"))
            }
        }

        return schedule
    }

    func getWeekdayString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date) // e.g., "Monday"
    }

    
    func isDate(_ date: Date, between startStr: String, and endStr: String) -> Bool {
        guard let start = DateFormatter.ddMMyyyy.date(from: startStr),
              let end = DateFormatter.ddMMyyyy.date(from: endStr) else { return false }
        return (start...end).contains(date)
    }



    //MARK: API Call
    func api_getBusinessHours() {
        APIService.shared.fetchTiming1 { workingHours in
            let salonHours = workingHours
            self.workingHoursJson = workingHours
            self.shiftTimingJson = workingHours
            let workinghours = APIService.shared.parseWorkingHours(salonHours)
            self.salonItems = self.convertWorkingHoursToSchedule(workinghours)
        }
    }
    
    func convertWorkingHoursToSchedule(_ workingHours: [WorkingHour]) -> [ScheduleModel] {
        let allDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        var result: [ScheduleModel] = []

        for day in allDays {
            if let match = workingHours.first(where: { $0.day == day }) {
                let fromTime = match.from ?? "00:00"
                let toTime = match.to ?? "23:00"
                result.append(ScheduleModel(day: day, from: fromTime, to: toTime, isSwitched: true))
            } else {
                result.append(ScheduleModel(day: day, from: "00:00", to: "23:00", isSwitched: false))
            }
        }

        return result
    }
    
    func getShiftData() {
        
        guard let fromDateString = self.txt_FromDate.text,
              let toDateString = self.txt_ToDate.text,
              let fromDate = convertStringToDate1(fromDateString),
              let toDate = convertStringToDate1(toDateString) else {
            print("Invalid date format")
            return
        }

        let formattedFrom = formatDateToString(fromDate)
        let formattedTo = formatDateToString(toDate)
        
        
        APIService.shared.getShiftTeam(vendorId: LocalData.userId, endDate: formattedTo, isTeamDetails: "1", limit: "10", page: "1", search: self.txt_search.text ?? "", startDate: formattedFrom,) { result in
            guard let model = result else {
                return
            }

            if model.error == "" || model.error == nil {
                let arr = model.data
                if arr.count != 0 {
                    self.TeamList = arr
                    self.teamRosterItem = self.buildRosterFromJson(dates: self.dates, items: self.TeamList)
                    self.tableView.reloadData()
                    DispatchQueue.main.async {
                        self.tableView.layoutIfNeeded()
                        self.tableHeightConstraint?.constant = self.tableView.contentSize.height
                    }
                }
            } else {
                self.show_alert(msg: model.error!, title: "Team Roster")
            }
        }
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


extension TeamRosterVC: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let calendarUtil = Calendar.current
        let weekday = calendarUtil.component(.weekday, from: date)

        // 🔹 Calculate weekStart (Monday)
        let daysToSubtract = (weekday == 1) ? 6 : weekday - 2
        guard let weekStart = calendarUtil.date(byAdding: .day, value: -daysToSubtract, to: date),
              let weekEnd = calendarUtil.date(byAdding: .day, value: 6, to: weekStart) else { return }

        // 🔹 Deselect all current selections
        for selected in calendar.selectedDates {
            calendar.deselect(selected)
        }

        // 🔹 Select full week
        let weekDates = getDateRange(from: weekStart, to: weekEnd)
        for d in weekDates {
            calendar.select(d)
        }

        // 🔹 Format for labels
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"

        txt_FromDate.text = formatter.string(from: weekStart)
        txt_ToDate.text = formatter.string(from: weekEnd)

        // 🔹 Store values and update shift data
        firstDate = weekStart
        lastDate = weekEnd
        dates = generateWeekDates(start: weekStart, end: weekEnd)
        self.getShiftData()

        calendarVC?.dismiss(animated: true)
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

extension TeamRosterVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamRosterItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TeamRosterCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.configure(item: teamRosterItem[indexPath.row], dateCount: dates.count)
        return cell
    }
}
