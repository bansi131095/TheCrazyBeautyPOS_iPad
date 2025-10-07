//
//  BookingList_VC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 08/08/25.
//

import UIKit
import DropDown
import FSCalendar
import Alamofire

class BookingList_VC: UIViewController, UIPopoverPresentationControllerDelegate {

    //MARK: - Outlet
    
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_PastBooking: UILabel!
    @IBOutlet weak var lbl_FutureBooking: UILabel!
    
    @IBOutlet weak var vw_PastBooking: UIView!
    @IBOutlet weak var vw_FutureBooking: UIView!
    
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var vw_Client: NSLayoutConstraint!
    
    @IBOutlet weak var tbl_vw2: UITableView!
    
    
    @IBOutlet weak var vw_TitleRebook: UIView!
    @IBOutlet weak var vw_MainPopup: UIView!
    @IBOutlet weak var vw_Rebook: UIView!
    
    @IBOutlet weak var vw_Staff: UIView!
    @IBOutlet weak var txt_Staff: TextInputLayout!
    @IBOutlet weak var vw_Date: UIView!
    @IBOutlet weak var txt_DateOfBirth: TextInputLayout!
    
    @IBOutlet weak var vw_AvailableTime: UIView!
    @IBOutlet weak var cv_AvailableTime: UICollectionView!
    
    @IBOutlet weak var vw_Save: UIView!
    
    @IBOutlet weak var vw_HeightRebook: NSLayoutConstraint!
    
    @IBOutlet weak var cv_Height: NSLayoutConstraint!
    
    @IBOutlet weak var vw_NoDate: UIView!
    @IBOutlet weak var lbl_AvailableTime: UILabel!
    
    @IBOutlet weak var btn_Booking: GradientButton!
    
    @IBOutlet weak var tbl_Rebook: UITableView!
    @IBOutlet weak var tbl_RebookHeight: NSLayoutConstraint!
    @IBOutlet weak var txt_Search: UITextField!
    //MARK: - Global Variable
    
    var bookingId = String()
    var pastBookingsArray: [ClientBookingModelData] = []
    var futureBookingsArray: [ClientBookingModelData] = []
    
    var calendar: FSCalendar!
    var calendarVC: UIViewController?
    var selectedDate: Date = Date.now
    
//    var staffList: [StaffListResponseModel] = []
    var staffList: [SpinnerStaffModel] = []
    var timeSlotList: [TimeSlotModel] = []
    let dropDown = DropDown()
    
    var duration = String()
    var staff_id = String()
    var booking_id = Int()
    var staffBookingArray = String()
    var selectedTimeIndex: IndexPath?
    var startTime = String()
    var endTime = String()
    var searchWorkItem: DispatchWorkItem?
    var service_id = String()
    var price = String()
    
