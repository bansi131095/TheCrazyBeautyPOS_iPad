//
//  AssignServiceHeaderCell.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 04/07/25.
//

import UIKit

class AssignServiceHeaderCell: UITableViewHeaderFooterView {
    
    @IBOutlet weak var btn_checkAll: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var Act_Check:(()->Void)?
    @IBAction func btn_checkAll(_ sender: Any) {
        self.Act_Check?()
    }
    
    
}
