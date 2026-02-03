//
//  AddServiceVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 03/07/25.
//

import UIKit
import DropDown

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
    
    @IBOutlet weak var lbl_vendorOnly: UILabel!
    
    @IBOutlet weak var txt_TypeofService: TextInputLayout!
    @IBOutlet weak var txt_SecondaryType: TextInputLayout!
    @IBOutlet weak var txt_ParentService: TextInputLayout!
    @IBOutlet weak var txt_Resource: TextInputLayout!
    
    
    //MARK: - View
    
    @IBOutlet weak var vw_TypeOfService: UIView!
    @IBOutlet weak var vw_SecondaryType: UIView!
    @IBOutlet weak var vw_MainCategory: UIView!
    @IBOutlet weak var vw_ServiceFor: UIView!
    @IBOutlet weak var vw_SelectPreferredStaff: UIView!
    @IBOutlet weak var lbl_Line: UILabel!
    @IBOutlet weak var vw_ServiceDuration: UIView!
    @IBOutlet weak var vw_Price: UIView!
    @IBOutlet weak var vw_RegularPrice: UIView!
    @IBOutlet weak var vw_VendorOnly: UIView!
    @IBOutlet weak var vw_PatchTest: UIView!
    @IBOutlet weak var vw_Cancel: UIView!
    @IBOutlet weak var vw_ParentService: UIView!
    @IBOutlet weak var vw_Resourc: UIView!
    
    @IBOutlet weak var lbl_AllField: UILabel!
    
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
    var resoucreId = 0
    
    
    var hasSubService = "0"
    var isSubService = "0"
    var categoryParId = "0"
    
//    var arr_ServiceType = ["Service Without Sub Type","Service With Sub Type"]
    
    var arr_ServiceType: [String] {
        return [
            NSLocalizedString("Service Without Sub Type", comment: ""),
            NSLocalizedString("Service With Sub Type", comment: "")
        ]
    }
    var serviceTypeKey = ["Service Without Sub Type","Service With Sub Type"]
    var selectedService = "Service Without Sub Type"
    
    
    
//    var arr_SecondaryType = ["Main Service","Sub Service"]
    var arr_SecondaryType: [String] {
        return [
            NSLocalizedString("Main Service", comment: ""),
            NSLocalizedString("Sub Service", comment: "")
        ]
    }
    var SecondaryType = ["Main Service","Sub Service"]
    var selectedSecondary = "Main Service"
    
    
