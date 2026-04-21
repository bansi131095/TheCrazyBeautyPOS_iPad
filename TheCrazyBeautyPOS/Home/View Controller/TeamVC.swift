//
//  TeamVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 12/06/25.
//

import UIKit

class TeamVC: UIViewController {

    
    @IBOutlet weak var lbl_TitleTeam: UILabel!
    @IBOutlet weak var scroll_vw: UIScrollView!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var txt_search: UITextField!
    @IBOutlet weak var lbl_totalStaff: UILabel!
    
    @IBOutlet weak var btn_AddNew: GradientButton!
    
    @IBOutlet weak var btn_TeamRoster: GradientButton!
    
    
    var staffList: [StaffData] = []
    var searchWorkItem: DispatchWorkItem?
    var currentPage = 1
    var totalCount = 0
    var isLoadingMore = false
    var hasMoreData = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentViewWidthConstraint.constant = 10 // or any dynamic value
        self.setTableView()
        setCustomFont()
        self.txt_search.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.lbl_TitleTeam.text = NSLocalizedString("Team", comment: "")
        let AddNew = NSAttributedString(
            string: NSLocalizedString("Add New",comment: ""),
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 18.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        btn_AddNew.setAttributedTitle(AddNew, for: .normal)
        
        let TeamRoster = NSAttributedString(
            string: NSLocalizedString("Team Roster",comment: ""),
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 18.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        btn_TeamRoster.setAttributedTitle(TeamRoster, for: .normal)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadData(Search: "")
    }
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Bold", size: 22.0) {
            lbl_TitleTeam.font = customFont
        }
    }
    
    func setTableView(){
        tbl_vw.register(UINib(nibName: "TeamCell", bundle: nil), forCellReuseIdentifier: "TeamCell")
        tbl_vw.register(UINib(nibName: "TeamHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "TeamHeaderCell")
        tbl_vw.delegate = self
        tbl_vw.dataSource = self
        tbl_vw.rowHeight = UITableView.automaticDimension
        tbl_vw.estimatedRowHeight = 70
    }
    

    @objc func textFieldDidChange(_ textField: UITextField) {
        /*searchWorkItem?.cancel()

        let newWorkItem = DispatchWorkItem { [weak self] in
            self?.loadData(Search: textField.text ?? "")
        }

        searchWorkItem = newWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: newWorkItem)*/
        self.loadData(Search: textField.text ?? "")
    }
    

    
    func loadData(Search: String, isPagination: Bool = false) {
        if isPagination {
            self.isLoadingMore = true
        } else {
            self.currentPage = 1
            self.staffList.removeAll()
            self.hasMoreData = true
//            showLoader()
        }

        APIService.shared.getteamDetails(page: "\(currentPage)", limit: "10", vendorId: LocalData.userId, search: Search, isTeamDetails: 1) { staffResult in
            self.hideLoader()
            guard let model = staffResult else {
                self.isLoadingMore = false
                return
            }

            let newItems = model.data ?? []
            self.totalCount = model.total ?? 0 // Make sure this field exists in your response model
            self.lbl_totalStaff.text = "\(self.totalCount) " + NSLocalizedString("Team Members", comment: "")
            if newItems.isEmpty || self.staffList.count + newItems.count >= self.totalCount {
                self.hasMoreData = false
            }

            self.staffList += newItems
            self.currentPage += 1
            self.isLoadingMore = false
            self.tbl_vw.backgroundView = self.staffList.isEmpty ? self.getNoDataLabel() : nil
            self.tbl_vw.reloadData()
        }
    }

    func getNoDataLabel() -> UILabel {
        let noDataLabel = UILabel()
        noDataLabel.text = NSLocalizedString("No Team Data Found", comment: "")
        noDataLabel.textAlignment = .center
        noDataLabel.textColor = .gray
        noDataLabel.font = UIFont(name: "Lato-Bold", size: 20.0)
        return noDataLabel
    }
    
    // Button Action
    @IBAction func act_addNew(_ sender: UIButton) {
        let addNew = self.storyboard?.instantiateViewController(withIdentifier: "AddTeamVC") as! AddTeamVC
        addNew.isEdit = false
        self.navigationController?.pushViewController(addNew, animated: true)
    }
    
    @IBAction func Act_addTeamRoster(_ sender: GradientButton) {
        let teamRoster = self.storyboard?.instantiateViewController(withIdentifier: "TeamRosterVC") as! TeamRosterVC
        self.navigationController?.pushViewController(teamRoster, animated: true)
    }
    
    //MARK: Add_TeamMember
    func addTeamData(firstName: String,
                     lastName: String,
                     vendorId: String,
                     email: String,
                     jobTitle: String,
                     gender: String,
                     dob: String,
                     phone: String,
                     showCustomer: Int,
                     showInCalendar: Int,
                     serviceIds: String,
                     workingHours: String,
                     shiftTimings: String,
                     block_timings: String,
                     photo: String,
                     job_bio: String,
                     holiday_dates: String,
                     average_rating:Double,
                     sequence:Int,
                     is_deleted:Int,
                     status:Int,
                     total_hours:String){
        APIService.shared.add_TeamData(firstName: firstName, lastName: lastName, vendorId: vendorId, email: email, jobTitle: jobTitle, gender: gender, dob: dob, phone: phone, showCustomer: showCustomer, showInCalendar: showInCalendar, serviceIds: serviceIds, workingHours: workingHours, shiftTimings: shiftTimings, block_timings: block_timings, photo: photo, job_bio: job_bio, holiday_dates: holiday_dates, average_rating: average_rating, sequence: sequence, is_deleted: is_deleted, status: status, total_hours: total_hours) { team_Result in
            self.hideLoader()
            
            guard let model = team_Result else {
                return
            }
                if model.error == "" || model.error == nil {
                    DispatchQueue.main.async {
                        self.hideLoader()
                        self.alertWithMessageOnly(NSLocalizedString("Team member added successfully", comment: ""))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.loadData(Search: "")
                        }
                    }
            } else {
                self.alertWithMessageOnly(NSLocalizedString("Failed to team member",comment: ""))
            }
        }
    }
    
    //MARK: Delete API
    func deleteTeamData(teamId: Int) {
        self.showLoader()
        APIService.shared.deleteTeamData(teamId: teamId) { staffResult in
            guard let model = staffResult else {
                return
            }
            self.hideLoader()
            if model.error == "" || model.error == nil {
                DispatchQueue.main.async {
                    self.alertWithMessageOnly(NSLocalizedString("Team member deleted successfully",comment: ""))
                }
                self.loadData(Search: "")
            } else {
                self.alertWithMessageOnly(NSLocalizedString("Failed to delete staff member",comment: ""))
            }
        }
    }
}

