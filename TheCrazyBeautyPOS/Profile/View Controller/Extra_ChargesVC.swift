//
//  Extra_ChargesVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 13/01/26.
//

import UIKit

class Extra_ChargesVC: UIViewController {

    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_CashPayment: UILabel!
    @IBOutlet weak var lbl_AddDiscount: UILabel!
    @IBOutlet weak var txt_CashPayment: TextInputLayout!
    
    @IBOutlet weak var lbl_CardPayment: UILabel!
    @IBOutlet weak var lbl_AddExtra: UILabel!
    @IBOutlet weak var txt_CardPayment: TextInputLayout!
    
    @IBOutlet weak var btn_Save: GradientButton!
    
    //MARK: - view Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lbl_Title.text = NSLocalizedString("Extra Charges", comment: "")
        self.lbl_CashPayment.text = NSLocalizedString("Cash Payment", comment: "")
        self.lbl_AddDiscount.text = NSLocalizedString("Add a discount percentage for customers who pay with Cash.", comment: "")
        
        self.lbl_CardPayment.text = NSLocalizedString("Card Payment", comment: "")
        self.lbl_AddExtra.text = NSLocalizedString("Add a Extra Charges for customers who pay with Card.", comment: "")
        txt_CashPayment.addTarget(self, action: #selector(cashChanged), for: .editingChanged)
        txt_CardPayment.addTarget(self, action: #selector(cardChanged), for: .editingChanged)
        setCustomFont()
        Get_CardDetails()
        let title = NSLocalizedString("Save", comment: "")
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 20.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        btn_Save.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    //MARK: - Funcation
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Medium", size: 18.0) {
            txt_CashPayment.font = customFont
            txt_CardPayment.font = customFont
        }
    }
    
    func applyFontToTextInput(_ textInput: TextInputLayout, font: UIFont) {
        if let tf = textInput.subviews.compactMap({ $0 as? UITextField }).first {
            tf.font = font
            tf.keyboardType = .numberPad
        }
    }

    @objc func cashChanged() {
        let value = Int(txt_CashPayment.text ?? "") ?? 0

        if value > 100 {
            txt_CashPayment.text = "0"
        }
        /*else {
            txt_CardPayment.text = "0"
        }*/
    }

    @objc func cardChanged() {
        let value = Int(txt_CardPayment.text ?? "") ?? 0

        if value > 100 {
            txt_CardPayment.text = "0"
        }
        /*else {
            txt_CashPayment.text = "0"
        }*/
    }

    
    //MARK: - Button Click
    @IBAction func btn_Save(_ sender: Any) {
        updateExtraChanges()
    }
    
    //MARK: - API Call
    func Get_CardDetails(){
        showLoader()
        APIService.shared.getExtraChanges { result in
            self.hideLoader()
            if let payment = result?.data{
                if payment.cashback != 0{
                    self.txt_CardPayment.text = String(payment.cashback ?? 0)
                }else{
                    self.txt_CardPayment.text = ""
                }
                
                if payment.card_charge != 0{
                    self.txt_CashPayment.text = String(payment.card_charge ?? 0)
                }else{
                    self.txt_CashPayment.text = ""
                }
                
            }
        }
    }
    
    func updateExtraChanges(){
        showLoader()
        APIService.shared.updateExtraChanges(card_charge: self.txt_CardPayment.text ?? "", cashback: self.txt_CashPayment.text ?? "", vendor_id: LocalData.userId) { result in
            self.hideLoader()
            if let message = result?.data{
                self.alertWithMessageOnly(NSLocalizedString("Extra charges updated successfully",comment: ""))
            }else{
                self.alertWithMessageOnly(NSLocalizedString("Failed to update extra charges",comment: ""))
            }
        }
    }
}
