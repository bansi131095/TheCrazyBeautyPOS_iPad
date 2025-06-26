//
//  TeamSequnenceCell.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 26/06/25.
//

import UIKit

class TeamSequnenceCell: UITableViewCell {

    @IBOutlet weak var img_User: UIImageView!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var txt_Sequence: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
