//
//  ProfileVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 23/06/25.
//

import UIKit

class ProfileVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var tbl_Categories_List: UITableView!
    @IBOutlet weak var containerView: UIView!
    
    //MARK: - Global Variable
    let arr_ImageList = ["ic_Store","ic_Notification","ic_Booking","ic_Team","ic_Schedule","ic_Payment","ic_Team","ic_Privacy"]
    let arr_ListName = ["Salon Details","Notifications","Booking","Team","Schedule","Payment","Kiosk & Customers","Privacy & Security"]
    
    var arrSelectIndex: [Int] = []
    
    //MARK: - View Lify Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    //MARK: - Button Action
    @IBAction func btn_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_AddSalon(_ sender: Any) {
    }
    
    
    //MARK: - Function
    func setUpTableView() {
        let nib = UINib(nibName: "SettingCell", bundle: nil)
        self.tbl_Categories_List.register(nib, forCellReuseIdentifier: "SettingCell")
        
        self.tbl_Categories_List.delegate = self
        self.tbl_Categories_List.dataSource = self
        
//        self.tbl_Categories_List.rowHeight = 100
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_ListName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl_Categories_List.dequeueReusableCell(withIdentifier: "SettingCell") as! SettingCell
        cell.lbl_Title.text = arr_ListName[indexPath.row]
        cell.img_List.image = UIImage(named: arr_ImageList[indexPath.row])
        cell.tbl_Categories_Height.constant = 0
        cell.data = arr_ListName
        
        if self.arrSelectIndex.firstIndex(of: indexPath.row) != nil {
            cell.img_List.tintColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
            cell.lbl_Title.textColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
            cell.img_Arrow.image = UIImage(named: "ic_Up")
            cell.tbl_Categories.isHidden = false
            cell.tbl_Categories_Height.constant = cell.tbl_Categories.contentSize.height
        }else{
            cell.img_List.tintColor = UIColor.black
            cell.lbl_Title.textColor = UIColor.black
            cell.img_Arrow.image = UIImage(named: "ic_Down")
            cell.tbl_Categories.isHidden = true
            cell.tbl_Categories_Height.constant = 0
        }
        
        cell.setTableView()
        cell.tbl_Categories.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = self.tbl_Categories_List.cellForRow(at: indexPath) as? SettingCell {
            if cell.img_Arrow.image == UIImage(named: "ic_Down"){
                self.arrSelectIndex.append(indexPath.row)
            }else if cell.img_Arrow.image == UIImage(named: "ic_Up"){
                if let index = self.arrSelectIndex.firstIndex(of: indexPath.row) {
                    self.arrSelectIndex.remove(at: index)
                }
            }
        }
        self.tbl_Categories_List.reloadData()
    }
}
