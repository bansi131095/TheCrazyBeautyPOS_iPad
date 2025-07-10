//
//  TimeOffCell.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 09/07/25.
//

import UIKit

class TimeOffCell: UITableViewCell {

    @IBOutlet weak var lbl_fromTo: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var Act_Delete:(()->Void)?
    @IBAction func act_delete(_ sender: UIButton) {
        self.Act_Delete?()
    }
    
   
}
