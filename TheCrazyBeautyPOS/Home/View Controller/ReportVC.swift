//
//  ReportVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 12/06/25.
//

import UIKit

class ReportVC: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var lbl_TotalAmount: UILabel!
    
    @IBOutlet weak var img_Team: UIImageView!
    @IBOutlet weak var img_Sales: UIImageView!
    @IBOutlet weak var img_Service: UIImageView!
    
    @IBOutlet weak var vw_TeamSaleService: UIView!
    @IBOutlet weak var lbl_Sales: UILabel!
    @IBOutlet weak var lbl_Walkin: UILabel!
    @IBOutlet weak var lbl_GiftCard: UILabel!
    
    @IBOutlet weak var vw_SaleWalkinGift: UIView!
    
    //MARK: - Global Variable
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        vw_SaleWalkinGift.isHidden = true
    }
    
    //MARK: -  Button Action
    
    @IBAction func btn_DownloadReport(_ sender: Any) {
    }
    
    
    @IBAction func btn_Team(_ sender: Any) {
        vw_SaleWalkinGift.isHidden = true
        img_Team.image = UIImage(named: "ic_Check")
        img_Sales.image = UIImage(named: "ic_Uncheck")
        img_Service.image = UIImage(named: "ic_Uncheck")
    }
    
    @IBAction func btn_Sales(_ sender: Any) {
        vw_SaleWalkinGift.isHidden = false
        img_Team.image = UIImage(named: "ic_Uncheck")
        img_Sales.image = UIImage(named: "ic_Check")
        img_Service.image = UIImage(named: "ic_Uncheck")
    }
    
    @IBAction func btn_Service(_ sender: Any) {
        vw_SaleWalkinGift.isHidden = true
        img_Team.image = UIImage(named: "ic_Uncheck")
        img_Sales.image = UIImage(named: "ic_Uncheck")
        img_Service.image = UIImage(named: "ic_Check")
    }
    
    
    
    @IBAction func btn_Sales_Second(_ sender: Any) {
    }
    
    @IBAction func btn_Walkin(_ sender: Any) {
    }
    
    
    @IBAction func btn_GiftCard(_ sender: Any) {
    }
    
    //MARK: - Function
    //MARK: - Web Api Calling
} 
