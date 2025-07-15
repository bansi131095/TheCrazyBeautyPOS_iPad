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
    @IBOutlet weak var lbl_type: UILabel!
    @IBOutlet weak var lbl_bookingId: UILabel!
    @IBOutlet weak var lbl_bookedBy: UILabel!
    @IBOutlet weak var lbl_bookedOn: UILabel!
    @IBOutlet weak var lbl_duration: UILabel!
    @IBOutlet weak var lbl_service: UILabel!
    @IBOutlet weak var lbl_firstVisit: UILabel!
    @IBOutlet weak var lbl_originalAmount: UILabel!
    @IBOutlet weak var lbl_total: UILabel!
    @IBOutlet weak var lbl_remaining: UILabel!
    
    var dictBookingDetails: BookingData?
    
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setData()
        // Do any additional setup after loading the view.
    }
    
    
    func setData() {
        if let dict = self.dictBookingDetails {
            self.vw_status.backgroundColor = getStatusColor(status: dict.bookingStatus?.lowercased() ?? "")
            self.lbl_status.text = dict.bookingStatus?.capitalized
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