extension TeamVC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.staffList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TeamHeaderCell") as? TeamHeaderCell else {
                return nil
            }

            // Customize your header view
            return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbl_vw.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as? TeamCell else {
            return UITableViewCell()
        }
        let staff = self.staffList[indexPath.item]
        cell.lbl_no.text = "\(indexPath.row+1)"
        cell.lbl_name.text = (staff.firstName ?? "").capitalized + " " + (staff.lastName ?? "").capitalized
        cell.lbl_email.text = staff.email
        cell.lbl_phone.text = staff.phone
        cell.lbl_jobTitle.text = staff.jobTitle
        
        if staff.averageRating != nil{
            cell.lbl_review.text = staff.jobTitle
        }else{
            cell.lbl_review.text = "-"
        }
        
        /*if staff.photo != "" {
            let imgUrl = global.imageUrl + (staff.photo ?? "")
            if let url = URL(string: imgUrl) {
                cell.img_vw.sd_setImage(with: url, completed: { (image, error, _, _) in
                    if let error = error {
                        print("❌ Failed to load image: \(error.localizedDescription)")
                        cell.img_vw.image = UIImage(named: "user")
                    } else {
                        cell.img_vw.image = image
                    }
                })
            }
        }*/
        
        cell.img_vw.image = UIImage(named: "user") // ✅ reset first

        if let photo = staff.photo, !photo.isEmpty {
            let imgUrl = global.imageUrl + photo
            
            if let url = URL(string: imgUrl) {
                cell.img_vw.sd_setImage(
                    with: url,
                    placeholderImage: UIImage(named: "user"), // ✅ placeholder
                    options: [.retryFailed, .continueInBackground],
                    completed: nil
                )
            }
        }
        
        cell.Act_Edit = {
            let addNew = self.storyboard?.instantiateViewController(withIdentifier: "AddTeamVC") as! AddTeamVC
            addNew.isEdit = true
            addNew.dictStaff = staff
            self.navigationController?.pushViewController(addNew, animated: true)
        }
        cell.Act_Delete = {
            let popup = ConfirmDeletePopupVC()
            popup.modalPresentationStyle = .overFullScreen
            popup.modalTransitionStyle = .crossDissolve
            popup.titleText = NSLocalizedString("Are you sure you want to delete this team member?",comment:"")
            popup.onConfirm = {
                print("Team confirmed delete")
                // Call your delete logic here
                self.deleteTeamData(teamId: staff.id ?? 0)
            }
            self.present(popup, animated: true, completion: nil)
        }
        cell.Act_Duplication = {
            let popup = ConfirmDeletePopupVC()
            popup.modalPresentationStyle = .overFullScreen
            popup.modalTransitionStyle = .crossDissolve
            popup.titleText = NSLocalizedString("Are you sure you want to copy this staff?",comment: "")
            popup.onConfirm = {
                self.addTeamData(firstName: staff.firstName ?? "", lastName: staff.lastName ?? "", vendorId: LocalData.userId, email: staff.email ?? "", jobTitle: staff.jobTitle ?? "", gender: staff.gender ?? "", dob: staff.dob ?? "", phone: staff.phone ?? "", showCustomer: staff.showCustomer ?? 0, showInCalendar: staff.showInCalendar ?? 0, serviceIds: staff.serviceIds ?? "", workingHours: staff.workingHours ?? "", shiftTimings: staff.shiftTimings ?? "", block_timings: staff.blockTimings ?? "", photo: staff.photo ?? "", job_bio: staff.jobBio ?? "", holiday_dates: staff.holidayDates ?? "", average_rating: Double(staff.averageRating ?? "") ?? 0.0, sequence: staff.sequence ?? 0, is_deleted: staff.isDeleted ?? 0, status: Int(staff.status ?? "") ?? 0, total_hours: staff.totalHours ?? "")
            }
            self.present(popup, animated: true, completion: nil)
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if offsetY > contentHeight - frameHeight - 100 {
            if !isLoadingMore && hasMoreData {
                self.loadData(Search: txt_search.text ?? "", isPagination: true)
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

