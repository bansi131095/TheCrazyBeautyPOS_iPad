//
//  OfflineGiftCardCell.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 29/07/25.
//

import UIKit

class OfflineGiftCardCell: UITableViewCell {

    @IBOutlet weak var lbl_Id: UILabel!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Price: UILabel!
    @IBOutlet weak var lbl_ExpiryDate: UILabel!
    @IBOutlet weak var lbl_GiftCode: UILabel!
    @IBOutlet weak var lbl_Message: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCustomFont()
    }

    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Regular", size: 20.0) {
            lbl_Id.font = customFont
            lbl_Name.font = customFont
            lbl_Price.font = customFont
            lbl_ExpiryDate.font = customFont
            lbl_GiftCode.font = customFont
            lbl_Message.font = customFont
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
