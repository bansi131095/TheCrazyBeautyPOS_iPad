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
        let attributedTitle = NSAttributedString(
            string: "Save",
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
            alertWithImage(title: "Kiosk Users", Msg: "Please enter email")
        } else if !self.txt_Email.text!.isValidEmail() {
            alertWithImage(title: "Kiosk Users", Msg: "Please enter valid email id.")
        } else if (self.txt_Password.text == "") {
            alertWithImage(title: "Kiosk Users", Msg: "Please enter password.")
        }else if !self.txt_Password.text!.isValidPassword() {
            alertWithImage(title: "Team Login", Msg: "Invalid Password.")
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
            self.TeamLogin = result!.data
            if result?.data != nil {
                self.txt_Email.text = self.TeamLogin.first?.email
            }else{
                self.alertWithMessageOnly("Something went wrong.")
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
                self.alertWithMessageOnly(result?.data ?? "")
            }else{
                self.alertWithMessageOnly(result?.error ?? "")
            }
        }
    }
}
