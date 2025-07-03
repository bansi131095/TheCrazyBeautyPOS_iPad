//
//  Gift Card 3 Cards Gift Card 3 Cards Gift Card 3 Cards Gift Card Gift Card GiftCardCell.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 25/06/25.
//

import UIKit

class GiftCardCell: UITableViewCell {
    
    
    @IBOutlet weak var lbl_no: UILabel!
    @IBOutlet weak var img_vw: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_ExpiryDate: UILabel!
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
