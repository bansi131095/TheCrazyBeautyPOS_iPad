//
//  AccountActivityCell.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 14/07/25.
//

import UIKit

class AccountActivityCell: UITableViewCell {

    
    @IBOutlet weak var lbl_activity: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func act_tooltip(_ sender: UIButton) {
    }
    
    
}
