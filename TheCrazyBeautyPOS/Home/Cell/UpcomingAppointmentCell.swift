//
//  UpcomingAppointmentCell.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 01/07/25.
//

import UIKit

class UpcomingAppointmentCell: UITableViewCell {

    
    @IBOutlet weak var lbl_bookingDate: UILabel!
    @IBOutlet weak var lbl_bookingTime: UILabel!
    @IBOutlet weak var lbl_customerName: UILabel!
    @IBOutlet weak var lbl_bookingId: UILabel!
    @IBOutlet weak var lbl_amount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var Act_Info:(()->Void)?
    @IBAction func act_info(_ sender: UIButton) {
        self.Act_Info?()
    }
    
}
