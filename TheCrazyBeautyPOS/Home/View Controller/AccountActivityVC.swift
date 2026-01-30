//
//  AccountActivityVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 14/07/25.
//

import UIKit

class AccountActivityVC: UIViewController {

    
    @IBOutlet weak var tbl_vw: UITableView!
    
    var notificationList: [MessageData] = []
    var currentPage = 1
    var totalCount = 0
    var isLoadingMore = false
    var hasMoreData = true
    
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTableView()
        self.getNotificationData()
        self.updateNotificationData()
        // Do any additional setup after loading the view.
    }

    
    //MARK: Setup Table View
    func setTableView(){
        tbl_vw.register(UINib(nibName: "AccountActivityCell", bundle: nil), forCellReuseIdentifier: "AccountActivityCell")
        tbl_vw.delegate = self
        tbl_vw.dataSource = self
        tbl_vw.rowHeight = UITableView.automaticDimension
        tbl_vw.estimatedRowHeight = 60
    }

    
    //MARK: Api Call
    func getNotificationData(isPagination: Bool = false) {
        if isPagination {
            self.isLoadingMore = true
        } else {
            self.currentPage = 1
            self.notificationList.removeAll()
            self.hasMoreData = true
            showLoader()
        }
        
        APIService.shared.getNotificationList(page: "\(currentPage)", limit: "10") { activityResult in
            self.hideLoader()
            guard let model = activityResult else {
                self.isLoadingMore = false
                return
            }

            let newItems = model.data
            self.totalCount = model.total // Make sure this field exists in your response model
            if newItems.isEmpty || self.notificationList.count + newItems.count >= self.totalCount {
                self.hasMoreData = false
            }

            self.notificationList += newItems
            self.currentPage += 1
            self.isLoadingMore = false
            self.tbl_vw.reloadData()
            self.tbl_vw.backgroundView = self.notificationList.isEmpty ? self.getNoDataLabel() : nil
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
    
    
    func updateNotificationData() {
        showLoader()
        APIService.shared.updateActivity(){ activityResult in
            self.hideLoader()
            guard let model = activityResult else {
                return
            }

            if model.error == "" || model.error == nil {
                DispatchQueue.main.async {
                    self.showToast(message: NSLocalizedString("Activities updated successfully",comment: ""))
                }
            }else{
                self.showToast(message: NSLocalizedString("Failed to update activities",comment: ""))
            }
        }
    }
    
    
    func showCustomTooltipCentered(message: String) {
        // Get the top-level window
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
            .first else {
            return
        }

        // Remove existing tooltip
        if let existing = window.viewWithTag(9999) {
            existing.removeFromSuperview()
        }

        // Create overlay
        let overlayView = UIView(frame: window.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        overlayView.tag = 9999
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(overlayView)

        // Add tooltip
        let tooltip = ToolTipView()
        tooltip.setMessage(message)
        tooltip.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(tooltip)

        // Center with constraints
        NSLayoutConstraint.activate([
            overlayView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: window.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: window.bottomAnchor),

            tooltip.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            tooltip.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            tooltip.widthAnchor.constraint(equalToConstant: window.bounds.width),
            tooltip.heightAnchor.constraint(equalToConstant: window.bounds.height)
        ])

        // Animate in
        overlayView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            overlayView.alpha = 1
        }

        // Dismiss after 2.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            UIView.animate(withDuration: 0.3, animations: {
                overlayView.alpha = 0
            }) { _ in
                overlayView.removeFromSuperview()
            }
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


extension AccountActivityVC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbl_vw.dequeueReusableCell(withIdentifier: "AccountActivityCell", for: indexPath) as? AccountActivityCell else {
            return UITableViewCell()
        }
        let activity = self.notificationList[indexPath.row]
        
//        cell.lbl_activity.text = activity.message
        if activity.message == "Salon services updated"{
            cell.lbl_activity.text = NSLocalizedString("Salon services updated",comment: "")
        }else if activity.message == "Salon details updated"{
            cell.lbl_activity.text = NSLocalizedString("Salon details updated",comment: "")
        }else if activity.message == "Working hours updated"{
            cell.lbl_activity.text = NSLocalizedString("Working hours updated",comment: "")
        }else if activity.message == "Salon images updated"{
            cell.lbl_activity.text = NSLocalizedString("Salon images updated",comment: "")
        }else if activity.message == "Bank details updated"{
            cell.lbl_activity.text = NSLocalizedString("Bank details updated",comment: "")
        }else if activity.message == "Change Password updated"{
            cell.lbl_activity.text = NSLocalizedString("Change Password updated",comment: "")
        }else if activity.message == "Salon categories updated"{
            cell.lbl_activity.text = NSLocalizedString("Salon categories updated",comment: "")
        }else if activity.message == "Staff sequence updated"{
            cell.lbl_activity.text = NSLocalizedString("Staff sequence updated",comment: "")
        }else if activity.message == "New appointment added"{
            cell.lbl_activity.text = NSLocalizedString("New appointment added",comment: "")
        }else if activity.message == "Service details updated"{
            cell.lbl_activity.text = NSLocalizedString("Service details updated",comment: "")
        }else if activity.message == "Break time updated"{
            cell.lbl_activity.text = NSLocalizedString("Break time updated",comment: "")
        }else if activity.message == "New special appointment added"{
            cell.lbl_activity.text = NSLocalizedString("New special appointment added",comment: "")
        }else if activity.message == "Appointment updated"{
            cell.lbl_activity.text = NSLocalizedString("Appointment updated",comment: "")
        }else if activity.message == "Staff holidays updated"{
            cell.lbl_activity.text = NSLocalizedString("Staff holidays updated",comment: "")
        }else if activity.message == "Staff details updated"{
            cell.lbl_activity.text = NSLocalizedString("Staff details updated",comment: "")
        }else if activity.message == "Service details added"{
            cell.lbl_activity.text = NSLocalizedString("Service details added",comment: "")
        }else if activity.message == "Appointment cancelled"{
            cell.lbl_activity.text = NSLocalizedString("Appointment cancelled",comment: "")
        }else if activity.message == "Appointment completed"{
            cell.lbl_activity.text = NSLocalizedString("Appointment completed",comment: "")
        }else if activity.message == "Appointment no show"{
            cell.lbl_activity.text = NSLocalizedString("Appointment no show",comment: "")
        }
        
        let updatedAt = activity.updatedAt
        let converted = ConvertDateFormat(date: updatedAt, inputdate: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", outputdateformat: "EEEE, MMM dd, yyyy 'at' hh:mm a")

        cell.lbl_time.text = converted
        if activity.description.isEmpty {
            cell.btn_tooltip.isHidden = true
        } else {
            cell.btn_tooltip.isHidden = false
        }
        cell.Act_ToolTip = {
            self.showCustomTooltipCentered(message: activity.description)
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if offsetY > contentHeight - frameHeight - 100 {
            if !isLoadingMore && hasMoreData {
                self.getNotificationData(isPagination: true)
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
    
    
}



















