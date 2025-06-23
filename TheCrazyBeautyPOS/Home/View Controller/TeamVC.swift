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
    
    var staffList: [StaffData] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentViewWidthConstraint.constant = 100 // or any dynamic value
        self.setTableView()
        self.loadData()
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
    
    
    func loadData() {
        APIService.shared.getteamDetails(page: "1", limit: "10", vendorId: LocalData.userId, search: "", isTeamDetails: 1, completion: { staffResult in
            guard let model = staffResult else {
                return
            }
            
            self.staffList = model.data ?? []
            self.tbl_vw.reloadData()
        })

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

extension TeamVC: UITableViewDelegate, UITableViewDataSource{
    
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
        return cell
    }
    
}
