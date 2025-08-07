//
//  Passcode_VC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 07/08/25.
//

import UIKit

class Passcode_VC: UIViewController {

    @IBOutlet weak var txt_1: UITextField!
    @IBOutlet weak var txt_2: UITextField!
    @IBOutlet weak var txt_3: UITextField!
    @IBOutlet weak var txt_4: UITextField!
    @IBOutlet weak var txt_5: UITextField!
    @IBOutlet weak var txt_6: UITextField!
    
    
    var OTP = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_1.tag = 1
        txt_2.tag = 2
        txt_3.tag = 3
        txt_4.tag = 4
        txt_5.tag = 5
        txt_6.tag = 6
        setCustomFont()
    }
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Regular", size: 22.0) {
            txt_1.font = customFont
            txt_2.font = customFont
            txt_3.font = customFont
            txt_4.font = customFont
            txt_5.font = customFont
            txt_6.font = customFont
        }
    }
    
    @IBAction func btn_Close(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btn_Continue(_ sender: Any) {
        if txt_1.text != "" && txt_2.text != "" && txt_3.text != "" && txt_4.text != "" && txt_5.text != "" && txt_6.text != "" {
            var otpStr = txt_1.text! + txt_2.text!
            otpStr.append(txt_3.text! + txt_4.text!)
            otpStr.append(txt_5.text! + txt_6.text!)
            if otpStr != ""{
                self.OTP = otpStr;
                verfiyPasscode(passcode: OTP)
            }
        }
    }
    
    
    func verfiyPasscode(passcode: String){
        APIService.shared.verifyPasscode(passcode: passcode, vendorId: LocalData.userId) { result in
            if result != nil {
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            }else{
                self.showToast(message: "Something went wrong")
            }
            
        }
    }
}


extension Passcode_VC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txt_4 {
            textField.resignFirstResponder()
            textField.endEditing(true)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            if let previousTextField = view.viewWithTag(textField.tag - 1) as? UITextField {
                previousTextField.becomeFirstResponder()
            }
            textField.text = string
            return false
        }
        
        // Allow only one character per text field
        if let text = textField.text, text.count >= 1 {
            if let nextTextField = view.viewWithTag(textField.tag + 1) as? UITextField {
                nextTextField.becomeFirstResponder()
                nextTextField.text = string
                if (nextTextField.tag == 6) {
                    nextTextField.endEditing(true)
                }
            }
            return false
        }
        
        return true
    }
    
}

