//
//  CategoryDescriptionCell.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 26/06/25.
//

import UIKit

class CategoryDescriptionCell: UITableViewCell {

    @IBOutlet weak var img_Category: UIImageView!
    @IBOutlet weak var lbl_CategoryName: UILabel!
    @IBOutlet weak var txt_Sequence: TextInputLayout!
    @IBOutlet weak var txt_Description: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
