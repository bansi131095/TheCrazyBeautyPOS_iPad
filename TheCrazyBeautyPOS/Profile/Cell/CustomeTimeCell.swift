//
//  CustomeTimeCell.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 02/12/25.
//

import UIKit

class CustomeTimeCell: UICollectionViewCell {

    
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_FromTime: UILabel!
    @IBOutlet weak var lbl_ToTime: UILabel!
    
    @IBOutlet weak var btnFrom_Time: UIButton!
    @IBOutlet weak var btnTo_Time: UIButton!
    @IBOutlet weak var btn_Close: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var Act_From:(()->Void)?
    @IBAction func act_From(_ sender: Any) {
        self.Act_From?()
    }

    var Act_To:(()->Void)?
    @IBAction func act_To(_ sender: Any) {
        self.Act_To?()
    }
    
    var Act_Close:(()->Void)?
    @IBAction func act_Close(_ sender: Any) {
        self.Act_Close?()
    }

}
