//
//  TeamCell.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 19/06/25.
//

import UIKit

class TeamCell: UITableViewCell {

    @IBOutlet weak var lbl_no: UILabel!
    @IBOutlet weak var img_vw: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_email: UILabel!
    @IBOutlet weak var lbl_phone: UILabel!
    @IBOutlet weak var lbl_jobTitle: UILabel!
    @IBOutlet weak var lbl_review: UILabel!
    @IBOutlet weak var lbl_Action: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
