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
    
    
    //MARK: - Global Variable
    
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: -  Button Action
    @IBAction func btn_Time(_ sender: Any) {
    }
    
    @IBAction func btn_SMSSettings(_ sender: Any) {
        setSettingsHideShow()
    }
    
    
    @IBAction func btn_EmailSettings(_ sender: Any) {
        setEmailSettingsHideShow()
    }
    
    //MARK: - Function
    
    func setSettingsHideShow(){
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
    }
    
    func setEmailSettingsHideShow(){
        lbl_EmailSettings.textColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
        lbl_Email_Line.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
        img_EmailDown.image = UIImage(named: "ic_Up")
        vw_Email_Notification.isHidden = false
        vw_Booking_Notification.isHidden = false
        lbl_Booking_Line.isHidden = false
        vw_New_BookingNotification.isHidden = false
        vw_BookingCancelNotificatoin.isHidden = false
        vw_NotShown.isHidden = false
    }
    
    //MARK: - Web Api Calling

}
