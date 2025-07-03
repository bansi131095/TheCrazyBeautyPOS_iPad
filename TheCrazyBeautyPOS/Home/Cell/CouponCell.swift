//
//  CouponCell.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 01/07/25.
//

import UIKit

class CouponCell: UITableViewCell {

    @IBOutlet weak var lbl_couponName: UILabel!
    @IBOutlet weak var lbl_amount: UILabel!
    @IBOutlet weak var lbl_upto: UILabel!
    @IBOutlet weak var lbl_code: UILabel!
    @IBOutlet weak var lbl_startDate: UILabel!
    @IBOutlet weak var lbl_endDate: UILabel!
    @IBOutlet weak var lbl_status: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var Act_Edit:(()->Void)?
    @IBAction func act_edit(_ sender: UIButton) {
        self.Act_Edit?()
    }
    
    var Act_Delete:(()->Void)?
    @IBAction func act_delete(_ sender: UIButton) {
        self.Act_Delete?()
    }
    
}
