//
//  ServiceItemCell.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 25/06/25.
//

import UIKit

class ServiceItemCell: UITableViewCell {

    @IBOutlet weak var lbl_no: UILabel!
    @IBOutlet weak var lbl_category: UILabel!
    @IBOutlet weak var lbl_service: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var lbl_serviceFor: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    
    
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
