//
//  Appointment_DetailsVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 18/07/25.
//

import UIKit

class Appointment_DetailsVC: UIViewController {

    
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var lbl_ServiceName: UILabel!
    @IBOutlet weak var lbl_Type: UILabel!
    @IBOutlet weak var lbl_Staff: UILabel!
    @IBOutlet weak var lbl_Status: UILabel!
    @IBOutlet weak var lbl_CouponCode: UILabel!
    @IBOutlet weak var lbl_MiscellaneousNote: UILabel!
    @IBOutlet weak var lbl_Payment: UILabel!
    @IBOutlet weak var lbl_MiscellaneousPrice: UILabel!
    @IBOutlet weak var lbl_Tip: UILabel!
    @IBOutlet weak var lbl_OriginalAmount: UILabel!
    @IBOutlet weak var lbl_Discount: UILabel!
    @IBOutlet weak var lbl_Total: UILabel!
    
    var model : SalesHistoryDateModel?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5) // or UIColor.clear
        self.modalPresentationStyle = .overCurrentContext
        self.lbl_Name.text = model?.name.capitalized
        self.lbl_Date.text = model?.booking_date
        self.lbl_Time.text = model?.booking_time
        self.lbl_ServiceName.text = model?.services.capitalized
        self.lbl_Type.text = model?.customer_type.capitalized
        self.lbl_Staff.text = model?.staff_names.capitalized
        self.lbl_Status.text = model?.booking_status.capitalized
        if model?.coupon_code == ""{
            self.lbl_CouponCode.text = "N/A"
        }else{
            self.lbl_CouponCode.text = model?.coupon_code
        }
        
        if model?.miscellaneous_notes == ""{
            self.lbl_MiscellaneousNote.text = "N/A"
        }else{
            self.lbl_MiscellaneousNote.text = model?.miscellaneous_notes
        }
        
        if model?.payment_type == ""{
            self.lbl_Payment.text = "N/A"
        }else{
            self.lbl_Payment.text = model?.payment_type.capitalized
        }
        
        /*self.lbl_MiscellaneousPrice.text = "\(SharedPrefs.getSymbol())" + "\(model?.miscellaneous_price ?? "")"
        self.lbl_Tip.text = "\(SharedPrefs.getSymbol())" + "\(Double(model?.tip ?? 0))"
        self.lbl_OriginalAmount.text = "\(SharedPrefs.getSymbol())" + "\(model?.sub_total ?? 0)"
        self.lbl_Discount.text = "\(SharedPrefs.getSymbol())" + "\(model?.discount_amount ?? "")"
        self.lbl_Total.text = "\(SharedPrefs.getSymbol())" + "\(model?.grand_total ?? "")"*/
        
        self.lbl_MiscellaneousPrice.text = "\(SharedPrefs.getSymbol())" + String(format: "%.2f", Double(model?.miscellaneous_price ?? "") ?? 0.0)
        self.lbl_Tip.text = "\(SharedPrefs.getSymbol())" + String(format: "%.2f", Double(model?.tip ?? 0))
        self.lbl_OriginalAmount.text = "\(SharedPrefs.getSymbol())" + String(format: "%.2f", Double(model?.sub_total ?? 0))
        self.lbl_Discount.text = "\(SharedPrefs.getSymbol())" + String(format: "%.2f", Double(model?.discount_amount ?? "") ?? 0.0)
        self.lbl_Total.text = "\(SharedPrefs.getSymbol())" + String(format: "%.2f", Double(model?.grand_total ?? "") ?? 0.0)
    }
    
    @IBAction func btn_Close(_ sender: Any) {
        dismiss(animated: true)
    }
    
    

}
