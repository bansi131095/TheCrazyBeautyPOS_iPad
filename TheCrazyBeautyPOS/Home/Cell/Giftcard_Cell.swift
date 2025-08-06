//
//  GiftcardCell.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 17/07/25.
//

import UIKit

class Giftcard_Cell: UITableViewCell {

    
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_GiftCard: UILabel!
    @IBOutlet weak var lbl_Amount: UILabel!
    @IBOutlet weak var lbl_UsedDate: UILabel!
    @IBOutlet weak var lbl_ExpiryDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCustomFont()
    }

    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Regular", size: 18.0) {
            lbl_Name.font = customFont
            lbl_GiftCard.font = customFont
            lbl_Amount.font = customFont
            lbl_UsedDate.font = customFont
            lbl_ExpiryDate.font = customFont
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
