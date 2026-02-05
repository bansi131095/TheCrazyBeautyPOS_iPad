//
//  Team&LoginVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 24/06/25.
//

import UIKit

class Team_LoginVC: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var txt_Name: TextInputLayout!
    @IBOutlet weak var txt_Email: TextInputLayout!
    @IBOutlet weak var txt_Password: TextInputLayout!
    
    @IBOutlet weak var btn_eye: UIButton!
    
    @IBOutlet weak var btn_Save: GradientButton!
    @IBOutlet weak var btn_LoginasStaff: GradientButton!
    
    @IBOutlet weak var lbl_AllField: UILabel!

    //MARK: - Global Variable
    var TeamLogin: [KioskDetailsModel] = []
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let Submit = NSLocalizedString("Submit", comment: "")
        let Loginas  = NSLocalizedString("Login as Staff", comment: "")
        let attributedTitle = NSAttributedString(
            string: Submit,
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 20.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        let LogattributedTitle = NSAttributedString(
            string: Loginas,
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 20.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        btn_Save.setAttributedTitle(attributedTitle, for: .normal)
        btn_LoginasStaff.setAttributedTitle(LogattributedTitle, for: .normal)
        self.lbl_AllField.text = NSLocalizedString("All fields marked with an asterisk (*) are required.", comment: "")
        setCustomFont()
        self.btn_eye.setImage(#imageLiteral(resourceName: "view"), for: .normal)
        self.txt_Password.isSecureTextEntry = true
        get_TeamLogin()
    }
    
    //MARK: -  Button Action
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
        if (self.txt_Name.text == ""){
            alertWithMessageOnly(NSLocalizedString("Name is Required.",comment: ""))
        }else if (self.txt_Email.text == "") {
            alertWithMessageOnly(NSLocalizedString("Email ID is required.",comment: ""))
        } else if !self.txt_Email.text!.isValidEmail() {
            alertWithMessageOnly(NSLocalizedString("Please provide valid email id.",comment: ""))
        } else if (self.txt_Password.text == "") {
            alertWithMessageOnly(NSLocalizedString("Password is required.",comment: ""))
        }else if !self.txt_Password.text!.isValidPassword(){
            alertWithMessageOnly(NSLocalizedString("Password must contain at least one uppercase letter, one lowercase letter, one special letter and one number, and be at least 8 characters long",comment: ""))
        }else{
            update_Subvendor()
        }
    }
    
    
    @IBAction func btn_LoginStaff(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "LoginScreen") as! LoginScreen
        vc.staffLogin = "Staff"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Function
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Medium", size: 18.0) {
            txt_Name.font = customFont
            txt_Email.font = customFont
            txt_Password.font = customFont
        }
    }
    
    //MARK: - Web Api Calling
    func get_TeamLogin(){
        showLoader()
        APIService.shared.fetchSubvendor { result in
            self.hideLoader()
            self.TeamLogin = result!.data
            if result?.data != nil {
                self.txt_Name.text = self.TeamLogin.first?.name
                self.txt_Email.text = self.TeamLogin.first?.email
                self.txt_Name.showLabel()
                self.txt_Email.showLabel()
                self.txt_Password.showLabel()
            }else{
                self.alertWithMessageOnly(NSLocalizedString("Failed to get pos id",comment: ""))
            }
        }
    }
    
    func update_Subvendor(){
        showLoader()
        APIService.shared.UpdateCreateSubvendor(email: self.txt_Email.text!, name: self.txt_Name.text!, password: self.txt_Password.text!, vendorId: LocalData.userId) { result in
            self.hideLoader()
            if result?.data != nil {
                self.txt_Password.text = ""
                self.alertWithMessageOnly(NSLocalizedString("Failed to insert sub vendor",comment: ""))
            }else{
                self.alertWithMessageOnly(NSLocalizedString("Failed to update sub vendor data",comment: ""))
            }
        }
    }
}
