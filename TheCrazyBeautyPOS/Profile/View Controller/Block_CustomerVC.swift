//
//  Block_CustomerVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 26/06/25.
//

import UIKit
import CountryPickerViewSwift
import Alamofire
import ObjectMapper

class Block_CustomerVC: UIViewController {
    
    @IBOutlet weak var vw_CountryPicker: UIView!
    @IBOutlet weak var vw_CountryHeight: NSLayoutConstraint!
    @IBOutlet weak var img_Flag: UIImageView!
    @IBOutlet weak var txt_MobileNumber: UITextField!
    
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var tbl_Height: NSLayoutConstraint!
    @IBOutlet weak var btn_Save: GradientButton!
    
    var arr_Number = [[String: String]]()
    var selectedCountrycode = "+353"
    
    
    lazy var countryCodeToLocale: [String: String] = {
        var map = [String: String]()
        for item in CountryCodeJson {
            if let code = item["code"] as? NSNumber, let locale = item["locale"] as? String {
                map["+\(code)"] = locale
            }
        }
        return map
    }()

    var CountryCodeJson: [[String: Any]] = {
        guard let path = Bundle.main.path(forResource: "CountryCodes", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let json = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            return []
        }
        return json
    }()

    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        let title = NSLocalizedString("Save", comment: "")
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 20.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        btn_Save.setAttributedTitle(attributedTitle, for: .normal)
        setCustomFont()
        if let iso = CountryUtils.getISOCode(from: selectedCountrycode),
           let flagImage = CountryUtils.imageFromEmoji(flag: CountryUtils.flag(from: iso)) {
            img_Flag.image = flagImage
        }
        
