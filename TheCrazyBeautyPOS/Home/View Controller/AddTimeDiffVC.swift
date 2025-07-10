//
//  AddTimeDiffVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 09/07/25.
//

import UIKit
import ObjectMapper
import FSCalendar

class AddTimeDiffVC: UIViewController {

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var txt_from: TextInputLayout!
    @IBOutlet weak var txt_to: TextInputLayout!
    @IBOutlet weak var tbl_vw: UITableView!
    
    var TeamName: String = ""
    var TeamId: String = ""
    var salonHolidaysList: [SalonHolidayData] = []
    
    var calendarVC: UIViewController?
    var fromSelectedDate: Date?
    var toSelectedDate: Date?
    var isSelectingFromDate: Bool = false

    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_from.delegate = self
        txt_to.delegate = self
        self.setTableView()
        self.getStaffHolidays()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: Button Action
    @IBAction func act_cancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func act_save(_ sender: GradientButton) {
        self.api_updatestaffHolidays()
    }
    
    
    //MARK: Table view
    func setTableView(){
        tbl_vw.register(UINib(nibName: "TimeOffCell", bundle: nil), forCellReuseIdentifier: "TimeOffCell")
        tbl_vw.register(UINib(nibName: "TimeOffHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "TimeOffHeaderCell")
        tbl_vw.delegate = self
        tbl_vw.dataSource = self
        tbl_vw.rowHeight = UITableView.automaticDimension
        tbl_vw.estimatedRowHeight = 60
    }
    
    //MARK: Api Call
    func getStaffHolidays() {
        APIService.shared.getStaffHoliday(staffId: self.TeamId) { staffResult in
            guard let model = staffResult else {
                return
            }

            let holidayDates = model
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
    
    
    func updateHolidayModel(_ sequenceList: [SalonHolidayData]) {
        salonHolidaysList.removeAll()

        for sequenceData in sequenceList {
            let data = SalonHolidayData(map: Map(mappingType: .fromJSON, JSON: [:]))!
            data.from = sequenceData.from
            data.to = sequenceData.to
            salonHolidaysList.append(data)
        }
        if salonHolidaysList.count == 0 {
            self.tbl_vw.isHidden = true
        } else {
            print("Selected Description: \(salonHolidaysList)")
            self.tbl_vw.isHidden = false
            self.tbl_vw.reloadData()
        }
    }
    
    
    func api_updatestaffHolidays() {
        
        self.showLoader()
        // Format dates to "dd-MM-yyyy"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"

        let fromDate = fromSelectedDate != nil ? dateFormatter.string(from: fromSelectedDate!) : ""
        let toDate = toSelectedDate != nil ? dateFormatter.string(from: toSelectedDate!) : ""

    
        // Convert to list of dictionaries
        var holidayDatesMap: [[String: String]] = []

        for staff in salonHolidaysList {
            let val: [String: String] = [
                "from": staff.from,
                "to": staff.to
            ]
            holidayDatesMap.append(val)
        }

        // Add manually selected date range if valid
        if !fromDate.isEmpty && !toDate.isEmpty {
            let val: [String: String] = [
                "from": fromDate,
                "to": toDate
            ]
            holidayDatesMap.append(val)
        }

        // Encode to JSON
        if let jsonData = try? JSONSerialization.data(withJSONObject: holidayDatesMap, options: .prettyPrinted),
           let holidayDatesData = String(data: jsonData, encoding: .utf8) {
            print("Holiday Dates Update: \(holidayDatesData)")
            
            APIService.shared.updateStaffHoliday(holidayDates: holidayDatesData, staffId: self.TeamId) { result in
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
                    self.show_alert(msg: model.error ?? "", title: "Update Staff")
                }
            }
        }

    }
    
    
    //MARK: Custom Function
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
        calendarVC?.view.addSubview(calendar)

        if let popover = calendarVC?.popoverPresentationController {
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
            popover.permittedArrowDirections = .up
        }

        self.present(calendarVC!, animated: true, completion: nil)
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



extension AddTimeDiffVC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.salonHolidaysList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TimeOffHeaderCell") as? TimeOffHeaderCell else {
                return nil
            }

            // Customize your header view
            return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbl_vw.dequeueReusableCell(withIdentifier: "TimeOffCell", for: indexPath) as? TimeOffCell else {
            return UITableViewCell()
        }
        let data = self.salonHolidaysList[indexPath.item]
        cell.lbl_fromTo.text = data.from + " to " + data.to
        cell.Act_Delete = {
            self.salonHolidaysList.remove(at: indexPath.row)
            self.tbl_vw.reloadData()
        }
        return cell
    }


    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
}



extension AddTimeDiffVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let formattedDate = formatter.string(from: date)

        if isSelectingFromDate {
            fromSelectedDate = date
            txt_from.text = formattedDate
            txt_from.showLabel()
        } else {
            toSelectedDate = date
            txt_to.text = formattedDate
            txt_to.showLabel()
        }

        calendarVC?.dismiss(animated: true)
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return date >= Calendar.current.startOfDay(for: Date())
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if date < Calendar.current.startOfDay(for: Date()) {
            return UIColor.lightGray // dim past dates
        }
        return nil // default color
    }


}


extension AddTimeDiffVC: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == txt_from) {
            self.view.endEditing(true)
            self.isSelectingFromDate = true
            showCalendarPopup(sourceView: textField)
            return false // Prevent keyboard
        } else if (textField == txt_to) {
            self.view.endEditing(true)
            self.isSelectingFromDate = false
            showCalendarPopup(sourceView: textField)
            return false // Prevent keyboard
        } else {
            return true
        }
    }
    
}
