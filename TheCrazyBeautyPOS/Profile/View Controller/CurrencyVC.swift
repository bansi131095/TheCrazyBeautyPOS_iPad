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
        let itemArray = self.CurrencyList.map { $0.currency_code }

        let dropDown = DropDown()
        dropDown.anchorView = txt_Currency
        dropDown.bottomOffset = CGPoint(x: 0, y: txt_Currency.bounds.height)
        dropDown.direction = .bottom
        dropDown.dataSource = itemArray
        dropDown.cellHeight = 35

        // ✅ Safely select previously selected item
        if let current = selectedCurrencyCode,
           let index = itemArray.firstIndex(of: current) {
            dropDown.selectRow(index)
        }

        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.txt_Currency.text = item
            self.selectedCurrencyCode = item
            
            if let selected = self.CurrencyList.first(where: { $0.currency_code == item }) {
                self.symbol = selected.symbol
            }
        }

        dropDown.show()
    }
        
    
    /*func openCurrency() {
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
            print("Selected item: \(item) at index: \(index)")
            txt_Currency.text = item
            for i in self.CurrencyList{
                let topic : String = i.currency_code
                if topic == item{
                    txt_Currency.text = i.currency_code
                    symbol = i.symbol
                    break
                }
            }
        }
    }*/
    
    func call_CurrencyAPI() {
        APIService.shared.fetchSalonCurrency { CurrencyResult in
            guard let data = CurrencyResult?.data else { return }
            self.CurrencyList = data
            
            if let selected = self.CurrencyList.first(where: { $0.is_selected }) {
                self.txt_Currency.text = selected.currency_code
                self.symbol = selected.symbol
                self.selectedCurrencyCode = selected.currency_code
            }else if let first = self.CurrencyList.first {
                self.txt_Currency.text = first.currency_code
                self.symbol = first.symbol
                self.selectedCurrencyCode = first.currency_code
            }
        }
    }
    
    func call_UpdateCurrencyAPI() {
        APIService.shared.UpdateCurrency(currency: self.txt_Currency.text ?? "", symbol: symbol, vendorId: LocalData.userId, completion: { result in
        })
    }
}
