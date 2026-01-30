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
    
    @IBOutlet weak var vw_IFEnable: UIView!
    @IBOutlet weak var img_Check: UIImageView!
    
    @IBOutlet weak var vw_NoLimit: UIView!
    //MARK: - Global Variable
    var noShowLimit: Int?
    var allow_noshow = -1
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let title = NSLocalizedString("Save", comment: "")
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 20.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        btn_Save.setAttributedTitle(attributedTitle, for: .normal)
        api_NoShowLimit()
    }
    
    //MARK: -  Button Action
    @IBAction func btn_CheckBox(_ sender: Any) {
        if img_Check.image == UIImage(named: "ic_check_White"){
            img_Check.image = UIImage(named: "check")
            self.vw_NoLimit.isHidden = false
            vw_IFEnable.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.8039215686, blue: 0.9568627451, alpha: 1)
            allow_noshow = 0
        }else{
            img_Check.image = UIImage(named: "ic_check_White")
            self.vw_NoLimit.isHidden = true
            vw_IFEnable.backgroundColor = .white
            allow_noshow = 1
            self.txt_NoShowLimit.text = "0"
        }
    }
    
    @IBAction func btn_Save(_ sender: Any) {
        if txt_NoShowLimit.text == ""{
            alertWithImage(title: NSLocalizedString("No Show Limit",comment: "") , Msg: NSLocalizedString("No.Show Limit is required.", comment: ""))
        }else{
            api_UpdateNoShowLimit()
        }
    }
    
    //MARK: - Function
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Medium", size: 18.0) {
            txt_NoShowLimit.font = customFont
            btn_Save.titleLabel?.font = customFont
        }
    }
    
    //MARK: - Web Api Calling
    func api_NoShowLimit() {
        showLoader()
        APIService.shared.fetchNoShowLimit { [weak self] result in
            self?.hideLoader()
            guard let self = self else { return }

//            DispatchQueue.main.async {
                let data = result?.data.first
                self.txt_NoShowLimit.text = "\(data?.noshow_limit ?? 0)"
                self.txt_NoShowLimit.showLabel()
                if data?.allow_noshow == 0{
                    self.img_Check.image = UIImage(named: "check")
                    self.vw_NoLimit.isHidden = false
                    self.vw_IFEnable.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.8039215686, blue: 0.9568627451, alpha: 1)
                    self.allow_noshow = 0
                }else{
                    self.img_Check.image = UIImage(named: "ic_check_White")
                    self.vw_NoLimit.isHidden = true
                    self.vw_IFEnable.backgroundColor = .white
                    self.allow_noshow = 1
                    
                }
//            }
        }
    }
    
    func api_UpdateNoShowLimit() {
        showLoader()
        APIService.shared.UpdateNoShowlimit(vendorId: LocalData.userId,allow_noshow: String(allow_noshow), noshow_limit: self.txt_NoShowLimit.text ?? "", completion: { result in
            self.hideLoader()
            if let message = result?.data {
                self.alertWithMessageOnly(NSLocalizedString("Noshow limit updated successfully",comment: ""))
            }else{
                self.alertWithMessageOnly(NSLocalizedString("Failed to update noshow limit",comment: ""))
            }
        })
    }
}
