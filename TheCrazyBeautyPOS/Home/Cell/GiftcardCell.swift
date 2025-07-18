//
//  GiftcardCell.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 17/07/25.
//

import UIKit

class GiftcardCell: UITableViewCell {

    
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_GiftCard: UILabel!
    @IBOutlet weak var lbl_Amount: UILabel!
    @IBOutlet weak var lbl_UsedDate: UILabel!
    @IBOutlet weak var lbl_ExpiryDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
