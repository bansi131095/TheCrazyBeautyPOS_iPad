//
//  EditScheduleVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 04/07/25.
//

import UIKit
import ObjectMapper

class EditScheduleVC: UIViewController {

    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var tbl_vw: UITableView!
    
    var salonItems: [ScheduleModel] = []

    var dropdownTableView: UITableView?
    var activeTextField: UITextField?

    var times:[String] = []

    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.api_getBusinessHours()
        self.setTableView()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: Button Action
    @IBAction func act_close(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func act_continue(_ sender: GradientButton) {
    }
    
    
    //MARK: Setup Table view
    func setTableView(){
        tbl_vw.register(UINib(nibName: "teamScheduleCell", bundle: nil), forCellReuseIdentifier: "teamScheduleCell")
        tbl_vw.delegate = self
        tbl_vw.dataSource = self
        tbl_vw.rowHeight = UITableView.automaticDimension
        tbl_vw.estimatedRowHeight = 60
    }
    
    
    //MARK: API Call
    func api_getBusinessHours() {
        APIService.shared.fetchTiming { workingHours in
            let salonHours = workingHours
            self.salonItems = self.convertWorkingHoursToSchedule(salonHours)
            self.tbl_vw.reloadData()
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


    func removeDropdown() {
        dropdownTableView?.removeFromSuperview()
        dropdownTableView = nil
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeDropdown()
        view.endEditing(true)
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
            guard let cell = self.tbl_vw.dequeueReusableCell(withIdentifier: "teamScheduleCell", for: indexPath) as? teamScheduleCell else {
                return UITableViewCell()
            }

            let item = salonItems[indexPath.row]
            cell.lbl_day.text = item.day

            cell.txt_from.text = item.from
            cell.txt_to.text = item.to

            // Set up dropdown trigger
            cell.onTextFieldTap = { [weak self] textField in
                self?.activeTextField = textField
                if let from = self?.timeStringToDouble(item.from), let to = self?.timeStringToDouble(item.to) {
                    let timeList = self?.generateTimeSlots(from: from, to: to, interval: 0.5)
                    self?.showDropdown(below: textField, timess: timeList ?? [])
                }
            }

            // Switch handling
            if item.isSwitched {
                cell.btn_switch.setImage(#imageLiteral(resourceName: "rdCheck.png"), for: .normal)
                cell.lbl_salonOff.isHidden = true
                cell.lbl_salonOff.text = ""
                cell.vw_1.isHidden = false
                cell.vw_2.isHidden = true
                cell.updateStackVisibility(view1Hidden: false, view2Hidden: true)
            } else {
                cell.btn_switch.setImage(#imageLiteral(resourceName: "rdUncheck"), for: .normal)
                cell.vw_1.isHidden = true
                cell.vw_2.isHidden = true
                cell.updateStackVisibility(view1Hidden: true, view2Hidden: true)
                cell.lbl_salonOff.isHidden = false
                cell.lbl_salonOff.text = "Salon Off"
            }

            cell.Act_Switch = {
                if cell.btn_switch.currentImage == #imageLiteral(resourceName: "rdUncheck") {
                    cell.btn_switch.setImage(#imageLiteral(resourceName: "rdCheck.png"), for: .normal)
                    item.isSwitched = true
                } else {
                    cell.btn_switch.setImage(#imageLiteral(resourceName: "rdUncheck"), for: .normal)
                    item.isSwitched = false
                }
                self.tbl_vw.reloadData()
            }
            return cell
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == dropdownTableView {
            return times.count
        } else {
            return salonItems.count
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == dropdownTableView {
            activeTextField?.text = times[indexPath.row]
            removeDropdown()
            activeTextField?.resignFirstResponder()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        removeDropdown()
    }
    
        
}
