//
//  HolidayDatesCell.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 30/06/25.
//

import UIKit

class HolidayDatesCell: UITableViewCell {

    @IBOutlet weak var lbl_fromTo: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
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
