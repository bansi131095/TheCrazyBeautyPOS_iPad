//
//  AddOfflineGiftCard_VC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 25/07/25.
//

import UIKit
import FSCalendar

class AddOfflineGiftCard_VC: UIViewController {

    
    @IBOutlet weak var txt_GiftName: TextInputLayout!
    @IBOutlet weak var txt_Price: TextInputLayout!
    @IBOutlet weak var txt_Description: FloatingTextView!
    @IBOutlet weak var txt_ExpiryDate: TextInputLayout!
    
    
    var calendarVC: UIViewController?
    var selectedDate: Date = Date.now
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txt_ExpiryDate.delegate = self
        setCustomFont()
    }
    

    
    @IBAction func btn_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_Cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btn_AddGiftCard(_ sender: Any) {
        if txt_GiftName.text == ""{
            self.showToast(message: "Gift Name is required.")
        }else if txt_Price.text == ""{
            self.showToast(message: "Price is required.")
        }else if txt_Description.text == ""{
            self.showToast(message: "Description is required.")
        }else if txt_ExpiryDate.text == "" {
            self.showToast(message: "Please select expiry date.")
        }else{
            AddOfflineGiftCardApiCall()
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
        calendar.appearance.titleDefaultColor = .black
        calendar.appearance.selectionColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
        calendar.appearance.todayColor = #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
        calendarVC?.view.addSubview(calendar)

        if let popover = calendarVC?.popoverPresentationController {
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
            popover.permittedArrowDirections = .down
        }

        self.present(calendarVC!, animated: true, completion: nil)
    }
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Regular", size: 22.0) {
            txt_GiftName.font = customFont
            txt_Price.font = customFont
            txt_ExpiryDate.font = customFont
        }
    }
    
    func AddOfflineGiftCardApiCall() {
        APIService.shared.add_offgift(vendorId: LocalData.userId, gift_name: self.txt_GiftName.text ?? "", price: self.txt_Price.text ?? "", expiry_date: self.txt_ExpiryDate.text ?? "", description: self.txt_Description.text) { result in
            guard let model = result else {
                return
            }
            
            if model.error == "" || model.error == nil {
                DispatchQueue.main.async {
                    // safe UI code here
                    self.showToast(message: model.data?.message ?? "")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            } else {
                self.show_alert(msg: model.error, title: "")
            }
            
        }
        
    }
}

extension AddOfflineGiftCard_VC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        txt_ExpiryDate.text = formatter.string(from: date)
        txt_ExpiryDate.showLabel()
        calendarVC?.dismiss(animated: true)
    }

    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return date >= Calendar.current.startOfDay(for: Date()) // Allow only today and future dates
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return date < Calendar.current.startOfDay(for: Date()) ? .lightGray : nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return #colorLiteral(red: 0.7686, green: 0.4, blue: 0.8902, alpha: 1) // ← Your desired selection color
    }
}

extension AddOfflineGiftCard_VC: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == txt_ExpiryDate) {
            self.view.endEditing(true)
            showCalendarPopup(sourceView: textField)
            return false // Prevent keyboard
        } else {
            return true
        }
    }
}
