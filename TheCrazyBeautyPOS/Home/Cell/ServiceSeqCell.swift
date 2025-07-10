//
//  ServiceSeqCell.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 10/07/25.
//

import UIKit

class ServiceSeqCell: UITableViewCell {

    @IBOutlet weak var lbl_no: UILabel!
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
    
}
