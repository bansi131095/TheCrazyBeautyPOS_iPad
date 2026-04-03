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
    @IBOutlet weak var btn_Save: GradientButton!
    
    
    
    
    @IBOutlet weak var vw_Service: UIView!
    @IBOutlet weak var img_Service: UIImageView!
    
    
    @IBOutlet weak var vw_SecondStaff: UIView!
    @IBOutlet weak var img_SecondStaff: UIImageView!
    //MARK: - Global Variable
    var booking_Flow = -1
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let title = NSLocalizedString("Save", comment: "")
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 18.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        btn_Save.setAttributedTitle(attributedTitle, for: .normal)
        get_BookingFlow()
    }
    
    //MARK: -  Button Action
    @IBAction func btn_Save(_ sender: Any) {
        call_BookingFlow()
        
    }
    
    
    @IBAction func btn_Staff(_ sender: Any) {
        booking_Flow = 0
        vw_Staff.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 0.3000000119)
        vw_Guest.backgroundColor = .white
        img_Staff.image = UIImage(named: "ic_Check")
        img_Guest.image = UIImage(named: "ic_Uncheck")
    }
    
    
    @IBAction func btn_Guest(_ sender: Any) {
        booking_Flow = 1
        vw_Staff.backgroundColor = .white
        vw_Guest.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 0.3000000119)
        img_Staff.image = UIImage(named: "ic_Uncheck")
        img_Guest.image = UIImage(named: "ic_Check")
    }
    
    @IBAction func btn_Service(_ sender: Any) {
        if img_Service.image == UIImage(named: "ic_check_White"){
            
            vw_Service.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 0.3000000119)
            img_Service.image = UIImage(named: "check")
        }else{

            vw_Service.backgroundColor = .white
            img_Service.image = UIImage(named: "ic_check_White")
        }
    }
    
    
    @IBAction func btn_SecondStaff(_ sender: Any) {
        if img_SecondStaff.image == UIImage(named: "ic_check_White"){
            vw_SecondStaff.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 0.3000000119)
            img_SecondStaff.image = UIImage(named: "check")
        }else{
            vw_SecondStaff.backgroundColor = .white
            img_SecondStaff.image = UIImage(named: "ic_check_White")
        }
    }
    
    //MARK: - Function
    //MARK: - Web Api Calling
    func call_BookingFlow(){
        
        var staff_service_view = -1
        if img_Service.image == UIImage(named: "check") && img_SecondStaff.image == UIImage(named: "check") {
            staff_service_view = 2
        }
        else if img_Service.image == UIImage(named: "check"){
            staff_service_view = 0
        }
        else if img_SecondStaff.image == UIImage(named: "check"){
            staff_service_view = 1
        }
        else {
            staff_service_view = -1
        }
        
        if (staff_service_view == -1) {
            self.alertWithMessageOnly(NSLocalizedString("Select at least one service preference",comment: ""))
            return;
        }
        
        showLoader()
        APIService.shared.UpdateBookingFlow(booking_flow: booking_Flow, vendorId: LocalData.userId, staff_service_view: staff_service_view, completion: { result in
            self.hideLoader()
            if let message = result?.data{
                self.alertWithMessageOnly(NSLocalizedString("Booking flow updated successfully",comment: ""))
            }else{
                self.alertWithMessageOnly(NSLocalizedString("Failed to update booking flow",comment: ""))
            }
        })
    }
    
    
    func get_BookingFlow(){
        self.showLoader()
        APIService.shared.fetchBookingFlow { result in
            self.hideLoader()
            if result?.data?.booking_flow == 1{
                self.booking_Flow = 1
                self.vw_Staff.backgroundColor = .white
                self.vw_Guest.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 0.3000000119)
                self.img_Staff.image = UIImage(named: "ic_Uncheck")
                self.img_Guest.image = UIImage(named: "ic_Check")
            }
            if result?.data?.booking_flow == 0{
                self.booking_Flow = 0
                self.vw_Staff.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 0.3000000119)
                self.vw_Guest.backgroundColor = .white
                self.img_Staff.image = UIImage(named: "ic_Check")
                self.img_Guest.image = UIImage(named: "ic_Uncheck")
            }
            
            if result?.data?.staff_service_view == 0{
                self.vw_Service.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 0.3000000119)
                self.img_Service.image = UIImage(named: "check")
                
                self.vw_SecondStaff.backgroundColor = .white
                self.img_SecondStaff.image = UIImage(named: "ic_check_White")
            }
            
            if result?.data?.staff_service_view == 1 {
               
                
                self.vw_Service.backgroundColor = .white
                self.img_Service.image = UIImage(named: "ic_check_White")
                
                self.vw_SecondStaff.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 0.3000000119)
                self.img_SecondStaff.image = UIImage(named: "check")
            }
            
            if result?.data?.staff_service_view == 2 {
                
                self.vw_Service.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 0.3000000119)
                self.img_Service.image = UIImage(named: "check")
                
                self.vw_SecondStaff.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 0.3000000119)
                self.img_SecondStaff.image = UIImage(named: "check")
            }
        }
    }
}
