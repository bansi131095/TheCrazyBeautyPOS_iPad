//
//  CartCell.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 18/06/25.
//

import UIKit

class CartCell: UITableViewCell {
    
    var onItemUpdate: ((Int, Int) -> Void)? // (itemIndex, changeAmount)

    
    @IBOutlet weak var lbl_category: UILabel!
    @IBOutlet weak var tbl_item: UITableView!
    @IBOutlet weak var tbl_item_heightConst: NSLayoutConstraint!
    
    var data: [ServiceItem] = [] {
        didSet {
            tbl_item.reloadData()
            DispatchQueue.main.async {
                self.updateTableViewHeight()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setTableView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // This is called when the cell's frame changes or it needs to re-layout.
        // It's a good place to ensure the internal table view's height is accurate.
        // However, avoid calling reloadData here as it can cause an infinite loop.
        updateTableViewHeight()
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTableView(){
        self.tbl_item.register(UINib(nibName: "CartItemCell", bundle: nil), forCellReuseIdentifier: "CartItemCell")
        self.tbl_item.delegate = self
        self.tbl_item.dataSource = self
        self.tbl_item.estimatedRowHeight = 100  // Crucial: Provide a good estimate!
        self.tbl_item.rowHeight = UITableView.automaticDimension // Allow individual item cells to size themselves
        self.tbl_item.isScrollEnabled = false
        self.tbl_item.separatorStyle = .none // Remove separators if not needed for cleaner look
        self.tbl_item.layoutIfNeeded()
    }

//    private func updateTableViewHeight() {
    /*func updateTableViewHeight() {
        // Force layout pass for the inner table view to get accurate contentSize
        self.tbl_item.setNeedsLayout()
        self.tbl_item.layoutIfNeeded()
        
        let newHeight = self.tbl_item.contentSize.height
        if self.tbl_item_heightConst.constant != newHeight {
            self.tbl_item_heightConst.constant = newHeight
            // Inform the cell itself to re-layout, which in turn helps the parent table.
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }*/
    
    func updateTableViewHeight() {
            tbl_item_heightConst.constant = tbl_item.contentSize.height
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
        cell.lbl_price.text = "−   \(SharedPrefs.getSymbol())\(items.price)"
        cell.lbl_count.text = "\(items.count)"
        cell.Act_Plus = {
//            self.data[indexPath.row].count += 1
//            self.tbl_item.reloadData()
            self.onItemUpdate?(indexPath.row, 1)
            
        }
        cell.Act_Minus = {
            if self.data[indexPath.row].count > 0 {
//                self.data[indexPath.row].count -= 1
//                self.tbl_item.reloadData()
                self.onItemUpdate?(indexPath.row, -1)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