    var headers: [String: String] {
        var baseHeaders = [
            "Accept": "application/json",
            "apikey": global.apikey,
            "Content-Type": "application/json",
        ]
        
        if !LocalData.loginToken.isEmpty {
            baseHeaders["Authorization"] = "Bearer \(LocalData.loginToken)"
        }
        
        return baseHeaders
    }
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setRegularFont()
        vw_TitleRebook.isHidden = true
        vw_MainPopup.isHidden = true
        vw_Rebook.isHidden = true
        vw_NoDate.isHidden = true
        self.tbl_vw2.isHidden = true
        self.tbl_Rebook.isHidden = true
        vw_Client.constant = 950
        apiPastBookingList(is_past: "1", search: "")
        setTableView()
        setCollectCategory()
        self.txt_DateOfBirth.delegate = self
        self.txt_Search.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    //MARK: -  Button Action
    @IBAction func btn_PastBooking(_ sender: UIButton) {
        vw_Client.constant = 950
        apiPastBookingList(is_past: "1", search: "")
        lbl_Title.text = "Client Past Bookings"
        lbl_PastBooking.textColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
        lbl_FutureBooking.textColor = .black
        
        vw_PastBooking.backgroundColor = .white
        vw_FutureBooking.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 0.3000000119)
        
    }
    
    @IBAction func btn_FutureBooking(_ sender: UIButton) {
        vw_Client.constant = 750
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
    
    
    @IBAction func btn_Close(_ sender: Any) {
        vw_TitleRebook.isHidden = true
        vw_MainPopup.isHidden = true
        self.txt_Staff.text = ""
        self.tbl_Rebook.isHidden = true
        self.vw_HeightRebook.constant = 160
    }
    
    @IBAction func btn_Staff(_ sender: Any) {
        if staffList.count == 0 {
            self.showToast(message: "No Staff List")
        }else{
            self.tbl_Rebook.isHidden = false
            self.tbl_Rebook.reloadData()
        }
//        openStaff()
    }
    
    @IBAction func btn_BookingAppointment(_ sender: Any) {
        if selectedTimeIndex == nil{
            self.showToast(message: "Please select any Time")
        }else{
            let staffBookingArray: [[String: Any]] = [
                [
                    "staff_id": staff_id,
                    "service_id": service_id,
                    "price": price,
                    "duration": duration,
                    "is_fav": 0
                ]
            ]

            // MARK: - Convert to JSON String
            var staffBookingJSONString = ""
            if let jsonData = try? JSONSerialization.data(withJSONObject: staffBookingArray, options: []),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                staffBookingJSONString = jsonString
            }
            
            let timeDict: [String: String] = [
                "startTime": startTime,
                "endTime": endTime
            ]

            var timeJSONString = ""
            if let jsonData = try? JSONSerialization.data(withJSONObject: timeDict, options: []),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                timeJSONString = jsonString
            }

            // MARK: - Prepare API Parameters
            let params: [String: Any] = [
                "booking_date": self.txt_DateOfBirth.text ?? "",
                "booking_id": booking_id,
                "staff_id": staff_id,
                "is_fav": "0",
                "booking_time": timeJSONString,
                "staff_booking": staffBookingJSONString
            ]

           // MARK: - Print for Verification
           print("params => \(params)")
            let url = global.shared.URL_PAST_REBOOKING
            AF.request(url,method: .post,parameters: params,encoding: JSONEncoding.default,headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    self.alertWithMessageOnly("Appointment rebooked successfully")
                    self.vw_TitleRebook.isHidden = true
                    self.vw_MainPopup.isHidden = true
                    self.txt_Staff.text = ""
                    self.selectedTimeIndex = nil
                    self.vw_HeightRebook.constant = 160
                case .failure(let error):
                    self.alertWithMessageOnly("Something went wrong")
                }
            }
        }
        
    }
    
    @IBAction func btn_Calender(_ sender: Any) {
        showCalendarPopup(sourceView: txt_DateOfBirth)
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
        
        tbl_Rebook.register(UINib(nibName: "RebookListCell", bundle: nil), forCellReuseIdentifier: "RebookListCell")
        tbl_Rebook.register(UINib(nibName: "RebookListHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "RebookListHeaderCell")
        tbl_Rebook.delegate = self
        tbl_Rebook.dataSource = self
        tbl_Rebook.rowHeight = UITableView.automaticDimension
        tbl_Rebook.estimatedRowHeight = 50
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        /*searchWorkItem?.cancel()
        let newWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
        }
        searchWorkItem = newWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: newWorkItem) */
        
        let searchText = textField.text ?? ""
        if self.lbl_Title.text == "Client Past Bookings" {
            self.apiPastBookingList(is_past: "1", search: searchText)
        } else if self.lbl_Title.text == "Client Future Bookings" {
            self.apifutureBookingsList(is_past: "0", search: searchText)
        }
    }

    
    func setCollectCategory() {
        self.cv_AvailableTime.register(UINib(nibName: "TimeListCell", bundle: nil), forCellWithReuseIdentifier: "TimeListCell")
        cv_AvailableTime.dataSource = self
        cv_AvailableTime.delegate = self
    }
    
    
    func setRegularFont(){
        if let customFont = UIFont(name: "Lato-Regular", size: 20.0) {
            txt_DateOfBirth.font = customFont
            txt_Staff.font = customFont
        }
    }
    
    //MARK: - Web Api Calling
    func apiPastBookingList(is_past:String,search:String){
//        showLoader()
        APIService.shared.Past_Client_Booking(customer_id: bookingId, is_past: is_past,search: search) { result in
            self.hideLoader()
            guard let model = result else {
                return
            }
            let newItems = model.data
            if newItems.isEmpty{
                self.tbl_vw.isHidden = true
                self.tbl_vw2.isHidden = true
                self.showNoDataMessage("No Bookings Found!", in: self.view)
            }else{
                self.pastBookingsArray = newItems
                self.tbl_vw.isHidden = false
                self.tbl_vw.reloadData()
                self.tbl_vw2.isHidden = true
                self.hideNoDataMessage()
            }
        }
    }
    
    func apifutureBookingsList(is_past:String,search:String){
//        self.showLoader()
        APIService.shared.Past_Client_Booking(customer_id: bookingId, is_past: is_past,search: search) { result in
            self.hideLoader()
            guard let model = result else {
                return
            }
            let newItems = model.data
            if newItems.isEmpty{
                self.tbl_vw.isHidden = true
                self.tbl_vw2.isHidden = true
                self.showNoDataMessage("No Bookings Found!", in: self.view)
            }else{
                self.futureBookingsArray = newItems
                self.tbl_vw.isHidden = true
                self.tbl_vw2.reloadData()
                self.tbl_vw2.isHidden = false
                self.hideNoDataMessage()
            }
        }
    }
    
    /*func get_Staff(id:String){
        self.showLoader()
        APIService.shared.fetchStaffList(service_id: id) { result in
            self.hideLoader()
            guard let model = result else {
                return
            }
            self.staffList = result?.data ?? []
            
        }
    }*/
    
    func get_Staff(id: String) {
        self.showLoader()
        APIService.shared.fetchStaffList(service_id: id) { result in
            self.hideLoader()
            guard let model = result else {
                return
            }
            
            // Map staff into SpinnerStaffModel list
            let mappedList = model.data.map { staff -> SpinnerStaffModel in
                let isFavorite: Bool = staff.services?
                    .split(separator: ",")
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                    .contains(id) ?? false
                print("isFavorite:-**-**-\(isFavorite)")
                return SpinnerStaffModel(
                    id: staff.id,
                    fullname: staff.fullname ?? "Unknown",
                    isFavorite: isFavorite
                    
                    
                )
            } ?? []
            
            self.staffList = mappedList
            
            // Reload UI if needed
            DispatchQueue.main.async {
                self.tbl_Rebook.reloadData()
                self.tbl_RebookHeight.constant = self.tbl_Rebook.contentSize.height
            }
        }
    }

    
    
    /*func get_Staff(id: String) {
        self.showLoader()
        
        APIService.shared.fetchStaffList(service_id: id) { result in
            self.hideLoader()
            
            guard let model = result else { return }
            
            // Map response into StaffListResponseModel
            let staffListMapped: [StaffListResponseModel] = model.data.map { dataItem in
                // Check if the staff's ID is present in the "services" list
                let isFavorite: Bool
                if let services = dataItem.services {
                    let serviceIds = services.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                    isFavorite = serviceIds.contains(id)   // 👈 compare with requested service_id
                } else {
                    isFavorite = false
                }
                
                // Create and return StaffListResponseModel safely
                return StaffListResponseModel(
                    id: Int(dataItem.id ?? 0),
                    fullname: dataItem.fullname ?? "Unknown",
                    isFavorite: isFavorite,
                )!
            }
            
            self.staffList = staffListMapped
        }
    }*/


    
    /*func getTimeSlots(duration:String,full_date:String,staff_id:String) {
        APIService.shared.TimeSlot(duration: duration, full_date: full_date, staff_id: staff_id) { result in
            guard let model = result else {
                return
            }
            self.timeSlotList = result?.data ?? []
            self.cv_AvailableTime.reloadData()
        }
    }*/
    
    func getTimeSlots(duration: String, full_date: String, staff_id: String) {
        self.showLoader()
        APIService.shared.TimeSlot(duration: duration, full_date: full_date, staff_id: staff_id) { result in
            self.hideLoader()
            guard let model = result else {
                return
            }
            
            self.timeSlotList = model.data
            
            if self.timeSlotList.isEmpty {
                // Hide collection view if no slots
                self.lbl_AvailableTime.isHidden = true
                self.cv_AvailableTime.isHidden = true
                
                // Show "No slots available"
                self.vw_NoDate.isHidden = false
                self.btn_Booking.isUserInteractionEnabled = false
                self.btn_Booking.alpha = 0.5
            } else {
                self.vw_NoDate.isHidden = true
                self.lbl_AvailableTime.isHidden = false
                self.cv_AvailableTime.isHidden = false
                self.btn_Booking.isUserInteractionEnabled = true
                self.btn_Booking.alpha = 1.0
            }
            
            self.cv_AvailableTime.reloadData()
        }
    }
    
    /*func pastBooking(booking_date:String,booking_id:String,startTime:String,endTime:String,) {
        APIService.shared.PastBooking(booking_date: booking_date, booking_id: booking_id, startTime: startTime, endTime: endTime, staffBookingArray: <#T##[[String : Any]]#>, staff_id: staff_id) { result in
            if let res = result {
                self.alertWithMessageOnly(result?.data ?? "")
            } else {
                self.alertWithMessageOnly(result?.error ?? "")
            }
        }
    }*/
    
    func openStaff() {
       var itemArray: [String] = []

       for i in self.staffList {
           itemArray.append(i.fullname)
       }

       let slotDuration = DropDown()
       slotDuration.anchorView = txt_Staff
       slotDuration.bottomOffset = CGPoint(x: 0, y: (slotDuration.anchorView?.plainView.bounds.height) ?? 0)
       slotDuration.direction = .bottom
       slotDuration.dataSource = itemArray
       slotDuration.cellHeight = 35
       slotDuration.textFont = UIFont(name: "Lato-Regular", size: 18.0)!
       slotDuration.backgroundColor = .white
       slotDuration.show()

       slotDuration.selectionAction = { [unowned self] (index: Int, item: String) in
           txt_Staff.text = item
           for i in self.staffList {
               if i.fullname == item {
                   txt_Staff.text = i.fullname
                   self.vw_Date.isHidden = false
                   self.vw_AvailableTime.isHidden = false
                   self.cv_AvailableTime.isHidden = false
                   self.vw_Save.isHidden = false
                   self.selectedTimeIndex = nil
                   self.cv_AvailableTime.reloadData()
                   self.vw_HeightRebook.constant = 560
                   let formatter = DateFormatter()
                       formatter.dateFormat = "dd-MM-yyyy"
                    txt_DateOfBirth.text = formatter.string(from: Date())
                    txt_DateOfBirth.showLabel()
                   getTimeSlots(duration: duration, full_date: self.txt_DateOfBirth.text ?? "", staff_id: staff_id)
                   cv_Height.constant = 180
                   break
               }
           }
       }
    }
    
    
    func showCalendarPopup(sourceView: UIView) {
        calendarVC = UIViewController()
        calendarVC?.modalPresentationStyle = .popover
        calendarVC?.preferredContentSize = CGSize(width: 500, height: 400)

        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 500, height: 400))
        calendar.delegate = self
        calendar.dataSource = self
//        calendar.select(selectedDate)
        let today = Date()
        calendar.select(today)
        selectedDate = today
        
        calendarVC?.view.addSubview(calendar)

        if let popover = calendarVC?.popoverPresentationController {
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
            popover.permittedArrowDirections = .any
        }
        self.present(calendarVC!, animated: true, completion: nil)
    }
    
    func parseStaffBookingArray(from jsonString: String) -> [StaffBooking] {
        let data = Data(jsonString.utf8)
        do {
            return try JSONDecoder().decode([StaffBooking].self, from: data)
        } catch {
            print("❌ Error parsing staff booking array:", error)
            return []
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tbl_Rebook {
            let sectionHeaderHeight: CGFloat = 0 // apne header ki height dalna
            if scrollView.contentOffset.y <= sectionHeaderHeight,
               scrollView.contentOffset.y >= 0 {
                scrollView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
            } else if scrollView.contentOffset.y >= sectionHeaderHeight {
                scrollView.contentInset = UIEdgeInsets(top: -sectionHeaderHeight, left: 0, bottom: 0, right: 0)
            }
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
        }else if tableView == tbl_vw2{
            return self.futureBookingsArray.count
        }else{
            return self.staffList.count
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tbl_Rebook{
            return 0
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tbl_vw{
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ClientPastBookingsHeaderCell") as? ClientPastBookingsHeaderCell else {
                    return nil
                }
                return header
        }else if tableView == tbl_vw2{
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ClientFutureBookingsHeaderCell") as? ClientFutureBookingsHeaderCell else {
                    return nil
                }
                return header
        }else {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "RebookListHeaderCell") as? RebookListHeaderCell else {
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
            cell.Act_Rebook = {
                self.vw_TitleRebook.isHidden = false
                self.vw_MainPopup.isHidden = false
                self.vw_Rebook.isHidden = false
                self.get_Staff(id: data.service_id ?? "")
                print(data.staff_id ?? "")
                print(data.service_id ?? "")
                self.duration = data.duration ?? ""
                self.staff_id = data.staff_id ?? ""
            }
            service_id = data.service_id ?? ""
            price = data.grand_total ?? ""
            booking_id = data.id
            staffBookingArray = data.staff_booking ?? ""
            cell.lbl_GrandTotal.text = "\(LocalData.symbol)\(data.grand_total ?? "")"
            return cell
        }else if tableView == tbl_vw2{
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
        }else {
            guard let cell = tbl_Rebook.dequeueReusableCell(withIdentifier: "RebookListCell", for: indexPath) as? RebookListCell else {
                return UITableViewCell()
            }
            let data = self.staffList[indexPath.row]
            cell.lbl_FullName.text = data.fullname.capitalized
            cell.img_Heart.isHidden = true
            if data.isFavorite == true{
                cell.img_Heart.isHidden = false
            }else{
                cell.img_Heart.isHidden = true
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tbl_Rebook{
            let data = self.staffList[indexPath.row]
            self.txt_Staff.text = data.fullname
            staff_id = "\(data.id ?? 0)"
            self.tbl_Rebook.isHidden = true
            self.vw_Date.isHidden = false
            self.vw_AvailableTime.isHidden = false
            self.cv_AvailableTime.isHidden = false
            self.vw_Save.isHidden = false
            self.selectedTimeIndex = nil
            self.cv_AvailableTime.reloadData()
            self.vw_HeightRebook.constant = 560
            let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
             txt_DateOfBirth.text = formatter.string(from: Date())
             txt_DateOfBirth.showLabel()
            getTimeSlots(duration: duration, full_date: self.txt_DateOfBirth.text ?? "", staff_id: "\(data.id ?? 0)")
            cv_Height.constant = 180
        }
    }
}


extension BookingList_VC: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        self.txt_DateOfBirth.text = formatter.string(from: selectedDate)
        self.txt_DateOfBirth.showLabel()
        getTimeSlots(duration: duration, full_date: self.txt_DateOfBirth.text ?? "", staff_id: staff_id)
        calendarVC?.dismiss(animated: true)
    }
    
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
}

