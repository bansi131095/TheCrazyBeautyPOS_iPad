//
//  InventoryCell.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 25/06/25.
//

import UIKit

class InventoryCell: UITableViewCell {
    
    @IBOutlet weak var lbl_no: UILabel!
    @IBOutlet weak var lbl_productName: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_qty: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        setCustomFont()
        // Initialization code
    }
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Medium", size: 18.0) {
            lbl_no.font = customFont
            lbl_productName.font = customFont
            lbl_price.font = customFont
            lbl_qty.font = customFont
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
