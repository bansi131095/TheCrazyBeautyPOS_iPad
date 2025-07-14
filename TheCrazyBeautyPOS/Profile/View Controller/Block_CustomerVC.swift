//
//  Block_CustomerVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 26/06/25.
//

import UIKit
import CountryPickerViewSwift

class Block_CustomerVC: UIViewController {

    
    
//    @IBOutlet weak var countryPicker: UIView!
    
    @IBOutlet weak var img_Flag: UIImageView!
    @IBOutlet weak var txt_MobileNumber: UITextField!
    
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var tbl_Height: NSLayoutConstraint!
    
    var SelectedCountryCode : String = ""
    var SelectedCountryPhoneCode : String = ""
    var totalNumber = 1
    var arr_Number = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    
    //MARK: - Function
    func setTableView(){
        tbl_vw.register(UINib(nibName: "BlockCustomerCell", bundle: nil), forCellReuseIdentifier: "BlockCustomerCell")
        tbl_vw.delegate = self
        tbl_vw.dataSource = self
        tbl_vw.rowHeight = UITableView.automaticDimension
        tbl_vw.estimatedRowHeight = 80
    }
    
    func AddMoreField() {
        self.arr_Number.append("")  // Add empty string for new field
        self.tbl_Height.constant = CGFloat(self.arr_Number.count * 80)
        self.tbl_vw.performBatchUpdates({
            self.tbl_vw.insertRows(at: [IndexPath(row: self.arr_Number.count - 1, section: 0)], with: .automatic)
        }, completion: nil)
    }

    //MARK: - Button Action
    @IBAction func btn_Flag(_ sender: Any) {
    }
    
    
    @IBAction func btn_AddMore(_ sender: Any) {
        AddMoreField()
    }
    
    @IBAction func btn_Save(_ sender: Any) {
    }
    
    
}

extension Block_CustomerVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_Number.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl_vw.dequeueReusableCell(withIdentifier: "BlockCustomerCell", for: indexPath) as! BlockCustomerCell
        return cell
    }
}
