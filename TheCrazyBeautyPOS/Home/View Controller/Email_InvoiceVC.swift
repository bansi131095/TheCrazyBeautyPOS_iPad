//
//  Email_InvoiceVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 05/08/25.
//

import UIKit

class Email_InvoiceVC: UIViewController {

    
    
    @IBOutlet weak var txt_Email: TextInputLayout!
    
    var booking_ID : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    
    @IBAction func btn_Close(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func btn_Continue(_ sender: Any) {
        if (self.txt_Email.text == "") {
            self.txt_Email.showErrorMessage(message: NSLocalizedString("Please enter email",comment: ""))
        } else if !self.txt_Email.text!.isValidEmail() {
            self.txt_Email.showErrorMessage(message: NSLocalizedString("Please enter valid email",comment: ""))
        }else{
            api_SendInvoiceEmail()
        }
    }
    
    
    func api_SendInvoiceEmail() {
        self.showLoader()
        APIService.shared.SendInvoice(booking_id: booking_ID, email: self.txt_Email.text ?? "") { result in
            self.hideLoader()
            guard let model = result else {
                return
            }
            self.hideLoader()
            if model.error == "" || model.error == nil {
                self.showToast(message: NSLocalizedString("Email sent successfully", comment: ""))
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.dismiss(animated: true)
                }
            } else {
                self.showToast(message: NSLocalizedString("Failed to get booking data", comment: ""))
//                self.show_alert(msg: model.error ?? "", title: "Update Staff")
            }
        }
    }
}
