//
//  TopServicesCell.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 30/01/26.
//

import UIKit

class TopServicesCell: UITableViewCell {

    
    @IBOutlet weak var lbl_Booked: UILabel!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Generated: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
