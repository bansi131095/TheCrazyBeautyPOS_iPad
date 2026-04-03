//
//  ForgotPassword_VC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 25/03/26.
//

import UIKit

class ForgotPassword_VC: UIViewController {

    
    @IBOutlet weak var vw_Email: UIView!
    @IBOutlet weak var vw_Success: UIView!
    @IBOutlet weak var lbl_ForgotPassword: UILabel!
    @IBOutlet weak var lbl_Login: UILabel!
    @IBOutlet weak var txt_Email: TextInputLayout!
    @IBOutlet weak var btn_SendRestLink: GradientButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = NSLocalizedString("Send Reset Link", comment: "")
        
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 18.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        btn_SendRestLink.setAttributedTitle(attributedTitle, for: .normal)
    }
    

    @IBAction func btn_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_Login(_ sender: Any) {
        if (self.txt_Email.text == "") {
            self.txt_Email.showErrorMessage(message: NSLocalizedString("Email ID is required.",comment: ""))
        } else if !self.txt_Email.text!.isValidEmail() {
            self.txt_Email.showErrorMessage(message: NSLocalizedString("Please provide valid email id.",comment: ""))
        } else {
            ResendApicall()
        }
    }
    
    
    @IBAction func btn_BacktoLogin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btn_ResendLink(_ sender: Any) {
        ResendApicall()
    }
    
    @IBAction func btn_BackToPrevious(_ sender: Any) {
        self.txt_Email.text = ""
        self.vw_Email.isHidden = false
        self.vw_Success.isHidden = true
    }
    
    
    //MARK: - API CALL
    func ResendApicall() {
        showLoader()
        APIService.shared.SendRestlink(email: txt_Email.text ?? "") { result in
            self.hideLoader()
            if result?.data != nil{
                self.alertWithMessageOnly(NSLocalizedString("Reset password mail sent",comment: ""))
                DispatchQueue.main.async {
                    self.vw_Email.isHidden = true
                    self.vw_Success.isHidden = false
                }
            }else{
                self.vw_Email.isHidden = false
                self.vw_Success.isHidden = true
                self.alertWithMessageOnly(NSLocalizedString("Reset password mail failed",comment: ""))
            }
        }
    }
}
