//
//  AssignServiceCell.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 04/07/25.
//

import UIKit

class AssignServiceCell: UITableViewCell {
    
    @IBOutlet weak var btn_check: UIButton!
    @IBOutlet weak var lbl_category: UILabel!
    @IBOutlet weak var lbl_service: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var lbl_serviceFor: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var Act_Check:(()->Void)?
    @IBAction func act_check(_ sender: UIButton) {
        self.Act_Check?()
    }
    
}
