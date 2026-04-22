//
//  UpcomingAppointmentsVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 12/06/25.
//

import UIKit
import FSCalendar

class UpcomingAppointmentsVC: UIViewController {

    
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var txt_days: UITextField!
    @IBOutlet weak var lbl_total: UILabel!
    
    @IBOutlet weak var width_tbl: NSLayoutConstraint!
    @IBOutlet weak var tbl_Height: NSLayoutConstraint!
    
    
    @IBOutlet weak var txt_Date: UITextField!
    @IBOutlet weak var lbl_TotalBookings: UILabel!
    @IBOutlet weak var lbl_CalendarTotal: UILabel!
    @IBOutlet weak var lbl_CalendarTotalAmount: UILabel!
    @IBOutlet weak var lbl_WalkinTotal: UILabel!
    @IBOutlet weak var lbl_WalkinTotalAmount: UILabel!
    @IBOutlet weak var lbl_TotalCard: UILabel!
    @IBOutlet weak var lbl_TotalCash: UILabel!
    
    @IBOutlet weak var txt_TopTeamCount: UILabel!
    @IBOutlet weak var tbl_TopTeam: UITableView!
    
    @IBOutlet weak var txt_TopServicesCount: UILabel!
    @IBOutlet weak var tbl_TopServices: UITableView!
    
    
    
    @IBOutlet weak var tbl_TeamHeight: NSLayoutConstraint!
    @IBOutlet weak var tbl_ServiceHeight: NSLayoutConstraint!
    
    var upcomingList: [BookingData] = []
    var topService: [Service_ModelData] = []
    var teamMember: [Service_ModelData] = []
    var currentPage = 1
    var totalCount = 0
    var isLoadingMore = false
    var hasMoreData = true
    let dropdownView = UITableView()
//    let daysOptions = ["Next 7 Days", "Next 15 Days", "Next 30 Days"]
    var daysOptions: [String] {
        let numbers = [7, 15, 30]
        let format = NSLocalizedString("Next", comment: "")

        return numbers.map { num in
            String(format: format, "\(num)")
        }
    }
    let daysValues = [7, 15, 30] // Corresponding values
    var selectedDays: Int = 7
    var isDropdownVisible = false

    let formatter = DateFormatter()
    var selectedDate = Date()
    
    var calendarView: FSCalendar!
    var isCalendarVisible = false
    var calendarVC: UIViewController?
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTableView()
        self.loadData(Search: "", days: "\(selectedDays)")
        tbl_vw.isScrollEnabled = false
        tbl_vw.estimatedRowHeight = 70
        tbl_vw.estimatedSectionHeaderHeight = 0
        tbl_vw.estimatedSectionFooterHeight = 0
        
        tbl_TopTeam.isScrollEnabled = false
        tbl_TopTeam.estimatedRowHeight = 44
        tbl_TopTeam.estimatedSectionHeaderHeight = 0
        tbl_TopTeam.estimatedSectionFooterHeight = 0
        
        tbl_TopServices.isScrollEnabled = false
        tbl_TopServices.estimatedRowHeight = 44
        tbl_TopServices.estimatedSectionHeaderHeight = 0
        tbl_TopServices.estimatedSectionFooterHeight = 0
        
