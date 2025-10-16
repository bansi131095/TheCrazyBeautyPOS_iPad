//
//  CategoryDescriptionCell.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 26/06/25.
//

import UIKit

class CategoryDescriptionCell: UITableViewCell,UITextViewDelegate {

    @IBOutlet weak var img_Category: UIImageView!
    @IBOutlet weak var lbl_CategoryName: UILabel!
    @IBOutlet weak var txt_Sequence: TextInputLayout!
    @IBOutlet weak var txt_Description: UITextView!
    
    let placeholderLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCustomFont()
        txt_Description.delegate = self
        
        placeholderLabel.text = "Description"
        placeholderLabel.font = UIFont(name: "Lato-Medium", size: 18.0)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.numberOfLines = 1
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        txt_Description.addSubview(placeholderLabel)
        placeholderLabel.isHidden = !txt_Description.text.isEmpty
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Medium", size: 16.0) {
            txt_Sequence.font = customFont
            txt_Description.font = customFont
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
}
