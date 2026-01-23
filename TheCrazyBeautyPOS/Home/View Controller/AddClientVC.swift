//
//  AddClientVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 02/07/25.
//

import UIKit
import CountryPickerViewSwift
import FSCalendar

struct ClientTypeItem {
    let apiValue: String
    let displayValue: String
}

struct GenderItem {
    let apiValue: String
    let displayValue: String
}



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
    @IBOutlet weak var btn_Cancel: UIButton!
    
    @IBOutlet weak var lbl_TAddClient: UILabel!
    @IBOutlet weak var lbl_AllField: UILabel!
    
    var dictClient: CustomerData?
    
    let dropdownView = UITableView()
    let dropdownView1 = UITableView()
//    let genderOptions = ["Male", "Female", "Rather not to say"]
//    let ClientTypeOptions = ["VIP", "Non VIP"]
    
    var genderOptions: [GenderItem] {
        return [
            GenderItem(
                apiValue: "Male",
                displayValue: NSLocalizedString("Male", comment: "")
            ),
            GenderItem(
                apiValue: "Female",
                displayValue: NSLocalizedString("Female", comment: "")
            ),
            GenderItem(
                apiValue: "Rather not to say",
                displayValue: NSLocalizedString("Rather not to say", comment: "")
            )
        ]
    }

    
    var ClientTypeOptions: [ClientTypeItem] {
        return [
            ClientTypeItem(
                apiValue: "VIP",
                displayValue: NSLocalizedString("VIP", comment: "")
            ),
            ClientTypeItem(
                apiValue: "Non VIP",
                displayValue: NSLocalizedString("Non VIP", comment: "")
            )
        ]
    }

    var selectedClientTypeAPIValue: String = ""
    var selectedGenderAPIValue: String = ""

    var isDropdownVisible = false
    var isDropdownVisible1 = false
    var selectedCountrycode = "+353"
    var isEdit = false
    var calendarVC: UIViewController?
    var selectedDate: Date = Date.now
    var years: [Int] = []
    var calendar: FSCalendar!
    var isGuest = "true"
    
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lbl_AllField.text = NSLocalizedString("All fields marked with an asterisk (*) are required.", comment: "")
        let currentYear = Calendar.current.component(.year, from: Date())
        years = Array(1900...currentYear)
        self.dobTextField.delegate = self
        self.genderTextField.textColor = .black
        self.clientTypeTextField.textColor = .black
        
        setupGenderTextField()
        setupDropdownTable()
        setupClientTypeTextField()
        setupDropdownTable1()
        if isEdit {
            if isGuest == "true"{
                self.lbl_TAddClient.text = NSLocalizedString("Edit Guest", comment: "")
                self.btn_addEditTeam.setTitle(NSLocalizedString("Update Guest",comment: ""), for: .normal)
                self.setEditData()
            }else{
                self.lbl_TAddClient.text = NSLocalizedString("Edit Client", comment: "")
                self.btn_addEditTeam.setTitle(NSLocalizedString("Update Client",comment: ""), for: .normal)
                self.setEditData()
            }
        } else {
            self.lbl_TAddClient.text = NSLocalizedString("Add Client", comment: "")
            self.btn_addEditTeam.setTitle(NSLocalizedString("Add Client",comment: ""), for: .normal)
            if let iso = CountryUtils.getISOCode(from: selectedCountrycode),
               let flagImage = CountryUtils.imageFromEmoji(flag: CountryUtils.flag(from: iso)) {
                flag_imgVw.image = flagImage
            }
            setDefaultDropdownValues()
        }
        let attributedTitleSync_1 = NSAttributedString(
            string: NSLocalizedString("Cancel",comment: ""),
            attributes: [
                .font: UIFont(name: "Lato-Regular", size: 16.0)!,
                .foregroundColor: UIColor.red
            ]
        )
        btn_Cancel.setAttributedTitle(attributedTitleSync_1, for: .normal)
        
        self.setCustomFont()
        
        // Do any additional setup after loading the view.
    }
    
    func setDefaultDropdownValues() {
        // Gender → second value
        if genderOptions.count > 1 {
            let genderItem = genderOptions[1]
            genderTextField.setText(genderItem.displayValue)
            selectedGenderAPIValue = genderItem.apiValue
        }

        // Client Type → second value
        if ClientTypeOptions.count > 1 {
            let clientTypeItem = ClientTypeOptions[1]
            clientTypeTextField.setText(clientTypeItem.displayValue)
            selectedClientTypeAPIValue = clientTypeItem.apiValue
        }
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
            self.showToast(message: NSLocalizedString("Please enter first name",comment: ""))
        } else if self.mobileTextField.text!.isEmpty {
            self.showToast(message: NSLocalizedString("Please enter mobile number",comment: ""))
        } else {
            self.view.endEditing(true)
            if isEdit {
                if isGuest == "true"{
                    self.updateGuest(guestId: self.dictClient?.id ?? 0)
                }else{
                    self.updateClientData(clientId: self.dictClient?.id ?? 0)
                }
            } else {
                self.addClientData()
            }
        }
    }
    
    @IBAction func btn_DateOfBirth(_ sender: Any) {
        showCalendarPopup(sourceView: dobTextField)
    }
    
    @IBAction func act_country(_ sender: UIButton) {
        let countryView = CountrySelectView.shared
        countryView.show()
//        countryView.dismiss() //dismiss the picker view
        countryView.barTintColor = .gray //default is green
        countryView.searchBarPlaceholder = "Search" //default is "search"
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
            
            // ✅ Get ISO code and set flag image
            if let locale = countryDic["locale"] as? String {
                let isoCode = locale.uppercased()

                // Convert ISO → Emoji flag
                let flagEmoji = CountryUtils.flag(from: isoCode)

                // Convert Emoji flag → UIImage
                if let flagImage = CountryUtils.imageFromEmoji(flag: flagEmoji) {
                    self.flag_imgVw.image = flagImage
                } else {
                    self.flag_imgVw.image = nil
                    print("⚠️ Could not generate flag image")
                }
            }
        }
        
    }
    
    //MARK: Custom Function
    func showCalendarPopup(sourceView: UIView) {
        calendarVC = UIViewController()
        calendarVC?.modalPresentationStyle = .popover
        calendarVC?.preferredContentSize = CGSize(width: 500, height: 460)
        calendarVC?.view.backgroundColor = .white
//        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 500, height: 400))
        calendar = FSCalendar(frame: .zero)
        calendar.delegate = self
        calendar.dataSource = self
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.appearance.headerDateFormat = "MMMM yyyy"
        calendar.select(selectedDate)
//        calendarVC?.view.addSubview(calendar)

        calendar.appearance.selectionColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
        
        calendar.scope = .month
        calendar.scrollDirection = .horizontal   // default
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.locale = Locale(identifier: L102Language.currentAppleLanguage())
        guard let calendarVC = calendarVC else { return }
        calendarVC.view.addSubview(calendar)

        // ✅ Year tap area over calendar header
        let headerTapButton = UIButton()
        headerTapButton.backgroundColor = .clear
        headerTapButton.translatesAutoresizingMaskIntoConstraints = false
        headerTapButton.addTarget(self, action: #selector(headerTapped), for: .touchUpInside)
        calendarVC.view.addSubview(headerTapButton)

        // 📌 Constraints
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: calendarVC.view.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: calendarVC.view.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: calendarVC.view.trailingAnchor),
            calendar.bottomAnchor.constraint(equalTo: calendarVC.view.bottomAnchor),

            headerTapButton.topAnchor.constraint(equalTo: calendar.topAnchor, constant: 20),
            headerTapButton.leadingAnchor.constraint(equalTo: calendar.leadingAnchor),
            headerTapButton.trailingAnchor.constraint(equalTo: calendar.trailingAnchor),
            headerTapButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        if let popover = calendarVC.popoverPresentationController {
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
            popover.permittedArrowDirections = .up
        }

        self.present(calendarVC, animated: true, completion: nil)
    }
    
    /*@objc func headerTapped() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            guard let self = self else { return }

            //let currentYear = Calendar.current.component(.year, from: Date())
            //self.years = [currentYear]
            
            let alert = UIAlertController(title: "Select Year", message: "\n\n\n\n\n\n", preferredStyle: .alert)

            let picker = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
            picker.dataSource = self
            picker.delegate = self
            alert.view.addSubview(picker)

            let currentYear = Calendar.current.component(.year, from: self.calendar.currentPage)
            if let index = self.years.firstIndex(of: currentYear) {
                picker.selectRow(index, inComponent: 0, animated: false)
            }

            // ✅ Present from calendarVC (not self), safely
            self.calendarVC?.present(alert, animated: true)
        }
    }*/
    
    @objc func headerTapped() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }

            let alert = UIAlertController(title: "Select Month & Year", message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)

            let picker = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 160))
            picker.dataSource = self
            picker.delegate = self
            alert.view.addSubview(picker)

            // ✅ Get current month and year from calendar
            let currentDate = self.calendar.currentPage
            let currentMonth = Calendar.current.component(.month, from: currentDate)
            let currentYear = Calendar.current.component(.year, from: currentDate)

            // ✅ Set picker default position
            if let yearIndex = self.years.firstIndex(of: currentYear) {
                picker.selectRow(currentMonth - 1, inComponent: 0, animated: false)
                picker.selectRow(yearIndex, inComponent: 1, animated: false)
            }

            // ✅ Add Done & Cancel buttons
            let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
                let selectedMonth = picker.selectedRow(inComponent: 0) + 1
                let selectedYear = self.years[picker.selectedRow(inComponent: 1)]

                var components = DateComponents()
                components.year = selectedYear
                components.month = selectedMonth
                components.day = 1

                if let newDate = Calendar.current.date(from: components) {
                    self.calendar.setCurrentPage(newDate, animated: true)
                }
            }

            alert.addAction(doneAction)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            // ✅ Present the alert safely from calendarVC
            self.calendarVC?.present(alert, animated: true)
        }
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
                        formatter.locale = Locale(identifier: L102Language.currentAppleLanguage())
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
        /*if let clientType = self.dictClient?.client_type, !clientType.isEmpty && clientType != "null" {
            self.clientTypeTextField.setText(ClientTypeOptions[ClientTypeOptions.firstIndex(of: clientType)!])
        }*/
        
        if let clientType = dictClient?.client_type {
            if let item = ClientTypeOptions.first(where: { $0.apiValue == clientType }) {
                clientTypeTextField.setText(item.displayValue)
                selectedClientTypeAPIValue = item.apiValue
            }else{
                if ClientTypeOptions.count > 1 {
                    let clientTypeItem = ClientTypeOptions[1]
                    clientTypeTextField.setText(clientTypeItem.displayValue)
                    selectedClientTypeAPIValue = clientTypeItem.apiValue
                }
            }
        }

        if let gender = dictClient?.gender {
            if let item = genderOptions.first(where: { $0.apiValue == gender }) {
                genderTextField.setText(item.displayValue)
                selectedGenderAPIValue = item.apiValue
            }else{
                if genderOptions.count > 1 {
                    let genderItem = genderOptions[1]
                    genderTextField.setText(genderItem.displayValue)
                    selectedGenderAPIValue = genderItem.apiValue
                }
            }
        }

        /*if let gender = self.dictClient?.gender, !gender.isEmpty && gender != "null" {
            self.genderTextField.setText(genderOptions[genderOptions.firstIndex(of: gender)!])
        }*/
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
        if let customFont = UIFont(name: "Lato-Regular", size: 20.0) {
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
        let mobileNo = "\(selectedCountrycode)-\(self.mobileTextField.text ?? "")"
        self.showLoader()
        APIService.shared.addClientData(firstName: self.firstNameTextField.text ?? "", lastName: self.lastNameTextField.text ?? "", vendorId: LocalData.userId, email: self.emailTextField.text ?? "", clientType: selectedClientTypeAPIValue, gender: selectedGenderAPIValue, dob: self.dobTextField.text ?? "", phone: mobileNo) { staffResult in
            self.hideLoader()
            guard let model = staffResult else {
                return
            }

            if model.error == "" {
                DispatchQueue.main.async {
                    // safe UI code here
                    self.showToast(message: NSLocalizedString("Client added successfully",comment: ""))
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.showToast(message: NSLocalizedString("Failed to insert client", comment: ""))
            }
        }
    }
    
    func updateClientData(clientId: Int) {
        let mobileNo = "\(selectedCountrycode)-\(self.mobileTextField.text ?? "")"
        self.showLoader()
        
        APIService.shared.updateClientData(firstName: self.firstNameTextField.text ?? "", lastName: self.lastNameTextField.text ?? "", vendorId: LocalData.userId, email: self.emailTextField.text ?? "", clientType: selectedClientTypeAPIValue, gender: selectedGenderAPIValue, dob: self.dobTextField.text ?? "", phone: mobileNo, clientId: clientId) { staffResult in
            self.hideLoader()
            guard let model = staffResult else {
                return
            }
            self.hideLoader()
            if model.error == "" || model.error == nil {
                DispatchQueue.main.async {
                    // safe UI code here
                    self.showToast(message: NSLocalizedString("Client details updated successfully",comment: ""))
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.showToast(message: NSLocalizedString("Failed to insert client", comment: ""))
            }
        }
    }
    
    func updateGuest(guestId: Int) {
        let mobileNo = "\(selectedCountrycode)-\(self.mobileTextField.text ?? "")"
        self.showLoader()
        
        APIService.shared.updateGuest(client_type: selectedClientTypeAPIValue, dob: self.dobTextField.text ?? "", email: self.emailTextField.text ?? "", first_name: self.firstNameTextField.text ?? "", last_name: self.lastNameTextField.text ?? "", gender: selectedGenderAPIValue, phone: mobileNo, guestId: guestId) { staffResult in
            self.hideLoader()
            guard let model = staffResult else {
                return
            }
            self.hideLoader()
            if model.error == "" || model.error == nil {
                DispatchQueue.main.async {
                    // safe UI code here
                    self.showToast(message: NSLocalizedString("Guest details updated successfully",comment: ""))
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.showToast(message: NSLocalizedString("Failed to insert guest", comment: ""))
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
            cell.textLabel?.text = genderOptions[indexPath.row].displayValue
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            return cell
        } else if tableView == dropdownView1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = ClientTypeOptions[indexPath.row].displayValue
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == dropdownView {
            let item = genderOptions[indexPath.row]
            genderTextField.text = item.displayValue
            selectedGenderAPIValue = item.apiValue
            genderTextField.showLabel()
            dropdownView.isHidden = true
            isDropdownVisible = false
        } else if tableView == dropdownView1 {
            let item = ClientTypeOptions[indexPath.row]
            clientTypeTextField.text = item.displayValue
            selectedClientTypeAPIValue = item.apiValue
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
//            self.view.endEditing(true)
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
        formatter.locale = Locale(identifier: L102Language.currentAppleLanguage())
        self.dobTextField.text = formatter.string(from: selectedDate)
        self.dobTextField.showLabel()
        calendarVC?.dismiss(animated: true)
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        // ✅ Allow earliest year 1900
        return Calendar.current.date(from: DateComponents(year: 1900, month: 1, day: 1))!
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date() // today's date as max
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return #colorLiteral(red: 0.7686, green: 0.4, blue: 0.8902, alpha: 1) // ← Your desired selection color
    }
}

/*extension AddClientVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(years[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedYear = self.years[row]
        var components = Calendar.current.dateComponents([.month], from: self.calendar.currentPage)
        components.year = selectedYear
        components.day = 1
        if let date = Calendar.current.date(from: components) {
            self.calendar.setCurrentPage(date, animated: true)
        }
        self.calendarVC?.dismiss(animated: true)
    }
}*/


extension AddClientVC: UIPickerViewDelegate, UIPickerViewDataSource {

    var months: [String] {
        return [
            "January", "February", "March", "April", "May", "June",
            "July", "August", "September", "October", "November", "December"
        ]
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2 // Month + Year
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? months.count : years.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? months[row] : "\(years[row])"
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return component == 0 ? 140 : 80
    }
}
