//
//  ClientCell.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 25/06/25.
//

import UIKit

class ClientCell: UITableViewCell {

    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_email: UILabel!
    @IBOutlet weak var lbl_phone: UILabel!
    @IBOutlet weak var lbl_clientType: UILabel!
    @IBOutlet weak var lbl_gender: UILabel!
    @IBOutlet weak var lbl_userType: UILabel!
    
    
    @IBOutlet weak var lbl_Line: UILabel!
    @IBOutlet weak var btn_Edit: UIButton!
    @IBOutlet weak var btn_Delete: UIButton!
    @IBOutlet weak var btn_Icon: UIButton!
    @IBOutlet weak var btn_Calender: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        setCustomFont()
    }

    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Medium", size: 18.0) {
            lbl_name.font = customFont
            lbl_email.font = customFont
            lbl_phone.font = customFont
            lbl_clientType.font = customFont
            lbl_gender.font = customFont
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var Act_Edit:(()->Void)?
    @IBAction func act_edit(_ sender: UIButton) {
        self.Act_Edit?()
    }
    
    var Act_Delete:(()->Void)?
    @IBAction func act_delete(_ sender: UIButton) {
        self.Act_Delete?()
    }
    
    var Act_info:(()->Void)?
    @IBAction func act_info(_ sender: UIButton) {
        self.Act_info?()
    }
    
    var Act_Calender:(()->Void)?
    @IBAction func act_calender(_ sender: Any) {
        self.Act_Calender?()
    }
    
}
