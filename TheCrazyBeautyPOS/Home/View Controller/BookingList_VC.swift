//
//  BookingList_VC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 08/08/25.
//

import UIKit

class BookingList_VC: UIViewController {

    //MARK: - Outlet
    
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_PastBooking: UILabel!
    @IBOutlet weak var lbl_FutureBooking: UILabel!
    
    @IBOutlet weak var vw_PastBooking: UIView!
    @IBOutlet weak var vw_FutureBooking: UIView!
    
    //MARK: - Global Variable
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: -  Button Action
    
    @IBAction func btn_PastBooking(_ sender: Any) {
    }
    
    @IBAction func btn_FutureBooking(_ sender: Any) {
    }
    
    //MARK: - Function
    //MARK: - Web Api Calling
}
