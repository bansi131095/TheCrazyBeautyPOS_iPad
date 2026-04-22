//
//  AddAddon_VC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 13/02/26.
//

import UIKit

class AddAddon_VC: UIViewController {

    
    @IBOutlet weak var lbl_Addon: UILabel!
    @IBOutlet weak var txt_Name: TextInputLayout!
    @IBOutlet weak var txt_Price: TextInputLayout!
    @IBOutlet weak var txt_Duration: TextInputLayout!
    @IBOutlet weak var txt_Des: FloatingTextView!
    
    @IBOutlet weak var btn_Save: GradientButton!
    
    @IBOutlet weak var lbl_TitleAddon: UILabel!
    @IBOutlet weak var vw_AddonText: UIView!
    @IBOutlet weak var vw_AddonTable: UIView!
    @IBOutlet weak var tbl_ViewAddon: UITableView!
    
    var durationList:[DurationItem] = []
    var isEdit = false
    var selectedDuration = 0
    var addon_Id = Int()
    var addAddon = "AddAddon"
    var addonList: [InventoryData] = []
    var addonClientList: InventoryData?
    var isOpen = true
    var selectedDurationMinutes = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vw_AddonText.isHidden = true
        self.vw_AddonTable.isHidden = true
        let title = NSLocalizedString("Save", comment: "")
        
        let Save = NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 18.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        btn_Save.setAttributedTitle(Save, for: .normal)
        setTableView()
        setRegularFont()
        self.loadDuationData()
        
        
        if addAddon == "AddAddon" {
            vw_AddonText.isHidden = false
            vw_AddonTable.isHidden = true
            self.lbl_Addon.text = NSLocalizedString("Add Addon",comment: "")
        }else{
            self.lbl_TitleAddon.text = NSLocalizedString("All Addons",comment: "")
            api_AddonDetails()
            vw_AddonText.isHidden = true
            vw_AddonTable.isHidden = false
        }
    }

    @IBAction func btn_Close(_ sender: Any) {
        if isOpen {
            vw_AddonText.isHidden = true
            vw_AddonTable.isHidden = false
            self.api_AddonDetails()
        }
        if addAddon == "AddAddon"{
            vw_AddonText.isHidden = true
            vw_AddonTable.isHidden = true
            self.dismiss(animated: true)
        }
        
    }
        
    @IBAction func btn_Save(_ sender: Any) {
        if txt_Name.text == ""{
            self.alertWithMessageOnly(NSLocalizedString("Name is required.",comment: ""))
        }else if txt_Price.text == ""{
            self.alertWithMessageOnly(NSLocalizedString("Price is required.",comment: ""))
        }else if txt_Duration.text == ""{
            self.alertWithMessageOnly(NSLocalizedString("Duration is required.",comment: ""))
        }else {
            if addAddon == "AddAddon"{
                api_AddAddon()
            }else{
                api_UpdateAdd()
            }
        }
    }
    
 
    @IBAction func btn_vwAddClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    
    func setTableView(){
        tbl_ViewAddon.register(UINib(nibName: "AddonCell", bundle: nil), forCellReuseIdentifier: "AddonCell")
        tbl_ViewAddon.register(UINib(nibName: "AddonHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "AddonHeaderCell")
        tbl_ViewAddon.delegate = self
        tbl_ViewAddon.dataSource = self
        tbl_ViewAddon.rowHeight = UITableView.automaticDimension
        tbl_ViewAddon.estimatedRowHeight = 50
    }
    
    func setRegularFont(){
        if let customFont = UIFont(name: "Lato-Regular", size: 20.0) {
            txt_Name.font = customFont
            txt_Price.font = customFont
            txt_Duration.font = customFont
        }
    }
    
    
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
                    for: self.txt_Duration,
                    in: self.view,
                    with: options
                ) { [weak self] selected in
                    guard let self = self else { return }
                    self.txt_Duration.setText(selected)
                    
                    if let durationObj = self.durationList.first(where: { $0.label == selected }) {
                        self.selectedDurationMinutes = durationObj.duration
                    }
                }
                if self.isEdit {
                    for data in self.durationList {
                        if data.duration == "\(self.selectedDuration)" {
                            self.txt_Duration.setText(data.label)
                            self.selectedDurationMinutes = data.duration
                        }
                    }
                }
            }
        }
    }
    
    
    func api_AddAddon(){
        APIService.shared.AddAddon(addon_description: self.txt_Des.text, addon_duration: selectedDurationMinutes, addon_name: self.txt_Name.text ?? "", addon_price: self.txt_Price.text ?? "", vendor_id: LocalData.userId) { result  in
            if (result != nil) {
                DispatchQueue.main.async {
                    self.alertWithMessageOnly(NSLocalizedString("Addon added successfully",comment: ""))
                    self.addon_Id = result?.data?.insertId ?? 0
                    self.txt_Price.text = ""
                    self.txt_Name.text = ""
                    self.txt_Des.text = ""
                    self.txt_Duration.text = ""
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.presentingViewController?.dismiss(animated: true)
                    }
                }
            }else{
                if result?.error == "This name is already in use"{
                    self.alertWithMessageOnly(NSLocalizedString("This name is already in use",comment: ""))
                }else if result?.error == "Failed to add addon"{
                    self.alertWithMessageOnly(NSLocalizedString("Failed to add addon",comment: ""))
                }
            }
        }
    }
    
    func api_UpdateAdd(){
        self.showLoader()
        APIService.shared.updateAddon(addon_description: self.txt_Des.text, addon_duration: selectedDurationMinutes, addon_id: String(addon_Id), addon_name: self.txt_Name.text ?? "", vendor_id: LocalData.userId, addon_price: self.txt_Price.text ?? ""){ result in
            if result != nil {
                self.hideLoader()
                self.alertWithMessageOnly(NSLocalizedString("Addon details updated successfully",comment: ""))
                self.vw_AddonText.isHidden = true
                self.vw_AddonTable.isHidden = false
                self.api_AddonDetails()
                self.txt_Price.text = ""
                self.txt_Name.text = ""
                self.txt_Des.text = ""
                self.txt_Duration.text = ""
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.presentingViewController?.dismiss(animated: true)
                }
            }else{
                self.alertWithMessageOnly(NSLocalizedString("Failed to update addon",comment: ""))
            }
            
        }
    }
    
    
    func api_AddonDetails(){
        self.showLoader()
        APIService.shared.AddonDetails(vendorId: LocalData.userId) { ResourceDetails in
            self.hideLoader()
            self.addonList = ResourceDetails?.data ?? []
            self.tbl_ViewAddon.reloadData()
        }
    }
    
    func deleteResource(id: Int){
        self.showLoader()
        APIService.shared.deleteAddon(id: id) { result in
            guard let model = result else {
                return
            }
            self.hideLoader()
            if model.error == "" || model.error == nil {
                DispatchQueue.main.async {
                    self.alertWithMessageOnly(NSLocalizedString("Addon deleted successfully",comment: ""))
                }
                self.api_AddonDetails()
            } else {
                self.alertWithMessageOnly(NSLocalizedString("Failed to delete addon",comment: ""))
            }
        }
    }
    
}


