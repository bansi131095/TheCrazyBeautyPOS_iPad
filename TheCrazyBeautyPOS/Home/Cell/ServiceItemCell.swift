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
    @IBOutlet weak var lbl_type: UILabel!
    @IBOutlet weak var lbl_serviceFor: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_SalePrice: UILabel!
    
    @IBOutlet weak var btn_Duplication: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCustomFont()
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
    
    var Act_Duplication:(()->Void)?
    @IBAction func act_duplication(_ sender: UIButton) {
        self.Act_Duplication?()
    }
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Medium", size: 16.0) {
            lbl_no.font = customFont
            lbl_category.font = customFont
            lbl_service.font = customFont
            lbl_time.font = customFont
            lbl_serviceFor.font = customFont
            lbl_price.font = customFont
            lbl_SalePrice.font = customFont
            lbl_type.font = customFont
        }
    }
    
}
