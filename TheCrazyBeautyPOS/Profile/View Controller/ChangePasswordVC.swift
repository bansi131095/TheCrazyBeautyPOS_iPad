//
//  ChangePasswordVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 23/06/25.
//

import UIKit

class ChangePasswordVC: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var txt_OldPassword: TextInputLayout!
    @IBOutlet weak var txt_NewPassword: TextInputLayout!
    
    @IBOutlet weak var btn_Oeye: UIButton!
    @IBOutlet weak var btn_Neye: UIButton!
    @IBOutlet weak var btn_Save: GradientButton!
    
    //MARK: - Global Variable
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomFont()
        let title = NSLocalizedString("Save", comment: "")
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 20.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        btn_Save.setAttributedTitle(attributedTitle, for: .normal)
        self.btn_Oeye.setImage(#imageLiteral(resourceName: "view"), for: .normal)
        self.txt_OldPassword.isSecureTextEntry = true
        self.btn_Neye.setImage(#imageLiteral(resourceName: "view"), for: .normal)
        self.txt_NewPassword.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }
    
    //MARK: -  Button Action
    @IBAction func btn_Save(_ sender: Any) {
        if (self.txt_OldPassword.text == "") {
            alertWithImage(title: NSLocalizedString("Change Password",comment: ""), Msg: NSLocalizedString("Old Password is required.",comment: ""))
        }else if self.txt_NewPassword.text == "" {
            alertWithImage(title: NSLocalizedString("Change Password",comment: ""), Msg: NSLocalizedString("New Password is required.",comment: ""))
        }else {
            changePassword()
        }
    }
    
    @IBAction func btn_OldPassword(_ sender: UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "view.png") {
            sender.setImage(#imageLiteral(resourceName: "hidden"), for: .normal)
            self.txt_OldPassword.isSecureTextEntry = false
        } else {
            sender.setImage(#imageLiteral(resourceName: "view"), for: .normal)
            self.txt_OldPassword.isSecureTextEntry = true
        }
    }
    
    @IBAction func btn_NewPassword(_ sender: UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "view.png") {
            sender.setImage(#imageLiteral(resourceName: "hidden"), for: .normal)
            self.txt_NewPassword.isSecureTextEntry = false
        } else {
            sender.setImage(#imageLiteral(resourceName: "view"), for: .normal)
            self.txt_NewPassword.isSecureTextEntry = true
        }
    }
    
    //MARK: - Function
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Medium", size: 18.0) {
            txt_OldPassword.font = customFont
            txt_NewPassword.font = customFont
        }
    }
    //MARK: - Web Api Calling
    func changePassword(){
        showLoader()
        APIService.shared.ChangePassword(vendorId: LocalData.userId, new_pass: self.txt_NewPassword.text ?? "", old_pass: self.txt_OldPassword.text ?? "") { result in
            self.hideLoader()
            if let message = result?.data{
                self.alertWithMessageOnly(NSLocalizedString("New password updated successfully",comment: ""))
                self.txt_NewPassword.text = ""
                self.txt_OldPassword.text = ""
            }else{
                self.alertWithMessageOnly(NSLocalizedString("Failed to added new password",comment: ""))
            }
        }
    }
}
