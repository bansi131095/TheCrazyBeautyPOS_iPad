//
//  ClientFutureBookingsCell.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 08/08/25.
//

import UIKit

class ClientFutureBookingsCell: UITableViewCell {

    @IBOutlet weak var lbl_BookingNo: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var lbl_Status: UILabel!
    @IBOutlet weak var lbl_ServiceName: UILabel!
    @IBOutlet weak var lbl_SubTotal: UILabel!
    @IBOutlet weak var lbl_Discount: UILabel!
    @IBOutlet weak var lbl_MiscPrice: UILabel!
    @IBOutlet weak var lbl_MiscNotes: UILabel!
    @IBOutlet weak var lbl_Tip: UILabel!
    @IBOutlet weak var lbl_GrandTotal: UILabel!
    @IBOutlet weak var lbl_PaymentType: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCustomFont()
    }

    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Regular", size: 18.0) {
            lbl_BookingNo.font = customFont
            lbl_Date.font = customFont
            lbl_Time.font = customFont
            lbl_Status.font = customFont
            lbl_ServiceName.font = customFont
            lbl_SubTotal.font = customFont
            lbl_Discount.font = customFont
            lbl_MiscPrice.font = customFont
            lbl_MiscNotes.font = customFont
            lbl_Tip.font = customFont
            lbl_GrandTotal.font = customFont
            lbl_PaymentType.font = customFont
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var Act_Rebook:(()->Void)?
    @IBAction func btn_Rebook(_ sender: Any) {
        self.Act_Rebook?()
    }
}
