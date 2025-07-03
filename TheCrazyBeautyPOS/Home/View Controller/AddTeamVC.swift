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
    var isEdit = false
    
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dobTextField.delegate = self
        setupGenderTextField()
        setupDropdownTable()
        if isEdit {
            self.btn_addEditTeam.setTitle("Update Team Member", for: .normal)
            self.btn_editService.setTitle("Edit Services", for: .normal)
            self.btn_addTimeOff.isHidden = false
        } else {
            self.btn_addEditTeam.setTitle("Add Team Member", for: .normal)
            self.btn_editService.setTitle("Assign Services", for: .normal)
            self.btn_addTimeOff.isHidden = true
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
    }
    
    @IBAction func act_editService(_ sender: UIButton) {
    }
    
    @IBAction func act_addTimeOff(_ sender: UIButton) {
    }
    
    @IBAction func act_cancel(_ sender: UIButton) {
    }
    
    @IBAction func act_addEditTeam(_ sender: GradientButton) {
    }
    
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
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        self.dobTextField.text = formatter.string(from: date)
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
