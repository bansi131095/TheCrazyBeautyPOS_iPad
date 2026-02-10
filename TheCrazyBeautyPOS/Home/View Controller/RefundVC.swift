//
//  RefundVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 09/02/26.
//

import UIKit

class RefundVC: UIViewController {

    @IBOutlet weak var btn_Cancel: UIButton!
    @IBOutlet weak var btn_Confirm: GradientButton!
    @IBOutlet weak var btn_ComfirmStatus: GradientButton!
    
    @IBOutlet weak var lbl_Descritption: UILabel!
    
    var bookingID = String()
    var refund_id = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let Cancel = NSAttributedString(
            string: NSLocalizedString("Cancel",comment: ""),
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 20.0)!,
                .foregroundColor: UIColor.black
            ]
        )
        btn_Cancel.setAttributedTitle(Cancel, for: .normal)
        
        let Confirm = NSAttributedString(
            string: NSLocalizedString("Confirm",comment: ""),
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 20.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        btn_Confirm.setAttributedTitle(Confirm, for: .normal)
        
        let ComfirmStatus = NSAttributedString(
            string: NSLocalizedString("Confirm Status",comment: ""),
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 20.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        btn_ComfirmStatus.setAttributedTitle(ComfirmStatus, for: .normal)
    }
    
    @IBAction func btn_Close(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func btn_Cancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func btn_Confirm(_ sender: Any) {
        returnApicall(booking_id: bookingID)
    }
    
    
    @IBAction func btn_ConfirmStatus(_ sender: Any) {
        refundApiCall(booking_id: bookingID, transaction_id: refund_id)
    }
 
    
    func returnApicall(booking_id:String){
        APIService.shared.posReturn(booking_id: booking_id) { result in
            if result != nil {
                self.alertWithMessageOnly(NSLocalizedString("Refund request sent successfully",comment: ""))
                self.btn_Cancel.isHidden = true
                self.btn_Confirm.isHidden = true
                self.lbl_Descritption.isHidden = true
                self.btn_ComfirmStatus.isHidden = false
                self.refund_id = result?.data?.refund_id ?? ""
            }else{
                if result?.error == "Booking id is required"{
                    self.alertWithMessageOnly(NSLocalizedString("Booking id is required",comment: ""))
                }else if result?.error == "Please add your posid first"{
                    self.alertWithMessageOnly(NSLocalizedString("Please add your posid first",comment: ""))
                }else if result?.error == "Please turn on your machine first"{
                    self.alertWithMessageOnly(NSLocalizedString("Please turn on your machine first",comment: ""))
                }else if result?.error == "Transaction failed"{
                    self.alertWithMessageOnly(NSLocalizedString("Transaction failed",comment: ""))
                }
                self.btn_Cancel.isHidden = false
                self.btn_Confirm.isHidden = false
                self.lbl_Descritption.isHidden = false
                self.btn_ComfirmStatus.isHidden = true
            }
        }
    }
    
    func refundApiCall(booking_id:String,transaction_id:String){
        APIService.shared.posRefund(booking_id: booking_id, transaction_id: transaction_id) { result in
            if result?.dataObject?.transaction_status == "ACCEPTED" {
                self.dismiss(animated: true)
            }else if result?.dataObject?.transaction_status == "NOSTATUS"{
                self.alertWithMessageOnly(NSLocalizedString("Unable to Get Refund Status",comment: ""))
            }else if result?.dataObject?.transaction_status == "CANCELED"{
                self.alertWithMessageOnly(NSLocalizedString("Payment cancelled.",comment: ""))
            }else{
                self.alertWithMessageOnly(NSLocalizedString("Transaction id required",comment: ""))
            }
//            self.alertWithMessageOnly(NSLocalizedString("Refund request sent successfully",comment: ""))
        }
    }
}
