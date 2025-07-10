//
//  AddTeamVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 23/06/25.
//

import UIKit
import CountryPickerViewSwift
import FSCalendar

class AddTeamVC: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var img_teamMember: UIImageView!
    @IBOutlet weak var firstNameTextField: TextInputLayout!
    @IBOutlet weak var lastNameTextField: TextInputLayout!
    @IBOutlet weak var jobTitleTextField: TextInputLayout!
    @IBOutlet weak var genderTextField: TextInputLayout!
    @IBOutlet weak var emailTextField: TextInputLayout!
    @IBOutlet weak var dobTextField: TextInputLayout!
    @IBOutlet weak var mobileTextField: TextInputLayout!
    @IBOutlet weak var flag_imgVw: UIImageView!
    @IBOutlet weak var btn_visibility: UIButton!
    @IBOutlet weak var btn_editSchedule: UIButton!
    @IBOutlet weak var btn_editService: UIButton!
    @IBOutlet weak var btn_addTimeOff: UIButton!
    @IBOutlet weak var btn_addEditTeam: GradientButton!
    
    var dictStaff: StaffData?
    
    let dropdownView = UITableView()
    let datePicker = UIDatePicker()
    let genderOptions = ["Male", "Female", "Rather not to say"]
    var isDropdownVisible = false
    var selectedCountrycode = "+353"
    var calendarVC: UIViewController?
    var selectedDate: Date = Date.now
    var isEdit = false
    var serviceIds = String()
    var workingHoursJson: String = ""
    var shiftTimingJson: String = ""
    
    var salonItems: [ScheduleModel] = []
    
    
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.api_getBusinessHours()
        self.dobTextField.delegate = self
        setupGenderTextField()
        setupDropdownTable()
        if isEdit {
            self.btn_addEditTeam.setTitle("Update Team Member", for: .normal)
            self.btn_editService.setTitle("Edit Services", for: .normal)
            self.btn_addTimeOff.isHidden = false
            self.lbl_title.text = "Edit Team Member"
            self.setEditData()
        } else {
            self.btn_addEditTeam.setTitle("Add Team Member", for: .normal)
            self.btn_editService.setTitle("Assign Services", for: .normal)
            self.btn_addTimeOff.isHidden = true
            self.lbl_title.text = "Add Team Member"
        }
        // Do any additional setup after loading the view.
    }
    
    
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
    
    func setEditData() {
        if let dict = self.dictStaff {
            self.firstNameTextField.text = dict.firstName
            self.lastNameTextField.text = dict.lastName
            self.jobTitleTextField.text = dict.jobTitle
            self.emailTextField.text = dict.email
            if var phoneno = dict.phone {
                if !phoneno.isEmpty && phoneno.count >= 3 {
                    if phoneno.contains("--") {
                        phoneno = phoneno.replacingOccurrences(of: "--", with: "-")
                    }
                    print("Mobile No: \(phoneno)")
                    let split = phoneno.components(separatedBy: "-")
                    if split.count >= 2 {
                        let countryCode = split[0]
                        let mobileNo = split[1]
                        self.selectedCountrycode = countryCode
                        self.mobileTextField.setText(mobileNo) // Assuming this is your UITextField
                        if let iso = CountryUtils.getISOCode(from: countryCode) {
                            if let flagImage = CountryUtils.imageFromEmoji(flag: CountryUtils.flag(from: iso)) {
                                flag_imgVw.image = flagImage
                            }
                        }
                    }
                }
            }
            if let dob = dict.dob {
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
            if let gender = dict.gender, !gender.isEmpty && gender != "null" {
                self.genderTextField.setText(genderOptions[genderOptions.firstIndex(of: gender)!])
            }
            self.workingHoursJson = dict.workingHours ?? ""
            self.shiftTimingJson = dict.shiftTimings ?? ""
            self.serviceIds = dict.serviceIds ?? ""
            if let photo = dict.photo, photo != "" {
                let imgUrl = global.imageUrl + photo
                if let url = URL(string: imgUrl) {
                    self.img_teamMember.sd_setImage(with: url, completed: { (image, error, _, _) in
                        if let error = error {
                            print("❌ Failed to load image: \(error.localizedDescription)")
                            self.img_teamMember.image = UIImage(named: "user")
                        } else {
                            self.img_teamMember.image = image
                        }
                    })
                }
            }
        }
    }
    
    // MARK: Button Action
    @IBAction func act_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func act_visibility(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "rdCheck") {
            sender.setImage(UIImage(named: "rdUncheck"), for: .normal)
        } else if sender.currentImage == UIImage(named: "rdUncheck") {
            sender.setImage(UIImage(named: "rdCheck"), for: .normal)
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
    
    
    @IBAction func act_uploadImage(_ sender: UIButton) {
        showImagePickerActionSheet(sourceView: sender)
    }
    
    @IBAction func act_editSchedule(_ sender: UIButton) {
        let editSchedule = self.storyboard?.instantiateViewController(withIdentifier: "EditScheduleVC") as! EditScheduleVC
        editSchedule.modalPresentationStyle = .overCurrentContext
        editSchedule.modalTransitionStyle = .crossDissolve
        editSchedule.salonItems = self.salonItems
        editSchedule.isEdit = isEdit
        if isEdit {
            editSchedule.TeamName = self.dictStaff!.firstName!.capitalized + " " + self.dictStaff!.lastName!.capitalized
            editSchedule.TeamId = "\(self.dictStaff!.id ?? 0)"
            editSchedule.WorkingHours = self.dictStaff!.workingHours ?? ""
            editSchedule.shiftTiming = self.dictStaff!.shiftTimings ?? ""
        }
        editSchedule.onDataReturn = { value1, value2 in
            print("Received values: \(value1), \(value2)")
            self.workingHoursJson = value1
            self.shiftTimingJson = value2
            // Do something with the two strings
        }
        self.present(editSchedule, animated: true)
    }
    
    @IBAction func act_editService(_ sender: UIButton) {
        let editService = self.storyboard?.instantiateViewController(withIdentifier: "AssignServiceVC") as! AssignServiceVC
        editService.isEdit = isEdit
        if isEdit {
            editService.teamName = self.dictStaff!.firstName!.capitalized + " " + self.dictStaff!.lastName!.capitalized
        }
        editService.modalPresentationStyle = .overCurrentContext
        editService.modalTransitionStyle = .crossDissolve
        editService.onDataReturn = { [weak self] returnedData in
            print("Received data: \(returnedData)")
            self?.serviceIds = returnedData
            // self?.yourLabel.text = returnedData
        }
        self.present(editService, animated: true)
    }
    
    @IBAction func act_addTimeOff(_ sender: UIButton) {
        let addTimeOff = self.storyboard?.instantiateViewController(withIdentifier: "AddTimeDiffVC") as! AddTimeDiffVC
        if isEdit {
            addTimeOff.TeamName = self.dictStaff!.firstName!.capitalized + " " + self.dictStaff!.lastName!.capitalized
            addTimeOff.TeamId = "\(self.dictStaff!.id ?? 0)"
        }
        addTimeOff.modalPresentationStyle = .overCurrentContext
        addTimeOff.modalTransitionStyle = .crossDissolve
        self.present(addTimeOff, animated: true)
    }
    
    @IBAction func act_cancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func act_addEditTeam(_ sender: GradientButton) {
        if self.firstNameTextField.text!.isEmpty {
            self.showToast(message: "Please enter first name")
        } else if self.jobTitleTextField.text!.isEmpty {
            self.showToast(message: "Please enter job title")
        } else if self.genderTextField.text!.isEmpty {
            self.showToast(message: "Please select gender")
        } else {
            if isEdit {
                self.updateTeamApi()
            } else {
                self.addTeamApi()
            }
        }
    }
    
    //MARK: API Call
    func api_getBusinessHours() {
        APIService.shared.fetchTiming { workingHours in
            let salonHours = workingHours
            self.workingHoursJson = workingHours
            self.shiftTimingJson = workingHours
            let workinghours = APIService.shared.parseWorkingHours(salonHours)
            self.salonItems = self.convertWorkingHoursToSchedule(workinghours)
        }
    }
    
    func addTeamApi() {
        let mobileNo = "\(selectedCountrycode)-\(self.mobileTextField.text ?? "")"
        self.showLoader()
         if let image = self.img_teamMember.image {
             APIService.shared.addTeamData(firstName: self.firstNameTextField.text ?? "", lastName: self.lastNameTextField.text ?? "", vendorId: "\(LocalData.userId)", email: self.emailTextField.text ?? "", jobTitle: self.jobTitleTextField.text ?? "", gender: self.genderTextField.text ?? "", dob: self.dobTextField.text ?? "", phone: mobileNo, showCustomer: self.btn_visibility.currentImage == UIImage(named: "rdCheck") ? "1" : "0", showInCalendar: "1", serviceIds: self.serviceIds, workingHours: self.workingHoursJson, shiftTimings: self.shiftTimingJson, image: image, imageKey: "file") { response in
                 self.hideLoader()
                 if response != nil {
                    DispatchQueue.main.async {
                        // safe UI code here
                        self.showToast(message: "Team member added successfully")
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    let errorMessage = response?.error ?? "Something went wrong"
                    self.show_alert(msg: errorMessage, title: "Add Team")
                }
            }
         } else {
             APIService.shared.addTeamData(firstName: self.firstNameTextField.text ?? "", lastName: self.lastNameTextField.text ?? "", vendorId: "\(LocalData.userId)", email: self.emailTextField.text ?? "", jobTitle: self.jobTitleTextField.text ?? "", gender: self.genderTextField.text ?? "", dob: self.dobTextField.text ?? "", phone: mobileNo, showCustomer: self.btn_visibility.currentImage == UIImage(named: "rdCheck") ? "1" : "0", showInCalendar: "1", serviceIds: self.serviceIds, workingHours: self.workingHoursJson, shiftTimings: self.shiftTimingJson, image: nil, imageKey: "file") { response in
                 self.hideLoader()
                 if response != nil {
                    DispatchQueue.main.async {
                        // safe UI code here
                        self.showToast(message: "Team member added successfully")
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    let errorMessage = response?.error ?? "Something went wrong"
                    self.show_alert(msg: errorMessage, title: "Add Team")
                }
            }
         }
    }
    
    func updateTeamApi() {
        let mobileNo = "\(selectedCountrycode)-\(self.mobileTextField.text ?? "")"
        self.showLoader()
         if let image = self.img_teamMember.image {
             APIService.shared.updateTeamData(firstName: self.firstNameTextField.text ?? "", lastName: self.lastNameTextField.text ?? "", vendorId: "\(LocalData.userId)", email: self.emailTextField.text ?? "", jobTitle: self.jobTitleTextField.text ?? "", gender: self.genderTextField.text ?? "", dob: self.dobTextField.text ?? "", phone: mobileNo, showCustomer: self.btn_visibility.currentImage == UIImage(named: "rdCheck") ? "1" : "0", showInCalendar: "1", serviceIds: self.serviceIds, workingHours: self.workingHoursJson, shiftTimings: self.shiftTimingJson, image: image, imageKey: "file", teamId: "\(self.dictStaff!.id ?? 0)") { response in
                 self.hideLoader()
                 if response != nil {
                    DispatchQueue.main.async {
                        // safe UI code here
                        self.showToast(message: response?.data ?? "")
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    let errorMessage = response?.error ?? "Something went wrong"
                    self.show_alert(msg: errorMessage, title: "Update Team")
                }
            }
         } else {
             APIService.shared.updateTeamData(firstName: self.firstNameTextField.text ?? "", lastName: self.lastNameTextField.text ?? "", vendorId: "\(LocalData.userId)", email: self.emailTextField.text ?? "", jobTitle: self.jobTitleTextField.text ?? "", gender: self.genderTextField.text ?? "", dob: self.dobTextField.text ?? "", phone: mobileNo, showCustomer: self.btn_visibility.currentImage == UIImage(named: "rdCheck") ? "1" : "0", showInCalendar: "1", serviceIds: self.serviceIds, workingHours: self.workingHoursJson, shiftTimings: self.shiftTimingJson, image: nil, imageKey: "file", teamId: "\(self.dictStaff!.id ?? 0)") { response in
                 self.hideLoader()
                 if response != nil {
                    DispatchQueue.main.async {
                        // safe UI code here
                        self.showToast(message: response?.data ?? "")
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    let errorMessage = response?.error ?? "Something went wrong"
                    self.show_alert(msg: errorMessage, title: "Update Team")
                }
            }
         }
    }
    
    
    func convertWorkingHoursToSchedule(_ workingHours: [WorkingHour]) -> [ScheduleModel] {
        let allDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        var result: [ScheduleModel] = []

        for day in allDays {
            if let match = workingHours.first(where: { $0.day == day }) {
                let fromTime = match.from ?? "00:00"
                let toTime = match.to ?? "23:00"
                result.append(ScheduleModel(day: day, from: fromTime, to: toTime, isSwitched: true))
            } else {
                result.append(ScheduleModel(day: day, from: "00:00", to: "23:00", isSwitched: false))
            }
        }

        return result
    }
    
    //MARK: Function
    func showImagePickerActionSheet(sourceView: UIView) {
        let actionSheet = UIAlertController(title: "Select Image", message: nil, preferredStyle: .actionSheet)

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.presentImagePicker(sourceType: .camera)
            }))
        }

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
                self.presentImagePicker(sourceType: .photoLibrary)
            }))
        }

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        // ✅ Important: iPad compatibility
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = sourceView
            popoverController.sourceRect = sourceView.bounds
        }

        self.present(actionSheet, animated: true)
    }

    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true)
    }

    
    func showCalendarPopup(sourceView: UIView) {
        calendarVC = UIViewController()
        calendarVC?.modalPresentationStyle = .popover
        calendarVC?.preferredContentSize = CGSize(width: 500, height: 400)

        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 500, height: 400))
        calendar.delegate = self
        calendar.dataSource = self

        calendarVC?.view.addSubview(calendar)

        if let popover = calendarVC?.popoverPresentationController {
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
            popover.permittedArrowDirections = .up
        }

        self.present(calendarVC!, animated: true, completion: nil)
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

extension AddTeamVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genderOptions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = genderOptions[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        genderTextField.text = genderOptions[indexPath.row]
        genderTextField.showLabel()
        dropdownView.isHidden = true
        isDropdownVisible = false
    }
}


extension AddTeamVC: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == dobTextField) {
            showCalendarPopup(sourceView: textField)
            return false // Prevent keyboard
        } else {
            return true
        }
    }
    
}


extension AddTeamVC: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        self.dobTextField.text = formatter.string(from: selectedDate)
        self.dobTextField.showLabel()
        calendarVC?.dismiss(animated: true)
    }
}

extension AddTeamVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        if let selectedImage = info[.originalImage] as? UIImage {
            // Use selectedImage (e.g. assign to UIImageView)
            print("Image selected")
            self.img_teamMember.image = selectedImage
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    
}
