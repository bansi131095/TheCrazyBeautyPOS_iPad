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
    
    @IBOutlet weak var vw_NoShowFee: UIView!
    @IBOutlet weak var lbl_NoShowFee: UILabel!
    
    
    @IBOutlet weak var vw_PaidByCard: UIView!
    @IBOutlet weak var lbl_PaidByCard: UILabel!
    
    @IBOutlet weak var vw_PaidByCash: UIView!
    @IBOutlet weak var lbl_PaidByCash: UILabel!
    
    @IBOutlet weak var vw_PaidAmount: UIView!
    @IBOutlet weak var lbl_PaidAmount: UILabel!
    
    @IBOutlet weak var vw_CancellationFee: UIView!
    @IBOutlet weak var lbl_CancellationFee: UILabel!
    
    @IBOutlet weak var vw_RefundAmount: UIView!
    @IBOutlet weak var lbl_RefundAmount: UILabel!
    
    var model : SalesHistoryDateModel?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5) // or UIColor.clear
        self.modalPresentationStyle = .overCurrentContext
        self.lbl_Name.text = model?.name.capitalized
        self.lbl_Date.text = model?.booking_date
        self.lbl_Time.text = model?.booking_time
        self.lbl_ServiceName.text = model?.services.capitalized
        self.lbl_Type.text = model?.customer_type.capitalized
        self.lbl_Staff.text = model?.staff_names.capitalized
        
        if model?.booking_status.capitalized == "Completed"{
            self.lbl_Status.textColor = UIColor.green
        }else{
            self.lbl_Status.textColor = #colorLiteral(red: 1, green: 0.2941176471, blue: 0.3333333333, alpha: 1)
        }
        
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
        
        self.lbl_MiscellaneousPrice.text = "\(SharedPrefs.getSymbol())" + String(format: "%.2f", Double(model?.miscellaneous_price ?? "") ?? 0.0)
        self.lbl_Tip.text = "\(SharedPrefs.getSymbol())" + String(format: "%.2f", Double(model?.tip ?? 0))
        self.lbl_OriginalAmount.text = "\(SharedPrefs.getSymbol())" + String(format: "%.2f", Double(model?.sub_total ?? 0))
        self.lbl_Discount.text = "\(SharedPrefs.getSymbol())" + String(format: "%.2f", Double(model?.discount_amount ?? "") ?? 0.0)
        self.lbl_Total.text = "\(SharedPrefs.getSymbol())" + String(format: "%.2f", Double(model?.grand_total ?? "") ?? 0.0)
        
        if self.model?.penalty_amount ?? 0 > 0 && self.model?.booking_status == "no show"{
            self.vw_NoShowFee.isHidden = false
            self.lbl_NoShowFee.text = "\(SharedPrefs.getSymbol())" + String(format: "%.2f", Double(model?.penalty_amount ?? 0))
            self.lbl_NoShowFee.textColor = #colorLiteral(red: 1, green: 0.2941176471, blue: 0.3333333333, alpha: 1)
        }else{
            self.vw_NoShowFee.isHidden = true
        }
        
        if model?.booking_status.capitalized == "Completed" && self.model?.card_amount ?? 0 > 0 {
            self.vw_PaidByCard.isHidden = false
            self.lbl_PaidByCard.text = "\(SharedPrefs.getSymbol())" + String(format: "%.2f",Double(model?.card_amount ?? 0))
        }else{
            self.vw_PaidByCard.isHidden = true
        }
        
        if model?.booking_status.capitalized == "Completed" && self.model?.cash_amount ?? 0 > 0 {
            self.vw_PaidByCash.isHidden = false
            self.lbl_PaidByCash.text = "\(SharedPrefs.getSymbol())" + String(format: "%.2f",Double(model?.cash_amount ?? 0))
        }else{
            self.vw_PaidByCash.isHidden = true
        }
        
        if model?.booking_status.capitalized != "Completed" && self.model?.paid_amount ?? 0 > 0 {
            self.vw_PaidAmount.isHidden = false
            self.lbl_PaidAmount.text = "\(SharedPrefs.getSymbol())" + String(format: "%.2f",Double(model?.paid_amount ?? 0))
        }else{
            self.vw_PaidAmount.isHidden = true
        }
        
        if model?.booking_status.capitalized == "Cancelled" && self.model?.penalty_amount ?? 0 > 0 {
            self.vw_CancellationFee.isHidden = false
            self.lbl_CancellationFee.text = "\(SharedPrefs.getSymbol())" + String(format:
                "%.2f",Double(model?.penalty_amount ?? 0))
            self.lbl_CancellationFee.textColor = #colorLiteral(red: 1, green: 0.2941176471, blue: 0.3333333333, alpha: 1)
        }else{
            self.vw_CancellationFee.isHidden = true
        }
        
        let refund = Int(self.model?.paid_amount ?? 0) - Int(self.model?.penalty_amount ?? 0)
        
        if model?.booking_status.capitalized != "Completed" && refund > 0 {
            self.vw_RefundAmount.isHidden = false
            self.lbl_RefundAmount.text = "\(SharedPrefs.getSymbol())" + String(format:
                "%.2f",Double(refund))
        }else{
            self.vw_RefundAmount.isHidden = true
        }
    }
    
    @IBAction func btn_Close(_ sender: Any) {
        dismiss(animated: true)
    }
    
    

}
