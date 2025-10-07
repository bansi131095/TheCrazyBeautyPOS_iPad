//
//  CategoryCell.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 12/06/25.
//

import UIKit
import SDWebImage

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var img_back: UIImageView!
    @IBOutlet weak var img_image: SDAnimatedImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var vw_count: GradientView!
    @IBOutlet weak var lbl_count: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setCustomFont()
    }
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Medium", size: 16.0) {
            lbl_name.font = customFont
        }
    }

}
