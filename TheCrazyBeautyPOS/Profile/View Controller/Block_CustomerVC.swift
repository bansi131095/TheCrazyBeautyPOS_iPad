//
//  Block_CustomerVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 26/06/25.
//

import UIKit
import CountryPickerViewSwift

class Block_CustomerVC: UIViewController {

    
    
//    @IBOutlet weak var countryPicker: UIView!
    
    @IBOutlet weak var img_Flag: UIImageView!
    @IBOutlet weak var txt_MobileNumber: UITextField!
    
    
    var SelectedCountryCode : String = ""
    var SelectedCountryPhoneCode : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func btn_Flag(_ sender: Any) {
    
    }
}
