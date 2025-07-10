//
//  AddServiceVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 03/07/25.
//

import UIKit

class AddServiceVC: UIViewController {
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var txt_serviceName: TextInputLayout!
    @IBOutlet weak var txt_mainCategory: TextInputLayout!
    @IBOutlet weak var txt_serviceFor: TextInputLayout!
    @IBOutlet weak var txt_description: FloatingTextView!
    @IBOutlet weak var txt_serviceDuration: TextInputLayout!
    @IBOutlet weak var txt_priceType: TextInputLayout!
    @IBOutlet weak var txt_regulatPrice: TextInputLayout!
    @IBOutlet weak var txt_salesPrice: TextInputLayout!
    @IBOutlet weak var btn_vendorOnly: UIButton!
    @IBOutlet weak var btn_needToContact: UIButton!
    @IBOutlet weak var btn_patchTest: UIButton!
    @IBOutlet weak var staffTextField: TextInputLayout!
    @IBOutlet weak var tagHolderView: UIView!
    @IBOutlet weak var btn_service: GradientButton!
    
    var dictService: ServiceData?
    var isEdit = false
    var durationList:[DurationItem] = []
    var categoryList: [ServiceDatas] = []
    var staffList: [StaffData] = []
    var selectedStaffList: [StaffData] = []
    let durationTableView = UITableView()
    var isDurationVisible = false
    let categoryTableView = UITableView()
    var isCategoryVisible = false
    let serviceForTableView = UITableView()
    var isServiceForVisible = false
    var selected:[String] = []
    var selectedDuration = 0
    var parentId = 0
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDuationData()
        self.loadCategoryData()
        self.loadData()
        let options: [String] = ["Male", "Female", "Unisex"]
        DropdownManager.shared.setupDropdown(
            for: self.txt_serviceFor,
            in: self.view,
            with: options
        ) { [weak self] selected in
            guard let self = self else { return }
            self.txt_serviceFor.setText(selected)
        }
        let options1: [String] = ["Starts From", "Fixed"]
        DropdownManager.shared.setupDropdown(
            for: self.txt_priceType,
            in: self.view,
            with: options1
        ) { [weak self] selected in
            guard let self = self else { return }
            self.txt_priceType.setText(selected)
        }
        staffTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openStaffPopup))
        staffTextField.addGestureRecognizer(tapGesture)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if self.isEdit {
                self.lbl_title.text = "Edit Service"
                self.btn_service.setTitle("Edit Service", for: .normal)
                self.setData()
            } else {
                self.lbl_title.text = "Add Service"
                self.btn_service.setTitle("Add Service", for: .normal)
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: Button Action
    @IBAction func act_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func act_cancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func act_addEditService(_ sender: GradientButton) {
        if self.txt_serviceName.text!.isEmpty {
            self.showToast(message: "Please enter service name")
        } else if self.txt_mainCategory.text!.isEmpty {
            self.showToast(message: "Please select category")
        } else if self.txt_serviceFor.text!.isEmpty {
            self.showToast(message: "Please select service for")
        } else if self.txt_serviceDuration.text!.isEmpty {
            self.showToast(message: "Please select service time")
        } else if self.txt_priceType.text!.isEmpty {
            self.showToast(message: "Please select price type")
        } else if self.txt_regulatPrice.text!.isEmpty {
            self.showToast(message: "Please enter price")
        } else {
            if isEdit {
                self.updateServiceData(serviceId: "\(self.dictService?.id ?? 0)")
            } else {
                self.addServiceData()
            }
        }
    }
    
    @IBAction func act_vendorOnly(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "rdCheck") {
            sender.setImage(UIImage(named: "rdUncheck"), for: .normal)
        } else if sender.currentImage == UIImage(named: "rdUncheck") {
            sender.setImage(UIImage(named: "rdCheck"), for: .normal)
        }
    }
    
    @IBAction func act_needToContact(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "rdCheck") {
            sender.setImage(UIImage(named: "rdUncheck"), for: .normal)
        } else if sender.currentImage == UIImage(named: "rdUncheck") {
            sender.setImage(UIImage(named: "rdCheck"), for: .normal)
        }
    }
    
    @IBAction func act_patchTest(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "rdCheck") {
            sender.setImage(UIImage(named: "rdUncheck"), for: .normal)
        } else if sender.currentImage == UIImage(named: "rdUncheck") {
            sender.setImage(UIImage(named: "rdCheck"), for: .normal)
        }
    }
    
    //MARK: Set Data
    func setData() {
//        self.txt_serviceName.showLabel()
        self.txt_serviceName.setText(self.dictService?.service ?? "")
        self.txt_mainCategory.setText(self.dictService?.category ?? "")
        self.parentId = self.dictService?.category_id ?? 0
        self.txt_serviceFor.setText(self.dictService?.service_for ?? "")
        self.txt_description.text = self.dictService?.description ?? ""
        self.selectedDuration = self.dictService?.duration ?? 0
        self.txt_priceType.setText(self.dictService?.price_type ?? "")
        self.txt_regulatPrice.setText(self.dictService?.price ?? "")
        self.txt_salesPrice.setText(self.dictService?.sale_price ?? "")
        if let venderOnly = self.dictService?.isVendorOnly, venderOnly == 1 {
            self.btn_vendorOnly.setImage(UIImage(named: "rdCheck"), for: .normal)
        } else {
            self.btn_vendorOnly.setImage(UIImage(named: "rdUncheck"), for: .normal)
        }
        if let contactSalon = self.dictService?.conatctSalon, contactSalon == 1 {
            self.btn_needToContact.setImage(UIImage(named: "rdCheck"), for: .normal)
        } else {
            self.btn_needToContact.setImage(UIImage(named: "rdUncheck"), for: .normal)
        }
        if let patchTest = self.dictService?.patchTest, patchTest == 1 {
            self.btn_patchTest.setImage(UIImage(named: "rdCheck"), for: .normal)
        } else {
            self.btn_patchTest.setImage(UIImage(named: "rdUncheck"), for: .normal)
        }
        
        
    }


    @objc func openStaffPopup() {
        if !self.selectedStaffList.isEmpty {
            for staff in self.selectedStaffList {
                selected.append("\(staff.id ?? 0)")
            }
        }
        let popup = PreferredStaffPopupViewController()
        popup.staffList = staffList
        popup.selectedStaff = selected
        popup.onComplete = { selected in
            print("Selected staff: \(selected)")
            self.selectedStaffList = []
            self.selected = selected
            for staff in self.staffList {
                if selected.contains("\(staff.id ?? 0)") {
                    self.selectedStaffList.append(staff)
                }
            }
            self.refreshTags()
        }
        self.present(popup, animated: true)
    }

    func refreshTags() {
        tagHolderView.subviews.forEach { $0.removeFromSuperview() }
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        let padding: CGFloat = 8
        let maxWidth = tagHolderView.frame.width
        
        for tag in selectedStaffList {
            let name = (tag.firstName ?? "") + " " + (tag.lastName ?? "")
            let tagView = TagView(text: name)
            tagView.onRemove = {
                if let index = self.selectedStaffList.firstIndex(where: { $0.id == tag.id }) {
                    self.selectedStaffList.remove(at: index)
                }
                self.refreshTags()
            }
            let size = tagView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            if x + size.width > maxWidth {
                x = 0
                y += size.height + padding
            }
            tagView.frame = CGRect(x: x, y: y, width: size.width, height: size.height)
            tagHolderView.addSubview(tagView)
            x += size.width + padding
        }
        
        // Adjust container height if needed
        let totalHeight = y + 40
        tagHolderView.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
    }
    
    
    //MARK: Load Api
    func loadDuationData() {
    
        APIService.shared.getDurationDetails() { staffResult in
            guard let model = staffResult else {
                return
            }
            let newItems = model.data
            if !newItems.isEmpty {
                self.durationList = newItems
                var options: [String] = []
                for dur in self.durationList {
                    options.append(dur.label)
                }
                DropdownManager.shared.setupDropdown(
                    for: self.txt_serviceDuration,
                    in: self.view,
                    with: options
                ) { [weak self] selected in
                    guard let self = self else { return }
                    self.txt_serviceDuration.setText(selected)
                }
                if self.isEdit {
                    for data in self.durationList {
                        if data.duration == "\(self.selectedDuration)" {
                            self.txt_serviceDuration.setText(data.label)
                        }
                    }
                }
            }
            
        }
    }
    
    func loadCategoryData() {
    
        APIService.shared.getselectMainCategory() { staffResult in
            guard let model = staffResult else {
                return
            }
            let newItems = model.data
            if !newItems.isEmpty {
                self.categoryList = newItems
                var options: [String] = []
                for cate in self.categoryList {
                    options.append(cate.service_name)
                }
                DropdownManager.shared.setupDropdown(
                    for: self.txt_mainCategory,
                    in: self.view,
                    with: options
                ) { [weak self] selected in
                    guard let self = self else { return }
                    self.txt_mainCategory.setText(selected)
                }
                if self.isEdit {
                    for data in self.categoryList {
                        if data.id == self.parentId {
                            self.txt_mainCategory.setText(data.service_name)
                        }
                    }
                }
            }
            
        }
    }
    
    func loadData() {
    
        APIService.shared.getteamDetails(page: "1", limit: "100000", vendorId: LocalData.userId, search: "") { staffResult in
            guard let model = staffResult else {
                return
            }

            let newItems = model.data ?? []
            self.staffList += newItems
            if self.isEdit {
                if let staffIds = self.dictService?.staff_id, !staffIds.isEmpty {
                    let list = staffIds.components(separatedBy: ",")
                    self.selected = list
                    if !self.selected.isEmpty {
                        for staff in self.staffList {
                            if self.selected.contains("\(staff.id ?? 0)") {
                                self.selectedStaffList.append(staff)
                            }
                        }
                        self.refreshTags()
                    }
                }
            }
        }
    }
    
    func addServiceData() {
        for data in durationList {
            if data.label == self.txt_serviceDuration.text {
                selectedDuration = Int(data.duration) ?? 0
            }
        }
        for data in categoryList {
            if data.service_name == self.txt_mainCategory.text ?? "" {
                parentId = data.id
            }
        }
        
        let staffIds = !self.selected.isEmpty ? self.selected.joined(separator: ",") : ""
        APIService.shared.addServiceData(serviceName: self.txt_serviceName.text ?? "", parentId: parentId, vendorId: LocalData.userId, description: self.txt_description.text, serviceFor: self.txt_serviceFor.text ?? "", duration: selectedDuration, priceType: self.txt_priceType.text ?? "", price: Int(self.txt_regulatPrice.text ?? "") ?? 0, salePrice: Int(self.txt_salesPrice.text ?? "") ?? 0, vendorOnly: btn_vendorOnly.currentImage == UIImage(named: "rdCheck") ? "1" : "0", contactSalon: btn_needToContact.currentImage == UIImage(named: "rdCheck") ? "1" : "0", testRequired: btn_patchTest.currentImage == UIImage(named: "rdCheck") ? "1" : "0", staffId: staffIds) { staffResult in
            guard let model = staffResult else {
                return
            }

            if model.error == "" || model.error == nil {
                DispatchQueue.main.async {
                    // safe UI code here
                    self.showToast(message: "Service added successfully")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.show_alert(msg: model.error!, title: "Add Service")
            }
        }
    }
    
    
    func updateServiceData(serviceId: String) {
        for data in durationList {
            if data.label == self.txt_serviceDuration.text {
                selectedDuration = Int(data.duration) ?? 0
            }
        }
        for data in categoryList {
            if data.id == Int(self.txt_mainCategory.text ?? "") ?? 0 {
                parentId = data.id
            }
        }
        
        let staffIds = !self.selected.isEmpty ? self.selected.joined(separator: ",") : ""
        APIService.shared.updateServiceData(serviceName: self.txt_serviceName.text ?? "", parentId: parentId, vendorId: LocalData.userId, description: self.txt_description.text, serviceFor: self.txt_serviceFor.text ?? "", duration: selectedDuration, priceType: self.txt_priceType.text ?? "", price: Int(self.txt_regulatPrice.text ?? "") ?? 0, salePrice: Int(self.txt_salesPrice.text ?? "") ?? 0, vendorOnly: btn_vendorOnly.currentImage == UIImage(named: "rdCheck") ? "1" : "0", contactSalon: btn_needToContact.currentImage == UIImage(named: "rdCheck") ? "1" : "0", testRequired: btn_patchTest.currentImage == UIImage(named: "rdCheck") ? "1" : "0", staffId: staffIds, serviceId: serviceId) { staffResult in
            guard let model = staffResult else {
                return
            }

            if model.error == "" || model.error == nil {
                DispatchQueue.main.async {
                    // safe UI code here
                    self.showToast(message: model.data)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.show_alert(msg: model.error!, title: "Update Service")
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


extension AddServiceVC: UITextFieldDelegate {
    
    
    
}
