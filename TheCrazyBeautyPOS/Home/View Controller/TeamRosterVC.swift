//
//  TeamRosterVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 25/06/25.
//

import UIKit

class TeamRosterVC: UIViewController {

    let tableView = UITableView()

    let calendar = Calendar.current
    var selectedDate: Date = Date()
    var weekStart: Date?
    var weekEnd: Date?
    var dates: [String] = []

    var workingHoursJson: String = ""
    var shiftTimingJson: String = ""
    var salonItems: [ScheduleModel] = []
    
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        self.selectedDate = Date.now
        // Calculate start of week (Monday)
        let weekday = calendar.component(.weekday, from: self.selectedDate)
        // Convert to "days to subtract" to get Monday (Sunday=1, Monday=2,...)
        let daysToSubtract = (weekday + 5) % 7

        if let startOfWeek = calendar.date(byAdding: .day, value: -daysToSubtract, to: self.selectedDate) {
            self.weekStart = calendar.startOfDay(for: startOfWeek)
            self.weekEnd = calendar.date(byAdding: .day, value: 6, to: self.weekStart!)
        }
        self.dates = generateWeekDates(start: self.weekStart, end: self.weekEnd)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"

        if let weekStart, let weekEnd {
            let startDate = formatter.string(from: weekStart)
            let endDate = formatter.string(from: weekEnd)
            
            print("Start Date: \(startDate)")
            print("End Date: \(endDate)")
        }

        
        // Do any additional setup after loading the view.
    }
    
    
    
    //MARK: Button Action
    @IBAction func act_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.register(ShiftTableViewCell.self, forCellReuseIdentifier: ShiftTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        tableView.tableHeaderView = createHeaderView()
    }
    
    func createHeaderView() -> UIView {
        let container = UIView()
        container.backgroundColor = .systemGroupedBackground

        let nameLabel = UILabel()
        nameLabel.text = "Team Member"
        nameLabel.font = .boldSystemFont(ofSize: 16)
        nameLabel.frame = CGRect(x: 8, y: 0, width: 120, height: 40)

        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 128, y: 0, width: UIScreen.main.bounds.width - 128, height: 40)
        scrollView.showsHorizontalScrollIndicator = true

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 1
        stackView.distribution = .fillEqually

        for day in dates {
            let label = UILabel()
            label.text = day
            label.textAlignment = .center
            label.font = .boldSystemFont(ofSize: 14)
            label.backgroundColor = .systemGray5
            label.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
            label.widthAnchor.constraint(equalToConstant: 100).isActive = true
            stackView.addArrangedSubview(label)
        }

        scrollView.addSubview(stackView)
        container.addSubview(nameLabel)
        container.addSubview(scrollView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 40)
        ])

        container.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 40)
        return container
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TeamRosterVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 //teamMembers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShiftTableViewCell.identifier, for: indexPath) as! ShiftTableViewCell
//        let member = teamMembers[indexPath.row]
//        cell.configure(with: member)
        return cell
    }

}
