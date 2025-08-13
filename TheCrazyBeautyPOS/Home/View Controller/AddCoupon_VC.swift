//
//  AddCoupon_VC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 28/07/25.
//

import UIKit
import DropDown
import FSCalendar

class AddCoupon_VC: UIViewController {

    //MARK: - Outlet
    
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var btn_Coupon: GradientButton!
    
    @IBOutlet weak var txt_CouponName: TextInputLayout!
    @IBOutlet weak var txt_CouponCode: TextInputLayout!
    @IBOutlet weak var txt_DiscountType: TextInputLayout!
    
    
    @IBOutlet weak var vw_Amount: UIView!
    @IBOutlet weak var txt_Amount: TextInputLayout!
    @IBOutlet weak var vw_AmountPercentage: UIView!
    
    @IBOutlet weak var txt_Percentage: TextInputLayout!
    @IBOutlet weak var txt_AmountPercentage: TextInputLayout!
    
    @IBOutlet weak var txt_StartDate: TextInputLayout!
    @IBOutlet weak var txt_EndDate: TextInputLayout!
    
    @IBOutlet weak var txt_Status: TextInputLayout!
    //MARK: - Global Variable
    var arr_Status = ["Active","Inactive"]
    var arr_DiscountType = ["Flat","Percentage"]
    
    var calendarVC: UIViewController?
    var fromSelectedDate: Date?
    var toSelectedDate: Date?
    var isSelectingFromDate: Bool = false
    
