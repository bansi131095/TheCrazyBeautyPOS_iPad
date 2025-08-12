//
//  PatchTestCell.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 11/08/25.
//

import UIKit

class PatchTestCell: UITableViewCell {

    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Test_Date: UILabel!
    @IBOutlet weak var lbl_TestBy: UILabel!
    @IBOutlet weak var lbl_TestStatus: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
