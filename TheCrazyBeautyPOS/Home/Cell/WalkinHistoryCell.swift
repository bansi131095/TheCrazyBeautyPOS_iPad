//
//  WalkinHistoryCell.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 18/07/25.
//

import UIKit

class WalkinHistoryCell: UITableViewCell {

    @IBOutlet weak var lbl_ID: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_ServiceName: UILabel!
    @IBOutlet weak var lbl_GiftCard: UILabel!
    @IBOutlet weak var lbl_PaymentType: UILabel!
    @IBOutlet weak var lbl_CouponCode: UILabel!
    @IBOutlet weak var lbl_Discount: UILabel!
    @IBOutlet weak var lbl_MisPrice: UILabel!
    @IBOutlet weak var lbl_Tip: UILabel!
    @IBOutlet weak var lbl_Total: UILabel!
    @IBOutlet weak var lbl_GrandTotal: UILabel!
    @IBOutlet weak var btn_Action: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCustomFont()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Medium", size: 20.0) {
            lbl_ID.font = customFont
            lbl_Date.font = customFont
            lbl_ServiceName.font = customFont
            lbl_GiftCard.font = customFont
            lbl_PaymentType.font = customFont
            lbl_CouponCode.font = customFont
            lbl_Discount.font = customFont
            lbl_MisPrice.font = customFont
            lbl_Tip.font = customFont
            lbl_Total.font = customFont
            lbl_GrandTotal.font = customFont
        }
    }
    
    
    var Act_Action:(()->Void)?
    @IBAction func act_Action(_ sender: UIButton) {
        self.Act_Action?()
    }
    
    
}
