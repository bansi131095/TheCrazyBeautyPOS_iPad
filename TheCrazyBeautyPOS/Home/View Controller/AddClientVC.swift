//
//  AddClientVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 02/07/25.
//

import UIKit
import CountryPickerViewSwift
import FSCalendar


class AddClientVC: UIViewController {

    @IBOutlet weak var firstNameTextField: TextInputLayout!
    @IBOutlet weak var lastNameTextField: TextInputLayout!
    @IBOutlet weak var clientTypeTextField: TextInputLayout!
    @IBOutlet weak var genderTextField: TextInputLayout!
    @IBOutlet weak var emailTextField: TextInputLayout!
    @IBOutlet weak var dobTextField: TextInputLayout!
    @IBOutlet weak var mobileTextField: TextInputLayout!
    @IBOutlet weak var flag_imgVw: UIImageView!
    @IBOutlet weak var btn_addEditTeam: GradientButton!
    
    
    var dictClient: CustomerData?
    
    let dropdownView = UITableView()
    let dropdownView1 = UITableView()
    let genderOptions = ["Male", "Female", "Rather not to say"]
    let ClientTypeOptions = ["VIP", "Non VIP"]
    var isDropdownVisible = false
    var isDropdownVisible1 = false
    var selectedCountrycode = "+353"
    var isEdit = false
    var calendarVC: UIViewController?
    var selectedDate: Date = Date.now
    
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dobTextField.delegate = self
        setupGenderTextField()
        setupDropdownTable()
        setupClientTypeTextField()
        setupDropdownTable1()
        if isEdit {
            self.btn_addEditTeam.setTitle("Update Client", for: .normal)
            self.setEditData()
        } else {
            self.btn_addEditTeam.setTitle("Add Client", for: .normal)
        }
        self.setCustomFont()
        // Do any additional setup after loading the view.
    }
    
    //MARK: Setup Views
    func setupGenderTextField() {
    
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleDropdown))
        genderTextField.addGestureRecognizer(tapGesture)
        genderTextField.isUserInteractionEnabled = true
    }
    
    func setupDropdownTable() {
        dropdownView.translatesAutoresizingMaskIntoConstraints = false
        dropdownView.delegate = self
        dropdownView.dataSource = self
        dropdownView.isHidden = true
        dropdownView.layer.borderWidth = 1
        dropdownView.layer.borderColor = UIColor.lightGray.cgColor
        dropdownView.layer.cornerRadius = 10
        dropdownView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(dropdownView)
        
        NSLayoutConstraint.activate([
            dropdownView.topAnchor.constraint(equalTo: genderTextField.bottomAnchor, constant: -30),
            dropdownView.centerXAnchor.constraint(equalTo: genderTextField.centerXAnchor),
            dropdownView.widthAnchor.constraint(equalTo: genderTextField.widthAnchor),
            dropdownView.heightAnchor.constraint(equalToConstant: CGFloat(genderOptions.count * 45))
        ])
    }
    
    @objc func toggleDropdown() {
        
        isDropdownVisible.toggle()
        dropdownView.isHidden = !isDropdownVisible
    }
    
    func setupClientTypeTextField() {
    
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleDropdown1))
        clientTypeTextField.addGestureRecognizer(tapGesture)
        clientTypeTextField.isUserInteractionEnabled = true
    }
    
    func setupDropdownTable1() {
        dropdownView1.translatesAutoresizingMaskIntoConstraints = false
        dropdownView1.delegate = self
        dropdownView1.dataSource = self
        dropdownView1.isHidden = true
        dropdownView1.layer.borderWidth = 1
        dropdownView1.layer.borderColor = UIColor.lightGray.cgColor
        dropdownView1.layer.cornerRadius = 10
        dropdownView1.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(dropdownView1)
        
        NSLayoutConstraint.activate([
            dropdownView1.topAnchor.constraint(equalTo: clientTypeTextField.bottomAnchor, constant: -30),
            dropdownView1.centerXAnchor.constraint(equalTo: clientTypeTextField.centerXAnchor),
            dropdownView1.widthAnchor.constraint(equalTo: clientTypeTextField.widthAnchor),
            dropdownView1.heightAnchor.constraint(equalToConstant: CGFloat(ClientTypeOptions.count * 45))
        ])
    }
    
    @objc func toggleDropdown1() {
        
        isDropdownVisible1.toggle()
        dropdownView1.isHidden = !isDropdownVisible1
    }
    
    //MARK: Button Action
    @IBAction func act_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func act_cancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func act_addEditClient(_ sender: GradientButton) {
        if self.firstNameTextField.text!.isEmpty {
            self.showToast(message: "Please enter first name")
        } else if self.mobileTextField.text!.isEmpty {
            self.showToast(message: "Please enter mobile number")
        } else {
            self.view.endEditing(true)
            if isEdit {
                self.updateClientData(clientId: self.dictClient?.id ?? 0)
            } else {
                self.addClientData()
            }
        }
    }
    
    @IBAction func act_country(_ sender: UIButton) {
        let countryView = CountrySelectView.shared
        countryView.show()
//        countryView.dismiss() //dismiss the picker view
        countryView.barTintColor = .gray //default is green
        countryView.searchBarPlaceholder = "serach" //default is "search"
        countryView.displayLanguage = .english //default is english
        countryView.selectedCountryCallBack = { countryDic in
            print(countryDic)
            if let locale = countryDic["locale"] as? String {
                let path = Bundle(for: CountrySelectView.self).resourcePath! + "/CountryPicker.bundle"
                let CABundle = Bundle(path: path)!
                self.flag_imgVw.image = UIImage(named: locale, in:  CABundle, compatibleWith: nil)
            }
            if let countryCode = countryDic["code"] as? Int {
                let phoneCode = "+\(countryCode)"
                print("Phone Code: \(phoneCode)")
                self.selectedCountrycode = phoneCode  // Example: set it to a UILabel
            } else {
                print("⚠️ code not found in countryDic")
            }
        }
        
    }
    
    //MARK: Custom Function
    func showCalendarPopup(sourceView: UIView) {
        calendarVC = UIViewController()
        calendarVC?.modalPresentationStyle = .popover
        calendarVC?.preferredContentSize = CGSize(width: 500, height: 400)

        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 500, height: 400))
        calendar.delegate = self
        calendar.dataSource = self
        calendar.select(selectedDate)
        calendarVC?.view.addSubview(calendar)

        if let popover = calendarVC?.popoverPresentationController {
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
            popover.permittedArrowDirections = .up
        }

        self.present(calendarVC!, animated: true, completion: nil)
    }
    
    func setEditData() {
        self.firstNameTextField.setText(self.dictClient?.first_name ?? "")
        self.lastNameTextField.setText(self.dictClient?.last_name ?? "")
        self.emailTextField.setText(self.dictClient?.email ?? "")
        if var phoneno = self.dictClient?.phone {
            if !phoneno.isEmpty && phoneno.count >= 3 {
                if phoneno.contains("--") {
                    phoneno = phoneno.replacingOccurrences(of: "--", with: "-")
                }

//                if phoneno.contains("+") {
//                    phoneno = phoneno.replacingOccurrences(of: "+", with: "")
//                }

                print("Mobile No: \(phoneno)")

                let split = phoneno.components(separatedBy: "-")

                if split.count >= 2 {
                    let countryCode = split[0]
                    let mobileNo = split[1]
                    self.selectedCountrycode = countryCode
                    self.mobileTextField.setText(mobileNo) // Assuming this is your UITextField
                    if let iso = CountryUtils.getISOCode(from: countryCode){
                        if let flagImage = CountryUtils.imageFromEmoji(flag: flag(from: iso)) {
                            flag_imgVw.image = flagImage
                        }
                    }
                }
            }
        }
        if let dob = self.dictClient?.dob {
            if !dob.isEmpty {
                let dateParts = dob.split(separator: "-")
                if dateParts.count == 3, let day = Int(dateParts[0]), let month = Int(dateParts[1]), let year = Int(dateParts[2]) {
                    var dateComponents = DateComponents()
                    dateComponents.day = day
                    dateComponents.month = month
                    dateComponents.year = year
                    if let date = Calendar.current.date(from: dateComponents) {
                        selectedDate = date
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd-MM-yyyy"
                        self.dobTextField.setText(formatter.string(from: selectedDate))
                    }
                } else {
                    selectedDate = Date.now
                }
            } else {
                selectedDate = Date.now
            }
        } else {
            selectedDate = Date.now
        }
        if let clientType = self.dictClient?.client_type, !clientType.isEmpty && clientType != "null" {
            self.clientTypeTextField.setText(ClientTypeOptions[ClientTypeOptions.firstIndex(of: clientType)!])
        }
        if let gender = self.dictClient?.gender, !gender.isEmpty && gender != "null" {
            self.genderTextField.setText(genderOptions[genderOptions.firstIndex(of: gender)!])
        }
    }
    
    func flag(from countryCode: String) -> String {
        let base: UInt32 = 127397
        var scalarView = String.UnicodeScalarView()

        for u in countryCode.uppercased().unicodeScalars {
            if let scalar = UnicodeScalar(base + u.value) {
                scalarView.append(scalar)
            }
        }

        return String(scalarView)
    }

    func imageFromEmoji(flag: String, fontSize: CGFloat = 40) -> UIImage? {
        let size = CGSize(width: fontSize, height: fontSize)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(rect)

        (flag as NSString).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: fontSize)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Regular", size: 22.0) {
            firstNameTextField.font = customFont
            lastNameTextField.font = customFont
            emailTextField.font = customFont
            mobileTextField.font = customFont
            genderTextField.font = customFont
            clientTypeTextField.font = customFont
            dobTextField.font = customFont
        }
    }
    
    //MARK: Load Add Api
    func addClientData() {
        let mobileNo = "+\(selectedCountrycode)-\(self.mobileTextField.text ?? "")"
        
        APIService.shared.addClientData(firstName: self.firstNameTextField.text ?? "", lastName: self.lastNameTextField.text ?? "", vendorId: LocalData.userId, email: self.emailTextField.text ?? "", clientType: self.clientTypeTextField.text ?? "", gender: self.genderTextField.text ?? "", dob: self.dobTextField.text ?? "", phone: mobileNo) { staffResult in
            guard let model = staffResult else {
                return
            }

            if model.error == "" {
                DispatchQueue.main.async {
                    // safe UI code here
                    self.showToast(message: "Client added successfully")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.show_alert(msg: model.error, title: "Add Client")
            }
        }
    }
    
    func updateClientData(clientId: Int) {
        let mobileNo = "\(selectedCountrycode)-\(self.mobileTextField.text ?? "")"
        self.showLoader()
        
        APIService.shared.updateClientData(firstName: self.firstNameTextField.text ?? "", lastName: self.lastNameTextField.text ?? "", vendorId: LocalData.userId, email: self.emailTextField.text ?? "", clientType: self.clientTypeTextField.text ?? "", gender: self.genderTextField.text ?? "", dob: self.dobTextField.text ?? "", phone: mobileNo, clientId: clientId) { staffResult in
            guard let model = staffResult else {
                return
            }
            self.hideLoader()
            if model.error == "" || model.error == nil {
                DispatchQueue.main.async {
                    // safe UI code here
                    self.showToast(message: model.data)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.show_alert(msg: model.error ?? "", title: "Update Client")
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


extension AddClientVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == dropdownView {
            return genderOptions.count
        } else if tableView == dropdownView1 {
            return ClientTypeOptions.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == dropdownView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = genderOptions[indexPath.row]
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            return cell
        } else if tableView == dropdownView1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = ClientTypeOptions[indexPath.row]
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == dropdownView {
            genderTextField.text = genderOptions[indexPath.row]
            genderTextField.showLabel()
            dropdownView.isHidden = true
            isDropdownVisible = false
        } else if tableView == dropdownView1 {
            clientTypeTextField.text = ClientTypeOptions[indexPath.row]
            clientTypeTextField.showLabel()
            dropdownView1.isHidden = true
            isDropdownVisible1 = false
        }
    }
}


extension AddClientVC: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == dobTextField) {
            self.view.endEditing(true)
            showCalendarPopup(sourceView: textField)
            return false // Prevent keyboard
        } else {
            return true
        }
    }
    
}


extension AddClientVC: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        self.dobTextField.text = formatter.string(from: selectedDate)
        self.dobTextField.showLabel()
        calendarVC?.dismiss(animated: true)
    }
}