        fetchBlockedCustomers{}
        if arr_Number.isEmpty{
            self.vw_CountryHeight.constant = 65
            self.vw_CountryPicker.isHidden = false
        }
    }
    
    
    //MARK: - Function
    func setTableView(){
        tbl_vw.register(UINib(nibName: "BlockCustomerCell", bundle: nil), forCellReuseIdentifier: "BlockCustomerCell")
        tbl_vw.delegate = self
        tbl_vw.dataSource = self
        tbl_vw.rowHeight = UITableView.automaticDimension
        tbl_vw.estimatedRowHeight = 70
    }
    
    func AddMoreField() {
//        self.arr_Number.append("")
        arr_Number.append(["countryCode": "+353", "mobile": "", "locale": "IE"])
        self.tbl_Height.constant = CGFloat(self.arr_Number.count * 70)
        self.tbl_vw.performBatchUpdates({
            self.tbl_vw.insertRows(at: [IndexPath(row: self.arr_Number.count - 1, section: 0)], with: .automatic)
        }, completion: nil)
    }

    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Medium", size: 18.0) {
            txt_MobileNumber.font = customFont
        }
    }
    
    //MARK: - Button Action
    @IBAction func btn_Flag(_ sender: Any) {
        openCountryPicker { code, image, locale in
            self.img_Flag.image = image
            self.selectedCountrycode = code
        }
    }
    
    @IBAction func btn_AddMore(_ sender: Any) {
        AddMoreField()
    }
    
    @IBAction func btn_Save(_ sender: Any) {
        view.endEditing(true)
        var numbers: [String] = []

            // Add top mobile number
        if let mainMobile = txt_MobileNumber.text?.trimmingCharacters(in: .whitespaces), !mainMobile.isEmpty {
            numbers.append("\(selectedCountrycode)-\(mainMobile)")
        }

            // Add all TableView numbers
        for (index, dict) in arr_Number.enumerated() {
            if let cell = tbl_vw.cellForRow(at: IndexPath(row: index, section: 0)) as? BlockCustomerCell {
                let code = dict["countryCode"] ?? "+000"
                let mobile = cell.txt_MobileNumber.text?.trimmingCharacters(in: .whitespaces) ?? ""
                if !mobile.isEmpty {
                    numbers.append("\(code)-\(mobile)")
                }
            }
        }

        let joinedNumbers = numbers.joined(separator: ",")
        print("📤 Sending block customers: \(joinedNumbers)")
        showLoader()
        APIService.shared.uploadBlockCustomers(vendorId: LocalData.userId, blockCustomers: joinedNumbers) { success, errorMessage in
            self.hideLoader()
            if success {
                self.alertWithMessageOnly(NSLocalizedString("Customer blocked successfully", comment: ""))
            } else {
                self.alertWithMessageOnly(NSLocalizedString("Failed to block customer",comment: ""))
            }
        }
    }
    
    /*func openCountryPicker(completion: @escaping (_ code: String, _ image: UIImage?, _ locale: String) -> Void) {
        let countryView = CountrySelectView.shared
        countryView.show()
        countryView.barTintColor = .gray
        countryView.searchBarPlaceholder = "Search"
        countryView.displayLanguage = .english

        countryView.selectedCountryCallBack = { countryDic in
            if let locale = countryDic["locale"] as? String,
               let code = countryDic["code"] as? Int {
                let path = Bundle(for: CountrySelectView.self).resourcePath! + "/CountryPicker.bundle"
                let CABundle = Bundle(path: path)!
                let image = UIImage(named: locale, in: CABundle, compatibleWith: nil)
                completion("+\(code)", image, locale)
            }
        }
    }*/
    
    
    func openCountryPicker(
        completion: @escaping (_ code: String, _ image: UIImage?, _ locale: String) -> Void
    ) {
        let countryView = CountrySelectView.shared
        countryView.show()
        countryView.barTintColor = .gray
        countryView.searchBarPlaceholder = "Search"
        countryView.displayLanguage = .english

        countryView.selectedCountryCallBack = { countryDic in

            guard
                let locale = countryDic["locale"] as? String,
                let code = countryDic["code"] as? Int
            else { return }

            // ✅ ISO Code (ex: "IN", "US")
            let isoCode = locale.uppercased()

            // ✅ ISO → Emoji
            let flagEmoji = CountryUtils.flag(from: isoCode)

            // ✅ Emoji → UIImage
            let flagImage = CountryUtils.imageFromEmoji(flag: flagEmoji)

            // ✅ Return values
            completion("+\(code)", flagImage, locale)
        }
    }

    /*func fetchBlockedCustomers(completion: @escaping () -> Void) {
        let url = global.shared.URL_BLOCK_CUSTOMERS + "/\(LocalData.userId)"
        
        var headers: [String: String] {
            var baseHeaders = [
                "Accept": "application/json",
                "apikey": global.apikey,
                "Content-Type": "application/json",
            ]
            
            if !LocalData.loginToken.isEmpty {
                baseHeaders["Authorization"] = "Bearer \(LocalData.loginToken)"
            }
            
            return baseHeaders
        }
        
        AF.request(url, method: .get, headers: HTTPHeaders(headers)).validate()
            .responseObject { (response: DataResponse<BlockCustomerResponse, AFError>) in
                switch response.result {
                case .success(let model):
                    if let data = response.data,
                       let responseStr = String(data: data, encoding: .utf8) {
                        print("📦 API Raw Response:\n\(responseStr)")
                    }

                    if let customerString = model.data.first?.block_customers {
                        let numberArray = customerString.components(separatedBy: ",")
                        self.arr_Number = numberArray.map { entry in
                            let components = entry.components(separatedBy: "-")
                            if components.count == 2 {
                                return [
                                    "countryCode": components[0],
                                    "mobile": components[1],
                                    "locale": "IE" // Optional: you can infer from code
                                ]
                            } else {
                                return [:]
                            }
                        }
                        if !self.arr_Number.isEmpty {
                            self.vw_CountryHeight.constant = 0
                            self.vw_CountryPicker.isHidden = true
                        }else{
                            self.arr_Number.append(["countryCode": "+353", "mobile": "", "locale": "IE"])
                            self.vw_CountryHeight.constant = 65
                            self.vw_CountryPicker.isHidden = false
                        }
                    } else {
                        self.arr_Number = [["countryCode": "+353", "mobile": "", "locale": "IE"]]
                        self.vw_CountryHeight.constant = 65
                        self.vw_CountryPicker.isHidden = false
                    }

                    self.tbl_vw.reloadData()
                    self.tbl_Height.constant = CGFloat(self.arr_Number.count * 60)
                    completion()
                    
                case .failure(let error):
                    print("❌ API Error: \(error)")
                    completion()
                }
            }
    }*/
    
    
    func fetchBlockedCustomers(completion: @escaping () -> Void) {
        let url = global.shared.URL_BLOCK_CUSTOMERS + "/\(LocalData.userId)"
        var headers: [String: String] {
            var baseHeaders = [
                "Accept": "application/json",
                "apikey": global.apikey,
                "Content-Type": "application/json",
            ]
            if !LocalData.loginToken.isEmpty {
                baseHeaders["Authorization"] = "Bearer \(LocalData.loginToken)"
            }
            return baseHeaders
        }
        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let json):
                    // 🧾 Log raw JSON
                    if let data = response.data,
                       let responseStr = String(data: data, encoding: .utf8) {
                        print("📦 API Raw Response:\n\(responseStr)")
                    }
     
                    // 🧠 Parse JSON manually using ObjectMapper
                    if let model = Mapper<BlockCustomerResponse>().map(JSONObject: json) {
                        if let customerString = model.data.first?.block_customers {
                            let numberArray = customerString.components(separatedBy: ",")
                            self.arr_Number = numberArray.map { entry in
                                let components = entry.components(separatedBy: "-")
                                if components.count == 2 {
                                    return [
                                        "countryCode": components[0],
                                        "mobile": components[1],
                                        "locale": "IE" // or infer dynamically
                                    ]
                                } else {
                                    return [:]
                                }
                            }
     
                            if !self.arr_Number.isEmpty {
                                self.vw_CountryHeight.constant = 0
                                self.vw_CountryPicker.isHidden = true
                            } else {
                                self.arr_Number.append(["countryCode": "+353", "mobile": "", "locale": "IE"])
                                self.vw_CountryHeight.constant = 65
                                self.vw_CountryPicker.isHidden = false
                            }
                        } else {
                            self.arr_Number = [["countryCode": "+353", "mobile": "", "locale": "IE"]]
                            self.vw_CountryHeight.constant = 65
                            self.vw_CountryPicker.isHidden = false
                        }
     
                        self.tbl_vw.reloadData()
                        self.tbl_Height.constant = CGFloat(self.arr_Number.count * 70)
                        completion()
                    } else {
                        print("❌ Mapping failed — JSON structure may not match model")
                        completion()
                    }
     
                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    if let data = response.data,
                       let responseStr = String(data: data, encoding: .utf8) {
                        print("📦 Raw Error Response:\n\(responseStr)")
                    }
                    completion()
                }
            }
    }

    
    
    @objc func mobileTextChanged(_ textField: UITextField) {
        let index = textField.tag
        if index < arr_Number.count {
            arr_Number[index]["mobile"] = textField.text ?? ""
        }
    }
}

