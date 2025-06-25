//
//  Booking_PreferenceVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 24/06/25.
//

import UIKit

class Booking_PreferenceVC: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var vw_Staff: UIView!
    @IBOutlet weak var vw_Guest: UIView!
    @IBOutlet weak var img_Staff: UIImageView!
    @IBOutlet weak var img_Guest: UIImageView!
    
    //MARK: - Global Variable
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: -  Button Action
    @IBAction func btn_Save(_ sender: Any) {
    }
    
    
    @IBAction func btn_Staff(_ sender: Any) {
        vw_Staff.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 0.3000000119)
        vw_Guest.backgroundColor = .white
        img_Staff.image = UIImage(named: "ic_Check")
        img_Guest.image = UIImage(named: "ic_Uncheck")
    }
    
    
    @IBAction func btn_Guest(_ sender: Any) {
        vw_Staff.backgroundColor = .white
        vw_Guest.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 0.3000000119)
        img_Staff.image = UIImage(named: "ic_Uncheck")
        img_Guest.image = UIImage(named: "ic_Check")
    }
    
    //MARK: - Function
    //MARK: - Web Api Calling
} 
