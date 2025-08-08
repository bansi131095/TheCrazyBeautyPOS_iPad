//
//  BookingList_VC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 08/08/25.
//

import UIKit

class BookingList_VC: UIViewController {

    //MARK: - Outlet
    
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_PastBooking: UILabel!
    @IBOutlet weak var lbl_FutureBooking: UILabel!
    
    @IBOutlet weak var vw_PastBooking: UIView!
    @IBOutlet weak var vw_FutureBooking: UIView!
    
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var vw_Client: NSLayoutConstraint!
    
    @IBOutlet weak var tbl_vw2: UITableView!
    //MARK: - Global Variable
    var bookingId = String()
    var pastBookingsArray: [ClientBookingModelData] = []
    var futureBookingsArray: [ClientBookingModelData] = []
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbl_vw2.isHidden = true
        vw_Client.constant = 1200
        apiPastBookingList(is_past: "1", search: "")
        setTableView()
    }
    
    //MARK: -  Button Action
    @IBAction func btn_PastBooking(_ sender: UIButton) {
        vw_Client.constant = 1200
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = self.tbl_vw.cellForRow(at: indexPath) as! ClientPastBookingsCell
        cell.lbl_PaymentType.isHidden = false
        cell.lbl_BookingNo.isHidden = false
        
        
        apiPastBookingList(is_past: "1", search: "")
        lbl_Title.text = "Client Past Bookings"
        lbl_PastBooking.textColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
        lbl_FutureBooking.textColor = .black
        
        vw_PastBooking.backgroundColor = .white
        vw_FutureBooking.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 0.3000000119)
        
    }
    
    @IBAction func btn_FutureBooking(_ sender: UIButton) {
        vw_Client.constant = 1100
        apifutureBookingsList(is_past: "0", search: "")
        lbl_Title.text = "Client Future Bookings"
        lbl_FutureBooking.textColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
        lbl_PastBooking.textColor = .black
        
        vw_FutureBooking.backgroundColor = .white
        vw_PastBooking.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 0.3000000119)
    }
    
    @IBAction func btn_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Function
    func setTableView(){
        tbl_vw.register(UINib(nibName: "ClientPastBookingsCell", bundle: nil), forCellReuseIdentifier: "ClientPastBookingsCell")
        tbl_vw.register(UINib(nibName: "ClientPastBookingsHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "ClientPastBookingsHeaderCell")
        tbl_vw.delegate = self
        tbl_vw.dataSource = self
        tbl_vw.rowHeight = UITableView.automaticDimension
        tbl_vw.estimatedRowHeight = 60
        
        
        tbl_vw2.register(UINib(nibName: "ClientFutureBookingsCell", bundle: nil), forCellReuseIdentifier: "ClientFutureBookingsCell")
        tbl_vw2.register(UINib(nibName: "ClientFutureBookingsHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "ClientFutureBookingsHeaderCell")
        tbl_vw2.delegate = self
        tbl_vw2.dataSource = self
        tbl_vw2.rowHeight = UITableView.automaticDimension
        tbl_vw2.estimatedRowHeight = 60
        
    }
    
    
    
    //MARK: - Web Api Calling
    func apiPastBookingList(is_past:String,search:String){
        APIService.shared.Past_Client_Booking(customer_id: bookingId, is_past: is_past,search: search) { result in
            guard let model = result else {
                return
            }
            let newItems = model.data
            self.pastBookingsArray = newItems
            self.tbl_vw.isHidden = false
            self.tbl_vw.reloadData()
            self.tbl_vw2.isHidden = true
        }
    }
    
    func apifutureBookingsList(is_past:String,search:String){
        APIService.shared.Past_Client_Booking(customer_id: bookingId, is_past: is_past,search: search) { result in
            guard let model = result else {
                return
            }
            let newItems = model.data
            self.futureBookingsArray = newItems
            self.tbl_vw.isHidden = true
            self.tbl_vw2.reloadData()
            self.tbl_vw2.isHidden = false
        }
    }
    
}

extension BookingList_VC : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbl_vw{
            return self.pastBookingsArray.count
        }else{
            return self.futureBookingsArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tbl_vw{
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ClientPastBookingsHeaderCell") as? ClientPastBookingsHeaderCell else {
                    return nil
                }
                return header
        }
        else if tableView == tbl_vw2{
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ClientFutureBookingsHeaderCell") as? ClientFutureBookingsHeaderCell else {
                    return nil
                }
                return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tbl_vw{
            guard let cell = tbl_vw.dequeueReusableCell(withIdentifier: "ClientPastBookingsCell", for: indexPath) as? ClientPastBookingsCell else {
                return UITableViewCell()
            }
            let data = self.pastBookingsArray[indexPath.row]
            cell.lbl_BookingNo.text = data.booking_number ?? ""
            cell.lbl_Date.text = data.booking_date ?? ""
            cell.lbl_Time.text = data.booking_time ?? ""
            cell.lbl_Status.text = data.booking_status?.capitalized ?? ""
            cell.lbl_ServiceName.text = data.service_name?.capitalized ?? ""
            cell.lbl_SubTotal.text = "\(LocalData.symbol)\(Double(data.sub_total))"
            if data.discount_amount == "0.00"{
                cell.lbl_Discount.text = "N/A"
            }else{
                cell.lbl_Discount.text = data.discount_amount ?? ""
            }
            
            if data.miscellaneous_notes == ""{
                cell.lbl_MiscNotes.text = "N/A"
            }else{
                cell.lbl_MiscNotes.text = data.miscellaneous_notes ?? ""
            }
            
            if data.miscellaneous_price == "0.00"{
                cell.lbl_MiscPrice.text = "N/A"
            }else{
                cell.lbl_MiscPrice.text = data.miscellaneous_price ?? ""
            }
            
            if data.tip == "0.00"{
                cell.lbl_Tip.text = "N/A"
            }else{
                cell.lbl_Tip.text = data.tip ?? ""
            }
            if data.payment_type == ""{
                cell.lbl_PaymentType.text = "N/A"
            }else{
                cell.lbl_PaymentType.text = data.payment_type?.capitalized ?? ""
            }
            cell.lbl_GrandTotal.text = "\(LocalData.symbol)\(data.grand_total ?? "")"
            return cell
        }
        else{
            guard let cell = tbl_vw2.dequeueReusableCell(withIdentifier: "ClientFutureBookingsCell", for: indexPath) as? ClientFutureBookingsCell else {
                return UITableViewCell()
            }
            let data = self.futureBookingsArray[indexPath.row]
            cell.lbl_BookingNo.text = data.booking_number ?? ""
            cell.lbl_Date.text = data.booking_date ?? ""
            cell.lbl_Time.text = data.booking_time ?? ""
            cell.lbl_Status.text = data.booking_status?.capitalized ?? ""
            cell.lbl_ServiceName.text = data.service_name?.capitalized ?? ""
            cell.lbl_SubTotal.text = "\(LocalData.symbol)\(Double(data.sub_total))"
            if data.discount_amount == "0.00"{
                cell.lbl_Discount.text = "N/A"
            }else{
                cell.lbl_Discount.text = data.discount_amount ?? ""
            }
            
            if data.miscellaneous_notes == ""{
                cell.lbl_MiscNotes.text = "N/A"
            }else{
                cell.lbl_MiscNotes.text = data.miscellaneous_notes ?? ""
            }
            
            if data.miscellaneous_price == "0.00"{
                cell.lbl_MiscPrice.text = "N/A"
            }else{
                cell.lbl_MiscPrice.text = data.miscellaneous_price ?? ""
            }
            
            if data.tip == "0.00"{
                cell.lbl_Tip.text = "N/A"
            }else{
                cell.lbl_Tip.text = data.tip ?? ""
            }
            if data.payment_type == ""{
                cell.lbl_PaymentType.text = "N/A"
            }else{
                cell.lbl_PaymentType.text = data.payment_type?.capitalized ?? ""
            }
            cell.lbl_GrandTotal.text = "\(LocalData.symbol)\(data.grand_total ?? "")"
            return cell
        }
    }
}

