//
//  Category_DescriptionVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 26/06/25.
//

import UIKit

class Category_DescriptionVC: UIViewController {

    @IBOutlet weak var tbl_CategoriesDescription: UITableView!
    @IBOutlet weak var tbl_Height: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    func setTableView(){
        tbl_CategoriesDescription.register(UINib(nibName: "CategoryDescriptionCell", bundle: nil), forCellReuseIdentifier: "CategoryDescriptionCell")
        tbl_CategoriesDescription.delegate = self
        tbl_CategoriesDescription.dataSource = self
        tbl_CategoriesDescription.rowHeight = UITableView.automaticDimension
        tbl_CategoriesDescription.reloadData()
//        tbl_CategoriesDescription.estimatedRowHeight = 180
        
        tbl_Height.constant = self.tbl_CategoriesDescription.contentSize.height
    }
    
    @IBAction func btn_Save(_ sender: Any) {
    }
    
    
}

extension Category_DescriptionVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl_CategoriesDescription.dequeueReusableCell(withIdentifier: "CategoryDescriptionCell") as! CategoryDescriptionCell
        return cell
    }
}

