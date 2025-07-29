//
//  AccountActivityCell.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 14/07/25.
//

import UIKit

class AccountActivityCell: UITableViewCell {

    
    @IBOutlet weak var lbl_activity: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var btn_tooltip: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var Act_ToolTip:(()->Void)?
    @IBAction func act_tooltip(_ sender: UIButton) {
        Act_ToolTip?()
    }

    
}


func showTooltip(from view: UIView, in container: UIView, message: String) {
    // Remove existing tooltip
    if let existingTooltip = container.viewWithTag(9999) {
        existingTooltip.removeFromSuperview()
    }

    let tooltipLabel = UILabel()
    tooltipLabel.text = message
    tooltipLabel.textColor = .white
    tooltipLabel.font = UIFont.systemFont(ofSize: 13)
    tooltipLabel.backgroundColor = UIColor.black.withAlphaComponent(0.85)
    tooltipLabel.textAlignment = .center
    tooltipLabel.numberOfLines = 0
    tooltipLabel.layer.cornerRadius = 6
    tooltipLabel.layer.masksToBounds = true
    tooltipLabel.tag = 9999
    tooltipLabel.translatesAutoresizingMaskIntoConstraints = false
    container.addSubview(tooltipLabel)

    // Convert the position of the view to container coordinates
    let convertedFrame = view.convert(view.bounds, to: container)

    // Set tooltip position using frame instead of Auto Layout for simplicity
    let tooltipWidth: CGFloat = 160
    let tooltipHeight: CGFloat = 60
    let x = convertedFrame.midX - tooltipWidth / 2
    let y = convertedFrame.minY - tooltipHeight - 8

    tooltipLabel.frame = CGRect(x: x, y: y, width: tooltipWidth, height: tooltipHeight)
    tooltipLabel.alpha = 0

    UIView.animate(withDuration: 0.3) {
        tooltipLabel.alpha = 1
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
        UIView.animate(withDuration: 0.3, animations: {
            tooltipLabel.alpha = 0
        }, completion: { _ in
            tooltipLabel.removeFromSuperview()
        })
    }
}


