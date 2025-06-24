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
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btn_eye.setImage(#imageLiteral(resourceName: "view"), for: .normal)
        self.txt_Password.isSecureTextEntry = true
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
        }
    }
    
    
    @IBAction func btn_LoginStaff(_ sender: Any) {
    }
    
    //MARK: - Function
    //MARK: - Web Api Calling
}
