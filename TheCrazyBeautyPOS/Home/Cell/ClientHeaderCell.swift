//
//  ClientHeaderCell.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 25/06/25.
//

import UIKit

protocol ClientSortDelegate: AnyObject {
    func btnSort_Action(cell: ClientHeaderCell)
}

class ClientHeaderCell: UITableViewHeaderFooterView {
    
    weak var delegate: ClientSortDelegate?
    
    @IBOutlet weak var img_AtoZ: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func btnSortBy_Action(_ sender: UIButton) {
        delegate?.btnSort_Action(cell: self)
    }
}
