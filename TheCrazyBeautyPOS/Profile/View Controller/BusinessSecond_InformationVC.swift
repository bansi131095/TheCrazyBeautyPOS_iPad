//
//  BusinessSecond_InformationVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 15/07/25.
//

import UIKit
import DropDown

class BusinessSecond_InformationVC: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var lbl_MonFromTime: UILabel!
    @IBOutlet weak var lbl_MonToTime: UILabel!
    
    @IBOutlet weak var vw_MonTime: UIView!
    @IBOutlet weak var vw_MonClose: UIView!
    
    @IBOutlet weak var Switch_Mon: UISwitch!
    
    @IBOutlet weak var lbl_TuesFromTime: UILabel!
    @IBOutlet weak var lbl_TuesToTime: UILabel!
    
    @IBOutlet weak var vw_TuesTime: UIView!
    @IBOutlet weak var vw_TuesClose: UIView!
    
    @IBOutlet weak var Switch_Tues: UISwitch!
    
    
    @IBOutlet weak var lbl_WednesFromTime: UILabel!
    @IBOutlet weak var lbl_WednesToTime: UILabel!
    
    @IBOutlet weak var vw_WednesTime: UIView!
    @IBOutlet weak var vw_WednesClose: UIView!
    
    @IBOutlet weak var Switch_Wednes: UISwitch!
    
    @IBOutlet weak var lbl_ThursFromTime: UILabel!
    @IBOutlet weak var lbl_ThursToTime: UILabel!
    
    @IBOutlet weak var vw_ThursTime: UIView!
    @IBOutlet weak var vw_ThursClose: UIView!
    
    @IBOutlet weak var Switch_Thurs: UISwitch!
    
    @IBOutlet weak var lbl_FriFromTime: UILabel!
    @IBOutlet weak var lbl_FriToTime: UILabel!
    
    @IBOutlet weak var vw_FriTime: UIView!
    @IBOutlet weak var vw_FriClose: UIView!
    
    @IBOutlet weak var Switch_Fri: UISwitch!
    
    @IBOutlet weak var lbl_SaturFromTime: UILabel!
    @IBOutlet weak var lbl_SaturToTime: UILabel!
    
    @IBOutlet weak var vw_SaturTime: UIView!
    @IBOutlet weak var vw_SaturClose: UIView!
    
    @IBOutlet weak var Switch_Satur: UISwitch!
    
    @IBOutlet weak var lbl_SunFromTime: UILabel!
    @IBOutlet weak var lbl_SunToTime: UILabel!
    
    @IBOutlet weak var vw_SunTime: UIView!
    @IBOutlet weak var vw_SunClose: UIView!
    
    @IBOutlet weak var Switch_Sun: UISwitch!
    
    @IBOutlet weak var btn_Continue: GradientButton!
    //MARK: - Global Variable
    var timeSlots: [String] = []
    var vendor_Id = Int()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Switch_Sun.isOn = false
        vw_SunClose.isHidden = false
        vw_SunTime.isHidden = true
        TimeSlots()
        let attributedTitle = NSAttributedString(
            string: "Continue",
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 20.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        btn_Continue.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    //MARK: -  Button Action
    @IBAction func btn_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btn_MonFromTime(_ sender: Any) {
        openTimeDropdown(for: lbl_MonFromTime)
    }
    
    @IBAction func btn_MonToTime(_ sender: Any) {
        openTimeDropdown(for: lbl_MonToTime)
    }
    
    @IBAction func btn_TuesFromTime(_ sender: Any) {
        openTimeDropdown(for: lbl_TuesFromTime)
    }
    
    @IBAction func btn_TuesToTime(_ sender: Any) {
        openTimeDropdown(for: lbl_TuesToTime)
    }
    
    @IBAction func btn_WednesFromTime(_ sender: Any) {
        openTimeDropdown(for: lbl_WednesFromTime)
    }
    
    @IBAction func btn_WednesToTime(_ sender: Any) {
        openTimeDropdown(for: lbl_WednesToTime)
    }
    
    @IBAction func btn_ThursFromTime(_ sender: Any) {
        openTimeDropdown(for: lbl_ThursFromTime)
    }
    
    @IBAction func btn_ThursToTime(_ sender: Any) {
        openTimeDropdown(for: lbl_ThursToTime)
    }
    
    @IBAction func btn_FriFromTime(_ sender: Any) {
        openTimeDropdown(for: lbl_FriFromTime)
    }
    
    @IBAction func btn_FriToTime(_ sender: Any) {
        openTimeDropdown(for: lbl_FriToTime)
    }
    
    @IBAction func btn_SaturFromTime(_ sender: Any) {
        openTimeDropdown(for: lbl_SaturFromTime)
    }
    
    @IBAction func btn_SaturToTime(_ sender: Any) {
        openTimeDropdown(for: lbl_SaturToTime)
    }
    
    @IBAction func btn_SunFromTime(_ sender: Any) {
        openTimeDropdown(for: lbl_SunFromTime)
    }
    
    @IBAction func btn_SunToTime(_ sender: Any) {
        openTimeDropdown(for: lbl_SunToTime)
    }
    
    @IBAction func switch_Mon(_ sender: UISwitch) {
        if sender.isOn{
            Switch_Mon.isOn = true
            vw_MonTime.isHidden = false
            vw_MonClose.isHidden = true
        }else{
            Switch_Mon.isOn = false
            vw_MonTime.isHidden = true
            vw_MonClose.isHidden = false
        }
    }
    
    @IBAction func switch_Tues(_ sender: UISwitch) {
        if sender.isOn{
            Switch_Tues.isOn = true
            vw_TuesTime.isHidden = false
            vw_TuesClose.isHidden = true
        }else{
            Switch_Tues.isOn = false
            vw_TuesTime.isHidden = true
            vw_TuesClose.isHidden = false
        }
    }
    
    @IBAction func switch_Wednes(_ sender: UISwitch) {
        if sender.isOn{
            Switch_Wednes.isOn = true
            vw_WednesTime.isHidden = false
            vw_WednesClose.isHidden = true
        }else{
            Switch_Wednes.isOn = false
            vw_WednesTime.isHidden = true
            vw_WednesClose.isHidden = false
        }
    }
    
    @IBAction func switch_Thurs(_ sender: UISwitch) {
        if sender.isOn{
            Switch_Thurs.isOn = true
            vw_ThursTime.isHidden = false
            vw_ThursClose.isHidden = true
        }else{
            Switch_Thurs.isOn = false
            vw_ThursTime.isHidden = true
            vw_ThursClose.isHidden = false
        }
    }
    
    @IBAction func switch_Fri(_ sender: UISwitch) {
        if sender.isOn{
            Switch_Fri.isOn = true
            vw_FriTime.isHidden = false
            vw_FriClose.isHidden = true
        }else{
            Switch_Fri.isOn = false
            vw_FriTime.isHidden = true
            vw_FriClose.isHidden = false
        }
    }
    
    @IBAction func switch_Satur(_ sender: UISwitch) {
        if sender.isOn{
            Switch_Satur.isOn = true
            vw_SaturTime.isHidden = false
            vw_SaturClose.isHidden = true
        }else{
            Switch_Satur.isOn = false
            vw_SaturTime.isHidden = true
            vw_SaturClose.isHidden = false
        }
    }
    
    @IBAction func switch_Sun(_ sender: UISwitch) {
        if sender.isOn{
            Switch_Sun.isOn = true
            vw_SunTime.isHidden = false
            vw_SunClose.isHidden = true
        }else{
            Switch_Sun.isOn = false
            vw_SunTime.isHidden = true
            vw_SunClose.isHidden = false
        }
    }
    
    
    
    @IBAction func btn_Continue(_ sender: Any) {
        update_business_hours()
        
    }
    
    
    //MARK: - Function
    func TimeSlots(){
        for hour in 0..<24 {
            for minute in [0, 30] {
                // Stop at 23:00, exclude 23:30
                if hour == 23 && minute == 30 {
                    break
                }
                let time = String(format: "%02d:%02d", hour, minute)
                timeSlots.append(time)
            }
        }
    }
    
    
    func openTimeDropdown(for label: UILabel) {
        let slotDuration = DropDown()
        slotDuration.anchorView = label
        slotDuration.bottomOffset = CGPoint(x: 0, y: label.bounds.height)
        slotDuration.direction = .bottom
        slotDuration.dataSource = timeSlots
        slotDuration.cellHeight = 35
        slotDuration.width = label.frame.width
        slotDuration.textFont = UIFont(name: "Lato-Regular", size: 18.0)!
        slotDuration.backgroundColor = .white
        slotDuration.selectionAction = { [weak self] (index: Int, item: String) in
            label.text = item
            print("Selected time: \(item)")
        }

        slotDuration.show()
    }
    //MARK: - Function
    
    
    
    func createWorkingHoursFromUI() -> [WorkingHour1] {
        var result: [WorkingHour1] = []

        let allDays: [(day: String, isOn: Bool, from: UILabel, to: UILabel)] = [
            ("Monday", Switch_Mon.isOn, lbl_MonFromTime, lbl_MonToTime),
            ("Tuesday", Switch_Tues.isOn, lbl_TuesFromTime, lbl_TuesToTime),
            ("Wednesday", Switch_Wednes.isOn, lbl_WednesFromTime, lbl_WednesToTime),
            ("Thursday", Switch_Thurs.isOn, lbl_ThursFromTime, lbl_ThursToTime),
            ("Friday", Switch_Fri.isOn, lbl_FriFromTime, lbl_FriToTime),
            ("Saturday", Switch_Satur.isOn, lbl_SaturFromTime, lbl_SaturToTime),
            ("Sunday", Switch_Sun.isOn, lbl_SunFromTime, lbl_SunToTime)
        ]

        for entry in allDays {
            if entry.isOn {
                let model = WorkingHour1(JSON: [
                    "day": entry.day,
                    "from": entry.from.text ?? "",
                    "to": entry.to.text ?? ""
                ])
                if let model = model {
                    result.append(model)
                }
            }
        }

        return result
    }
    
    func update_business_hours() {
        let workingHoursToSend: [WorkingHour1] = createWorkingHoursFromUI()
        let url = global.shared.URL_UPDATE_BUSINESS_TIMING + "/\(vendor_Id)"
        print("url:- \(url)")
        showLoader()
        APIService.shared.Add_BusinessHours(url: url,workingHours: workingHoursToSend) { result  in
            self.hideLoader()
            if result {
                let storyboard = UIStoryboard(name: "Profile", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "BusinessThird_InformationVC") as! BusinessThird_InformationVC
                vc.salon_Id = self.vendor_Id
                self.navigationController?.pushViewController(vc, animated: false)
                self.alertWithMessageOnly("Business timing updated successfully")
            } else {
                self.alertWithMessageOnly("Something went wrong.")
            }
        }
    }
    
    //MARK: - Web Api Calling
}
