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

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btn_PasswordHideShow(_ sender: UIButton) {
    }
    
    @IBAction func btn_Save(_ sender: Any) {
        if (self.txt_Email.text == "") {
            self.txt_Email.showErrorMessage(message: "Please enter email")
        } else if !self.txt_Email.text!.isValidEmail() {
            self.txt_Email.showErrorMessage(message: "Please enter valid email")
        } else if (self.txt_Password.text == "") {
            self.txt_Password.showErrorMessage(message: "Please enter password")
        }
    }
    
    
}
