//
//  SalesHistoryCell.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 18/07/25.
//

import UIKit

class SalesHistoryCell: UITableViewCell {

    @IBOutlet weak var lbl_ID: UILabel!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var lbl_Type: UILabel!
    @IBOutlet weak var lbl_Staff: UILabel!
    @IBOutlet weak var lbl_Status: UILabel!
    @IBOutlet weak var lbl_Payment: UILabel!
    @IBOutlet weak var lbl_Tip: UILabel!
    @IBOutlet weak var lbl_Total: UILabel!
    @IBOutlet weak var btn_Action: UIButton!
    @IBOutlet weak var btn_Mail: UIButton!
    @IBOutlet weak var btn_Delete: UIButton!
    
    @IBOutlet weak var vwRefund: UIView!
    @IBOutlet weak var lbl_Refund: UILabel!
    @IBOutlet weak var btn_Refund: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCustomFont()
        self.lbl_Refund.text = NSLocalizedString("Refund",comment: "")
    }

    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Regular", size: 16.0) {
            lbl_ID.font = customFont
            lbl_Name.font = customFont
            lbl_Date.font = customFont
            lbl_Time.font = customFont
            lbl_Type.font = customFont
            lbl_Staff.font = customFont
            lbl_Status.font = customFont
            lbl_Payment.font = customFont
            lbl_Tip.font = customFont
            lbl_Total.font = customFont
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var Act_Action:(()->Void)?
    @IBAction func act_Action(_ sender: UIButton) {
        self.Act_Action?()
    }
    
    var Act_Mail:(()->Void)?
    @IBAction func act_Mail(_ sender: Any) {
        self.Act_Mail?()
    }
    
    var Act_Delete:(()->Void)?
    @IBAction func act_Delete(_ sender: Any) {
        self.Act_Delete?()
    }
    
    var Act_Refund:(()->Void)?
    @IBAction func act_Refund(_ sender: Any) {
        self.Act_Refund?()
    }
}