        setupDaysTextField()
        setupDropdownTable()
        updateDateLabel()
        todayBookings()
        Apicall_TopserviceReport()
        Apicall_TopTeamMember()
    }
    
    
    //MARK: Set Table View
    func setTableView(){
        tbl_vw.register(UINib(nibName: "UpcomingAppointmentCell", bundle: nil), forCellReuseIdentifier: "UpcomingAppointmentCell")
        tbl_vw.delegate = self
        tbl_vw.dataSource = self
        tbl_vw.rowHeight = UITableView.automaticDimension
        tbl_vw.estimatedRowHeight = 60
        tbl_vw.reloadData()
        updateTableHeight()
        
        tbl_TopTeam.register(UINib(nibName: "TeamMemberCell", bundle: nil), forCellReuseIdentifier: "TeamMemberCell")
        tbl_TopTeam.delegate = self
        tbl_TopTeam.dataSource = self
        tbl_TopTeam.rowHeight = UITableView.automaticDimension
        tbl_TopTeam.estimatedRowHeight = 44
        tbl_TopTeam.reloadData()
        updateTopTeamHeight()
        
        tbl_TopServices.register(UINib(nibName: "TopServicesCell", bundle: nil), forCellReuseIdentifier: "TopServicesCell")
        tbl_TopServices.delegate = self
        tbl_TopServices.dataSource = self
        tbl_TopServices.rowHeight = UITableView.automaticDimension
        tbl_TopServices.estimatedRowHeight = 44
        tbl_TopServices.reloadData()
        updateServiceHeight()
    }
    
    //MARK: Setup Views
    func setupDaysTextField() {
    
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleDropdown))
        txt_days.addGestureRecognizer(tapGesture)
        txt_days.isUserInteractionEnabled = true
        txt_days.text = daysOptions[0]   // Next 7 Days
        selectedDays = daysValues[0]
    }
    
    func setupDropdownTable() {
        dropdownView.translatesAutoresizingMaskIntoConstraints = false
        dropdownView.delegate = self
        dropdownView.dataSource = self
        dropdownView.isHidden = true
        dropdownView.layer.borderWidth = 1
        dropdownView.layer.borderColor = UIColor.lightGray.cgColor
        dropdownView.layer.cornerRadius = 10
        dropdownView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(dropdownView)
        
        NSLayoutConstraint.activate([
            dropdownView.topAnchor.constraint(equalTo: txt_days.bottomAnchor, constant: -10),
            dropdownView.centerXAnchor.constraint(equalTo: txt_days.centerXAnchor),
            dropdownView.widthAnchor.constraint(equalTo: txt_days.widthAnchor, constant: 80),
            dropdownView.heightAnchor.constraint(equalToConstant: CGFloat(daysOptions.count * 45))
        ])
    }
    
    @objc func toggleDropdown() {
        
        isDropdownVisible.toggle()
        dropdownView.isHidden = !isDropdownVisible
    }
    
    
    //MARK: Api Call
    func loadData(Search: String, isPagination: Bool = false, days: String) {
        if isPagination {
            self.isLoadingMore = true
        } else {
            self.currentPage = 1
            self.upcomingList.removeAll()
            self.hasMoreData = true
            showLoader()
        }

        APIService.shared.getBookingHistory(page: "\(currentPage)", limit: "10", vendorId: LocalData.userId, search: Search, days: days) { staffResult in
            self.hideLoader()
            guard let model = staffResult else {
                self.isLoadingMore = false
                return
            }

            let newItems = model.data ?? []
            self.totalCount = model.total ?? 0 // Make sure this field exists in your response model
            self.lbl_total.text = "\(self.totalCount)"
            
            if newItems.isEmpty || self.upcomingList.count + newItems.count >= self.totalCount {
                self.hasMoreData = false
            }

            self.upcomingList += newItems
            self.currentPage += 1
            self.isLoadingMore = false
            self.tbl_vw.backgroundView = self.upcomingList.isEmpty ? self.getNoDataLabel() : nil
            self.tbl_vw.reloadData()
            self.updateTableHeight()
        }
    }
    
    func getNoDataLabel() -> UILabel {
        let noDataLabel = UILabel()
        noDataLabel.text = NSLocalizedString("No Data Found", comment: "")
        noDataLabel.textAlignment = .center
        noDataLabel.textColor = .gray
        noDataLabel.font = UIFont(name: "Lato-Bold", size: 20.0)
        return noDataLabel
    }
    
    func formatBookingDate(_ inputDate: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MM-yyyy"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX") // ensures consistent parsing
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "EEEE, MMM dd, yyyy" // "Wednesday, Jul 02, 2025"
        outputFormatter.locale = Locale(identifier: "en_US")
        if let date = inputFormatter.date(from: inputDate) {
            return outputFormatter.string(from: date)
        } else {
            return inputDate // fallback if parsing fails
        }
    }

    func formatBookingTime(_ inputTime: String) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")

        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "h:mm a"
        displayFormatter.locale = Locale(identifier: "en_US")

        let times = inputTime.components(separatedBy: " to ")
        guard times.count == 2,
              let startTime = timeFormatter.date(from: times[0]),
              let endTime = timeFormatter.date(from: times[1]) else {
            return inputTime // fallback if parsing fails
        }

        let formattedStart = displayFormatter.string(from: startTime)
        let formattedEnd = displayFormatter.string(from: endTime)
        return "\(formattedStart) to \(formattedEnd)"
    }
    
    func getdays() {
        
    }
    
    

        @objc func toggleCalendar() {
            isCalendarVisible.toggle()
            calendarView.isHidden = !isCalendarVisible
        }
    
    
    func todayBookings() {
        let dateStr = formattedDateDDMMYYYY(selectedDate) // make sure your date is formatted as dd-MM-yyyy
        APIService.shared.TodayBookings(vendorId: LocalData.userId, date: dateStr) { (result: TodayBookingModel?) in
            
            // Safely unwrap the data
            guard let data = result?.data else {
                print("No data found in TodayBookings API")
                self.alertWithMessageOnly(result?.error ?? "")
                return
            }

            // ✅ Assign values properly (assuming all are strings)
            
            self.lbl_TotalBookings.text = NSLocalizedString("Bookings : ", comment: "") + String(data.total_bookings)
            self.lbl_CalendarTotal.text = NSLocalizedString("Bookings : ", comment: "") + String(data.calendar_total)
//            self.lbl_CalendarTotalAmount.text = "Amount : " + "\(SharedPrefs.getSymbol())" + String(Double(data.calendar_total_amount))
            self.lbl_WalkinTotal.text = NSLocalizedString("Bookings : ", comment: "") + String(data.walkin_total)
//            self.lbl_WalkinTotalAmount.text = "Amount : " + "\(SharedPrefs.getSymbol())" + String(Double(data.walkin_total_amount))
//            self.lbl_TotalCard.text = "Card : " + "\(SharedPrefs.getSymbol())" + String(Double(data.total_card))
//            self.lbl_TotalCash.text = "Cash : " + "\(SharedPrefs.getSymbol())" + String(Double(data.total_cash))
            self.lbl_WalkinTotalAmount.text = NSLocalizedString("Amount", comment: "") + "\(SharedPrefs.getSymbol())" + String(format: "%.2f", data.walkin_total_amount)
            self.lbl_CalendarTotalAmount.text = NSLocalizedString("Amount", comment: "") + "\(SharedPrefs.getSymbol())" + String(format: "%.2f", data.calendar_total_amount)
            self.lbl_TotalCard.text = NSLocalizedString("Card", comment: "") + "\(SharedPrefs.getSymbol())" + String(format: "%.2f", data.total_card)
            self.lbl_TotalCash.text = NSLocalizedString("Cash", comment: "") + "\(SharedPrefs.getSymbol())" + String(format: "%.2f", data.total_cash)
        }
    }


    @IBAction func btn_Date(_ sender: UIButton) {
        showCalendarPopup(sourceView: txt_Date)
    }
    
    @IBAction func btn_PerviousDate(_ sender: UIButton) {
        selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!
        updateDateLabel()
        todayBookings()
    }
    
    @IBAction func btn_NextDate(_ sender: UIButton) {
        selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)!
        updateDateLabel()
        todayBookings()
    }
    
    func updateDateLabel() {
        txt_Date.text = formattedDate(selectedDate)
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "EEE MMMM dd, yyyy"
        return formatter.string(from: date)
    }

    func formattedDateDDMMYYYY(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
    }

    func showCalendarPopup(sourceView: UIView) {
        // Create the popup view controller
        calendarVC = UIViewController()
        calendarVC?.modalPresentationStyle = .popover
        calendarVC?.preferredContentSize = CGSize(width: 500, height: 400)

        // Create the FSCalendar
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 500, height: 400))
        
        // ✅ Fix for Swift 6 (use `any` explicitly)
        calendar.delegate = (self as any FSCalendarDelegate)
        calendar.dataSource = (self as any FSCalendarDataSource)
        
        // Calendar appearance
        calendar.appearance.titleDefaultColor = .black
        calendar.appearance.selectionColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
        calendar.appearance.todaySelectionColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