extension Block_CustomerVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_Number.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl_vw.dequeueReusableCell(withIdentifier: "BlockCustomerCell", for: indexPath) as! BlockCustomerCell
        let item = arr_Number[indexPath.row]
        cell.txt_MobileNumber.showLabel()
        cell.txt_MobileNumber.text = item["mobile"] ?? ""
        cell.txt_MobileNumber.tag = indexPath.row
        cell.txt_MobileNumber.addTarget(self, action: #selector(mobileTextChanged(_:)), for: .editingChanged)
        
        let code = item["countryCode"] ?? "+000"
        if let iso = CountryUtils.getISOCode(from: code),
           let flagImage = CountryUtils.imageFromEmoji(flag: CountryUtils.flag(from: iso)) {
            cell.img_Flag.image = flagImage
        }
        
        cell.txt_MobileNumber.tag = indexPath.row
        cell.txt_MobileNumber.addTarget(self, action: #selector(mobileTextChanged(_:)), for: .editingChanged)
        
        cell.Act_Delete = { deletedCell in
            if let deletedIndexPath = tableView.indexPath(for: deletedCell) {
                self.tbl_vw.performBatchUpdates({
                    self.arr_Number.remove(at: deletedIndexPath.row)
                    self.tbl_vw.deleteRows(at: [deletedIndexPath], with: .automatic)
                }, completion: { _ in
                    if self.arr_Number.isEmpty {
                        self.vw_CountryHeight.constant = 65
                        self.vw_CountryPicker.isHidden = false
                        self.tbl_vw.reloadData() // Refresh properly
                    }
                    self.tbl_Height.constant = CGFloat(self.arr_Number.count * 70)
                })
            }
        }
        
        cell.Act_Flag = {
            self.openCountryPicker { code, image, locale in
                // ✅ Update the selected row's data
                self.arr_Number[indexPath.row]["countryCode"] = code
                self.arr_Number[indexPath.row]["locale"] = locale

                // ✅ Set the flag image
                cell.img_Flag.image = image
            }
        }
        return cell
    }
}