extension AddAddon_VC: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AddonHeaderCell") as? AddonHeaderCell else {
                return nil
            }

            // Customize your header view
            return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbl_ViewAddon.dequeueReusableCell(withIdentifier: "AddonCell", for: indexPath) as? AddonCell else {
            return UITableViewCell()
        }
        let data = self.addonList[indexPath.item]
        cell.lbl_Number.text = String(data.id)
        cell.lbl_Name.text = data.addon_name
        cell.lbl_Price.text = "\(LocalData.symbol)" + "\(String(data.addon_price))"
        cell.lbl_Description.text = data.addon_description
        cell.lbl_Duration.text = String(data.addon_duration)
        cell.Act_Edit = {
            if self.isOpen {
                self.vw_AddonText.isHidden = false
                self.vw_AddonTable.isHidden = true
                self.lbl_TitleAddon.text = NSLocalizedString("Update Addon",comment: "")
                self.addonClientList = data
                self.addon_Id = self.addonClientList?.id ?? 0
                self.txt_Name.text = self.addonClientList?.addon_name
                self.txt_Des.text = self.addonClientList?.addon_description ?? ""
//                self.txt_Duration.text = String(self.addonClientList?.addon_duration ?? 0)
                self.txt_Price.text = String(self.addonClientList?.addon_price ?? 0)
                
                
                let durationMinutes = String(self.addonClientList?.addon_duration ?? 0)
                        
                        if let durationObj = self.durationList.first(where: { $0.duration == durationMinutes }) {
                            self.txt_Duration.setText(durationObj.label)
                            self.selectedDurationMinutes = durationObj.duration
                        }
                        
                
                self.txt_Name.showLabel()
                self.txt_Duration.showLabel()
                self.txt_Price.showLabel()
            }
            
        }
        cell.Act_Delete = {
            self.addonClientList = data
            let popup = ConfirmDeletePopupVC()
            popup.modalPresentationStyle = .overFullScreen
            popup.modalTransitionStyle = .crossDissolve
            popup.titleText = NSLocalizedString("Are you sure you want to delete this Addon?",comment: "")
            popup.onConfirm = {
                print("User confirmed delete")
                // Call your delete logic here
                self.deleteResource(id: self.addonClientList?.id ?? 0)
            }
            self.present(popup, animated: true, completion: nil)
        }
        return cell
    }
    
    
}

