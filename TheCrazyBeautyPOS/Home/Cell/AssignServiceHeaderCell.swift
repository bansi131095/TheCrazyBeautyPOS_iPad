//
//  AssignServiceHeaderCell.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 04/07/25.
//

import UIKit

class AssignServiceHeaderCell: UITableViewHeaderFooterView {
    
    @IBOutlet weak var btn_checkAll: UIButton!
    
    @IBOutlet weak var lbl_Category: UILabel!
    @IBOutlet weak var lbl_Service: UILabel!
    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var lbl_ServiceFor: UILabel!
    @IBOutlet weak var lbl_Price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lbl_Category.text = NSLocalizedString("Category", comment: "")
        lbl_Service.text = NSLocalizedString("Service", comment: "")
        lbl_Time.text = NSLocalizedString("Time", comment: "")
        lbl_ServiceFor.text = NSLocalizedString("Service For", comment: "")
        lbl_Price.text = NSLocalizedString("Price", comment: "")
        // Initialization code
    }
    var Act_Check:(()->Void)?
    @IBAction func btn_checkAll(_ sender: Any) {
        self.Act_Check?()
    }
    
    
}
