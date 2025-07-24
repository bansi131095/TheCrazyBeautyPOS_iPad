//
//  WalkinCheckoutVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 22/07/25.
//

import UIKit

protocol WalkingDelegate {
    func didClearData()
}


class WalkinCheckoutVC: UIViewController {

    @IBOutlet weak var txt_paymentType: TextInputLayout!
    @IBOutlet weak var txt_couponCode: TextInputLayout!
    @IBOutlet weak var txt_miscServiPrice: TextInputLayout!
    @IBOutlet weak var txt_miscServiNotes: TextInputLayout!
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
    @IBOutlet weak var vw_payment1: UIView!
    @IBOutlet weak var txt_payment1: TextInputLayout!
    var loaderAlert: UIAlertController?
    @IBOutlet weak var btn_apply: GradientButton!
    
    var delegate: WalkingDelegate?
    
    var isButtonDisabled: Bool = true
    
    let dropdownView = UITableView()
    var isDropdownVisible = false
    var tips: String = ""
    var miscPrice: String = "0"
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
        self.widgetPrice = self.price
        self.grandTotal = self.price
//        self.setupPaymentTextField()
//        setupDropdownTable()
        var paymentOptions:[String] = []
        if totalGiftCard == 0 {
            paymentOptions = ["Cash", "Card", "Giftcard / Voucher"]
        } else {
            paymentOptions = ["Cash", "Card"]
        }
        DropdownManager.shared.setupDropdown(
            for: self.txt_paymentType,
            in: self.view,
            with: paymentOptions
        ) { [weak self] selected in
            guard let self = self else { return }
            self.txt_paymentType.setText(selected)
            if totalGiftCard == 0 {
                if txt_paymentType.text == paymentOptions[2] {
                    self.vw_coupon.isHidden = false
                    isButtonDisabled = true
                } else {
                    self.vw_coupon.isHidden = true
                    isButtonDisabled = false
                }
            } else {
                self.vw_coupon.isHidden = true
                isButtonDisabled = false
            }
        }
        let paymentOptions1 = ["Cash", "Card"]
        DropdownManager.shared.setupDropdown(
            for: self.txt_payment1,
            in: self.view,
            with: paymentOptions1
        ) { [weak self] selected in
            guard let self = self else { return }
            self.txt_payment1.setText(selected)
            isButtonDisabled = false
        }
        self.vw_coupon.isHidden = true
        vw_service.isHidden = totalServices == 0
        vw_giftcard.isHidden = totalGiftCard == 0
        vw_total.isHidden = price == 0.0
        self.vw_discount.isHidden = true
        self.vw_grandTotal.isHidden = true
        self.vw_payment1.isHidden = true
        self.lbl_total.text = "\(LocalData.symbol)\(String(format: "%.2f", self.price))"
        self.lbl_service.text = "x\(totalServices)"
        self.lbl_giftCard.text = "x\(totalGiftCard)"
        txt_miscServiPrice.addTarget(self, action: #selector(miscPriceChanged(_:)), for: .editingChanged)
        txt_tips.addTarget(self, action: #selector(tipsValueChanged(_:)), for: .editingChanged)

        // Do any additional setup after loading the view.
    }
    
    
    //MARK: Button Action
    @IBAction func act_close(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func act_save(_ sender: GradientButton) {
        if !isButtonDisabled {
            self.AddServiceData()
        }
    }
    
    
    @IBAction func act_Apply(_ sender: GradientButton) {
        if self.btn_apply.currentTitle == "Apply" {
            if txt_couponCode.text!.isEmpty {
                self.showAlertToast(message: "Please enter coupon code")
            } else {
                self.checkCouponCode()
            }
        } else {
            // Apply
            self.txt_couponCode.text = ""
            self.btn_apply.setTitle("Apply", for: .normal)
            self.grandTotal -= self.discount
            self.discount = 0
            self.lbl_grandTotal.text = "\(LocalData.symbol)\(self.grandTotal)"
            self.lbl_discount.text = "-\(LocalData.symbol)\(self.discount)"
            self.vw_discount.isHidden = self.discount == 0
            self.vw_grandTotal.isHidden = self.grandTotal == 0
            self.vw_payment1.isHidden = self.discount == 0
        }
        
    }

    
    @objc func miscPriceChanged(_ textField: UITextField) {
        guard let value = textField.text, !value.isEmpty else {
            price = widgetPrice
            grandTotal = widgetPrice - discount
            updateTotals()
            return
        }

        // Validate number
        var total = widgetPrice
        if let miscValue = Double(value) {
            miscPrice = value
            total += miscValue
            price = total
            grandTotal = total - discount
        }
        if let priceValue = Double(value) {
            miscPrice = value
            price = widgetPrice + priceValue
            grandTotal = price - discount
        } else {
            textField.text = ""
        }

        updateTotals()
    }
    
    @objc func tipsValueChanged(_ textField: UITextField) {
        guard let tipText = textField.text else { return }

        if tipText.isEmpty {
            tips = ""
            if !miscPrice.isEmpty, let misc = Double(miscPrice) {
                let total = widgetPrice + misc
                price = total
                grandTotal = total - discount
            } else {
                price = widgetPrice
                grandTotal = widgetPrice - discount
            }
            updateTotals()
            return
        }

        if let tipValue = Double(tipText) {
            tips = tipText
            let miscValue = Double(miscPrice) ?? 0
            price = widgetPrice + miscValue + tipValue
            grandTotal = price - discount
        } else {
            textField.text = ""
        }

        updateTotals()
    }


    func updateTotals() {
        lbl_total.text = "\(LocalData.symbol)\(String(format: "%.2f", price))"
        lbl_grandTotal.text = "\(LocalData.symbol)\(String(format: "%.2f", grandTotal))"
    }

    
    //MARK: Api Call
    func checkCouponCode() {
        let bookingDate = convertDateString(Date.now)

        APIService.shared.CheckCouponCode(vendor_id: LocalData.userId, code: self.txt_couponCode.text ?? "", bookingDate: bookingDate) { result in
            guard let model = result else {
                return
            }

            let checkCouponData = model.data
            if model.error == "" || model.error == nil {
                if checkCouponData?.is_coupon == 1 {
                    APIService.shared.ApplyCouponCode(vendor_id: LocalData.userId, code: self.txt_couponCode.text ?? "") { result in
                        guard let model = result else {
                            return
                        }
                        let data = model.data
                        if model.error == "" || model.error == nil {
//                            self.showAlertToast(message: data?.message ?? "")
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
                                        let total = (price * self.discountVal) / 100.0
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
                                if self.discount != 0 {
                                    self.btn_apply.setTitle("Remove", for: .normal)
                                }
                                self.lbl_grandTotal.text = "\(LocalData.symbol)\(self.grandTotal)"
                                self.lbl_discount.text = "-\(LocalData.symbol)\(self.discount)"
                                self.vw_discount.isHidden = self.discount == 0
                                self.vw_grandTotal.isHidden = self.grandTotal == 0
                                self.vw_payment1.isHidden = self.discount == 0
                            }
                        } else {
                            self.show_alert(msg: model.error ?? "", title: "")
                        }
                    }
                } else if checkCouponData?.is_gift == 1 {
                    APIService.shared.ApplyGiftCard(vendor_id: LocalData.userId, code: self.txt_couponCode.text ?? "", total: "", customerId: "0") { result in
                        guard let model = result else {
                            return
                        }
                        let data = model.data
                        if model.error == "" || model.error == nil {
                            // Assume you already parsed this using ObjectMapper:
                            if let giftCard = model.data?.results.first,
                               Double(giftCard.price) < self.price {

                                self.showAlertToast(message: data?.message ?? "")
                                self.discount = Double(giftCard.price)
                                self.grandTotal = self.price - self.discount

                                // Uncomment and use this if you need to handle advancePay logic
                                // if advancePay > 0 {
                                //     totalPayable = (grandTotal * advancePay) / 100.0
                                // }
                                self.lbl_grandTotal.text = "\(LocalData.symbol)\(self.grandTotal)"
                                self.lbl_discount.text = "-\(LocalData.symbol)\(self.discount)"
                                self.vw_discount.isHidden = self.discount == 0
                                self.vw_grandTotal.isHidden = self.grandTotal == 0
                                self.vw_payment1.isHidden = self.discount == 0
                            }
                        } else {
                            self.show_alert(msg: model.error ?? "", title: "")
                        }
                    }
                }
            } else {
                self.show_alert(msg: model.error ?? "", title: "Update Client")
            }
        }
        
    }
    
    
    func AddServiceData() {
        
        var payment = ""
        if self.txt_paymentType.text == "Cash" {
            payment = "cash"
        } else if self.txt_paymentType.text == "Gift Card / Voucher" {
            payment = "giftcard"
        } else {
            payment = "card"
        }

        if let secondary = self.txt_payment1.text, !secondary.isEmpty {
            if secondary == "Cash" {
                payment += ",cash"
            } else {
                payment += ",card"
            }
        }
        if payment == "card" || payment == "giftcard,card" {
            self.startTerminalTransaction(price: self.widgetPrice, miscPrice: miscPrice, notes: self.txt_miscServiNotes.text ?? "", paymentType: payment)
        } else {
            APIService.shared.addCartDetails(vendorId: LocalData.userId,
                                             subTotal: self.widgetPrice,
                                             grandTotal: self.grandTotal,
                                             discountAmount: String(format: "%.2f", self.discount),
                                             serviceIds: self.serviceId,
                                             couponCode: self.txt_couponCode.text ?? "",
                                             discountPercentage: "0",
                                             transactionId: "",
                                             paymentType: payment,
                                             discountType: self.discountType,
                                             giftCard: self.giftCards,
                                             miscellaneousNote: self.txt_miscServiNotes.text ?? "",
                                             miscellaneousPrice: Double(miscPrice) ?? 0,
                                             tips: Double(tips) ?? 0) { result in
                guard let model = result else {
                    return
                }

                if model.error == "" || model.error == nil {
                    DispatchQueue.main.async {
                        // safe UI code here
                        self.showToast(message: model.data ?? "")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.delegate?.didClearData()
                            self.dismiss(animated: true)
                        }
                    }
                } else {
                    self.show_alert(msg: model.error!, title: "Add Cart Details")
                }
            }
        }
        
    }
    
