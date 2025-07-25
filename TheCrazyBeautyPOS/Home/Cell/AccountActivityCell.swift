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
    
    var tooltip: TooltipView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tooltip = TooltipView()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var Act_ToolTip:(()->Void)?
    @IBAction func act_tooltip(_ sender: UIButton) {
        self.Act_ToolTip?()
    }
    
    func showTooltip(message: String) {
        if let tooltip = tooltip {
            tooltip.show(message: message, in: self.contentView, above: btn_tooltip)
        }
    }

    
}


class TooltipView: UIView {
    private let label = UILabel()

    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.black
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.alpha = 0

        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4)
        ])
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(message: String, in view: UIView, above button: UIView) {
        self.label.text = message
        view.addSubview(self)

        NSLayoutConstraint.activate([
            self.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -8),
            self.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            self.widthAnchor.constraint(lessThanOrEqualToConstant: 250)
        ])
        view.layoutIfNeeded()

        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            }, completion: { _ in
                self.removeFromSuperview()
            })
        }
    }
}
