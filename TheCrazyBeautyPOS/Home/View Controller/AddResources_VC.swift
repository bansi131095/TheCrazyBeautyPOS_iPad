//
//  AddResources_VC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 26/08/25.
//

import UIKit

class AddResources_VC: UIViewController,UITextFieldDelegate {
    
    //MARK: - Outlet
    @IBOutlet weak var vw_AddResources: UIView!
    @IBOutlet weak var vw_AllResources: UIView!
    @IBOutlet weak var txt_Name: TextInputLayout!
    @IBOutlet weak var txt_Qty: TextInputLayout!
    @IBOutlet weak var txt_Description: FloatingTextView!
    
    @IBOutlet weak var tbl_AllResources: UITableView!
    
    
    @IBOutlet weak var lbl_AddResources: UILabel!
    
    //MARK: - Global Variable
    var resource_id = Int()
    var AddResources = "AddResources"
    var resourcList: [InventoryData] = []
    var resourcListClient: InventoryData?
    var isOpen = true
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        vw_AddResources.isHidden = true
        vw_AllResources.isHidden = true
        setTableView()
        setRegularFont()
        
        if AddResources == "AddResources"{
            vw_AddResources.isHidden = false
            vw_AllResources.isHidden = true
            self.lbl_AddResources.text = "Add Resources"
        }else{
            api_ResourceDetails()
            vw_AddResources.isHidden = true
            vw_AllResources.isHidden = false
        }
    }
    
    //MARK: -  Button Action
    @IBAction func btn_Close(_ sender: Any) {
        if isOpen{
            vw_AddResources.isHidden = true
            vw_AllResources.isHidden = false
            self.api_ResourceDetails()
        }
        if AddResources == "AddResources"{
            vw_AddResources.isHidden = true
            vw_AllResources.isHidden = true
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func btn_CloseAll(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btn_Save(_ sender: Any) {
        if txt_Name.text == ""{
            self.showToast(message: "Name is required.")
        }else if txt_Qty.text == ""{
            self.showToast(message: "Quantity is required.")
        }else{
            if AddResources == "AddResources"{
                api_AddResources()
            }else{
                api_UpdateResource()
            }
        }
    }
    
    //MARK: - Function
    func setTableView(){
        tbl_AllResources.register(UINib(nibName: "AllResourcesCell", bundle: nil), forCellReuseIdentifier: "AllResourcesCell")
        tbl_AllResources.register(UINib(nibName: "AllResourcesHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "AllResourcesHeaderCell")
        tbl_AllResources.delegate = self
        tbl_AllResources.dataSource = self
        tbl_AllResources.rowHeight = UITableView.automaticDimension
        tbl_AllResources.estimatedRowHeight = 50
    }
    
    func setRegularFont(){
        if let customFont = UIFont(name: "Lato-Regular", size: 20.0) {
            txt_Name.font = customFont
            txt_Qty.font = customFont
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Only allow digits (0–9)
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    //MARK: - Web Api Calling
    func api_AddResources(){
        APIService.shared.addResource(description: self.txt_Description.text, name: self.txt_Name.text ?? "", qty: self.txt_Qty.text ?? "",vendor_id: LocalData.userId) { result  in
            if (result != nil) {
                DispatchQueue.main.async {
                    // safe UI code here
                    self.showToast(message: result?.data?.message ?? "")
                    self.resource_id = result?.data?.insertId ?? 0
                    self.txt_Qty.text = ""
                    self.txt_Name.text = ""
                    self.txt_Description.text = ""
                }
            }else{
                self.showToast(message: result?.error ?? "")
            }
        }
    }
    
    func api_ResourceDetails(){
        self.showLoader()
        APIService.shared.ResourceDetails(vendorId: LocalData.userId) { ResourceDetails in
            self.hideLoader()
            self.resourcList = ResourceDetails?.data ?? []
            self.tbl_AllResources.reloadData()
        }
    }
    
    func api_UpdateResource(){
        self.showLoader()
        APIService.shared.UpdateResource(description: self.txt_Description.text, name: self.txt_Name.text ?? "", qty: self.txt_Qty.text ?? "", resource_id: String(resource_id), vendor_id: LocalData.userId) { result in
            if result != nil {
                self.hideLoader()
                print(self.resource_id)
                self.showToast(message: result?.data ?? "")
                self.vw_AddResources.isHidden = true
                self.vw_AllResources.isHidden = false
                self.api_ResourceDetails()
                self.txt_Qty.text = ""
                self.txt_Name.text = ""
                self.txt_Description.text = ""
                
            }else{
                self.showToast(message: result?.error ?? "")
            }
            
        }
    }
    
    func deleteResource(id: Int){
        self.showLoader()
        APIService.shared.deleteResource(id: id) { result in
            guard let model = result else {
                return
            }
            self.hideLoader()
            if model.error == "" || model.error == nil {
                DispatchQueue.main.async {
                    // safe UI code here
                    self.showToast(message: model.data)
                }
                self.api_ResourceDetails()
            } else {
                self.show_alert(msg: model.error ?? "", title: "Delete Team")
            }
        }
    }
    
}
extension AddResources_VC: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AllResourcesHeaderCell") as? AllResourcesHeaderCell else {
                return nil
            }

            // Customize your header view
            return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resourcList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbl_AllResources.dequeueReusableCell(withIdentifier: "AllResourcesCell", for: indexPath) as? AllResourcesCell else {
            return UITableViewCell()
        }
        let data = self.resourcList[indexPath.item]
        cell.lbl_Number.text = String(data.id)
        cell.lbl_Name.text = data.name
        cell.lbl_Qty.text = String(data.qty)
        cell.lbl_Description.text = data.description
        cell.Act_Edit = {
            if self.isOpen {
                self.vw_AddResources.isHidden = false
                self.vw_AllResources.isHidden = true
                self.lbl_AddResources.text = "Update Resources"
                self.resourcListClient = data
                self.resource_id = self.resourcListClient?.id ?? 0
                self.txt_Name.text = self.resourcListClient?.name
                self.txt_Description.text = self.resourcListClient?.description ?? ""
                self.txt_Qty.text = String(self.resourcListClient?.qty ?? 0)
            }
            
        }
        cell.Act_Delete = {
            self.resourcListClient = data
            let popup = ConfirmDeletePopupVC()
            popup.modalPresentationStyle = .overFullScreen
            popup.modalTransitionStyle = .crossDissolve
            popup.titleText = "Are you sure you want to delete this service?"
            popup.onConfirm = {
                print("User confirmed delete")
                // Call your delete logic here
                self.deleteResource(id: self.resourcListClient?.id ?? 0)
            }
            self.present(popup, animated: true, completion: nil)
        }
        return cell
    }
    
    
}