    func startTerminalTransaction(price: Double, miscPrice: String, notes: String, paymentType: String) {
        let cal = price + (Double(miscPrice) ?? 0)
        let priceInCents = Int(cal * 100)
        let priceString = "\(priceInCents)"

        showLoaderDialog(on: self, title: "Confirming transaction from terminal")

        APIService.shared.WalkinTransaction(vendorId: LocalData.userId,
                                            amount: priceString,
                                            miscPrice: miscPrice,
                                            miscNotes: notes) { transactionModel in
            self.dismissLoaderDialog()
            guard let model = transactionModel else {
                self.showToast(message: transactionModel?.error ?? "Error")
                return
            }

            if model.error == "" || model.error == nil {
                let tranId = model.data ?? ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    let popup = PaymentConfirmationPopupVC()
                    popup.modalPresentationStyle = .overFullScreen
                    popup.modalTransitionStyle = .crossDissolve
                    popup.onConfirm = {
                        // handle confirm
                        print("✅ Payment Confirmed")
                        self.verifyTransactionStatus(transactionId: tranId, price: price, miscPrice: miscPrice, notes: notes, paymentType: paymentType)
                        // proceed to check payment status or update UI
                    }
                    self.present(popup, animated: true)
                }
            } else {
                self.showToast(message: transactionModel?.error ?? "Error")
            }

        }
    }
    
    func verifyTransactionStatus(transactionId: String, price: Double, miscPrice: String, notes: String, paymentType: String) {
        showLoaderDialog(on: self, title: "Updating")

        APIService.shared.WalkinPayment(vendorId: LocalData.userId,
                                        transactionId: transactionId
        ) { posPaymentStatus in
            

            guard let data = posPaymentStatus?.data else { return }

            switch data.transactionStatus {
            case "NOSTATUS":
                self.showToast(message: "Still pending...")
            case "CANCELED", "REFUSED":
                self.showToast(message: "Payment cancelled")
            case "ACCEPTED":
                self.dismiss(animated: true) {
                    self.dismissLoaderDialog()
                    self.submitCartAfterAccepted(
                        price: price,
                        miscPrice: miscPrice,
                        notes: notes,
                        transactionId: transactionId,
                        paymentType: paymentType
                    )
                }
                
            default:
                self.showToast(message: "Unknown status")
                
            }
        }
    }

    func submitCartAfterAccepted(price: Double, miscPrice: String, notes: String, transactionId: String, paymentType: String) {
        APIService.shared.addCartDetails(
            vendorId: LocalData.userId,
            subTotal: price,
            grandTotal: self.grandTotal,
            discountAmount: String(format: "%.2f", self.discount),
            serviceIds: self.serviceId,
            couponCode: self.txt_couponCode.text ?? "",
            discountPercentage: "0",
            transactionId: transactionId,
            paymentType: paymentType, // e.g. "card", "giftcard"
            discountType: self.discountType,
            giftCard: self.giftCards,
            miscellaneousNote: notes,
            miscellaneousPrice: Double(miscPrice) ?? 0,
            tips: Double(self.tips) ?? 0
        ) { result in
            self.dismissLoaderDialog()

            guard let model = result else {
                return
            }

            if model.error == "" || model.error == nil {
                DispatchQueue.main.async {
                    // safe UI code here
                    self.showToast(message: model.data ?? "")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.delegate?.didClearData()
                        self.dismiss(animated: true)
                    }
                }
                
            } else {
                self.show_alert(msg: model.error!, title: "Add Cart Details")
            }
        }
    }


    
    func convertDateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
    }

    
   /* func showPaymentConfirmationDialog(from viewController: UIViewController, onConfirm: @escaping () -> Void) {
        let backgroundView = UIView(frame: viewController.view.bounds)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        let dialogView = UIView()
        dialogView.backgroundColor = .white
        dialogView.layer.cornerRadius = 12
        dialogView.translatesAutoresizingMaskIntoConstraints = false

        // Confirm button
        let confirmButton = UIButton(type: .system)
        confirmButton.setTitle("Confirm Payment Status", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.titleLabel?.font = UIFont(name: "Lato-Bold", size: 18)
        confirmButton.backgroundColor = .clear
        confirmButton.layer.cornerRadius = 36
        confirmButton.translatesAutoresizingMaskIntoConstraints = false

        // Gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(red: 206/255, green: 71/255, blue: 250/255, alpha: 1).cgColor,
                                UIColor(red: 146/255, green: 93/255, blue: 249/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.cornerRadius = 36
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 240, height: 50)

        let gradientContainer = UIView()
        gradientContainer.layer.insertSublayer(gradientLayer, at: 0)
        gradientContainer.layer.cornerRadius = 36
        gradientContainer.translatesAutoresizingMaskIntoConstraints = false
        gradientContainer.addSubview(confirmButton)

        // Close button
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = .gray
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        // Wrap in container
        dialogView.addSubview(gradientContainer)
        dialogView.addSubview(closeButton)

        // Fullscreen overlay
        backgroundView.addSubview(dialogView)
        viewController.view.addSubview(backgroundView)

        // Constraints
        NSLayoutConstraint.activate([
            dialogView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            dialogView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            dialogView.widthAnchor.constraint(equalToConstant: 300),

            gradientContainer.topAnchor.constraint(equalTo: dialogView.topAnchor, constant: 20),
            gradientContainer.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor, constant: 20),
            gradientContainer.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor, constant: -20),
            gradientContainer.heightAnchor.constraint(equalToConstant: 50),

            confirmButton.leadingAnchor.constraint(equalTo: gradientContainer.leadingAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: gradientContainer.trailingAnchor),
            confirmButton.topAnchor.constraint(equalTo: gradientContainer.topAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor),

            closeButton.topAnchor.constraint(equalTo: dialogView.topAnchor, constant: 5),
            closeButton.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor, constant: -5),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),

            dialogView.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: 20)
        ])

        // Actions
        confirmButton.addAction(UIAction { _ in
            backgroundView.removeFromSuperview()
            onConfirm()
        }, for: .touchUpInside)

        closeButton.addAction(UIAction { _ in
            backgroundView.removeFromSuperview()
            viewController.dismiss(animated: true)
        }, for: .touchUpInside)
    } */

    func showLoaderDialog(on viewController: UIViewController, title: String) {
        // 🚨 Add non-empty message to prevent iPad crash
        let alert = UIAlertController(title: nil, message: " ", preferredStyle: .alert)

        // Create loading spinner
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()

        // Create message label
        let messageLabel = UILabel()
        messageLabel.text = title
        messageLabel.numberOfLines = 3
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textAlignment = .left
        messageLabel.lineBreakMode = .byTruncatingTail
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        // Create container view
        let container = UIStackView(arrangedSubviews: [spinner, messageLabel])
        container.axis = .horizontal
        container.spacing = 20
        container.alignment = .center
        container.translatesAutoresizingMaskIntoConstraints = false

        alert.view.addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 20),
            container.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: 20),
            container.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant: 20),
            container.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor, constant: 20),
        ])

        // 📱 iPad-safe presentation
        if let popover = alert.popoverPresentationController {
            popover.sourceView = viewController.view
            popover.sourceRect = CGRect(x: viewController.view.bounds.midX,
                                        y: viewController.view.bounds.midY,
                                        width: 0,
                                        height: 0)
            popover.permittedArrowDirections = []
        }

        loaderAlert = alert

        viewController.present(alert, animated: true)
    }


    func dismissLoaderDialog() {
        loaderAlert?.dismiss(animated: true)
        loaderAlert = nil
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

