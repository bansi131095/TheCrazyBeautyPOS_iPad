//
//  PastBookings_VC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 08/08/25.
//

import UIKit

class PastBookings_VC: UIViewController {

    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    
    var customer_id = String()
    var pastBookingsArray: [ClientBookingModelData] = []
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    func setTableView(){
        tbl_vw.register(UINib(nibName: "ClientPastBookingsCell", bundle: nil), forCellReuseIdentifier: "ClientPastBookingsCell")
        tbl_vw.register(UINib(nibName: "ClientPastBookingsHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "ClientPastBookingsHeaderCell")
        tbl_vw.delegate = self
        tbl_vw.dataSource = self
        tbl_vw.rowHeight = UITableView.automaticDimension
        tbl_vw.estimatedRowHeight = 60
    }
    
    
    
}

extension PastBookings_VC : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pastBookingsArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ClientPastBookingsHeaderCell") as? ClientPastBookingsHeaderCell else {
                return nil
            }
            return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbl_vw.dequeueReusableCell(withIdentifier: "ClientPastBookingsCell", for: indexPath) as? ClientPastBookingsCell else {
            return UITableViewCell()
        }
        let data = self.pastBookingsArray[indexPath.row]
        cell.lbl_BookingNo.text = data.booking_number ?? ""
        cell.lbl_Date.text = data.booking_date ?? ""
        cell.lbl_Time.text = data.booking_time ?? ""
        cell.lbl_Status.text = data.booking_status?.capitalized ?? ""
        cell.lbl_ServiceName.text = data.service_name?.capitalized ?? ""
        cell.lbl_SubTotal.text = "\(data.sub_total)"
        cell.lbl_Discount.text = data.discount_amount ?? ""
        cell.lbl_MiscNotes.text = data.miscellaneous_notes ?? ""
        cell.lbl_MiscPrice.text = data.miscellaneous_price ?? ""
        cell.lbl_Tip.text = data.tip ?? ""
        cell.lbl_GrandTotal.text = data.grand_total ?? ""
        cell.lbl_PaymentType.text = data.payment_type ?? ""
        return cell
    }
    
}
