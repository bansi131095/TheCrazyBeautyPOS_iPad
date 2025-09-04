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
    @IBOutlet weak var lbl_titleCustomerName: UILabel!
    @IBOutlet weak var lbl_customerName: UILabel!
    @IBOutlet weak var lbl_BookingNo: UILabel!
    @IBOutlet weak var lbl_bookingId: UILabel!
    @IBOutlet weak var lbl_amount: UILabel!
    @IBOutlet weak var lbl_titleAmount: UILabel!
    @IBOutlet weak var lbl_Type: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCustomFont()
        // Initialization code
    }
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Medium", size: 16.0) {
            lbl_bookingDate.font = customFont
            lbl_bookingTime.font = customFont
            lbl_titleCustomerName.font = customFont
            lbl_customerName.font = customFont
            lbl_BookingNo.font = customFont
            lbl_bookingId.font = customFont
            lbl_amount.font = customFont
            lbl_titleAmount.font = customFont
        }
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
