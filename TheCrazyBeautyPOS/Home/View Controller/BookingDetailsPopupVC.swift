//
//  BookingDetailsPopupVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 15/07/25.
//

import UIKit

class BookingDetailsPopupVC: UIViewController {

    
    @IBOutlet weak var vw_status: UIView!
    @IBOutlet weak var lbl_status: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_phone: UILabel!
    @IBOutlet weak var vw_type: UIView!
    @IBOutlet weak var lbl_type: UILabel!
    @IBOutlet weak var vw_bookingId: UIView!
    @IBOutlet weak var lbl_bookingId: UILabel!
    @IBOutlet weak var vw_bookedBy: UIView!
    @IBOutlet weak var lbl_bookedBy: UILabel!
    @IBOutlet weak var vw_bookedOn: UIView!
    @IBOutlet weak var lbl_bookedOn: UILabel!
    @IBOutlet weak var vw_duration: UIView!
    @IBOutlet weak var lbl_duration: UILabel!
    @IBOutlet weak var vw_service: UIView!
    @IBOutlet weak var lbl_service: UILabel!
    @IBOutlet weak var vw_firstTime: UIView!
    @IBOutlet weak var lbl_firstVisit: UILabel!
    @IBOutlet weak var vw_MiscNotes: UIView!
    @IBOutlet weak var lbl_MiscNotes: UILabel!
    @IBOutlet weak var vw_MiscPrice: UIView!
    @IBOutlet weak var lbl_MiscPrice: UILabel!
    @IBOutlet weak var vw_originalAmount: UIView!
    @IBOutlet weak var lbl_originalAmount: UILabel!
    @IBOutlet weak var vw_discount: UIView!
    @IBOutlet weak var lbl_discount: UILabel!
    @IBOutlet weak var vw_paidAmount: UIView!
    @IBOutlet weak var lbl_paidAmount: UILabel!
    @IBOutlet weak var vw_total: UIView!
    @IBOutlet weak var lbl_total: UILabel!
    @IBOutlet weak var vw_remaining: UIView!
    @IBOutlet weak var lbl_remaining: UILabel!
    @IBOutlet weak var popupView: UIView!
    
    
    var dictBookingDetails: BookingData?
    
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setData()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap(_:)))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: Set Data
    func setData() {
        if let dict = self.dictBookingDetails {
            let bookedBy = dict.bookedBy
            var BookedBy = ""
            if bookedBy == "vendor" {
                BookedBy = "Salon"
            }else{
                BookedBy = "Customer"
            }
            
            var amountPayable: Double = 0.0
            let grandTotal = Double(dict.grandTotal ?? "0.0") ?? 0.0
            let paidAmount = Double(dict.paidAmount ?? "0.0") ?? 0.0
            amountPayable = grandTotal - paidAmount
            self.vw_status.backgroundColor = getStatusColor(status: dict.bookingStatus?.lowercased() ?? "")
            self.lbl_status.text = dict.bookingStatus?.capitalized
            self.lbl_name.text = dict.name
            self.lbl_phone.text = dict.phone
            self.lbl_type.text = dict.customerType?.capitalized
            self.lbl_bookingId.text = dict.bookingNumber
            self.lbl_bookedBy.text = BookedBy
            self.lbl_bookedOn.text = dict.bookingDate
            self.lbl_duration.text = "\(dict.duration ?? "") min"
            self.lbl_service.text = dict.services
            self.lbl_firstVisit.text = dict.isVisit == "true" ? "Yes" : "No"
            
            if dict.subTotal != "0.00", dict.subTotal != "0"  {
                self.vw_originalAmount.isHidden = false
                if let value = Double(dict.subTotal ?? "") {
                    let formattedString = String(format: "%.2f", value)
                    self.lbl_originalAmount.text = "\(LocalData.symbol) \(formattedString)"
                }
            } else {
                self.vw_originalAmount.isHidden = true
            }
            if dict.discountAmount != "0.00", dict.discountAmount != "0" {
                self.vw_discount.isHidden = false
                self.lbl_discount.text = "\(LocalData.symbol) \(dict.discountAmount ?? "").00"
            } else {
                self.vw_discount.isHidden = true
            }
            if dict.miscellaneousNotes != "" {
                self.vw_MiscNotes.isHidden = false
                self.lbl_MiscNotes.text = dict.miscellaneousNotes
            } else {
                self.vw_MiscNotes.isHidden = true
            }
            if dict.miscellaneousPrice != "" {
                if dict.miscellaneousPrice != "0.00", dict.miscellaneousPrice != "0" {
                    self.vw_MiscPrice.isHidden = false
                    self.lbl_MiscPrice.text = "\(LocalData.symbol) \(dict.miscellaneousPrice ?? "")"
                } else {
                    self.vw_MiscPrice.isHidden = true
                }
            } else {
                self.vw_MiscPrice.isHidden = true
            }
            if dict.bookingStatus == "booked" {
                if dict.paidAmount != "0.00", dict.paidAmount != "0" {
                    self.vw_paidAmount.isHidden = false
                    self.lbl_paidAmount.text = "\(LocalData.symbol) \((dict.paidAmount ?? "")).00"
                } else {
                    self.vw_paidAmount.isHidden = true
                }
                if dict.grandTotal != "0.00", dict.grandTotal != "0" {
                    self.lbl_total.text = "\(LocalData.symbol) \(dict.grandTotal ?? "")"
                }
                if (dict.paidAmount != "0.00" && dict.paidAmount != "0") || amountPayable > 0 {
                    self.vw_remaining.isHidden = false
                    self.lbl_remaining.text = "\(LocalData.symbol) \(String(format: "%.2f", amountPayable))"
                } else {
                    self.vw_remaining.isHidden = true
                }
                if BookedBy == "Salon" {
                    if (dict.paidAmount != "0.00" && dict.paidAmount != "0") || amountPayable > 0 {
                        self.vw_remaining.isHidden = false
                        self.lbl_remaining.text = "\(LocalData.symbol) \(String(format: "%.2f", amountPayable))"
                    } else {
                        self.vw_remaining.isHidden = true
                    }
                }
            }
            
        }
    }
    
    
    @objc private func handleOutsideTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        if !popupView.frame.contains(location) {
            self.dismiss(animated: true, completion: nil)
        }
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
