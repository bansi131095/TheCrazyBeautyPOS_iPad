//
//  Notifications_SettingsVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 25/06/25.
//

import UIKit
import DropDown


class Notifications_SettingsVC: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var lbl_Amount: UILabel!
    
    
    @IBOutlet weak var lbl_SMSSettings: UILabel!
    @IBOutlet weak var img_Down: UIImageView!
    @IBOutlet weak var lbl_LineSMS: UILabel!
    
    //SMS_Settings
    @IBOutlet weak var vw_StyleFactory: UIView!
    @IBOutlet weak var lbl_StyleFactory: UILabel!
    @IBOutlet weak var vw_NewBook: UIView!
    @IBOutlet weak var vw_BookingCancel: UIView!
    @IBOutlet weak var vw_CustomerNotification: UIView!
    @IBOutlet weak var lbl_Customer_Line: UILabel!
    @IBOutlet weak var vw_Customer_NewBook: UIView!
    @IBOutlet weak var vw_Customer_BookingCancel: UIView!
    
    //Email_Settings
    @IBOutlet weak var lbl_EmailSettings: UILabel!
    @IBOutlet weak var img_EmailDown: UIImageView!
    @IBOutlet weak var lbl_Email_Line: UILabel!
    
    @IBOutlet weak var vw_Email_Notification: UIView!
    @IBOutlet weak var vw_Booking_Notification: UIView!
    @IBOutlet weak var lbl_Booking_Line: UILabel!
    
    //Booking
    @IBOutlet weak var vw_New_BookingNotification: UIView!
    @IBOutlet weak var vw_BookingCancelNotificatoin: UIView!
    @IBOutlet weak var vw_NotShown: UIView!
    
    
    
    @IBOutlet weak var Switch_SmsF_NewBooking: UISwitch!
    @IBOutlet weak var Switch_SmsF_BookingCompleted: UISwitch!
    @IBOutlet weak var Switch_SmsF_BookingCancel: UISwitch!
    
    @IBOutlet weak var Switch_Cust_NewBooking: UISwitch!
    @IBOutlet weak var Switch_Cust_BookingCompleted: UISwitch!
    @IBOutlet weak var Switch_Cust_BookingCancel: UISwitch!
    @IBOutlet weak var Switch_Cust_Reminder: UISwitch!
    
    @IBOutlet weak var Switch_EmailS_Notification: UISwitch!
    
    @IBOutlet weak var Switch_BookingN_NewBooking: UISwitch!
    @IBOutlet weak var Switch_BookingN_BookingCompleted: UISwitch!
    @IBOutlet weak var Switch_BookingN_BookingCancel: UISwitch!
    @IBOutlet weak var Switch_BookingN_EditBooking: UISwitch!
    @IBOutlet weak var Switch_BookingN_NotShown: UISwitch!
    
    
    //MARK: - Global Variable
    var isSMSExpanded = false
    var isEmailExpanded = false
    var arr_TimeSlot = ["30 Minutes","3 Hours","6 Hours","12 Hours","24 Hours 30 Minutes"]
    var select_Hours: String = ""
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialVisibility()
        self.lbl_Time.text = arr_TimeSlot[0]
        select_Hours = "1 Hours"
        get_NotificationSettings()
    }
    
    //MARK: -  Button Action
    @IBAction func btn_Time(_ sender: Any) {
        openHours()
    }
    
    @IBAction func btn_SMSSettings(_ sender: Any) {
        isSMSExpanded.toggle()
        setSettingsHideShow()
    }
    
    
    @IBAction func btn_EmailSettings(_ sender: Any) {
        isEmailExpanded.toggle()
        setEmailSettingsHideShow()
    }
    
    @IBAction func btn_Save(_ sender: Any) {
        let emailNotifications = Switch_EmailS_Notification.isOn ? "1" : "0"
        let smsSettings: [[String: Int]] = [
            ["c_booked": Switch_Cust_NewBooking.isOn ? 1 : 0],
            ["c_completed": Switch_Cust_BookingCompleted.isOn ? 1 : 0],
            ["c_cancelled": Switch_Cust_BookingCancel.isOn ? 1 : 0],
            ["v_booked": Switch_SmsF_NewBooking.isOn ? 1 : 0],
            ["v_completed": Switch_SmsF_BookingCompleted.isOn ? 1 : 0],
            ["v_cancelled": Switch_SmsF_BookingCancel.isOn ? 1 : 0],
            ["c_reminder": Switch_Cust_Reminder.isOn ? 1 : 0]
        ]
        
        let emailSettings: [[String: Int]] = [
            ["add_booking": Switch_BookingN_NewBooking.isOn ? 1 : 0],
            ["edit_booking": Switch_BookingN_EditBooking.isOn ? 1 : 0],
            ["complete_booking": Switch_BookingN_BookingCompleted.isOn ? 1 : 0],
            ["cancel_booking": Switch_BookingN_BookingCancel.isOn ? 1 : 0],
            ["noshow_booking": Switch_BookingN_NotShown.isOn ? 1 : 0]
        ]

        APIService.shared.updateNotificationSettings(vendorId: LocalData.userId,reminderTime: getReminderTimeMinutes(),smsSettings: smsSettings,emailSettings: emailSettings, emailNotifications: emailNotifications) { success in
            DispatchQueue.main.async {
                if success {
                    self.alertWithMessageOnly("SMS/Emails settings saved successfully")
                } else {
                    self.alertWithMessageOnly("Something went wrong.")
                }
            }
        }
    }
    
    //MARK: - Function
    func setInitialVisibility() {
        // Hide all toggle sections initially
        vw_StyleFactory.isHidden = true
        lbl_StyleFactory.isHidden = true
        vw_NewBook.isHidden = true
        vw_BookingCancel.isHidden = true
        vw_CustomerNotification.isHidden = true
        lbl_Customer_Line.isHidden = true
        vw_Customer_NewBook.isHidden = true
        vw_Customer_BookingCancel.isHidden = true

        vw_Email_Notification.isHidden = true
        vw_Booking_Notification.isHidden = true
        lbl_Booking_Line.isHidden = true
        vw_New_BookingNotification.isHidden = true
        vw_BookingCancelNotificatoin.isHidden = true
        vw_NotShown.isHidden = true
    }
    
    func setSettingsHideShow(){
        if isSMSExpanded{
            lbl_SMSSettings.textColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
            lbl_LineSMS.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
            img_Down.image = UIImage(named: "ic_Up")
            vw_StyleFactory.isHidden = false
            lbl_StyleFactory.isHidden = false
            vw_NewBook.isHidden = false
            vw_BookingCancel.isHidden = false
            vw_CustomerNotification.isHidden = false
            lbl_Customer_Line.isHidden = false
            vw_Customer_NewBook.isHidden = false
            vw_Customer_BookingCancel.isHidden = false
        }else{
            lbl_SMSSettings.textColor = UIColor.black
            lbl_LineSMS.backgroundColor = UIColor.black
            img_Down.image = UIImage(named: "ic_Down")
            vw_StyleFactory.isHidden = true
            lbl_StyleFactory.isHidden = true
            vw_NewBook.isHidden = true
            vw_BookingCancel.isHidden = true
            vw_CustomerNotification.isHidden = true
            lbl_Customer_Line.isHidden = true
            vw_Customer_NewBook.isHidden = true
            vw_Customer_BookingCancel.isHidden = true
        }
    }
    
    func setEmailSettingsHideShow(){
        if isEmailExpanded{
            lbl_EmailSettings.textColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
            lbl_Email_Line.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
            img_EmailDown.image = UIImage(named: "ic_Up")
            vw_Email_Notification.isHidden = false
            vw_Booking_Notification.isHidden = false
            lbl_Booking_Line.isHidden = false
            vw_New_BookingNotification.isHidden = false
            vw_BookingCancelNotificatoin.isHidden = false
            vw_NotShown.isHidden = false
        }else{
            lbl_EmailSettings.textColor = UIColor.black
            lbl_Email_Line.backgroundColor = UIColor.black
            img_EmailDown.image = UIImage(named: "ic_Down")
            vw_Email_Notification.isHidden = true
            vw_Booking_Notification.isHidden = true
            lbl_Booking_Line.isHidden = true
            vw_New_BookingNotification.isHidden = true
            vw_BookingCancelNotificatoin.isHidden = true
            vw_NotShown.isHidden = true
        }
    }
    
    func openHours() {
        let slotDuration = DropDown()
        slotDuration.anchorView = lbl_Time
        slotDuration.bottomOffset = CGPoint(x: 0, y: (slotDuration.anchorView?.plainView.bounds.height) ?? 0)
        slotDuration.direction = .bottom
        slotDuration.dataSource = arr_TimeSlot
        slotDuration.cellHeight = 35
        slotDuration.show()

        slotDuration.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.lbl_Time.text = item
            self.select_Hours = item // Example: "5 Hours"
            print("Selected Slot: \(self.select_Hours)")
        }
    }
    
    func getReminderTimeMinutes() -> String {
        // Extract the number part only, e.g., "30 Minutes" => "30"
        let full = lbl_Time.text ?? ""
        let components = full.components(separatedBy: CharacterSet.decimalDigits.inverted)
        let minutes = components.compactMap { Int($0) }.first ?? 30
        return "\(minutes)"
    }
    
    
    //MARK: - Web Api Calling
    func get_NotificationSettings() {
        APIService.shared.fetchSMSDetails { details in
            if let details = details {
                self.lbl_Time.text = "\(details.reminder_time ?? 0) Minutes"

                // Parse and update SMS settings
                if let smsSettingsJSON = details.sms_settings,
                   let smsData = smsSettingsJSON.data(using: .utf8),
                   let smsArray = try? JSONSerialization.jsonObject(with: smsData, options: []) as? [[String: Int]] {
                    self.updateSMSUI(using: smsArray)
                }

                // Parse and update Email settings
                if let emailSettingsJSON = details.email_settings,
                   let emailData = emailSettingsJSON.data(using: .utf8),
                   let emailArray = try? JSONSerialization.jsonObject(with: emailData, options: []) as? [[String: Int]] {
                    self.updateEmailUI(using: emailArray)
                }

            } else {
                print("⚠️ No SMS details found.")
            }
        }
    }


}

