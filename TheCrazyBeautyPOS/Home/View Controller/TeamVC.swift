//
//  TeamVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 12/06/25.
//

import UIKit

class TeamVC: UIViewController {

    
    @IBOutlet weak var scroll_vw: UIScrollView!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var txt_search: UITextField!
    @IBOutlet weak var lbl_totalStaff: UILabel!
    
    var staffList: [StaffData] = []
    var searchWorkItem: DispatchWorkItem?
    var currentPage = 1
    var totalCount = 0
    var isLoadingMore = false
    var hasMoreData = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentViewWidthConstraint.constant = 100 // or any dynamic value
        self.setTableView()
        self.txt_search.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.loadData(Search: "")
        // Do any additional setup after loading the view.
    }
    
    
    func setTableView(){
        tbl_vw.register(UINib(nibName: "TeamCell", bundle: nil), forCellReuseIdentifier: "TeamCell")
        tbl_vw.register(UINib(nibName: "TeamHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "TeamHeaderCell")
        tbl_vw.delegate = self
        tbl_vw.dataSource = self
        tbl_vw.rowHeight = UITableView.automaticDimension
        tbl_vw.estimatedRowHeight = 60
    }
    

    @objc func textFieldDidChange(_ textField: UITextField) {
        searchWorkItem?.cancel()

        let newWorkItem = DispatchWorkItem { [weak self] in
            self?.loadData(Search: textField.text ?? "")
        }

        searchWorkItem = newWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: newWorkItem)
    }
    

    
    func loadData(Search: String, isPagination: Bool = false) {
        if isPagination {
            self.isLoadingMore = true
        } else {
            self.currentPage = 1
            self.staffList.removeAll()
            self.hasMoreData = true
        }

        APIService.shared.getteamDetails(page: "\(currentPage)", limit: "10", vendorId: LocalData.userId, search: Search, isTeamDetails: 1) { staffResult in
            guard let model = staffResult else {
                self.isLoadingMore = false
                return
            }

            let newItems = model.data ?? []
            self.totalCount = model.total ?? 0 // Make sure this field exists in your response model
            self.lbl_totalStaff.text = "\(self.totalCount) Team Members"
            if newItems.isEmpty || self.staffList.count + newItems.count >= self.totalCount {
                self.hasMoreData = false
            }

            self.staffList += newItems
            self.currentPage += 1
            self.isLoadingMore = false
            self.tbl_vw.reloadData()
        }
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        cell.lbl_review.text = ""
        cell.Act_Edit = {
            let addNew = self.storyboard?.instantiateViewController(withIdentifier: "AddTeamVC") as! AddTeamVC
            addNew.isEdit = true
            addNew.dictStaff = staff
            self.navigationController?.pushViewController(addNew, animated: true)
        }
        cell.Act_Delete = {
            
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

extension TeamVC: UITextFieldDelegate {
    
    
    
}
