//
//  Payment&CancellationVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 24/06/25.
//

import UIKit
import DropDown

class Payment_CancellationVC: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var txt_PaymentPercent: TextInputLayout!
    @IBOutlet weak var txt_CancellationDuration: TextInputLayout!
    @IBOutlet weak var txt_CancellationAmount: TextInputLayout!
    @IBOutlet weak var txt_CancellationPolicy: UITextView!
    
    
    @IBOutlet weak var vw_CancellationDuration: UIView!
    @IBOutlet weak var vw_Specify: UIView!
    @IBOutlet weak var vw_TextView: UIView!
    
    
    //MARK: - Global Variable
    var arr_CancellationDuration: [String] = ["No notice required","6 Hours Notice required","12 Hours Notice required","24 Hours Notice required","48 Hours Notice required"]
    var select_CancellationDuration: String = ""
    
    var GetAmountModel: [GetAmountModel] = []
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        get_Amount()
    }
    

    //MARK: -  Button Action
    @IBAction func btn_Save(_ sender: Any) {
        if select_CancellationDuration != "No notice required"{
            let penaltyAmount = txt_CancellationAmount.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "0"
            if penaltyAmount.isEmpty || penaltyAmount == "0" {
                alertWithImage(title: "Cancellation", Msg: "Please enter Cancellation amount percent.")
                return
            }
        }
        update_Amount()
    }
    
    @IBAction func btn_Cancellation(_ sender: Any) {
        openCancellationDuration()
    }
    
    //MARK: - Function
    func openCancellationDuration() {
        let slotDuration = DropDown()
        slotDuration.anchorView = txt_CancellationDuration
        slotDuration.bottomOffset = CGPoint(x: 0, y:(slotDuration.anchorView?.plainView.bounds.height)!)
        slotDuration.direction = .bottom
        slotDuration.dataSource = arr_CancellationDuration
        slotDuration.cellHeight = 35
        slotDuration.show()
        
        slotDuration.selectionAction = {  [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.txt_CancellationDuration.text = item
            if index == 0{
                select_CancellationDuration = "No notice required"
                vw_CancellationDuration.isHidden = true
                vw_Specify.isHidden = true
                vw_TextView.isHidden = false
            }else{
                hideShow()
            }
        }
    }
    
    func hideShow(){
        vw_CancellationDuration.isHidden = false
        vw_Specify.isHidden = false
        vw_TextView.isHidden = true
    }
    
    func getPenaltyDurationValue() -> String {
        switch select_CancellationDuration {
        case "6 Hours Notice required":
            return "6"
        case "12 Hours Notice required":
            return "12"
        case "24 Hours Notice required":
            return "24"
        case "48 Hours Notice required":
            return "48"
        default:
            return "0"
        }
    }
    
    //MARK: - Web Api Calling
    func get_Amount() {
        APIService.shared.fetchAmount { response in
            guard let model = response?.data?.first else { return }

            self.txt_PaymentPercent.text = "\(model.advance_pay)"
            self.txt_CancellationAmount.text = "\(model.penalty_fees)"
            self.txt_CancellationPolicy.text = model.cancellation_policy ?? ""

            // Use penalty_duration directly
            switch model.penalty_duration {
            case 6:
                self.txt_CancellationDuration.text = self.arr_CancellationDuration[1]
                self.select_CancellationDuration = self.arr_CancellationDuration[1]
                self.hideShow()
            case 12:
                self.txt_CancellationDuration.text = self.arr_CancellationDuration[2]
                self.select_CancellationDuration = self.arr_CancellationDuration[2]
                self.hideShow()
            case 24:
                self.txt_CancellationDuration.text = self.arr_CancellationDuration[3]
                self.select_CancellationDuration = self.arr_CancellationDuration[3]
                self.hideShow()
            case 48:
                self.txt_CancellationDuration.text = self.arr_CancellationDuration[4]
                self.select_CancellationDuration = self.arr_CancellationDuration[4]
                self.hideShow()
            default:
                self.txt_CancellationDuration.text = self.arr_CancellationDuration[0]
                self.select_CancellationDuration = self.arr_CancellationDuration[0]
                self.vw_CancellationDuration.isHidden = true
                self.vw_Specify.isHidden = true
                self.vw_TextView.isHidden = false
            }
        }
    }
    
    
    
    func update_Amount() {
        APIService.shared.UpdateAmount(vendorId: LocalData.userId, amount: txt_PaymentPercent.text ?? "0", penaltyFees: txt_CancellationAmount.text ?? "0", penaltyDuration: getPenaltyDurationValue(), cancellationPolicy: txt_CancellationPolicy.text ?? "") { result in
            if let message = result?.data{
                self.alertWithMessageOnly(message)
            }else{
                self.alertWithMessageOnly("Something went wrong.")
            }
        }
    }
}
