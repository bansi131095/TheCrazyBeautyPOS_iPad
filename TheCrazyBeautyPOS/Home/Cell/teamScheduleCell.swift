//
//  teamScheduleCell.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 07/07/25.
//

import UIKit

class teamScheduleCell: UITableViewCell {

    
    @IBOutlet weak var lbl_day: UILabel!
    @IBOutlet weak var btn_switch: UIButton!
    @IBOutlet weak var vw_1: UIView!
    @IBOutlet weak var vw_2: UIView!
    @IBOutlet weak var txt_from: TextInputLayout!
    @IBOutlet weak var txt_to: TextInputLayout!
    @IBOutlet weak var txt_from1: TextInputLayout!
    @IBOutlet weak var txt_to1: TextInputLayout!
    @IBOutlet weak var lbl_salonOff: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackHeightConstraint: NSLayoutConstraint!
   
    var onTextFieldTap: ((UITextField) -> Void)?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        [txt_from, txt_to, txt_from1, txt_to1].forEach {
            $0?.addTarget(self, action: #selector(textFieldTapped(_:)), for: .editingDidBegin)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: Button Action
    var Act_Switch: (() -> Void)?
    @IBAction func act_switch(_ sender: Any) {
        self.Act_Switch?()
    }

    @objc private func textFieldTapped(_ textField: UITextField) {
        onTextFieldTap?(textField)
    }

    
    func updateStackVisibility(view1Hidden: Bool, view2Hidden: Bool) {
        vw_1.isHidden = view1Hidden
        vw_2.isHidden = view2Hidden

        // If both views are hidden, collapse the stack
        let shouldCollapseStack = view1Hidden && view2Hidden

        stackHeightConstraint.constant = shouldCollapseStack ? 0 : 1 // Just to keep it active
        stackHeightConstraint.isActive = shouldCollapseStack

        UIView.animate(withDuration: 0.3) {
            self.superview?.layoutIfNeeded()
        }
    }

}
