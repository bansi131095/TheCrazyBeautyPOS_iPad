//
//  ToolTipView.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 28/07/25.
//

import UIKit

class ToolTipView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var lbl_tooltip: UILabel!
    @IBOutlet weak var vw_toolTip: UIView!
    
    
    var contentView: UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        vw_toolTip.layer.cornerRadius = vw_toolTip.bounds.height / 2
        vw_toolTip.layer.masksToBounds = true
    }


    private func commonInit() {
        guard let view = Bundle.main.loadNibNamed("ToolTipView", owner: self, options: nil)?.first as? UIView else {
            return
        }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        self.contentView = view
    }

    func setMessage(_ message: String) {
        lbl_tooltip.text = message
    }
    
}
