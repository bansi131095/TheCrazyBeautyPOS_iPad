//
//  BookingHistoryVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 14/07/25.
//

import UIKit

class BookingHistoryVC: UIViewController {

    
//    @IBOutlet weak var txt_search: UITextField!
    @IBOutlet weak var tbl_vw: UITableView!
    
    var upcomingList: [BookingData] = []
    
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTableView()
        self.loadData()
        // Do any additional setup after loading the view.
    }
    

    //MARK: Setup Table View
    func setTableView(){
        tbl_vw.register(UINib(nibName: "BookingHistoryCell", bundle: nil), forCellReuseIdentifier: "BookingHistoryCell")
        tbl_vw.delegate = self
        tbl_vw.dataSource = self
        tbl_vw.rowHeight = UITableView.automaticDimension
        tbl_vw.estimatedRowHeight = 60
    }
    
    
    //MARK: Load Api
    func loadData() {
        showLoader()
        APIService.shared.getbookingHistory(page: "1", limit: "10", vendorId: LocalData.userId, search: "", days: "300") { staffResult in
            self.hideLoader()
            guard let model = staffResult else {
                return
            }

            let newItems = model.data ?? []
            self.upcomingList = newItems
        
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension BookingHistoryVC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.upcomingList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbl_vw.dequeueReusableCell(withIdentifier: "BookingHistoryCell", for: indexPath) as? BookingHistoryCell else {
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
        if let type = upcoming.customerType, type != "" {
            cell.lbl_type.setTitle(type.capitalized, for: .normal)
        }
        
        cell.Act_Info = {
            let popup = self.storyboard?.instantiateViewController(withIdentifier: "BookingDetailsPopupVC") as! BookingDetailsPopupVC
            popup.modalPresentationStyle = .overCurrentContext
            popup.modalTransitionStyle = .crossDissolve
            popup.dictBookingDetails = upcoming
            self.present(popup, animated: true , completion: nil)
        }
        return cell
    }
    
}