    var isEdit = false
    var CouponData: CouponData?
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomFont()
        txt_DiscountType.text = arr_DiscountType.first
        txt_Status.text = arr_Status.first
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if self.isEdit {
                self.lbl_Title.text = "Edit Coupon"
                self.btn_Coupon.setTitle("Update Coupon", for: .normal)
                self.setData()
            } else {
                self.lbl_Title.text = "Add Coupon"
                self.btn_Coupon.setTitle("Add Coupon", for: .normal)
            }
        }
    }
    
    //MARK: -  Button Action
    @IBAction func btn_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func btn_DiscountType(_ sender: Any) {
        openDiscountType()
    }
    
    @IBAction func btn_StatusDropdown(_ sender: Any) {
        openStatus()
    }
    
    @IBAction func btn_Cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func btn_AddCoupon(_ sender: Any) {
    guard let couponName = txt_CouponName.text, !couponName.isEmpty else {
            self.showToast(message: "Coupon Name is required.")
            return
        }
        
        guard let couponCode = txt_CouponCode.text, !couponCode.isEmpty else {
            self.showToast(message: "Coupon Code is required.")
            return
        }
        
        guard let discountType = txt_DiscountType.text else { return }
        
        if discountType == "Flat" {
            guard let amount = txt_Amount.text, !amount.isEmpty else {
                self.showToast(message: "Amount is required.")
                return
            }
        } else if discountType == "Percentage" {
            guard let percentage = txt_Percentage.text, !percentage.isEmpty else {
                self.showToast(message: "Percentage is required.")
                return
            }
            guard let maxAmount = txt_AmountPercentage.text, !maxAmount.isEmpty else {
                self.showToast(message: "Amount is required.")
                return
            }
        }
        
        guard let startDate = txt_StartDate.text, !startDate.isEmpty else {
            self.showToast(message: "Start Date is required.")
            return
        }
        
        guard let endDate = txt_EndDate.text, !endDate.isEmpty else {
            self.showToast(message: "End Date is required.")
            return
        }
        
        if isEdit {
            if self.CouponData?.discount_type == "Flat"{
                UpdateCoupon(highest_amount: "", Amount: self.txt_Amount.text ?? "", Id: self.CouponData?.id ?? 0)
            }else{
                UpdateCoupon(highest_amount: self.txt_AmountPercentage.text ?? "", Amount: self.txt_Percentage.text ?? "", Id: self.CouponData?.id ?? 0)
            }
        }else{
            if txt_DiscountType.text == "Flat"{
                addFunctionApiCalling(highest_amount: "", Amount: self.txt_Amount.text ?? "")
            }else{
                addFunctionApiCalling(highest_amount: self.txt_AmountPercentage.text ?? "", Amount: self.txt_Percentage.text ?? "")
            }
        }
    }
    
    //MARK: - Function
    func setData(){
        self.txt_CouponName.text = self.CouponData?.coupon_name ?? ""
        self.txt_CouponCode.text = self.CouponData?.coupon_code ?? ""
        self.txt_DiscountType.text = self.CouponData?.discount_type ?? ""
        if self.CouponData?.discount_type == "Flat"{
            self.vw_Amount.isHidden = false
            self.vw_AmountPercentage.isHidden = true
            self.txt_Amount.text = "\(self.CouponData?.amount ?? 0)"
        }else{
            self.vw_Amount.isHidden = true
            self.vw_AmountPercentage.isHidden = false
            self.txt_Percentage.text = "\(self.CouponData?.amount ?? 0)"
            self.txt_AmountPercentage.text = "\(self.CouponData?.highest_amount ?? 0)"
        }
        self.txt_StartDate.text = self.CouponData?.start_date
        self.txt_EndDate.text = self.CouponData?.end_date
        self.txt_Status.text = self.CouponData?.status
    }
    
    func openDiscountType() {
        let slotDuration = DropDown()
        slotDuration.anchorView = txt_DiscountType
        slotDuration.bottomOffset = CGPoint(x: 0, y:(slotDuration.anchorView?.plainView.bounds.height)!)
        slotDuration.direction = .bottom
        slotDuration.dataSource = arr_DiscountType
        slotDuration.cellHeight = 35
        slotDuration.show()
        
        slotDuration.selectionAction = {  [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.txt_DiscountType.text = item
            if item == "Flat"{
                self.vw_Amount.isHidden = false
                self.vw_AmountPercentage.isHidden = true
            }else if item == "Percentage"{
                self.vw_Amount.isHidden = true
                self.vw_AmountPercentage.isHidden = false
            }
        }
    }
    
    func openStatus() {
        let slotDuration = DropDown()
        slotDuration.anchorView = txt_Status
        slotDuration.bottomOffset = CGPoint(x: 0, y:(slotDuration.anchorView?.plainView.bounds.height)!)
        slotDuration.direction = .bottom
        slotDuration.dataSource = arr_Status
        slotDuration.cellHeight = 35
        slotDuration.show()
        
        slotDuration.selectionAction = {  [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.txt_Status.text = item
        }
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
            txt_CouponName.font = customFont
            txt_CouponCode.font = customFont
            txt_DiscountType.font = customFont
            txt_Amount.font = customFont
            txt_Percentage.font = customFont
            txt_AmountPercentage.font = customFont
            txt_StartDate.font = customFont
            txt_EndDate.font = customFont
            txt_Status.font = customFont
        }
    }
    
    //MARK: - Web Api Calling
    func addFunctionApiCalling(highest_amount: String,Amount:String) {
        showLoader()
        APIService.shared.add_AddCoupon(vendorId: LocalData.userId, status: self.txt_Status.text ?? "", start_date: self.txt_StartDate.text ?? "", highest_amount: highest_amount, end_date: self.txt_EndDate.text ?? "", discount_type: self.txt_DiscountType.text ?? "", coupon_name: self.txt_CouponName.text ?? "", coupon_code: self.txt_CouponCode.text ?? "", amount: Amount) { result in
            self.hideLoader()
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
    
    func UpdateCoupon(highest_amount: String,Amount:String,Id:Int){
        showLoader()
        APIService.shared.updateGiftCoupon(Id: Id, amount: Amount, coupon_code: self.txt_CouponCode.text ?? "", discount_type: self.txt_DiscountType.text ?? "", vendor_id: LocalData.userId, coupon_name: self.txt_CouponName.text ?? "", end_date: self.txt_EndDate.text ?? "", highest_amount: highest_amount, start_date: self.txt_StartDate.text ?? "", status: self.txt_Status.text ?? "") { result in
            self.hideLoader()
            guard let model = result else {
                return
            }
            
            if model.error == "" || model.error == nil {
                DispatchQueue.main.async {
                    // safe UI code here
                    self.showToast(message: model.data)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            } else {
                self.show_alert(msg: model.error ?? "", title: "")
            }
            
        }
    }
}

extension AddCoupon_VC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let formattedDate = formatter.string(from: date)

        if isSelectingFromDate {
            fromSelectedDate = date
            txt_StartDate.text = formattedDate
            txt_StartDate.showLabel()
        } else {
            toSelectedDate = date
            txt_EndDate.text = formattedDate
            txt_EndDate.showLabel()
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


extension AddCoupon_VC: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == txt_StartDate) {
            self.view.endEditing(true)
            self.isSelectingFromDate = true
            showCalendarPopup(sourceView: textField)
            return false // Prevent keyboard
        } else if (textField == txt_EndDate) {
            self.view.endEditing(true)
            self.isSelectingFromDate = false
            showCalendarPopup(sourceView: textField)
            return false // Prevent keyboard
        } else {
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txt_Percentage {
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)

            if let intValue = Int(newText), intValue > 100 {
                textField.text = "100"
                self.showToast(message: "Percentage cannot exceed 100.")
                return false
            }
        }
        return true
    }

}
