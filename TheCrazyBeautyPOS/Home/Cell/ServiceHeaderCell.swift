//
//  ServiceHeaderCell.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 25/06/25.
//

import UIKit

protocol SortDelegate: AnyObject {
    
    func btnSort_Action(cell: ServiceHeaderCell)
    
}

class ServiceHeaderCell: UITableViewHeaderFooterView {

    weak var delegate: SortDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
