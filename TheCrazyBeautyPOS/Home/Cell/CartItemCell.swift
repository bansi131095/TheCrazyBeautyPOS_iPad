//
//  CartItemCell.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 18/06/25.
//

import UIKit

class CartItemCell: UITableViewCell {
    
    @IBOutlet weak var lbl_service: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_count: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btn_plus(_ sender: Any) {
    }
    
    @IBAction func btn_minus(_ sender: Any) {
    }
    
}
