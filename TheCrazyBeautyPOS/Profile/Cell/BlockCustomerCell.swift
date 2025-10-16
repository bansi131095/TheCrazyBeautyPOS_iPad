//
//  BlockCustomerCell.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 11/07/25.
//

import UIKit

class BlockCustomerCell: UITableViewCell {

    @IBOutlet weak var txt_MobileNumber: TextInputLayout!
    @IBOutlet weak var img_Flag: UIImageView!
    @IBOutlet weak var btn_Delete: UIButton!
    @IBOutlet weak var vw_Close: UIView!
    
    var Act_Delete: ((_ cell: BlockCustomerCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCustomFont()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    var Act_Delete:(()->Void)?
    @IBAction func act_Delete(_ sender: UIButton) {
//        self.Act_Delete?()
        Act_Delete?(self)
    }
    
    var Act_Flag:(()->Void)?
    @IBAction func act_Flag(_ sender: UIButton) {
        self.Act_Flag?()
    }
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Medium", size: 16.0) {
            txt_MobileNumber.font = customFont
        }
    }
}
