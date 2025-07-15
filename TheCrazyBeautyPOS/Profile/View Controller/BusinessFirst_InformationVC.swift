//
//  BusinessFirst_InformationVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 15/07/25.
//

import UIKit

class BusinessFirst_InformationVC: UIViewController {

    
    var colorApplyMode: ColorApplyMode = .text
    var arr_SalonType = ["Male","Female","Unisex"]
    
    //MARK: - Outlet
    
    @IBOutlet weak var txt_BusinessName: TextInputLayout!
    @IBOutlet weak var txt_SalonType: TextInputLayout!
    
    @IBOutlet weak var txt_Address: TextInputLayout!
    @IBOutlet weak var map_vw: UIView!
    @IBOutlet weak var switch_visible: UISwitch!
    
    //MARK: - Global Variable
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //MARK: -  Button Action
    
    @IBAction func btn_SalonType(_ sender: Any) {
    }
    
    @IBAction func btn_Address(_ sender: Any) {
    }
    
    @IBAction func btn_Continue(_ sender: Any) {
    }
    
    @IBAction func switch_Visible(_ sender: UISwitch) {
        if sender.isOn{
            switch_visible.isOn = true
            web_status = 1
        }else{
            switch_visible.isOn = false
            web_status = 0
        }
    }
    
    //MARK: - Function
    //MARK: - Web Api Calling

}
