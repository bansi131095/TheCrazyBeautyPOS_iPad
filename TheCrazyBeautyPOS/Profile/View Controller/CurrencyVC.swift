//
//  CurrencyVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 30/06/25.
//

import UIKit
import DropDown

class CurrencyVC: UIViewController {

    
    @IBOutlet weak var txt_Currency: TextInputLayout!
    @IBOutlet weak var btn_Save: GradientButton!
    
    
    var CurrencyList: [CurrencyDataA] = []
    var CurrencyGet: CurrencyDataA = CurrencyDataA()
    var symbol = String()
    var selectedCurrencyCode: String?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomFont()
        let title = NSLocalizedString("Save", comment: "")
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 20.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        btn_Save.setAttributedTitle(attributedTitle, for: .normal)
        call_CurrencyAPI()
    }
    
    @IBAction func btn_Currency(_ sender: Any) {
        openCurrency()
    }
    
    @IBAction func btn_Save(_ sender: Any) {
        call_UpdateCurrencyAPI()
    }
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Medium", size: 18.0) {
            txt_Currency.font = customFont
        }
    }
    
    func openCurrency() {
       var itemArray: [String] = []

       for i in self.CurrencyList {
           itemArray.append(i.currency_code)
       }

       let slotDuration = DropDown()
       slotDuration.anchorView = txt_Currency
       slotDuration.bottomOffset = CGPoint(x: 0, y: (slotDuration.anchorView?.plainView.bounds.height) ?? 0)
       slotDuration.direction = .bottom
       slotDuration.dataSource = itemArray
       slotDuration.cellHeight = 35
       slotDuration.show()
        slotDuration.textFont = UIFont(name: "Lato-Regular", size: 18.0)!
        slotDuration.backgroundColor = .white
       slotDuration.selectionAction = { [unowned self] (index: Int, item: String) in
           txt_Currency.text = item
           for i in self.CurrencyList {
               if i.currency_code == item {
                   txt_Currency.text = i.currency_code
//                   LocalData.currency = i.currency
//                   LocalData.selectedCurrencyCode = i.currency_code
//                   selectedCurrencyCode = i.currency_code
                   symbol = i.symbol
                   /*SharedPrefs.setCurrency(i.currency_code)
                   SharedPrefs.setSymbol(i.symbol)*/
                   break
               }
           }
       }
    }
    
    func call_CurrencyAPI() {
        showLoader()
        APIService.shared.fetchSalonCurrency { result in
            self.hideLoader()
            if result?.data != nil {
                self.CurrencyList = result!.data
                self.call_GetCurrencyAPI()
            }else{
                self.alertWithMessageOnly(NSLocalizedString("Failed to get vendor currency",comment: ""))
            }
        }
    }
    
    func call_GetCurrencyAPI() {
        showLoader()
        APIService.shared.getCurrencyA(completion: { result in
            self.hideLoader()
            guard let data = result?.data else { return }
            if (data.count > 0) {
                self.CurrencyGet = data[0]
            }
        
            for i in self.CurrencyList {
                if self.CurrencyGet.currency == i.currency_code{
                    self.txt_Currency.text = i.currency_code
//                    LocalData.currency = i.currency
//                    LocalData.selectedCurrencyCode = i.currency_code
//                    self.selectedCurrencyCode = i.currency_code
                    self.symbol = i.symbol
                    /*SharedPrefs.setCurrency(i.currency_code)
                    SharedPrefs.setSymbol(i.symbol)*/
                    break
                }
            }
        })
    }
    
    func call_UpdateCurrencyAPI() {
        APIService.shared.UpdateCurrency(currency: self.txt_Currency.text ?? "", symbol: symbol, vendorId: LocalData.userId, completion: { result in
            if result?.data != nil {
                self.alertWithMessageOnly(NSLocalizedString("Currency updated successfully",comment: ""))
                SharedPrefs.setCurrency(self.txt_Currency.text ?? "")
                SharedPrefs.setSymbol(self.symbol)
            } else {
                self.alertWithMessageOnly(NSLocalizedString("Failed to Currency",comment: ""))
            }
        })
    }
}

