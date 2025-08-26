//
//  AllResourcesCell.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 26/08/25.
//

import UIKit

class AllResourcesCell: UITableViewCell {

    @IBOutlet weak var lbl_Number: UILabel!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Qty: UILabel!
    @IBOutlet weak var lbl_Description: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
