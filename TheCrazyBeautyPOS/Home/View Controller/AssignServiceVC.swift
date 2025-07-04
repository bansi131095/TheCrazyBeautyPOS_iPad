//
//  AssignServiceVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 04/07/25.
//

import UIKit

class AssignServiceVC: UIViewController {

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    
    
    var serviceList: [ServiceData] = []
    var selectedServiceId: [String] = []
    var serviceIds = String()
    
    var isEdit = false
    var teamName = ""
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        contentViewWidthConstraint.constant = 300 // or any dynamic value
        if isEdit {
            self.lbl_title.text = "Services For " + "\(teamName)"
            let list = serviceIds.components(separatedBy: ",")
            self.selectedServiceId = list
        } else {
            self.lbl_title.text = "Assign Services to New Team Member"
            serviceIds = ""
            selectedServiceId = []
        }
        self.setTableView()
        self.loadData()
        // Do any additional setup after loading the view.
    }
    
    //MARK: Setup Views
    func setTableView(){
        tbl_vw.register(UINib(nibName: "AssignServiceCell", bundle: nil), forCellReuseIdentifier: "AssignServiceCell")
        tbl_vw.register(UINib(nibName: "AssignServiceHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "AssignServiceHeaderCell")
        tbl_vw.delegate = self
        tbl_vw.dataSource = self
        tbl_vw.rowHeight = UITableView.automaticDimension
        tbl_vw.estimatedRowHeight = 60
    }
    
    //MARK: Button Action
    @IBAction func act_close(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
   
    //MARK: Load Api
    func loadData() {
        
        APIService.shared.getServiceDetails(page: "1", limit: "1000000", vendorId: LocalData.userId, search: "", booking: "booking", categoryId: "", isGroup: true) { staffResult in
            guard let model = staffResult else {
                return
            }

            let newItems = model.data
            self.serviceList += newItems
            self.tbl_vw.reloadData()
        }
    }
    

    func selectAllServices() {

        if selectedServiceId.count == serviceList.count {
            selectedServiceId.removeAll()
            serviceIds = ""
        } else {
            selectedServiceId.removeAll()
            for service in serviceList {
                selectedServiceId.append("\(service.id)")
            }
            serviceIds = selectedServiceId.joined(separator: ",")
        }

        // Call setState equivalent if needed, like:
        // self.tableView.reloadData()
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



extension AssignServiceVC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.serviceList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AssignServiceHeaderCell") as? AssignServiceHeaderCell else {
                return nil
            }
        if self.selectedServiceId.count == self.serviceList.count {
            header.btn_checkAll.setImage(#imageLiteral(resourceName: "check.png"), for: .normal)
        } else {
            header.btn_checkAll.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        }
        header.Act_Check = {
            if header.btn_checkAll.currentImage == #imageLiteral(resourceName: "check.png") {
                self.selectedServiceId.removeAll()
                self.selectedServiceId = []
                self.serviceIds = ""
            } else {
                self.selectAllServices()
            }
            self.tbl_vw.reloadData()
        }
            // Customize your header view
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbl_vw.dequeueReusableCell(withIdentifier: "AssignServiceCell", for: indexPath) as? AssignServiceCell else {
            return UITableViewCell()
        }
        let service = self.serviceList[indexPath.row]
        cell.lbl_category.text = service.category
        cell.lbl_service.text = service.service
        cell.lbl_time.text = "\(service.duration) Min"
        cell.lbl_serviceFor.text = service.service_for
        cell.lbl_price.text = "\(LocalData.symbol)\(service.price)"
        if self.selectedServiceId.contains("\(service.id)") {
            cell.btn_check.setImage(#imageLiteral(resourceName: "check.png"), for: .normal)
        } else {
            cell.btn_check.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        }
        cell.Act_Check = {
            if self.selectedServiceId.contains("\(service.id)") {
                self.selectedServiceId.remove(at: self.selectedServiceId.firstIndex(of: "\(service.id)")!)
            } else {
                self.selectedServiceId.append("\(service.id)")
            }
            self.serviceIds = self.selectedServiceId.joined(separator: ",")
            self.tbl_vw.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let service = self.serviceList[indexPath.row]
        if self.selectedServiceId.contains("\(service.id)") {
            self.selectedServiceId.remove(at: self.selectedServiceId.firstIndex(of: "\(service.id)")!)
        } else {
            self.selectedServiceId.append("\(service.id)")
        }
        self.serviceIds = self.selectedServiceId.joined(separator: ",")
        self.tbl_vw.reloadData()
    }
    
}
