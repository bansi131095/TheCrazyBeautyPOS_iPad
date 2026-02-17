//
//  AddonCell.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 13/02/26.
//

import UIKit

class AddonCell: UITableViewCell {

    
    @IBOutlet weak var lbl_Number: UILabel!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Duration: UILabel!
    @IBOutlet weak var lbl_Price: UILabel!
    @IBOutlet weak var lbl_Description: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCustomFont()
    }

    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Medium", size: 18.0) {
            lbl_Number.font = customFont
            lbl_Name.font = customFont
            lbl_Duration.font = customFont
            lbl_Price.font = customFont
            lbl_Description.font = customFont
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
