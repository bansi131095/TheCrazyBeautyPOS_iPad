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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lbl_Title.text = NSLocalizedString("Extra Charges", comment: "")
        self.lbl_CashPayment.text = NSLocalizedString("Cash Payment", comment: "")
        self.lbl_AddDiscount.text = NSLocalizedString("Add a discount percentage for customers who pay with Cash.", comment: "")
        
        self.lbl_CardPayment.text = NSLocalizedString("Card Payment", comment: "")
        self.lbl_AddExtra.text = NSLocalizedString("Add a Extra Charges for customers who pay with Card.", comment: "")
        
 
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

    
    @IBAction func btn_Save(_ sender: Any) {
    }
    
}
