//
//  AddInventory_VC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 28/07/25.
//

import UIKit

class AddInventory_VC: UIViewController {

    
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var txt_ProductName: TextInputLayout!
    @IBOutlet weak var txt_Price: TextInputLayout!
    @IBOutlet weak var txt_QTY: TextInputLayout!
    @IBOutlet weak var btn_AddInventory: GradientButton!
    
    var isEdit = false
    var InventoryService: InventoryData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomFont()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if self.isEdit {
                self.lbl_Title.text = "Edit Inventory"
                self.btn_AddInventory.setTitle("Update Inventory", for: .normal)
                self.setData()
            } else {
                self.lbl_Title.text = "Add Inventory"
                self.btn_AddInventory.setTitle("Add Inventory", for: .normal)
            }
        }
    }
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Regular", size: 20.0) {
            txt_ProductName.font = customFont
            txt_Price.font = customFont
            txt_QTY.font = customFont
        }
    }
    
    func setData(){
        self.txt_ProductName.text = self.InventoryService?.product_name
        self.txt_Price.text = "\(self.InventoryService?.price ?? 0)"
        self.txt_QTY.text = "\(self.InventoryService?.qty ?? 0)"
    }
    
    @IBAction func btn_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_Cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btn_AddInventory(_ sender: Any) {
        if txt_ProductName.text == ""{
            self.showToast(message: "Product Name is required.")
        }else if txt_Price.text == ""{
            self.showToast(message: "Price is required.")
        }else if txt_QTY.text == ""{
            self.showToast(message: "QTY is required.")
        }else{
            if isEdit {
                updateInventory(clientId: self.InventoryService?.id ?? 0)
            }else{
                addInverty()
            }
        }
    }
    
    
    func addInverty(){
        showLoader()
        APIService.shared.add_AddInventory(vendorId: LocalData.userId, price: self.txt_Price.text ?? "", product_name: self.txt_ProductName.text ?? "", qty: self.txt_QTY.text ?? "") { result in
            self.hideLoader()
            if result != nil {
                DispatchQueue.main.async {
                    self.showToast(message: result?.data?.message ?? "")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                self.showToast(message: "Something went wrong")
            }
        }
    }
    
    func updateInventory(clientId: Int){
        showLoader()
        APIService.shared.updateInventory(clientId: clientId, price: self.txt_Price.text ?? "", product_name: self.txt_ProductName.text ?? "", qty: self.txt_QTY.text ?? "", vendor_id: LocalData.userId) { result in
            self.hideLoader()
            guard let model = result else {
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

}
