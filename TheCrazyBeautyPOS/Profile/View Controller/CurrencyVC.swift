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
    
    
    var CurrencyList: [CurrencyData] = []
    var CurrencyGet: CurrencyData = CurrencyData()
    var symbol = String()
    var selectedCurrencyCode: String?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        call_CurrencyAPI()
    }
    
    @IBAction func btn_Currency(_ sender: Any) {
        openCurrency()
    }
    
    @IBAction func btn_Save(_ sender: Any) {
        call_UpdateCurrencyAPI()
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

       slotDuration.selectionAction = { [unowned self] (index: Int, item: String) in
           txt_Currency.text = item
           for i in self.CurrencyList {
               if i.currency_code == item {
                   txt_Currency.text = i.currency_code
                   selectedCurrencyCode = i.currency_code
                   symbol = i.symbol
                   break
               }
           }
       }
    }
    
    func call_CurrencyAPI() {
        APIService.shared.fetchSalonCurrency { result in
            if result?.data != nil {
                self.CurrencyList = result!.data
                self.call_GetCurrencyAPI()
            }else{
                self.alertWithMessageOnly(result?.error ?? "")
            }
        }
    }
    
    func call_GetCurrencyAPI() {
        APIService.shared.getCurrency(completion: { result in
            guard let data = result?.data else { return }
            if (data.count > 0) {
                self.CurrencyGet = data[0]
            }
        
            for i in self.CurrencyList {
                if self.CurrencyGet.currency == i.currency_code{
                    self.txt_Currency.text = i.currency_code
                    self.selectedCurrencyCode = i.currency_code
                    self.symbol = i.symbol
                    break
                }
            }
        })
    }
    
    func call_UpdateCurrencyAPI() {
        APIService.shared.UpdateCurrency(currency: self.txt_Currency.text ?? "", symbol: symbol, vendorId: LocalData.userId, completion: { result in
            if result?.data != nil {
                self.alertWithMessageOnly(result?.data ?? "")
            } else {
                self.alertWithMessageOnly(result?.error ?? "")
            }
        })
    }
}
