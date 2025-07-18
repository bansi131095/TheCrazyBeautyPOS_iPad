//
//  Team_ReportVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 17/07/25.
//

import UIKit
import DropDown
import FSCalendar


class Team_ReportVC: UIViewController {

    @IBOutlet weak var txt_SelectStaff: UITextField!
    @IBOutlet weak var txt_FromDate: UITextField!
    @IBOutlet weak var txt_ToDate: UITextField!
    
    var TeamDetails: [TeamDetailsModel] = []
    let dropDown = DropDown()
    
    var calendarVC: UIViewController?
    var firstDate: Date?
    var lastDate: Date?
    var datesRange: [Date] = []
    var selectingDateFor: UITextField?
    var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        get_TeamDetails()
    }
    
    func get_TeamDetails(){
        APIService.shared.fetchTeamDetails(vendorId: LocalData.userId) { result in
            self.TeamDetails = result!.data
            var names = self.TeamDetails.map { $0.first_name }
            names.insert("Select Staff", at: 0)
            self.dropDown.dataSource = names
        }
    }
    
    
    @IBAction func btn_SelectStaff(_ sender: Any) {
        dropDown.anchorView = txt_SelectStaff
        dropDown.bottomOffset = CGPoint(x: 0, y: txt_SelectStaff.bounds.height)
        dropDown.direction = .bottom
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_SelectStaff.text = item
            
            if index == 0 {
                print("No staff selected")  // First item: "Select Staff"
            } else {
                let selectedStaff = TeamDetails[index - 1] // Subtract 1 because of "Select Staff"
                print("Selected ID: \(selectedStaff.id), Name: \(selectedStaff.first_name)")
            }
        }
        dropDown.show()
    }
    
    @IBAction func btn_Calender(_ sender: UIButton) {
        if sender.tag == 1 {
            selectingDateFor = txt_FromDate
        } else {
            selectingDateFor = txt_ToDate
        }
        showCalendarPopup(sourceView: sender as! UIView)
    }
    
    //MARK: -  Function
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
}

extension Team_ReportVC: FSCalendarDelegate, FSCalendarDataSource {
    
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

            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy"
            txt_FromDate.text = formatter.string(from: firstDate!)
            txt_ToDate.text = formatter.string(from: lastDate!)

            calendarVC?.dismiss(animated: true, completion: nil)

        } else {
            // Reset all
            for selected in calendar.selectedDates {
                calendar.deselect(selected)
            }
            firstDate = date
            lastDate = nil
            calendar.select(date)

            // Clear text fields
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

