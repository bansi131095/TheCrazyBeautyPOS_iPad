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
    var symbol = String()
    var selectedCurrencyCode: String?
    var is_selectedCurrencyCode: String?

    
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

                   LocalData.selectedCurrencyCode = selectedCurrencyCode
                   LocalData.selectedSymbol = symbol
                   break
               }
           }
       }
    }
    
    func call_CurrencyAPI() {
        APIService.shared.fetchSalonCurrency { CurrencyResult in
            guard let data = CurrencyResult?.data else { return }
            self.CurrencyList = data
            
            if let savedCode = LocalData.selectedCurrencyCode {
                if let selected = self.CurrencyList.first(where: { $0.currency_code == savedCode }) {
                    self.txt_Currency.text = selected.currency_code
                    self.selectedCurrencyCode = selected.currency_code
                    self.symbol = selected.symbol
                }
            }else{
                self.txt_Currency.text = self.CurrencyList[0].currency_code
                self.selectedCurrencyCode = self.CurrencyList[0].currency_code
                self.symbol = self.CurrencyList[0].symbol
            }
        }
    }
    
    func call_UpdateCurrencyAPI() {
        APIService.shared.UpdateCurrency(currency: self.txt_Currency.text ?? "", symbol: symbol, vendorId: LocalData.userId, completion: { result in
            self.alertWithMessageOnly(result?.data ?? "")
        })
    }
}
