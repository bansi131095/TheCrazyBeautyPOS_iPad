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
    
    
    //MARK: - Global Variable
    var TeamLogin: [KioskDetailsModel] = []
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
            alertWithImage(title: "Team Login", Msg: "Name is Required.")
        }else if (self.txt_Email.text == "") {
            alertWithImage(title: "Team Login", Msg: "Please enter email")
        } else if !self.txt_Email.text!.isValidEmail() {
            alertWithImage(title: "Team Login", Msg: "Please enter valid email id.")
        } else if (self.txt_Password.text == "") {
            alertWithImage(title: "Team Login", Msg: "Please enter password.")
        }else if !self.txt_Password.text!.isValidPassword(){
            alertWithImage(title: "Team Login", Msg: "Invalid Password.")
        }else{
            update_Subvendor()
        }
    }
    
    
    @IBAction func btn_LoginStaff(_ sender: Any) {
    }
    
    //MARK: - Function
    //MARK: - Web Api Calling
    func get_TeamLogin(){
        APIService.shared.fetchSubvendor { result in
            self.TeamLogin = result!.data
            if result?.data != nil {
                self.txt_Name.text = self.TeamLogin.first?.name
                self.txt_Email.text = self.TeamLogin.first?.email
            }else{
                self.alertWithMessageOnly(result?.error ?? "")
            }
        }
    }
    
    func update_Subvendor(){
        APIService.shared.UpdateCreateSubvendor(email: self.txt_Email.text!, name: self.txt_Name.text!, password: self.txt_Password.text!, vendorId: LocalData.userId) { result in
            if result?.data != nil {
                self.txt_Password.text = ""
                self.alertWithMessageOnly(result?.data ?? "")
            }else{
                self.alertWithMessageOnly(result?.error ?? "")
            }
        }
    }
}
