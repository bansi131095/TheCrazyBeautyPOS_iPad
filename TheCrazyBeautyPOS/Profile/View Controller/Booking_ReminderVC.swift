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
    
    
    var select_Hours: String = ""
    let hoursArray = (1...24).map { "\($0) Hours" }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let numericHour = select_Hours.replacingOccurrences(of: " Hours", with: "")
        update_BookingReminder(reminder_mail: numericHour)
        
    }
    
    func openHours() {
        let slotHours = DropDown()
        slotHours.anchorView = txt_Reminder
        slotHours.bottomOffset = CGPoint(x: 0, y: (slotHours.anchorView?.plainView.bounds.height) ?? 0)
        slotHours.direction = .bottom
        slotHours.dataSource = hoursArray
        slotHours.cellHeight = 35
        slotHours.show()

        slotHours.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.txt_Reminder.text = item
            self.select_Hours = item
            LocalData.setHours = item
            
        }
    }
    
    func update_BookingReminder(reminder_mail:String) {
        APIService.shared.UpdateReminderMail(reminder_mail: reminder_mail, vendorId: LocalData.userId) { result in
            if result?.data != nil {
                self.alertWithMessageOnly(result?.data ?? "")
            } else {
                self.alertWithMessageOnly(result?.error ?? "")
            }
            
        }
    }
}
