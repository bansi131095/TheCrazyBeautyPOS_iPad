//
//  BlockCustomerCell.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 11/07/25.
//

import UIKit

class BlockCustomerCell: UITableViewCell {

    @IBOutlet weak var txt_MobileNumber: TextInputLayout!
    
    @IBOutlet weak var btn_Delete: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var Act_Delete:(()->Void)?
    @IBAction func act_Delete(_ sender: UIButton) {
        self.Act_Delete?()
    }
    
}