//        calendar.appearance.todayColor = #colorLiteral(red: 1, green: 0.2941176471, blue: 0.3333333333, alpha: 1)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        // Add calendar inside the popup view
        calendarVC?.view.addSubview(calendar)

        // Configure popover presentation
        if let popover = calendarVC?.popoverPresentationController {
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
            popover.permittedArrowDirections = .any
            popover.delegate = self // Optional if you want popover adaptive behavior
        }

        // Present the popup
        self.present(calendarVC!, animated: true, completion: nil)
    }

    func updateTableHeight() {
        DispatchQueue.main.async {
            self.tbl_vw.layoutIfNeeded()
            self.tbl_Height.constant = self.tbl_vw.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    
    func updateServiceHeight() {
        DispatchQueue.main.async {
            self.tbl_TopServices.layoutIfNeeded()
            self.tbl_ServiceHeight.constant = self.tbl_TopServices.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    func updateTopTeamHeight() {
        DispatchQueue.main.async {
            self.tbl_vw.reloadData()
            self.tbl_TopTeam.layoutIfNeeded()
            self.tbl_TeamHeight.constant = self.tbl_TopTeam.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    
    func Apicall_TopserviceReport() {
        showLoader()
        APIService.shared.getTopServices { result in
            self.hideLoader()
            guard let model = result else {
                print("API failed or empty response")
                self.topService = []
                return
            }

            self.topService = model.data ?? []
//            // Show/Hide No Data Label
//            if self.serviceList.isEmpty {
//                self.lbl_NoDataFound.isHidden = false
//            } else {
//                self.lbl_NoDataFound.isHidden = true
//            }
            self.tbl_TopServices.reloadData()
            
            self.txt_TopServicesCount.text = String(self.topService.count)
            self.updateServiceHeight()
        }
    }
    
    
    func Apicall_TopTeamMember() {
        showLoader()
        APIService.shared.getTopTeamMember { result in
            self.hideLoader()
            guard let model = result else {
                print("API failed or empty response")
                self.teamMember = []
                return
            }

            self.teamMember = model.data ?? []
//            // Show/Hide No Data Label
//            if self.serviceList.isEmpty {
//                self.lbl_NoDataFound.isHidden = false
//            } else {
//                self.lbl_NoDataFound.isHidden = true
//            }
            self.tbl_TopTeam.reloadData()
            self.txt_TopTeamCount.text = String(self.teamMember.count)
            self.updateTopTeamHeight()
        }
    }
    
}



extension UpcomingAppointmentsVC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbl_vw {
            return self.upcomingList.count
        }else if tableView == tbl_TopServices{
            return self.topService.count
        } else if tableView == tbl_TopTeam{
            return self.teamMember.count
        } else {
            return daysOptions.count
        }
        
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tbl_vw {
            guard let cell = tbl_vw.dequeueReusableCell(withIdentifier: "UpcomingAppointmentCell", for: indexPath) as? UpcomingAppointmentCell else {
                return UITableViewCell()
            }
//            cell.img_width.constant = 0
//            cell.img_leading.constant = 0
            let upcoming = self.upcomingList[indexPath.item]
            if let bookingDate = upcoming.bookingDate, bookingDate != "" {
                cell.lbl_bookingDate.text = formatBookingDate(bookingDate)
            }
            if let bookingTime = upcoming.bookingTime, bookingTime != "" {
                cell.lbl_bookingTime.text = formatBookingTime(bookingTime)
            }
            if let name = upcoming.name, name != "" {
                cell.lbl_customerName.text = name.capitalized
            }
            if let bookingId = upcoming.bookingNumber, bookingId != "" {
                cell.lbl_bookingId.text = "#\(bookingId)"
            }
            if let price = upcoming.grandTotal, price != "" {
                cell.lbl_amount.text = "\(LocalData.symbol)\(price)"
            }
            /*if let type = upcoming.customerType, type != "" {
                cell.lbl_Type.text = type.capitalized
            }*/
            
            if upcoming.customerType?.capitalized == "Guest"{
                cell.lbl_Type.text = NSLocalizedString("Guest", comment: "")
                cell.lbl_titleCustomerName.text = NSLocalizedString("Guest Name : ", comment: "")
            }else if upcoming.customerType?.capitalized == "Customer"{
                cell.lbl_Type.text = NSLocalizedString("Customer", comment: "")
                cell.lbl_titleCustomerName.text = NSLocalizedString("Customer Name", comment: "")
            }
            
            cell.Act_Info = {
                let popup = self.storyboard?.instantiateViewController(withIdentifier: "BookingDetailsPopupVC") as! BookingDetailsPopupVC
                popup.modalPresentationStyle = .overCurrentContext
                popup.modalTransitionStyle = .crossDissolve
                popup.dictBookingDetails = upcoming
                self.present(popup, animated: true , completion: nil)
            }
            return cell
        }else if tableView == tbl_TopServices {
            guard let cell = tbl_TopServices.dequeueReusableCell(withIdentifier: "TopServicesCell", for: indexPath) as? TopServicesCell else {
                return UITableViewCell()
            }
            let service = self.topService[indexPath.row]
            cell.lbl_Name.text = service.service_name
            cell.lbl_Booked.text = String(service.booking_count ?? 0)
            cell.lbl_Generated.text = "\(LocalData.symbol)\(String(describing: service.total_price ?? 0))"
            return cell
        }else if tableView == tbl_TopTeam{
            guard let cell = tbl_TopTeam.dequeueReusableCell(withIdentifier: "TeamMemberCell", for: indexPath) as? TeamMemberCell else {
                return UITableViewCell()
            }
            let team = self.teamMember[indexPath.row]
            cell.lbl_Name.text = team.fullname ?? ""
            cell.lbl_Appointments.text = String(team.booking_count ?? 0)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = daysOptions[indexPath.row]
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            return cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if offsetY > contentHeight - frameHeight - 100 {
            if !isLoadingMore && hasMoreData {
                self.loadData(Search: "", isPagination: true, days: "\(selectedDays)")
            }
        }
    }

    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if isLoadingMore {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            return spinner
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return isLoadingMore ? 50 : 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == dropdownView {
            txt_days.text = daysOptions[indexPath.row]
            dropdownView.isHidden = true
            isDropdownVisible = false
            selectedDays = daysValues[indexPath.row]
            self.loadData(Search: "", days: "\(selectedDays)")
            updateTableHeight()
        }
    }
    
}



extension UpcomingAppointmentsVC: FSCalendarDelegate, FSCalendarDataSource, UIPopoverPresentationControllerDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        txt_Date.text = formattedDate(date)
        todayBookings()
        calendarVC?.dismiss(animated: true, completion: nil)
        print("Selected Date:", formattedDateDDMMYYYY(date))
        print("Selected Date:", formattedDateDDMMYYYY(selectedDate))
    }
}

