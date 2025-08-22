//
//  RebookListCell.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 22/08/25.
//

import UIKit

class RebookListCell: UITableViewCell {

    @IBOutlet weak var lbl_FullName: UILabel!
    @IBOutlet weak var img_Heart: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCustomFont()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Regular", size: 20.0) {
            lbl_FullName.font = customFont
        }
    }
    
}
