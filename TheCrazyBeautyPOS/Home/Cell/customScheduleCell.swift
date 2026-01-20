//
//  customScheduleCell.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 08/07/25.
//

import UIKit

class customScheduleCell: UITableViewCell {

    @IBOutlet weak var lbl_day: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var vw_1: UIView!
    @IBOutlet weak var vw1_height_const: NSLayoutConstraint!
    @IBOutlet weak var vw_2: UIView!
    @IBOutlet weak var vw2_height_const: NSLayoutConstraint!
    @IBOutlet weak var txt_from: TextInputLayout!
    @IBOutlet weak var txt_to: TextInputLayout!
    @IBOutlet weak var txt_from1: TextInputLayout!
    @IBOutlet weak var txt_to1: TextInputLayout!
    @IBOutlet weak var img_remove: UIImageView!
    @IBOutlet weak var img_add: UIImageView!
    
    
    
    @IBOutlet weak var lbl_From: UILabel!
    @IBOutlet weak var lbl_TO: UILabel!
    
    
    @IBOutlet weak var lbl_From1: UILabel!
    @IBOutlet weak var lbl_To1: UILabel!
    
    var onTextFieldTap: ((UITextField) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lbl_From.text = NSLocalizedString("From", comment: "")
        lbl_TO.text = NSLocalizedString("To", comment: "")
        
        lbl_From1.text = NSLocalizedString("From", comment: "")
        lbl_To1.text = NSLocalizedString("To", comment: "")
        
        [txt_from, txt_to, txt_from1, txt_to1].forEach {
            $0?.addTarget(self, action: #selector(textFieldTapped(_:)), for: .editingDidBegin)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: Button Action
    var Act_Cancel: (() -> Void)?
    @IBAction func act_cancel(_ sender: Any) {
        self.Act_Cancel?()
    }

    @objc private func textFieldTapped(_ textField: UITextField) {
        onTextFieldTap?(textField)
    }

    var Act_Remove: (() -> Void)?
    @IBAction func act_delete(_ sender: UIButton) {
        self.Act_Remove?()
    }
    
    
    var Act_Add: (() -> Void)?
    @IBAction func act_add(_ sender: UIButton) {
        self.Act_Add?()
    }
    
}
