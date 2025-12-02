//
//  Custom_HoursVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 02/12/25.
//

import UIKit
import FSCalendar
import DropDown

class Custom_HoursVC: UIViewController {

    @IBOutlet weak var txt_Date: TextInputLayout!
    @IBOutlet weak var cv_Time: UICollectionView!
    @IBOutlet weak var cv_Height: NSLayoutConstraint!
    
    
    var calendarVC: UIViewController?
    var SelectedDate: Date?
    var SalonTiming: [SalonTiming] = []
    
    let fromTime = "00:00"
    let toTime = "23:30"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomFont()
        setCollectCategory()
        api_NoShowLimit()
    }
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Medium", size: 18.0) {
            txt_Date.font = customFont
        }
    }
    
    func setCollectCategory() {
        self.cv_Time.register(UINib(nibName: "CustomeTimeCell", bundle: nil), forCellWithReuseIdentifier: "CustomeTimeCell")
        self.cv_Time.dataSource = self
        self.cv_Time.delegate = self
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
    
    @IBAction func btn_Add(_ sender: Any) {
        guard let selectedDate = txt_Date.text, !selectedDate.isEmpty else {
            self.alertWithMessageOnly("Please Select Date.")
            return
        }

        if SalonTiming.contains(where: { $0.date == selectedDate }) {
            self.alertWithMessageOnly("This date already exists.")
            return
        }
        
        let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            
        let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEEE"
        
        let selectedDateObj = formatter.date(from: selectedDate)!
        let dayName = dayFormatter.string(from: selectedDateObj)
        
        let newItem = TheCrazyBeautyPOS.SalonTiming(JSON: [
                "date": selectedDate,
                "day": dayName,
                "working_hours": [
                    "from": "00:00",
                    "to": "23:30",
                    "day": dayName
                ]
            ])!
        SalonTiming.append(newItem)
        
        DispatchQueue.main.async {
            self.cv_Time.reloadData()
            self.updateCollectionHeight()
            let lastIndex = IndexPath(item: self.SalonTiming.count - 1, section: 0)
            self.cv_Time.scrollToItem(at: lastIndex, at: .centeredHorizontally, animated: true)
        }
    }
    
    @IBAction func btn_Save(_ sender: Any) {
        // ---- Create Array for JSON ----
            var jsonArray: [[String: Any]] = []
            
            for item in SalonTiming {
                var dict: [String: Any] = [:]
                
                // If id exists keep it, else ignore
                if let id = item.id {
                    dict["id"] = id
                }
                
                dict["date"] = item.date ?? ""
                dict["day"] = item.day ?? ""
                
                dict["working_hours"] = [
                    "day": item.working_hours?.day ?? "",
                    "from": item.working_hours?.from ?? "",
                    "to": item.working_hours?.to ?? ""
                ]
                
                jsonArray.append(dict)
            }
            
            // ---- Final JSON with delete key ----
            let finalParams: [String: Any] = [
                "salon_timing": jsonArray,
                "delete_timing": ""  // ← When delete used, send IDs here comma separated
            ]
            
            
            print("FINAL JSON TO SEND:")
            print("finalParams:- \(finalParams)")
            
    }
    
    //MARK: - Web Api Calling
    func api_NoShowLimit() {
        showLoader()
        APIService.shared.getSalonTimings { [weak self] result in
            self?.hideLoader()
            guard let self = self else { return }
            SalonTiming = result?.data ?? []
            DispatchQueue.main.async {
                self.cv_Time.reloadData()
                self.updateCollectionHeight()
            }
        }
    }
    
    func updateCollectionHeight() {
        self.cv_Time.layoutIfNeeded()
        self.cv_Height.constant =
            self.cv_Time.collectionViewLayout.collectionViewContentSize.height
    }
    
    func generateTimeSlots(start: String, end: String, interval: Int) -> [String] {
        var result: [String] = []

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        guard let startDate = formatter.date(from: start),
              let endDate = formatter.date(from: end) else { return result }

        var currentTime = startDate
        while currentTime <= endDate {
            result.append(formatter.string(from: currentTime))
            currentTime = Calendar.current.date(byAdding: .minute, value: interval, to: currentTime)!
        }

        return result
    }
    
    func removeTiming(at index: Int) {
        guard index >= 0 && index < SalonTiming.count else { return }

        SalonTiming.remove(at: index)
        cv_Time.reloadData()

        if !SalonTiming.isEmpty {
            let lastIndex = IndexPath(item: SalonTiming.count - 1, section: 0)
            self.cv_Time.reloadData()
            self.updateCollectionHeight()
            cv_Time.scrollToItem(at: lastIndex, at: .centeredHorizontally, animated: true)
        }
    }
}


