//
//  SettingCell.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 23/06/25.
//

import UIKit

class SettingCell: UITableViewCell {

    @IBOutlet weak var img_List: UIImageView!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var img_Arrow: UIImageView!
    @IBOutlet weak var tbl_Categories: UITableView!
    @IBOutlet weak var tbl_Categories_Height: NSLayoutConstraint!
    
    
    
    var data: [String] = [] {
        didSet {
            tbl_Categories.reloadData()
            DispatchQueue.main.async {
                self.tbl_Categories_Height.constant = self.tbl_Categories.contentSize.height
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
        self.tbl_Categories.register(UINib(nibName: "CategoriesCell", bundle: nil), forCellReuseIdentifier: "CategoriesCell")
        self.tbl_Categories.delegate = self
        self.tbl_Categories.dataSource = self
        self.tbl_Categories.estimatedRowHeight = 60  // Provide a reasonable estimate
        self.tbl_Categories.rowHeight = UITableView.automaticDimension
    }
    
}

extension SettingCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl_Categories.dequeueReusableCell(withIdentifier: "CategoriesCell") as! CategoriesCell
        cell.lbl_CategoriesName.text = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
