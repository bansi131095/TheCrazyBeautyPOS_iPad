//
//  WalkinCheckoutVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 22/07/25.
//

import UIKit

class WalkinCheckoutVC: UIViewController {

    @IBOutlet weak var txt_paymentType: TextInputLayout!
    @IBOutlet weak var txt_couponCode: TextInputLayout!
    @IBOutlet weak var txt_miscServiPrice: TextInputLayout!
    @IBOutlet weak var txt_tips: TextInputLayout!
    @IBOutlet weak var vw_service: UIView!
    @IBOutlet weak var lbl_service: UILabel!
    @IBOutlet weak var vw_giftcard: UIView!
    @IBOutlet weak var lbl_giftCard: UILabel!
    @IBOutlet weak var vw_total: UIView!
    @IBOutlet weak var lbl_total: UILabel!
    @IBOutlet weak var vw_coupon: UIView!
    @IBOutlet weak var vw_discount: UIView!
    @IBOutlet weak var lbl_discount: UILabel!
    @IBOutlet weak var vw_grandTotal: UIView!
    @IBOutlet weak var lbl_grandTotal: UILabel!
    
    
    let paymentOptions = ["Cash", "Card", "Giftcard / Voucher"]
    let dropdownView = UITableView()
    var isDropdownVisible = false
    
    var price: Double = 0.0
    var serviceId: String = ""
    var giftCards: String = ""
    var totalServices: Int = 0
    var totalGiftCard: Int = 0
    var discountVal: Double = 0
    var discount: Double = 0
    var upto: Double = 0
    var discountType: String = ""
    var grandTotal: Double = 0
    var widgetPrice: Double = 0 // replace with actual original total price

    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPaymentTextField()
        setupDropdownTable()
        self.vw_coupon.isHidden = true
        vw_service.isHidden = totalServices == 0
        vw_giftcard.isHidden = totalGiftCard == 0
        vw_total.isHidden = price == 0.0
        vw_discount.isHidden = true
        self.lbl_total.text = "\(LocalData.symbol)\(String(format: "%.2f", self.price))"
        self.lbl_service.text = "x\(totalServices)"
        self.lbl_giftCard.text = "x\(totalGiftCard)"
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: Button Action
    @IBAction func act_close(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func act_save(_ sender: GradientButton) {
    }
    
    
    @IBAction func act_Apply(_ sender: GradientButton) {
    }
    
    
    //MARK: DropDown
    func setupPaymentTextField() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleDropdown))
        txt_paymentType.addGestureRecognizer(tapGesture)
        txt_paymentType.isUserInteractionEnabled = true
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
            dropdownView.topAnchor.constraint(equalTo: txt_paymentType.bottomAnchor, constant: -30),
            dropdownView.centerXAnchor.constraint(equalTo: txt_paymentType.centerXAnchor),
            dropdownView.widthAnchor.constraint(equalTo: txt_paymentType.widthAnchor),
            dropdownView.heightAnchor.constraint(equalToConstant: CGFloat(paymentOptions.count * 45))
        ])
    }
    
    @objc func toggleDropdown() {
        
        isDropdownVisible.toggle()
        dropdownView.isHidden = !isDropdownVisible
    }
    
    
    //MARK: Api Call
    func checkCouponCode() {
        let bookingDate = convertDateString(Date.now)

        APIService.shared.CheckCouponCode(vendor_id: LocalData.userId, code: self.txt_couponCode.text ?? "", bookingDate: bookingDate) { result in
            guard let model = result else {
                return
            }

            var checkCouponData = model.data
            if model.error == "" || model.error == nil {
                if checkCouponData?.is_coupon == 1 {
                    APIService.shared.ApplyCouponCode(vendor_id: LocalData.userId, code: self.txt_couponCode.text ?? "") { result in
                        guard let model = result else {
                            return
                        }
                        var data = model.data
                        if model.error == "" || model.error == nil {
                            self.showAlertToast(message: data?.message ?? "")
                            // Assume you already parsed this using ObjectMapper:
                            let applyCouponData = data?.results.first

                            guard let coupon = applyCouponData else { return }

                            let amount = Double(coupon.amount)
                            let type = coupon.discount_type
                            let upto = Double(coupon.highest_amount)

                            // Save type and cap globally if needed
                            self.discountType = type
                            self.upto = upto

                            if amount != 0 {
                                let per = amount
                                if per != 0 {
                                    if type == "Flat" {
                                        if amount < self.grandTotal {
                                            self.discountVal = per
                                            self.discount = per
                                            var price = self.price
                                            price -= self.discount
                                            self.grandTotal = price
                                        } else {
                                            self.showAlertToast(message: "Please Add More service to use this coupon")
                                        }
                                    } else if type == "Percentage" {
                                        self.discountVal = per
                                        let price = self.widgetPrice // replace with your base price
                                        var total = (price * self.discountVal) / 100.0
                                        if upto != 0 && total > upto {
                                            self.discount = upto
                                        } else {
                                            self.discount = total
                                        }
                                        var price1 = self.price
                                        price1 -= self.discount
                                        self.grandTotal = price1
                                    }
                                    
                                } else {
                                    self.discount = 0
                                }
                                self.lbl_grandTotal.text = "\(LocalData.symbol)\(self.grandTotal)"
                                self.lbl_discount.text = "-\(LocalData.symbol)\(self.discount)"
                                self.vw_discount.isHidden = self.discount == 0
                                self.vw_grandTotal.isHidden = self.grandTotal == 0
                            }
                        } else {
                            self.show_alert(msg: model.error ?? "", title: "")
                        }
                    }
                } else if checkCouponData?.is_gift == 1 {
                    
                }
            } else {
                self.show_alert(msg: model.error ?? "", title: "Update Client")
            }
        }
        
    }
    
    func convertDateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
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

extension WalkinCheckoutVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentOptions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = paymentOptions[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        txt_paymentType.text = paymentOptions[indexPath.row]
        txt_paymentType.showLabel()
        dropdownView.isHidden = true
        isDropdownVisible = false
        if txt_paymentType.text == paymentOptions[2] {
            self.vw_coupon.isHidden = false
        } else {
            self.vw_coupon.isHidden = true
        }
    }
}
