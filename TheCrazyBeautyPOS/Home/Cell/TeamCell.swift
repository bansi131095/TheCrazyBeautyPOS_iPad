//
//  TeamCell.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 19/06/25.
//

import UIKit

class TeamCell: UITableViewCell {

    @IBOutlet weak var lbl_no: UILabel!
    @IBOutlet weak var img_vw: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_email: UILabel!
    @IBOutlet weak var lbl_phone: UILabel!
    @IBOutlet weak var lbl_jobTitle: UILabel!
    @IBOutlet weak var lbl_review: UILabel!
    
    
    @IBOutlet weak var img_Width: NSLayoutConstraint!
    @IBOutlet weak var img_Height: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCustomFont()
    }

    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Medium", size: 18.0) {
            lbl_no.font = customFont
            lbl_name.font = customFont
            lbl_email.font = customFont
            lbl_phone.font = customFont
            lbl_jobTitle.font = customFont
            lbl_review.font = customFont
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
    
}
