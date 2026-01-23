//
//  SalonHolidayVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 30/06/25.
//

import UIKit
import FSCalendar

class Salon_HolidayVC: UIViewController {

    @IBOutlet weak var txt_from: TextInputLayout!
    @IBOutlet weak var txt_to: TextInputLayout!
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var vwHoliday: UIView!
    @IBOutlet weak var vwHolidayHeight: NSLayoutConstraint!
    @IBOutlet weak var btn_Save: GradientButton!
    
    var salonHolidaysList: [HolidayDateModel] = []
    
    var calendarVC: UIViewController?
    var fromSelectedDate: Date?
    var toSelectedDate: Date?
    var isSelectingFromDate: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_from.delegate = self
        txt_to.delegate = self
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
        fetchHolidays()
        setCustomFont()
    }
    
    @IBAction func act_save(_ sender: GradientButton) {
        /*guard let from = txt_from.text, !from.isEmpty,
              let to = txt_to.text, !to.isEmpty else {
            print("❌ From or To date is missing")
            return
        }
        self.updateHolidaysDate()*/
        
        if txt_from.text == nil || txt_from.text!.isEmpty {
            alertWithMessageOnly(NSLocalizedString("Please select From date", comment: ""))
            return
        }

        if txt_to.text == nil || txt_to.text!.isEmpty {
            alertWithMessageOnly(NSLocalizedString("Please select To date", comment: ""))
            return
        }

       let formatter = DateFormatter()
       formatter.dateFormat = "dd-MM-yyyy"

       let fromDate = formatter.date(from: txt_from.text!)
       let toDate = formatter.date(from: txt_to.text!)

       if fromDate == nil || toDate == nil {
           alertWithMessageOnly(NSLocalizedString("Invalid date", comment: ""))
           return
       }

       if fromDate! > toDate! {
           alertWithMessageOnly(NSLocalizedString("From date should not be greater than To date", comment: ""))
           return
       }
        
       updateHolidaysDate()
    }
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Medium", size: 18.0) {
            txt_from.font = customFont
            txt_to.font = customFont
        }
    }
    
    func setTableView(){
        tbl_vw.register(UINib(nibName: "HolidayDatesCell", bundle: nil), forCellReuseIdentifier: "HolidayDatesCell")
        tbl_vw.delegate = self
        tbl_vw.dataSource = self
        tbl_vw.rowHeight = UITableView.automaticDimension
        tbl_vw.estimatedRowHeight = 60
    }
    
    
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
        calendar.locale = Locale(identifier: L102Language.currentAppleLanguage())
        calendarVC?.view.addSubview(calendar)

        if let popover = calendarVC?.popoverPresentationController {
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
            popover.permittedArrowDirections = .up
        }

        self.present(calendarVC!, animated: true, completion: nil)
    }
    
    //MARK: - APICAll
    func fetchHolidays() {
        showLoader()
        APIService.shared.fetchSalonHolidays { result in
            self.hideLoader()
            if let holidayWrapper = result?.data.first {
                self.salonHolidaysList = holidayWrapper.holiday_dates
                DispatchQueue.main.async {
                    self.tbl_vw.isHidden = self.salonHolidaysList.isEmpty
                    self.tbl_vw.reloadData()
                    self.vwHoliday.isHidden = false
                    self.vwHolidayHeight.constant = 30
                }
            } else {
                DispatchQueue.main.async {
                    self.tbl_vw.isHidden = true
                    self.vwHoliday.isHidden = true
                    self.vwHolidayHeight.constant = 0
                }
            }
        }
    }
    
    func updateHolidaysDate() {
        var allDates: [HolidayDate1] = []

        // Add only valid previous dates
        for item in salonHolidaysList {
            if let f = item.from, !f.isEmpty,
               let t = item.to, !t.isEmpty {
                allDates.append(HolidayDate1(from: f, to: t))
            }
        }

        // Add new entry only if both from and to are filled
        if let newFrom = txt_from.text, !newFrom.isEmpty,
           let newTo = txt_to.text, !newTo.isEmpty {
            allDates.append(HolidayDate1(from: newFrom, to: newTo))
        }
        showLoader()
        // Send to API
        APIService.shared.updateSalonHolidays(vendorID: LocalData.userId, holidays: allDates) { success in
            self.hideLoader()
            if success {
                self.alertWithMessageOnly(NSLocalizedString("Salon holidays updated successfully",comment: ""))
                self.txt_from.text = ""
                self.txt_to.text = ""
                self.fetchHolidays()
            } else {
                self.alertWithMessageOnly(NSLocalizedString("Failed to update salon holidays",comment: ""))
            }
        }
    }

}

extension Salon_HolidayVC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.salonHolidaysList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbl_vw.dequeueReusableCell(withIdentifier: "HolidayDatesCell", for: indexPath) as? HolidayDatesCell else {
            return UITableViewCell()
        }
        let data = self.salonHolidaysList[indexPath.row]
        cell.lbl_fromTo.text = "\(data.from ?? "") to \(data.to ?? "")"
        cell.Act_Delete = {
            self.salonHolidaysList.remove(at: indexPath.row)
            self.tbl_vw.reloadData()
            self.updateHolidaysDate()
        }
        return cell
    }


    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
}

extension Salon_HolidayVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let formattedDate = formatter.string(from: date)

        if isSelectingFromDate {
            fromSelectedDate = date
            txt_from.text = formattedDate
            txt_from.showLabel()
        } else {
            toSelectedDate = date
            txt_to.text = formattedDate
            txt_to.showLabel()
        }

        calendarVC?.dismiss(animated: true)
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return date >= Calendar.current.startOfDay(for: Date())
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if date < Calendar.current.startOfDay(for: Date()) {
            return UIColor.lightGray // dim past dates
        }
        return nil // default color
    }


}


extension Salon_HolidayVC: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == txt_from) {
            self.view.endEditing(true)
            self.isSelectingFromDate = true
            showCalendarPopup(sourceView: textField)
            return false // Prevent keyboard
        } else if (textField == txt_to) {
            self.view.endEditing(true)
            self.isSelectingFromDate = false
            showCalendarPopup(sourceView: textField)
            return false // Prevent keyboard
        } else {
            return true
        }
    }
    
}

