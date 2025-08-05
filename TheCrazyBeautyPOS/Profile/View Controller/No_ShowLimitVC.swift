//
//  No_ShowLimitVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 04/08/25.
//

import UIKit

class No_ShowLimitVC: UIViewController {
    
    
    //MARK: - Outlet
    @IBOutlet weak var txt_NoShowLimit: TextInputLayout!
    @IBOutlet weak var btn_Save: GradientButton!
    
    //MARK: - Global Variable
    var noShowLimit: Int?
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        api_NoShowLimit()
    }
    
    //MARK: -  Button Action
    @IBAction func btn_Save(_ sender: Any) {
        if txt_NoShowLimit.text == ""{
            alertWithImage(title: "No Show Limit", Msg: "No.Show Limit is required.")
        }else{
            api_UpdateNoShowLimit()
        }
    }
    
    //MARK: - Function
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Medium", size: 22.0) {
            txt_NoShowLimit.font = customFont
            btn_Save.titleLabel?.font = customFont
        }
    }
    
    //MARK: - Web Api Calling
    func api_NoShowLimit() {
        APIService.shared.fetchNoShowLimit { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                let data = result?.data.first
                self.txt_NoShowLimit.text = "\(data?.noshow_limit ?? 0)"
            }
        }
    }
    
    func api_UpdateNoShowLimit() {
        APIService.shared.UpdateNoShowlimit(vendorId: LocalData.userId, noshow_limit: self.txt_NoShowLimit.text ?? "", completion: { result in
            if let message = result?.data {
                self.alertWithMessageOnly(message)
            }else{
                self.alertWithMessageOnly("Something went wrong.")
            }
        })
    }
}