extension Notifications_SettingsVC {
    
    func updateSMSUI(using settings: [[String: Int]]) {
        for item in settings {
            if let key = item.keys.first, let value = item.values.first {
                let isOn = value == 1
                switch key {
                    case "c_booked":
                        Switch_Cust_NewBooking.isOn = isOn
                    case "c_completed":
                        Switch_Cust_BookingCompleted.isOn = isOn
                    case "c_cancelled":
                        Switch_Cust_BookingCancel.isOn = isOn
                    case "v_booked":
                        Switch_SmsF_NewBooking.isOn = isOn
                    case "v_completed":
                        Switch_SmsF_BookingCompleted.isOn = isOn
                    case "v_cancelled":
                        Switch_SmsF_BookingCancel.isOn = isOn
                    case "c_reminder":
                        Switch_Cust_Reminder.isOn = isOn
                    default:
                        break
                }
            }
        }
    }
    
    func updateEmailUI(using settings: [[String: Int]]) {
        for item in settings {
            if let key = item.keys.first, let value = item.values.first {
                let isOn = value == 1
                switch key {
                    case "add_booking":
                        Switch_BookingN_NewBooking.isOn = isOn
                    case "edit_booking":
                        Switch_BookingN_EditBooking.isOn = isOn
                    case "complete_booking":
                        Switch_BookingN_BookingCompleted.isOn = isOn
                    case "cancel_booking":
                        Switch_BookingN_BookingCancel.isOn = isOn
                    case "noshow_booking":
                        Switch_BookingN_NotShown.isOn = isOn
                    default:
                        break
                }
            }
        }
    }

}
