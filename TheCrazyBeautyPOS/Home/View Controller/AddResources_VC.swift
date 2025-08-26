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
    
    
    
    //MARK: - Global Variable
    var resource_id = Int()
    var AddResources = "AddResources"
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        vw_AddResources.isHidden = true
        vw_AllResources.isHidden = true
        setRegularFont()
        if AddResources == "AddResources"{
            vw_AddResources.isHidden = false
            vw_AllResources.isHidden = true
        }else{
            vw_AddResources.isHidden = true
            vw_AllResources.isHidden = false
        }
    }
    
    //MARK: -  Button Action
    @IBAction func btn_Close(_ sender: Any) {
        self.dismiss(animated: true)
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
            api_AddResources()
        }
    }
    
    //MARK: - Function
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
}
