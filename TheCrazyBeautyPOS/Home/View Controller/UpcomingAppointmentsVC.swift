//
//  UpcomingAppointmentsVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 12/06/25.
//

import UIKit

class UpcomingAppointmentsVC: UIViewController {

    
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var txt_days: UITextField!
    @IBOutlet weak var lbl_total: UILabel!
    
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
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTableView()
        self.loadData(Search: "", days: "\(selectedDays)")
        setupDaysTextField()
        setupDropdownTable()
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
            dropdownView.widthAnchor.constraint(equalTo: txt_days.widthAnchor),
            dropdownView.heightAnchor.constraint(equalToConstant: CGFloat(daysOptions.count * 45))
        ])
    }
    
    @objc func toggleDropdown() {
        
        isDropdownVisible.toggle()
        dropdownView.isHidden = !isDropdownVisible
    }
    
    
    //MARK: Load Api
    func loadData(Search: String, isPagination: Bool = false, days: String) {
        if isPagination {
            self.isLoadingMore = true
        } else {
            self.currentPage = 1
            self.upcomingList.removeAll()
            self.hasMoreData = true
        }

        APIService.shared.getbookingHistory(page: "\(currentPage)", limit: "10", vendorId: LocalData.userId, search: Search, days: days) { staffResult in
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
            self.tbl_vw.reloadData()
        }
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
            let upcoming = self.upcomingList[indexPath.item]
            if let bookingDate = upcoming.bookingDate, bookingDate != "" {
                cell.lbl_bookingDate.text = formatBookingDate(bookingDate)
            }
            if let bookingTime = upcoming.bookingTime, bookingTime != "" {
                cell.lbl_bookingTime.text = formatBookingTime(bookingTime)
            }
            if let name = upcoming.name, name != "" {
                cell.lbl_customerName.text = name
            }
            if let bookingId = upcoming.bookingNumber, bookingId != "" {
                cell.lbl_bookingId.text = "#\(bookingId)"
            }
            if let price = upcoming.grandTotal, price != "" {
                cell.lbl_amount.text = "\(LocalData.symbol)\(price)"
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


