//
//  ServiceReportCell.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 17/07/25.
//

import UIKit

class ServiceReportCell: UITableViewCell {

    
    @IBOutlet weak var lbl_no: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_Amount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCustomFont()
    }
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Regular", size: 16.0) {
            lbl_no.font = customFont
            lbl_name.font = customFont
            lbl_Amount.font = customFont
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
