//
//  CustomDate_Cell.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 30/03/26.
//

import UIKit

class CustomDate_Cell: UITableViewCell {

    
    @IBOutlet weak var vw_Date: UIView!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var vw_Height: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var Act_Edit:(()->Void)?
    @IBAction func act_Edit(_ sender: UIButton) {
        self.Act_Edit?()
    }
    
    var Act_Remove:(()->Void)?
    @IBAction func act_Remove(_ sender: UIButton) {
        self.Act_Remove?()
    }
}