//    var arr_Options = ["Male","Female","Unisex"]
    var arr_Options: [String] {
        return [
            NSLocalizedString("Male", comment: ""),
            NSLocalizedString("Female", comment: ""),
            NSLocalizedString("Unisex", comment: "")
        ]
    }
    var OptionsType = ["Male","Female","Unisex"]
    var selectedOption = "Male"
    
    var arr_PriceType: [String] {
        return [
            NSLocalizedString("Starts From", comment: ""),
            NSLocalizedString("Fixed", comment: "")
        ]
    }
    
    var PriceType = ["Starts From","Fixed"]
    var selectedPriceType = "Starts From"
    
    var resourcList: [InventoryData] = []
    var mainServices: [ServiceDatas] = []
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        get_CategoryList()
        get_CategoryList()
        loadResourceData()
        call_MainCategory()
        setRegularFont()
        /*if let customFont = UIFont(name: "Lato-Medium", size: 22.0) {
            lbl_vendorOnly.font = customFont
            
        }*/
        lbl_vendorOnly.text = NSLocalizedString("Vendor Only", comment: "")
        lbl_vendorOnly?.font = UIFont(name: "Lato-Bold", size: 24.0)!
        self.lbl_AllField.text = NSLocalizedString("All fields marked with an asterisk (*) are required.", comment: "")
        self.loadDuationData()
        self.loadCategoryData()
        self.loadData()
        staffTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openStaffPopup))
        staffTextField.addGestureRecognizer(tapGesture)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if self.isEdit {
                self.lbl_title.text = NSLocalizedString("Edit Service", comment: "")
                self.setData()
                self.btn_service.setTitle(NSLocalizedString("Update Service",comment: ""), for: .normal)
            } else {
                self.txt_TypeofService.text = self.arr_ServiceType[0]
                self.selectedService = self.serviceTypeKey.first ?? ""
                
                self.txt_SecondaryType.text = self.arr_SecondaryType[0]
                self.selectedSecondary = self.SecondaryType.first ?? ""
                
                self.txt_serviceFor.text = self.arr_Options[0]
                self.selectedOption = self.OptionsType.first ?? ""
                
                self.lbl_title.text = NSLocalizedString("Add Service", comment: "")
                self.btn_service.setTitle(NSLocalizedString("Add Service",comment: ""), for: .normal)
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
        if isEdit {
            if txt_TypeofService.text == NSLocalizedString("Service Without Sub Type",comment: ""){
                if self.txt_serviceName.text!.isEmpty {
                    self.alertWithMessageOnly(NSLocalizedString("Please enter service name",comment: ""))
                } else if self.txt_mainCategory.text!.isEmpty {
                    self.alertWithMessageOnly(NSLocalizedString("Please select category",comment: ""))
                } else if self.txt_serviceFor.text!.isEmpty {
                    self.alertWithMessageOnly(NSLocalizedString("Please select service for",comment: ""))
                } else if self.txt_serviceDuration.text!.isEmpty {
                    self.alertWithMessageOnly(NSLocalizedString("Please select service time",comment: ""))
                } else if self.txt_priceType.text!.isEmpty {
                    self.alertWithMessageOnly(NSLocalizedString("Please select price type",comment: ""))
                } else if self.txt_regulatPrice.text!.isEmpty {
                    self.alertWithMessageOnly(NSLocalizedString("Please enter price",comment: ""))
                }else{
                    self.updateServiceData(serviceId: "\(self.dictService?.id ?? 0)")
                }
            }else{
                if self.txt_serviceName.text!.isEmpty {
                    self.alertWithMessageOnly(NSLocalizedString("Please enter service name",comment: ""))
                } else if self.txt_mainCategory.text!.isEmpty {
                    self.alertWithMessageOnly(NSLocalizedString("Please select category",comment: ""))
                } else if self.txt_Resource.text!.isEmpty {
                    self.alertWithMessageOnly(NSLocalizedString("Please select Resource",comment: ""))
                }else{
                    self.updateServiceData(serviceId: "\(self.dictService?.id ?? 0)")
                }
            }
        }else{
            if txt_TypeofService.text == NSLocalizedString("Service Without Sub Type",comment: ""){
                if self.txt_serviceName.text!.isEmpty {
                    self.alertWithMessageOnly(NSLocalizedString("Please enter service name",comment: ""))
                } else if self.txt_mainCategory.text!.isEmpty {
                    self.alertWithMessageOnly(NSLocalizedString("Please select category",comment: ""))
                } else if self.txt_serviceFor.text!.isEmpty {
                    self.alertWithMessageOnly(NSLocalizedString("Please select service for",comment: ""))
                } else if self.txt_serviceDuration.text!.isEmpty {
                    self.alertWithMessageOnly(NSLocalizedString("Please select service time",comment: ""))
                } else if self.txt_priceType.text!.isEmpty {
                    self.alertWithMessageOnly(NSLocalizedString("Please select price type",comment: ""))
                } else if self.txt_regulatPrice.text!.isEmpty {
                    self.alertWithMessageOnly(NSLocalizedString("Please enter price",comment: ""))
                }else{
                    self.addServiceData()
                }
            }else{
                if self.txt_serviceName.text!.isEmpty {
                    self.alertWithMessageOnly(NSLocalizedString("Please enter service name",comment: ""))
                } else if self.txt_mainCategory.text!.isEmpty {
                    self.alertWithMessageOnly(NSLocalizedString("Please select category",comment: ""))
                } else if self.txt_Resource.text!.isEmpty {
                    self.alertWithMessageOnly(NSLocalizedString("Please select Resource",comment: ""))
                }else{
                    self.addServiceData()
                }
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
    
    @IBAction func btn_StaffSelection(_ sender: Any) {
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
    
    @IBAction func btn_TypeOfService(_ sender: Any) {
        openTypeofService()
    }
    
    @IBAction func btn_TypeSecondary(_ sender: Any) {
        openSecondaryType()
    }
    
    @IBAction func btn_ParentService(_ sender: Any) {
        openParentService()
    }
    
    @IBAction func btn_ResourceService(_ sender: Any) {
        openResourcList()
//        loadResourceData()
    }
    
    @IBAction func btn_ServiceFor(_ sender: Any) {
        openSalonType()
    }
    
    @IBAction func btn_MainCategory(_ sender: Any) {
        openMainCategory()
    }
    
    
    @IBAction func btn_PriceType(_ sender: Any) {
        openPriceType()
    }
    
    //MARK: Set Data
    func setRegularFont(){
        if let customFont = UIFont(name: "Lato-Regular", size: 20.0) {
            txt_serviceName.font = customFont
            txt_mainCategory.font = customFont
            txt_serviceFor.font = customFont
            txt_serviceDuration.font = customFont
            txt_priceType.font = customFont
            txt_regulatPrice.font = customFont
            txt_salesPrice.font = customFont
            staffTextField.font = customFont
            txt_TypeofService.font = customFont
            txt_SecondaryType.font = customFont
            txt_ParentService.font = customFont
            txt_Resource.font = customFont
        }
    }
    
    func setData() {
//        self.txt_serviceName.showLabel()
        self.txt_serviceName.setText(self.dictService?.service ?? "")
        self.txt_mainCategory.setText(self.dictService?.category ?? "")
        self.parentId = self.dictService?.category_id ?? 0
        self.txt_description.text = self.dictService?.description ?? ""
        self.selectedDuration = self.dictService?.duration ?? 0
        self.txt_regulatPrice.setText(self.dictService?.price ?? "")
        self.txt_regulatPrice.setText(self.dictService?.price ?? "")
        self.txt_salesPrice.setText(String(self.dictService?.sale_price ?? "0"))
        print("Resource :\(Int(self.dictService?.resource_id ?? "") ?? 0)")
        print("resoucreId :\(resoucreId)")
        self.resoucreId = Int(self.dictService?.resource_id ?? "") ?? 0
        if dictService?.price_type == "Starts From"{
            selectedPriceType = "Starts From"
            self.txt_priceType.text = NSLocalizedString("Starts From", comment: "")
        }else if dictService?.price_type == "Fixed"{
            selectedPriceType = "Fixed"
            self.txt_priceType.text = NSLocalizedString("Fixed", comment: "")
        }
        
        if dictService?.service_for == "Male"{
            selectedOption = "Male"
            self.txt_serviceFor.text = NSLocalizedString("Male",comment: "")
        }else if dictService?.service_for == "Female"{
            selectedOption = "Female"
            self.txt_serviceFor.text = NSLocalizedString("Female",comment: "")
        }else if dictService?.service_for == "Unisex"{
            selectedOption = "Unisex"
            self.txt_serviceFor.text = NSLocalizedString("Unisex",comment: "")
        }
        
        if dictService?.has_sub_service == 0 {
            self.selectedService = "Service Without Sub Type"
            self.txt_TypeofService.text = NSLocalizedString("Service Without Sub Type",comment: "")
            self.vw_TypeOfService.isHidden = false
            self.vw_SecondaryType.isHidden = false
            self.vw_MainCategory.isHidden = false
            self.vw_ParentService.isHidden = true
            self.txt_description.isHidden = false
            self.vw_ServiceFor.isHidden = false
            self.vw_SelectPreferredStaff.isHidden = false
            self.lbl_Line.isHidden = false
            self.vw_ServiceDuration.isHidden = false
            self.vw_Price.isHidden = false
            self.vw_RegularPrice.isHidden = false
            self.vw_VendorOnly.isHidden = false
            self.vw_PatchTest.isHidden = false
            self.vw_Cancel.isHidden = false
        }else{
            self.selectedService = "Service With Sub Type"
            self.txt_TypeofService.text = NSLocalizedString("Service With Sub Type",comment: "")
            self.vw_TypeOfService.isHidden = false
            self.vw_SecondaryType.isHidden = true
            self.vw_ParentService.isHidden = true
            self.vw_MainCategory.isHidden = false
            self.txt_description.isHidden = false
            self.vw_ServiceFor.isHidden = true
            self.vw_SelectPreferredStaff.isHidden = true
            self.lbl_Line.isHidden = true
            self.vw_ServiceDuration.isHidden = true
            self.vw_Price.isHidden = true
            self.vw_RegularPrice.isHidden = true
            self.vw_VendorOnly.isHidden = true
            self.vw_PatchTest.isHidden = true
            self.vw_Cancel.isHidden = false
        }
        
        if dictService?.is_sub_service == 0 {
            selectedSecondary = "Main Service"
            self.txt_SecondaryType.text = NSLocalizedString("Main Service", comment: "")
            vw_MainCategory.isHidden = false
            vw_ParentService.isHidden = true
        }else{
            selectedSecondary = "Sub Service"
            self.txt_SecondaryType.text = NSLocalizedString("Sub Service", comment: "")
            vw_ParentService.isHidden = false
            vw_MainCategory.isHidden = true
        }
        
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

    func openSalonType() {
        let slotDuration = DropDown()
        slotDuration.anchorView = txt_serviceFor
        slotDuration.bottomOffset = CGPoint(x: 0, y:(slotDuration.anchorView?.plainView.bounds.height)!)
        slotDuration.direction = .bottom
        slotDuration.dataSource = arr_Options
        slotDuration.cellHeight = 35
        slotDuration.show()
        slotDuration.textFont = UIFont(name: "Lato-Regular", size: 18.0)!
        slotDuration.backgroundColor = .white
        slotDuration.selectionAction = {  [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            selectedOption = self.OptionsType[index]
            self.txt_serviceFor.text = NSLocalizedString(item, comment: "")
            if selectedOption == "Male"{
                selectedOption = "Male"
            }else if selectedOption == "Female"{
                selectedOption = "Female"
            }else if selectedOption == "Unisex"{
                selectedOption = "Unisex"
            }
        }
    }
    
    func openPriceType() {
        let slotDuration = DropDown()
        slotDuration.anchorView = txt_priceType
        slotDuration.bottomOffset = CGPoint(x: 0, y:(slotDuration.anchorView?.plainView.bounds.height)!)
        slotDuration.direction = .bottom
        slotDuration.dataSource = arr_PriceType
        slotDuration.cellHeight = 35
        slotDuration.show()
        slotDuration.textFont = UIFont(name: "Lato-Regular", size: 18.0)!
        slotDuration.backgroundColor = .white
        slotDuration.selectionAction = {  [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            selectedPriceType = self.PriceType[index]
            self.txt_priceType.text = NSLocalizedString(item, comment: "")
            if selectedPriceType == "Starts From"{
                selectedPriceType = "Starts From"
            }else if selectedPriceType == "Fixed"{
                selectedPriceType = "Fixed"
            }
        }
    }
    
    
    func openTypeofService() {
        let TypeofService = DropDown()
        TypeofService.anchorView = txt_TypeofService
        TypeofService.bottomOffset = CGPoint(x: 0, y:(TypeofService.anchorView?.plainView.bounds.height)!)
        TypeofService.direction = .bottom
        TypeofService.dataSource = arr_ServiceType
        TypeofService.textFont = UIFont(name: "Lato-Regular", size: 18.0)!
        TypeofService.cellHeight = 35
        TypeofService.backgroundColor = .white
        TypeofService.show()
        
        TypeofService.selectionAction = {  [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            selectedService = self.serviceTypeKey[index]
            self.txt_TypeofService.text = NSLocalizedString(item, comment: "")
            if selectedService == "Service With Sub Type"{
                self.vw_TypeOfService.isHidden = false
                self.vw_SecondaryType.isHidden = true
                self.vw_ParentService.isHidden = true
                self.vw_MainCategory.isHidden = false
                self.txt_description.isHidden = false
                self.vw_ServiceFor.isHidden = true
                self.vw_SelectPreferredStaff.isHidden = true
                self.lbl_Line.isHidden = true
                self.vw_ServiceDuration.isHidden = true
                self.vw_Price.isHidden = true
                self.vw_RegularPrice.isHidden = true
                self.vw_VendorOnly.isHidden = true
                self.vw_PatchTest.isHidden = true
                self.vw_Cancel.isHidden = false
            }else{
                self.vw_TypeOfService.isHidden = false
                self.vw_SecondaryType.isHidden = false
                self.vw_MainCategory.isHidden = false
                self.vw_ParentService.isHidden = true
                self.txt_description.isHidden = false
                self.vw_ServiceFor.isHidden = false
                self.vw_SelectPreferredStaff.isHidden = false
                self.lbl_Line.isHidden = false
                self.vw_ServiceDuration.isHidden = false
                self.vw_Price.isHidden = false
                self.vw_RegularPrice.isHidden = false
                self.vw_VendorOnly.isHidden = false
                self.vw_PatchTest.isHidden = false
                self.vw_Cancel.isHidden = false
            }
        }
    }
    
    func openSecondaryType() {
        let SecondaryType = DropDown()
        SecondaryType.anchorView = txt_SecondaryType
        SecondaryType.bottomOffset = CGPoint(x: 0, y:(SecondaryType.anchorView?.plainView.bounds.height)!)
        SecondaryType.direction = .bottom
        SecondaryType.dataSource = arr_SecondaryType
        SecondaryType.textFont = UIFont(name: "Lato-Regular", size: 18.0)!
        SecondaryType.cellHeight = 35
        SecondaryType.backgroundColor = .white
        SecondaryType.show()
        
        SecondaryType.selectionAction = {  [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.txt_SecondaryType.text = item
            if item == "Sub Service"{
                vw_ParentService.isHidden = false
                vw_MainCategory.isHidden = true
            }else{
                vw_MainCategory.isHidden = false
                vw_ParentService.isHidden = true
            }
        }
    }
    
    func openParentService() {
        var itemArray: [String] = []

        for i in self.mainServices {
            itemArray.append(i.service_name)
        }
        
        let ParentService = DropDown()
        ParentService.anchorView = txt_ParentService
        ParentService.bottomOffset = CGPoint(x: 0, y:(ParentService.anchorView?.plainView.bounds.height)!)
        ParentService.direction = .bottom
        ParentService.dataSource = itemArray
        ParentService.textFont = UIFont(name: "Lato-Regular", size: 18.0)!
        ParentService.cellHeight = 35
        ParentService.backgroundColor = .white
        ParentService.show()
        
        ParentService.selectionAction = {  [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.txt_ParentService.text = item
        }
    }

    
    func openResourcList() {
       var itemArray: [String] = []

       for i in self.resourcList {
           itemArray.append("\(i.name) - \(i.qty)")
       }

       let slotDuration = DropDown()
       slotDuration.anchorView = txt_Resource
       slotDuration.bottomOffset = CGPoint(x: 0, y: (slotDuration.anchorView?.plainView.bounds.height) ?? 0)
       slotDuration.direction = .bottom
       slotDuration.textFont = UIFont(name: "Lato-Regular", size: 18.0)!
       slotDuration.backgroundColor = .white
       slotDuration.dataSource = itemArray
       slotDuration.cellHeight = 35
       slotDuration.show()

       slotDuration.selectionAction = { [unowned self] (index: Int, item: String) in
        let selectedResource = self.resourcList[index]
            txt_Resource.text = "\(selectedResource.name) - \(selectedResource.qty)"
            resoucreId = selectedResource.id
       }
        
    }
    
    @objc func openStaffPopup() {
        if selectedStaffList.isEmpty {
                selected.removeAll()
            } else {
                // Build fresh selected IDs from selectedStaffList
                selected = selectedStaffList.compactMap { "\($0.id ?? 0)" }
            }
        
        /*if !self.selectedStaffList.isEmpty {
            for staff in self.selectedStaffList {
                selected.append("\(staff.id ?? 0)")
            }
        }*/
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
        showLoader()
        APIService.shared.getDurationDetails() { staffResult in
            self.hideLoader()
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
    
    
    func openDuationData() {
       var itemArray: [String] = []

       for i in self.durationList {
           itemArray.append("\(i.label)")
       }

       let slotDuration = DropDown()
       slotDuration.anchorView = txt_serviceDuration
       slotDuration.bottomOffset = CGPoint(x: 0, y: (slotDuration.anchorView?.plainView.bounds.height) ?? 0)
       slotDuration.direction = .bottom
       slotDuration.textFont = UIFont(name: "Lato-Regular", size: 18.0)!
       slotDuration.backgroundColor = .white
       slotDuration.dataSource = itemArray
       slotDuration.cellHeight = 35
       slotDuration.show()

       slotDuration.selectionAction = { [unowned self] (index: Int, item: String) in
        let selectedResource = self.durationList[index]
            txt_serviceDuration.text = "\(selectedResource.label)"
//            resoucreId = selectedResource.label
       }
        
    }
    
    func loadCategoryData() {
        showLoader()
        APIService.shared.getSelectMainCategory() { staffResult in
            self.hideLoader()
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
    
    func call_MainCategory() {
        showLoader()
        APIService.shared.getSelectMainCategory { result in
            self.hideLoader()
            if result?.data != nil {
                self.categoryList = result!.data
            }else{
                self.alertWithMessageOnly(NSLocalizedString("Failed to get vendor currency",comment: ""))
            }
        }
    }
    
    func openMainCategory() {
       var itemArray: [String] = []

       for i in self.categoryList {
           itemArray.append(i.service_name)
       }

       let slotDuration = DropDown()
        slotDuration.anchorView = txt_mainCategory
        slotDuration.bottomOffset = CGPoint(x: 0, y: (slotDuration.anchorView?.plainView.bounds.height) ?? 0)
        slotDuration.direction = .bottom
        slotDuration.dataSource = itemArray
        slotDuration.cellHeight = 35
        slotDuration.show()
        slotDuration.textFont = UIFont(name: "Lato-Regular", size: 18.0)!
        slotDuration.backgroundColor = .white
        slotDuration.selectionAction = { [unowned self] (index: Int, item: String) in
           txt_mainCategory.text = item
           for i in self.categoryList {
               if i.service_name == item {
                   txt_mainCategory.text = i.service_name
                   parentId = i.id
//                   LocalData.currency = i.currency
//                   LocalData.selectedCurrencyCode = i.currency_code
//                   selectedCurrencyCode = i.currency_code
//                   symbol = i.symbol
                   /*SharedPrefs.setCurrency(i.currency_code)
                   SharedPrefs.setSymbol(i.symbol)*/
                   break
               }
           }
       }
    }
    
    func get_CategoryList() {
        self.showLoader()
        APIService.shared.fetchMainServices { businessResult in
            self.hideLoader()
            guard let businessModel = businessResult else {
                return
            }
            self.mainServices = businessModel.data
            print("mainServices:- \(self.mainServices)")
        }
    }
    
    
    /*func ResourceDetails(){
        APIService.shared.ResourceDetails(vendorId: LocalData.userId) { ResourceDetails in
            self.hideLoader()
            self.resourcList = ResourceDetails?.data ?? []
        }
        if self.isEdit {
            for i in self.resourcList {
                if i.id == Int(self.resoucreId) {
                    self.txt_Resource.setText(i.name)
                }
            }
        }
    }*/
    
    func loadResourceData() {
        showLoader()
        APIService.shared.ResourceDetails(vendorId: LocalData.userId) { ResourceDetails in
            self.hideLoader()
            guard let model = ResourceDetails else {
                return
            }
            let newItems = model.data
            
            if !newItems.isEmpty {
                self.resourcList = ResourceDetails?.data ?? []
                var options: [String] = []
                for i in self.resourcList {
                    options.append("\(i.name) - \(i.qty)")
                }
                DropdownManager.shared.setupDropdown(
                    for: self.txt_Resource,
                    in: self.view,
                    with: options
                ) { [weak self] selected in
                    guard let self = self else { return }
                    self.txt_Resource.setText(selected)
                }
                if self.isEdit {
                    for data in self.resourcList {
                        if data.id == self.resoucreId {
                            self.txt_Resource.setText("\(data.name) - \(data.qty)")
                            
                        }
                    }
                }
            }
        }
    }
    
    
    func loadData() {
    showLoader()
        APIService.shared.getteamDetails(page: "1", limit: "100000", vendorId: LocalData.userId, search: "") { staffResult in
            self.hideLoader()
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
        
        for data in resourcList {
            if data.id == Int(self.txt_Resource.text ?? "") ?? 0 {
                resoucreId = data.id
            }
        }
        
        if (txt_TypeofService.text == NSLocalizedString("Service Without Sub Type",comment: "")){
            hasSubService = "0"

            if (self.txt_SecondaryType.text == NSLocalizedString("Main Service",comment: "")){
                isSubService = "0"
//                categoryParId = servicesMainList[binding.spnCategory.selectedItemPosition].id.toString()
            }else if (self.txt_SecondaryType.text == NSLocalizedString("Sub Service",comment: "")){
                isSubService = "1"
//                categoryParId = subServiceMainList[binding.spnCategory.selectedItemPosition].id.toString()
            }

        }else if (txt_TypeofService.text == NSLocalizedString("Service With Sub Type",comment: "")){
            hasSubService = "1"
//            categoryParId = servicesMainList[binding.spnCategory.selectedItemPosition].id.toString()
        }
        showLoader()
        var price = self.txt_regulatPrice.text
        if price == "" {
            price = "0"
        }
        
        var salePrice = self.txt_salesPrice.text
        if salePrice == "" {
            salePrice = "0"
        }
        
        
        let staffIds = !self.selected.isEmpty ? self.selected.joined(separator: ",") : ""
        APIService.shared.addServiceData(serviceName: self.txt_serviceName.text ?? "", parentId: parentId, vendorId: LocalData.userId, description: self.txt_description.text, serviceFor: selectedOption, duration: selectedDuration, priceType: selectedPriceType, price: price ?? "0", salePrice: salePrice ?? "0", vendorOnly: btn_vendorOnly.currentImage == UIImage(named: "rdCheck") ? "1" : "0", contactSalon: btn_needToContact.currentImage == UIImage(named: "rdCheck") ? "1" : "0", testRequired: btn_patchTest.currentImage == UIImage(named: "rdCheck") ? "1" : "0", staffId: staffIds,has_sub_service: hasSubService,is_sub_service: isSubService,resource_id: "\(resoucreId)") { staffResult in
            self.hideLoader()
            guard let model = staffResult else {
                return
            }

            if model.error == "" || model.error == nil {
                DispatchQueue.main.async {
                    self.alertWithMessageOnly(NSLocalizedString("Service added successfully",comment: ""))
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.alertWithMessageOnly(NSLocalizedString("Failed to insert service",comment: ""))
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
        
        for data in resourcList {
            if data.id == Int(self.txt_Resource.text ?? "") ?? 0 {
                resoucreId = data.id
            }
        }
        
        if (txt_TypeofService.text == NSLocalizedString("Service Without Sub Type",comment: "")){
            hasSubService = "0"

            if (self.txt_SecondaryType.text == NSLocalizedString("Main Service", comment: "")){
                isSubService = "0"
//                categoryParId = servicesMainList[binding.spnCategory.selectedItemPosition].id.toString()
            }else if (self.txt_SecondaryType.text == NSLocalizedString("Sub Service", comment: "")){
                isSubService = "1"
//                categoryParId = subServiceMainList[binding.spnCategory.selectedItemPosition].id.toString()
            }

        }else if (txt_TypeofService.text == NSLocalizedString("Service With Sub Type",comment: "")){
            hasSubService = "1"
//            categoryParId = servicesMainList[binding.spnCategory.selectedItemPosition].id.toString()
        }
        
        showLoader()
        
        var price = self.txt_regulatPrice.text
        if price == "" {
            price = "0"
        }
        
        var salePrice = self.txt_salesPrice.text
        if salePrice == "" {
            salePrice = "0"
        }
        
        let staffIds = !self.selected.isEmpty ? self.selected.joined(separator: ",") : ""
        APIService.shared.updateServiceData(serviceName: self.txt_serviceName.text ?? "", parentId: parentId, vendorId: LocalData.userId, description: self.txt_description.text, serviceFor: selectedOption, duration: selectedDuration, priceType: selectedPriceType, price: price ?? "0", salePrice: salePrice ?? "0", vendorOnly: btn_vendorOnly.currentImage == UIImage(named: "rdCheck") ? "1" : "0", contactSalon: btn_needToContact.currentImage == UIImage(named: "rdCheck") ? "1" : "0", testRequired: btn_patchTest.currentImage == UIImage(named: "rdCheck") ? "1" : "0", staffId: staffIds, serviceId: serviceId,has_sub_service: hasSubService,is_sub_service: isSubService,resource_id: "\(resoucreId)") { staffResult in
            self.hideLoader()
            guard let model = staffResult else {
                return
            }

            if model.error == "" || model.error == nil {
                DispatchQueue.main.async {
                    self.alertWithMessageOnly(NSLocalizedString("Service updated successfully",comment: ""))
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.alertWithMessageOnly(NSLocalizedString("Failed to edit service",comment: ""))
            }
        }
    }
}


extension AddServiceVC: UITextFieldDelegate {
}
