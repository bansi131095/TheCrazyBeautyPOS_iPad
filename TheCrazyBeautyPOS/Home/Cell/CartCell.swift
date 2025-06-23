//
//  CartCell.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 18/06/25.
//

import UIKit

class CartCell: UITableViewCell {

    
    @IBOutlet weak var lbl_category: UILabel!
    @IBOutlet weak var tbl_item: UITableView!
    @IBOutlet weak var tbl_item_heightConst: NSLayoutConstraint!
    
    var data: [ServiceItem] = [] {
        didSet {
            tbl_item.reloadData()
            DispatchQueue.main.async {
                self.tbl_item_heightConst.constant = self.tbl_item.contentSize.height
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTableView(){
        self.tbl_item.register(UINib(nibName: "CartItemCell", bundle: nil), forCellReuseIdentifier: "CartItemCell")
        self.tbl_item.delegate = self
        self.tbl_item.dataSource = self
        self.tbl_item.estimatedRowHeight = 44  // Provide a reasonable estimate
        self.tbl_item.rowHeight = UITableView.automaticDimension
    }
    
}

extension CartCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell") as? CartItemCell else {
            fatalError("The cell is not registered")
        }
        let items = data[indexPath.row]
        cell.lbl_service.text = items.name
        cell.lbl_price.text = "-\(LocalData.symbol)\(items.price)"
        cell.lbl_count.text = "\(items.count)"
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
}
