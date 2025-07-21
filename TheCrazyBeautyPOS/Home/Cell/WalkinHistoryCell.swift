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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var Act_Action:(()->Void)?
    @IBAction func act_Action(_ sender: UIButton) {
        self.Act_Action?()
    }
    
    
}
