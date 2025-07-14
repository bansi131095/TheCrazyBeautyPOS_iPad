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
    @IBOutlet weak var lbl_AllFields: UILabel!
    @IBOutlet weak var lbl_FieldHeight: NSLayoutConstraint!
    
    //MARK: - Global Variable
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        get_Notes()
    }
    
    //MARK: -  Button Action
    @IBAction func btn_Save(_ sender: Any) {
        if self.txtvw_Note.text == ""{
            alertWithImage(title: "Notes", Msg: "Notes is required.")
        }else{
            update_Notes()
        }
    }
    
    //MARK: - Function
    
    
    
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