extension BookingList_VC: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == txt_DateOfBirth) {
            showCalendarPopup(sourceView: textField)
            return false // Prevent keyboard
        } else {
            return true
        }
    }
}

extension UIViewController{
    /*func showNoDataMessage(_ message: String) {
        let label = UILabel()
        label.text = message
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont(name: "Lato-Medium", size: 18.0)
        label.frame = self.view.bounds
        self.view.addSubview(label)
        
        // Remove after few seconds if you want
        /*DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            label.removeFromSuperview()
        }*/
    }*/
    
    
    

    func showNoDataMessage(_ message: String, in parentView: UIView) {
        // If already exists, don’t add again
        if global.shared.noDataLabel == nil {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = .gray
            label.font = UIFont(name: "Lato-Medium", size: 18.0)
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            parentView.addSubview(label)
            
            // Center label in parent view
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: parentView.centerYAnchor),
                label.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20),
                label.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20)
            ])
            
            global.shared.noDataLabel = label
        }
        
        global.shared.noDataLabel?.text = message
        global.shared.noDataLabel?.isHidden = false
    }

    func hideNoDataMessage() {
        global.shared.noDataLabel?.isHidden = true
    }

    
}

extension BookingList_VC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeSlotList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv_AvailableTime.dequeueReusableCell(withReuseIdentifier: "TimeListCell", for: indexPath) as! TimeListCell
        let data = timeSlotList[indexPath.row]
        cell.lbl_Time.text = data.startTime
        if indexPath == selectedTimeIndex {
            cell.vwBG.backgroundColor = #colorLiteral(red: 0.8039215686, green: 0.1882352941, blue: 1, alpha: 0.6999999881)
            cell.vwBG.borderColor = .clear
            cell.vwBG.borderWidth = 0
            cell.lbl_Time.textColor = .white
        } else {
            cell.vwBG.backgroundColor = .clear
            cell.vwBG.borderColor = UIColor.gray
            cell.vwBG.borderWidth = 1
            cell.lbl_Time.textColor = .black
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cv_AvailableTime.frame.size.width/3, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTimeIndex = indexPath
        let data = timeSlotList[indexPath.row]
        let startTimeStr = data.startTime ?? ""

        // Date formatter to parse and format times
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        if let startDate = formatter.date(from: startTimeStr) {
            let endDate = Calendar.current.date(byAdding: .minute, value: Int(duration) ?? 0, to: startDate)!
            
            let endTimeStr = formatter.string(from: endDate)
            
            print("Start Time: \(startTimeStr)")
            print("End Time: \(endTimeStr)")
            startTime = startTimeStr
            endTime = endTimeStr
        }
        collectionView.reloadData()
    }
}

struct StaffBooking: Codable {
    let staff_id: Int
    let service_id: String
    let price: String
    let duration: String
    let is_fav: Int
}

