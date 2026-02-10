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
    
    var onDataReturn: ((String) -> Void)?
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        contentViewWidthConstraint.constant = 300 // or any dynamic value
        if isEdit {
            self.lbl_title.text = (NSLocalizedString("Services For ",comment: "")) + "\(teamName)"
            let list = serviceIds.components(separatedBy: ",")
            self.selectedServiceId = list
        } else {
            self.lbl_title.text = (NSLocalizedString("Assign Services to New Team Member",comment: ""))
            serviceIds = ""
            selectedServiceId = []
        }
        self.setTableView()
        self.loadData()
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
    
    
    @IBAction func act_continue(_ sender: GradientButton) {
        print("Count:- \(serviceIds)")
        serviceIds = selectedServiceId.joined(separator: ",")
        onDataReturn?(serviceIds) // Pass the data back
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Load Api
    func loadData() {
        showLoader()
        APIService.shared.getServiceDetails(page: "1", limit: "1000000", vendorId: LocalData.userId, search: "", booking: "booking", categoryId: "", isGroup: true) { staffResult in
            self.hideLoader()
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
//            serviceIds = ""
        } else {
            /*selectedServiceId.removeAll()
            for service in serviceList {
                selectedServiceId.append("\(service.id)")
            }*/
            selectedServiceId = serviceList.map { "\($0.id)" }
            
        }
        serviceIds = selectedServiceId.joined(separator: ",")
        // Call setState equivalent if needed, like:
        self.tbl_vw.reloadData()
    }
}


extension AssignServiceVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        serviceList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AssignServiceHeaderCell") as? AssignServiceHeaderCell else {
            return nil
        }
        
        let allSelected = selectedServiceId.count == serviceList.count
        header.btn_checkAll.setImage(allSelected ? #imageLiteral(resourceName: "check.png") : #imageLiteral(resourceName: "unchecked"), for: .normal)
        
        header.Act_Check = {
            self.selectAllServices()
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbl_vw.dequeueReusableCell(withIdentifier: "AssignServiceCell", for: indexPath) as? AssignServiceCell else {
            return UITableViewCell()
        }
        
        let service = serviceList[indexPath.row]
        cell.lbl_category.text = service.category
        cell.lbl_service.text = service.service
        cell.lbl_time.text = "\(service.duration) " + NSLocalizedString("Minutes",comment: "")
//        cell.lbl_serviceFor.text = service.service_for
        
        if service.service_for == "Male"{
            cell.lbl_serviceFor.text = NSLocalizedString("Male",comment: "")
        }else if service.service_for == "Female"{
            cell.lbl_serviceFor.text = NSLocalizedString("Female",comment: "")
        }else if service.service_for == "Unisex"{
            cell.lbl_serviceFor.text = NSLocalizedString("Unisex",comment: "")
        }
        
        
        cell.lbl_price.text = "\(LocalData.symbol)\(service.price)"
        
        let isSelected = selectedServiceId.contains("\(service.id)")
        cell.btn_check.setImage(isSelected ? #imageLiteral(resourceName: "check.png") : #imageLiteral(resourceName: "unchecked"), for: .normal)
        
        cell.Act_Check = {
            if let index = self.selectedServiceId.firstIndex(of: "\(service.id)") {
                self.selectedServiceId.remove(at: index)
            } else {
                self.selectedServiceId.append("\(service.id)")
            }
            self.serviceIds = self.selectedServiceId.joined(separator: ",")
            self.tbl_vw.reloadData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let service = serviceList[indexPath.row]
        if let index = selectedServiceId.firstIndex(of: "\(service.id)") {
            selectedServiceId.remove(at: index)
        } else {
            selectedServiceId.append("\(service.id)")
        }
        serviceIds = selectedServiceId.joined(separator: ",")
        tbl_vw.reloadData()
    }
}

/*extension AssignServiceVC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
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
    
}*/
