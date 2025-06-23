//
//  CategoriesCell.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 23/06/25.
//

import UIKit

class CategoriesCell: UITableViewCell {

    @IBOutlet weak var lbl_CategoriesName: UILabel!
    @IBOutlet weak var lbl_Line: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
