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
    
    //MARK: - Global Variable
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Get_BankDetails()
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
    //MARK: - Web Api Calling
    
    func AddBankDetails(){
        APIService.shared.UpdateBankDetails(accountNumber: self.txt_AccountNumber.text ?? "", accountHolderName: self.txt_AccountHolderName.text ?? "", completion: { result in
            self.alertWithMessageOnly(result?.data ?? "")
        })
    }
    
    func Get_BankDetails(){
        APIService.shared.fetchBankDetails { result in
            if let bank = result?.data?.first?.bankDetails{
                self.txt_AccountNumber.text = bank.accountNumber ?? ""
                self.txt_AccountHolderName.text = bank.accountHolderName ?? ""
            }
        }
    }
}
