//
//  BookingVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 09/06/25.
//

import UIKit
import WebKit

class BookingVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let token = SharedPrefs.getLoginToken()
        let userId = SharedPrefs.getUserId()
        LocalData.userId = userId
        self.loadData()
        let loginTimeString = SharedPrefs.getLoginTime()
        let loginTime = loginTimeString.isEmpty ? Int(Date().timeIntervalSince1970 * 1000) : Int(loginTimeString) ?? 0
        self.showProgressBar()
        // Format page link
        let link = global.CAL_WEB_URL
        let pageLink = String(format: link, userId, token, loginTime)

        print("pageLink == \(pageLink)")

        setupWebView(with: pageLink)
        // Do any additional setup after loading the view.
    }
    
    func setupWebView(with urlString: String) {
            // Clear all website data
        WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: Date(timeIntervalSince1970: 0)) {
            print("Web storage cleared")
        }

        guard let requestUrl = URL(string: urlString) else {
            print("❌ Invalid URL: \(urlString)")
            return
        }
        let request = URLRequest(url: requestUrl)
        webView.load(request)
        self.hideProgressBar()
        // Web view settings are handled by WKWebView automatically,
        // unlike Android WebView which needs `settings`
    }

    
    //MARK: Load Api
    func loadData() {
    
        APIService.shared.getCurrency() { staffResult in
            guard let model = staffResult else {
                return
            }

            let newItems = model.data ?? []
            if !newItems.isEmpty {
                let data = newItems[0]
                if let currency = data.currency, currency != "" {
                    SharedPrefs.setCurrency(currency)
                }
                if let symbol = data.symbol, symbol != "" {
                    SharedPrefs.setSymbol(symbol)
                }
                LocalData.getUserData()
                LocalData.symbol = SharedPrefs.getSymbol()
            }
        }
    }
        

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
