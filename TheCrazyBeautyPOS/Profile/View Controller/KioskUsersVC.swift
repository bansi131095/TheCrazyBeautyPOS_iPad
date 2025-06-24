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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btn_Eye.setImage(#imageLiteral(resourceName: "view"), for: .normal)
        self.txt_Password.isSecureTextEntry = true
        // Do any additional setup after loading the view.
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
        }
    }
    
    
}
