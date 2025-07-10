//
//  Salon_OpeningDateVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 10/07/25.
//

import UIKit
import FSCalendar

class Salon_OpeningDateVC: UIViewController {

    @IBOutlet weak var txt_Date: TextInputLayout!
    
    var calendarVC: UIViewController?
    var SelectedDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_Date.delegate = self
        fetchGetDate()
    }
    
    @IBAction func act_save(_ sender: GradientButton) {
        guard let from = txt_Date.text, !from.isEmpty else {
            return
        }
//        updateOpenDate()
        updateOpenDate()
    }

    //MARK: Custom Function
    func showCalendarPopup(sourceView: UIView) {
    
        calendarVC = UIViewController()
        calendarVC?.modalPresentationStyle = .popover
        calendarVC?.preferredContentSize = CGSize(width: 500, height: 400)

        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 500, height: 400))
        calendar.delegate = self
        calendar.dataSource = self
        calendar.appearance.titleDefaultColor = .black
        calendar.appearance.selectionColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
        calendar.appearance.todayColor = #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
        calendarVC?.view.addSubview(calendar)

        if let popover = calendarVC?.popoverPresentationController {
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
            popover.permittedArrowDirections = .up
        }

        self.present(calendarVC!, animated: true, completion: nil)
    }
    
    func fetchGetDate() {
        APIService.shared.fetchGetOpenDate { result in
            guard let result = result else {
                print("❌ Failed to get opening date")
                return
            }
            
            if let openingDate = result.data.first?.opening_date {
                self.txt_Date.text = openingDate
            } else {
                print("⚠️ No opening date available")
            }
        }
    }

    func updateOpenDate(){
        APIService.shared.UpdateOpenDate(vendor_id: LocalData.userId, opening_date: self.txt_Date.text ?? "") { result in
            if result != nil {
                self.alertWithMessageOnly(result?.data ?? "")
            }else{
                self.alertWithMessageOnly("Something Want Wrong")
            }
        }
    }
}

extension Salon_OpeningDateVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        SelectedDate = date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        txt_Date.text = formatter.string(from: date)
        txt_Date.showLabel()
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


extension Salon_OpeningDateVC: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txt_Date {
            view.endEditing(true)
            showCalendarPopup(sourceView: textField)
            return false
        }
        return true
    }
    
}

