//
//  KioskUsersVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 23/06/25.
//

import UIKit

class KioskUsersVC: UIViewController {

    @IBOutlet weak var txt_Email: TextInputLayout!
    @IBOutlet weak var txt_Password: TextInputLayout!
    @IBOutlet weak var btn_Eye: UIButton!
    @IBOutlet weak var btn_Save: GradientButton!
    
    
    var TeamLogin: [KioskDetailsModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let title = NSLocalizedString("Save", comment: "")
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 20)!,
                .foregroundColor: UIColor.white
            ]
        )
        btn_Save.setAttributedTitle(attributedTitle, for: .normal)
        self.btn_Eye.setImage(#imageLiteral(resourceName: "view"), for: .normal)
        self.txt_Password.isSecureTextEntry = true
        get_KioskUsers()
        setCustomFont()
    }
    

    @IBAction func btn_PasswordHideShow(_ sender: UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "view.png") {
            sender.setImage(#imageLiteral(resourceName: "hidden"), for: .normal)
            self.txt_Password.isSecureTextEntry = false
        } else {
            sender.setImage(#imageLiteral(resourceName: "view"), for: .normal)
            self.txt_Password.isSecureTextEntry = true
        }
    }
    
    @IBAction func btn_Save(_ sender: Any) {
        if (self.txt_Email.text == "") {
            alertWithMessageOnly(NSLocalizedString("Email ID is required.",comment: ""))
        } else if !self.txt_Email.text!.isValidEmail() {
            alertWithMessageOnly(NSLocalizedString("Please provide valid email id.",comment: ""))
        } else if (self.txt_Password.text == "") {
            alertWithMessageOnly(NSLocalizedString("Password is required.",comment: ""))
        }else if !self.txt_Password.text!.isValidPassword() {
            alertWithMessageOnly(NSLocalizedString("Password must contain at least one uppercase letter, one lowercase letter, one special letter and one number, and be at least 8 characters long",comment: ""))
        }else{
            update_KioskUsers()
        }
    }
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Medium", size: 18.0) {
            txt_Email.font = customFont
            txt_Password.font = customFont
        }
    }
    
    
    
    func get_KioskUsers() {
        self.showLoader()
        APIService.shared.fetchKioskUser { result in
            self.hideLoader()
            guard let data = result?.data else {
                self.alertWithMessageOnly("Failed to get team details")
                return
            }
            
            if data.isEmpty {
                print("TeamDetails array is empty")
                // handle empty UI if needed
                return
            }
            
            self.TeamLogin = data
            if result?.data != nil {
                self.txt_Email.text = self.TeamLogin.first?.email
                self.txt_Email.showLabel()
                self.txt_Password.showLabel()
            }else{
                self.alertWithMessageOnly(NSLocalizedString("Internal server error",comment: ""))
            }
        }
    }
    
    func update_KioskUsers() {
        self.showLoader()
        APIService.shared.UpdateAddKiosk(email: self.txt_Email.text!, password: self.txt_Password.text!, vendorId: LocalData.userId) { result in
            self.hideLoader()
            if result?.data != nil {
                self.txt_Email.text = ""
                self.txt_Password.text = ""
                self.alertWithMessageOnly((NSLocalizedString("Kiosk user data added successfully",comment: "")))
            }else{
                self.alertWithMessageOnly((NSLocalizedString("Failed to update kiosk user",comment: "")))
            }
        }
    }
}
