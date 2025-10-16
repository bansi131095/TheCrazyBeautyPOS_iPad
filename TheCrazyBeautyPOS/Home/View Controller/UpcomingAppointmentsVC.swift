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
    
    
    
    @IBOutlet weak var txt_Date: UITextField!
    @IBOutlet weak var lbl_TotalBookings: UILabel!
    @IBOutlet weak var lbl_CalendarTotal: UILabel!
    @IBOutlet weak var lbl_CalendarTotalAmount: UILabel!
    @IBOutlet weak var lbl_WalkinTotal: UILabel!
    @IBOutlet weak var lbl_WalkinTotalAmount: UILabel!
    @IBOutlet weak var lbl_TotalCard: UILabel!
    @IBOutlet weak var lbl_TotalCash: UILabel!
    
    var upcomingList: [BookingData] = []
    var currentPage = 1
    var totalCount = 0
    var isLoadingMore = false
    var hasMoreData = true
    let dropdownView = UITableView()
    let daysOptions = ["Next 7 Days", "Next 15 Days", "Next 30 Days"]
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
        setupDaysTextField()
        setupDropdownTable()
        updateDateLabel()
        todayBookings()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: Set Table View
    func setTableView(){
        tbl_vw.register(UINib(nibName: "UpcomingAppointmentCell", bundle: nil), forCellReuseIdentifier: "UpcomingAppointmentCell")
        tbl_vw.delegate = self
        tbl_vw.dataSource = self
        tbl_vw.rowHeight = UITableView.automaticDimension
        tbl_vw.estimatedRowHeight = 60
    }
    
    //MARK: Setup Views
    func setupDaysTextField() {
    
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleDropdown))
        txt_days.addGestureRecognizer(tapGesture)
        txt_days.isUserInteractionEnabled = true
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

        APIService.shared.getbookingHistory(page: "\(currentPage)", limit: "10", vendorId: LocalData.userId, search: Search, days: days) { staffResult in
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
        }
    }
    
    func getNoDataLabel() -> UILabel {
        let noDataLabel = UILabel()
        noDataLabel.text = "No Data Found"
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
                self.showToast(message: result?.error ?? "")
                return
            }

            // ✅ Assign values properly (assuming all are strings)
            self.lbl_TotalBookings.text = "Bookings : " + String(data.total_bookings)
            self.lbl_CalendarTotal.text = "Bookings : " + String(data.calendar_total)
            self.lbl_CalendarTotalAmount.text = "Amount : " + "\(SharedPrefs.getSymbol())" + String(Double(data.calendar_total_amount))
            self.lbl_WalkinTotal.text = "Bookings : " + String(data.walkin_total)
            self.lbl_WalkinTotalAmount.text = "Amount : " + "\(SharedPrefs.getSymbol())" + String(Double(data.walkin_total_amount))
            self.lbl_TotalCard.text = "Card : " + "\(SharedPrefs.getSymbol())" + String(Double(data.total_card))
            self.lbl_TotalCash.text = "Cash : " + "\(SharedPrefs.getSymbol())" + String(Double(data.total_cash))
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
        calendar.appearance.todayColor = #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
        
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


}



extension UpcomingAppointmentsVC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbl_vw {
            return self.upcomingList.count
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
            if let type = upcoming.customerType, type != "" {
                cell.lbl_Type.text = type.capitalized
            }
            cell.Act_Info = {
                let popup = self.storyboard?.instantiateViewController(withIdentifier: "BookingDetailsPopupVC") as! BookingDetailsPopupVC
                popup.modalPresentationStyle = .overCurrentContext
                popup.modalTransitionStyle = .crossDissolve
                popup.dictBookingDetails = upcoming
                self.present(popup, animated: true , completion: nil)
            }
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
        }
    }
    
}



extension UpcomingAppointmentsVC: FSCalendarDelegate, FSCalendarDataSource, UIPopoverPresentationControllerDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        txt_Date.text = formattedDate(date)
        calendarVC?.dismiss(animated: true, completion: nil)
        print("Selected Date:", formattedDateDDMMYYYY(date))
        print("Selected Date:", formattedDateDDMMYYYY(selectedDate))
    }
}

