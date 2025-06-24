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
    }
    
    //MARK: -  Button Action
    @IBAction func btn_Save(_ sender: Any) {
        if txt_AccountNumber.text == "" {
            alertWithImage(title: "Add Bank Details", Msg: "Account Number is required.")
        }else if txt_AccountHolderName.text == "" {
            alertWithImage(title: "Add Bank Details", Msg: "Account Holder Name is required.")
        }
    }
    
    //MARK: - Function
    //MARK: - Web Api Calling
}
