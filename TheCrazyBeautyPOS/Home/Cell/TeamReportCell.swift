//
//  TeamReportCell.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 22/07/25.
//

import UIKit

class TeamReportCell: UITableViewCell {

    
    @IBOutlet weak var lbl_Id: UILabel!
    @IBOutlet weak var lbl_CustomerName: UILabel!
    
    @IBOutlet weak var lbl_StaffName: UILabel!
    @IBOutlet weak var lbl_ServiceName: UILabel!
    @IBOutlet weak var lbl_Price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCustomFont()
    }
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Medium", size: 18.0) {
            lbl_Id.font = customFont
            lbl_CustomerName.font = customFont
            lbl_StaffName.font = customFont
            lbl_ServiceName.font = customFont
            lbl_Price.font = customFont
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
