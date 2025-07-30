//
//  Booking_PolicyVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 25/06/25.
//

import UIKit

class Booking_PolicyVC: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var txtvw_Note: UITextView!
    
    //MARK: - Global Variable
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        get_Notes()
        setCustomFont()
    }
    
    //MARK: -  Button Action
    @IBAction func btn_Save(_ sender: Any) {
        update_Notes()
    }
    
    //MARK: - Function
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Medium", size: 22.0) {
            txtvw_Note.font = customFont
        }
    }
    
    //MARK: - Web Api Calling
    func get_Notes(){
        APIService.shared.fetchNotes { result in
            self.txtvw_Note.text = result?.data.first?.notes
        }
    }
    
    func update_Notes(){
        APIService.shared.UpdateNotes(vendorId: LocalData.userId, notes: self.txtvw_Note.text ?? "") { result in
            if let message = result?.data{
                self.alertWithMessageOnly(message)
            }else{
                self.alertWithMessageOnly("Something went wrong.")
            }
        }
    }
}