extension Custom_HoursVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SalonTiming.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv_Time.dequeueReusableCell(withReuseIdentifier: "CustomeTimeCell", for: indexPath) as! CustomeTimeCell
        let data = SalonTiming[indexPath.row]
        cell.lbl_Date.text = data.date
        cell.lbl_FromTime.text = data.working_hours?.from
        cell.lbl_ToTime.text = data.working_hours?.to
        
        /*cell.Act_From = {
            let slots = self.generateTimeSlots(start: self.fromTime, end: self.toTime, interval: 30)
            
            let slotDuration = DropDown()
            slotDuration.anchorView = cell.lbl_FromTime
            slotDuration.bottomOffset = CGPoint(x: 0, y:(slotDuration.anchorView?.plainView.bounds.height)!)
            slotDuration.direction = .bottom
            slotDuration.dataSource = slots
            slotDuration.cellHeight = 35
            slotDuration.show()
            slotDuration.textFont = UIFont(name: "Lato-Regular", size: 18.0)!
            slotDuration.backgroundColor = .white
            slotDuration.selectionAction = {  [unowned self] (index: Int, item: String) in
                print("Selected item: \(item) at index: \(index)")
                cell.lbl_FromTime.text = item
            }
        }*/
        
        cell.Act_From = { [weak self] in
            guard let self = self else { return }
            
            let slots = self.generateTimeSlots(start: self.fromTime, end: self.toTime, interval: 30)
            let slotDuration = DropDown()
            
            slotDuration.anchorView = cell.lbl_FromTime
            slotDuration.dataSource = slots
            slotDuration.bottomOffset = CGPoint(x: 0, y:(slotDuration.anchorView?.plainView.bounds.height)!)
            slotDuration.direction = .bottom
            slotDuration.cellHeight = 35
            slotDuration.textFont = UIFont(name: "Lato-Regular", size: 16.0)!
            slotDuration.backgroundColor = .white
            slotDuration.show()
            
            slotDuration.selectionAction = { (index: Int, item: String) in
                print("Selected From: \(item)")
                cell.lbl_FromTime.text = item
                
                // 👉 Update Model here
                self.SalonTiming[indexPath.row].working_hours?.from = item
            }
        }
        
        
        cell.Act_To = { [weak self] in
            guard let self = self else { return }
            
            let slots = self.generateTimeSlots(start: self.fromTime, end: self.toTime, interval: 30)
            let slotDuration = DropDown()
            
            slotDuration.anchorView = cell.lbl_ToTime
            slotDuration.dataSource = slots
            slotDuration.bottomOffset = CGPoint(x: 0, y:(slotDuration.anchorView?.plainView.bounds.height)!)
            slotDuration.direction = .bottom
            slotDuration.cellHeight = 35
            slotDuration.textFont = UIFont(name: "Lato-Regular", size: 16.0)!
            slotDuration.backgroundColor = .white
            slotDuration.show()
            
            slotDuration.selectionAction = { (index: Int, item: String) in
                print("Selected To: \(item)")
                cell.lbl_ToTime.text = item
                
                // 👉 Update Model
                self.SalonTiming[indexPath.row].working_hours?.to = item
            }
        }

        /*cell.Act_To = {
            let slots = self.generateTimeSlots(start: self.fromTime, end: self.toTime, interval: 30)
            
            let slotDuration = DropDown()
            slotDuration.anchorView = cell.lbl_ToTime
            slotDuration.bottomOffset = CGPoint(x: 0, y:(slotDuration.anchorView?.plainView.bounds.height)!)
            slotDuration.direction = .bottom
            slotDuration.dataSource = slots
            slotDuration.cellHeight = 35
            slotDuration.show()
            slotDuration.textFont = UIFont(name: "Lato-Regular", size: 18.0)!
            slotDuration.backgroundColor = .white
            slotDuration.selectionAction = {  [unowned self] (index: Int, item: String) in
                print("Selected item: \(item) at index: \(index)")
                cell.lbl_ToTime.text = item
            }
        }*/
        
        cell.Act_Close = { [weak self] in
            guard let self = self else { return }
            self.removeTiming(at: indexPath.item)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cv_Time.frame.size.width/3, height: 100)
    }
    
}


extension Custom_HoursVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

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


extension Custom_HoursVC: UITextFieldDelegate {
    
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
