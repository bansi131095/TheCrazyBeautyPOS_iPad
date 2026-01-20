//
//  Booking_ReminderVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 25/06/25.
//

import UIKit
import DropDown

class Booking_ReminderVC: UIViewController {

    @IBOutlet weak var txt_Reminder: TextInputLayout!
    
    @IBOutlet weak var btn_Save: GradientButton!
    
    
    var ReminderModel: [ReminderModel] = []
    
    var select_Hours: String = ""
//    let hoursArray = (1...24).map { "\($0) Hours" }
    
    lazy var hoursArray: [String] = {
        let localizedHours = NSLocalizedString("Hours", comment: "")
        return (1...24).map { "\($0)" + " " + "\(localizedHours)" }
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomFont()
        get_ReminderMail()
        let title = NSLocalizedString("Save", comment: "")
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 20.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        btn_Save.setAttributedTitle(attributedTitle, for: .normal)
        if let savedSlot = LocalData.setHours, hoursArray.contains(savedSlot) {
            select_Hours = savedSlot
        } else {
            select_Hours = hoursArray[0]
        }
        txt_Reminder.text = select_Hours
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btn_Reminder(_ sender: Any) {
        openHours()
    }
    
    
    @IBAction func btn_Save(_ sender: Any) {
        /*let numericHour = select_Hours.replacingOccurrences(of: " Hours", with: "")
        update_BookingReminder(reminder_mail: numericHour)*/
        
        let numericHour = Int(select_Hours.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) ?? 0
        update_BookingReminder(reminder_mail: "\(numericHour)")

        
    }
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Medium", size: 18.0) {
            txt_Reminder.font = customFont
        }
    }
    
    func openHours() {
        let slotHours = DropDown()
        slotHours.anchorView = txt_Reminder
        slotHours.bottomOffset = CGPoint(x: 0, y: (slotHours.anchorView?.plainView.bounds.height) ?? 0)
        slotHours.direction = .bottom
        slotHours.dataSource = hoursArray
        slotHours.cellHeight = 35
        slotHours.show()
        slotHours.textFont = UIFont(name: "Lato-Regular", size: 18.0)!
        slotHours.backgroundColor = .white
        slotHours.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.txt_Reminder.text = item
            self.select_Hours = item
            LocalData.setHours = item
            
        }
    }
    
    func update_BookingReminder(reminder_mail:String) {
        self.showLoader()
        APIService.shared.UpdateReminderMail(reminder_mail: reminder_mail, vendorId: LocalData.userId) { result in
            self.hideLoader()
            if result?.data != nil {
//                self.alertWithMessageOnly(result?.data ?? "")
                self.alertWithMessageOnly(NSLocalizedString("Mail reminder updated successfully", comment: ""))
            } else {
                self.alertWithMessageOnly(NSLocalizedString("Failed to update reminder mail", comment: ""))
            }
        }
    }
    
    
    func get_ReminderMail() {
        self.showLoader()
        APIService.shared.getRemindermail { result in
            self.hideLoader()
            if result?.data != nil {
                self.ReminderModel = (result?.data)!
                self.txt_Reminder.text = String(self.ReminderModel[0].reminder_mail ?? 0) + " " + NSLocalizedString("Hours", comment: "")
                self.select_Hours = String(self.ReminderModel[0].reminder_mail ?? 0) + " " + NSLocalizedString("Hours", comment: "")
            }else{
                self.alertWithMessageOnly(NSLocalizedString("Failed to get reminder mail",comment: ""))
            }
        }
    }
}
