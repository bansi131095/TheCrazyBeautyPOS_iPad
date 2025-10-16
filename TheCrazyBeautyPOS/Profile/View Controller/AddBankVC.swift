//
//  AddBankVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 24/06/25.
//

import UIKit

class AddBankVC: UIViewController {

    
    //MARK: - Outlet
    @IBOutlet weak var txt_AccountNumber: TextInputLayout!
    
    @IBOutlet weak var txt_AccountHolderName: TextInputLayout!
    
    @IBOutlet weak var btn_Save: GradientButton!
    //MARK: - Global Variable
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributedTitle = NSAttributedString(
            string: "Save",
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 20.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        btn_Save.setAttributedTitle(attributedTitle, for: .normal)
        Get_BankDetails()
        setCustomFont()
    }
    
    //MARK: -  Button Action
    @IBAction func btn_Save(_ sender: Any) {
        if txt_AccountNumber.text == "" {
            alertWithImage(title: "Add Bank Details", Msg: "Account Number is required.")
        }else if txt_AccountHolderName.text == "" {
            alertWithImage(title: "Add Bank Details", Msg: "Account Holder Name is required.")
        }else{
            AddBankDetails()
        }
    }
    
    //MARK: - Function
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Medium", size: 18.0) {
            txt_AccountNumber.font = customFont
            txt_AccountHolderName.font = customFont
        }
    }
    
    //MARK: - Web Api Calling
    
    func AddBankDetails(){
        showLoader()
        APIService.shared.UpdateBankDetails(accountNumber: self.txt_AccountNumber.text ?? "", accountHolderName: self.txt_AccountHolderName.text ?? "", completion: { result in
            self.hideLoader()
            self.alertWithMessageOnly(result?.data ?? "")
        })
    }
    
    func Get_BankDetails(){
        showLoader()
        APIService.shared.fetchBankDetails { result in
            self.hideLoader()
            if let bank = result?.data?.first?.bankDetails{
                self.txt_AccountNumber.text = bank.accountNumber ?? ""
                self.txt_AccountHolderName.text = bank.accountHolderName ?? ""
            }
        }
    }
}
