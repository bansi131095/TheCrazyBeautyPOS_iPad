//
//  WalkinCheckoutVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 22/07/25.
//

import UIKit

protocol WalkingDelegate_ONE {
    func didClearData()
}


class WalkinCheckoutVC_ONE: UIViewController {

    @IBOutlet weak var vw_Main: UIView!
    @IBOutlet weak var lbl_MakePayment: UILabel!
    
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
    
    @IBOutlet weak var btn_Save: GradientButton!
    @IBOutlet weak var vw_Remaining: UIView!
    @IBOutlet weak var lbl_Remaining: UILabel!
    
    
    @IBOutlet weak var lbl_Service: UILabel!
    @IBOutlet weak var lblL_GiftCard: UILabel!
    @IBOutlet weak var lblL_Total: UILabel!
    @IBOutlet weak var lbl_LDiscount: UILabel!
    @IBOutlet weak var lbl_LGrandTotal: UILabel!
    
    
    var delegate: WalkingDelegate_ONE?
    
    var isButtonDisabled: Bool = true
    let dropdownView = UITableView()
    var isDropdownVisible = false
    let posId = SharedPrefs.getPosId()
    // --- price related
    var tips: String = "0"
    var miscPrice: String = "0"
    var price: Double = 0.0            // baseTotal + tips
    var serviceId: String = ""
    var giftCards: String = ""
    var totalServices: Int = 0
    var totalGiftCard: Int = 0

    // --- discount
    var discountVal: Double = 0        // flat amount or percentage value
    var discount: Double = 0
    var upto: Double = 0               // max cap for percentage
    var discountType: String = ""      // "Flat" / "Percentage"

    var grandTotal: Double = 0         // baseTotal - discount + tips
    var widgetPrice: Double = 0        // original service total


    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_MakePayment.text = NSLocalizedString("Make Payment", comment: "")
        self.lbl_Service.text = NSLocalizedString("Services", comment: "")
        self.lblL_GiftCard.text = NSLocalizedString("Gift Card", comment: "")
        self.lblL_Total.text = NSLocalizedString("Total", comment: "")
        self.lbl_LDiscount.text = NSLocalizedString("Discount", comment: "")
        self.lbl_LGrandTotal.text = NSLocalizedString("Grand Total", comment: "")
        self.widgetPrice = self.price
        self.grandTotal  = self.price

        setupDropdowns()

        vw_coupon.isHidden    = true
        vw_service.isHidden   = totalServices == 0
        vw_giftcard.isHidden  = totalGiftCard == 0
        vw_total.isHidden     = price == 0.0
        vw_discount.isHidden  = true
        vw_grandTotal.isHidden = true
        vw_payment1.isHidden  = true

        lbl_total.text   = "\(LocalData.symbol)\(String(format: "%.2f", self.price))"
        lbl_service.text = "x\(totalServices)"
        lbl_giftCard.text = "x\(totalGiftCard)"

        txt_miscServiPrice.addTarget(self, action: #selector(miscPriceChanged(_:)), for: .editingChanged)
        txt_tips.addTarget(self, action: #selector(tipsValueChanged(_:)), for: .editingChanged)

        // Do any additional setup after loading the view.
    }
    
    var paymentTypeSelectedFirst = ""
    
    //MARK: Dropdown
    /*func setupDropdowns() {
        var paymentOptions: [String] = []
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
            paymentTypeSelectedFirst = selected
            if totalGiftCard == 0 {
                if txt_paymentType.text == paymentOptions.last {
                    
                    
                    
                    self.vw_coupon.isHidden = false
                    self.isButtonDisabled = true
                    self.txt_couponCode.text = ""
                    self.txt_couponCode.isUserInteractionEnabled = true
                    self.txt_couponCode.isEnabled = true
                    self.txt_couponCode.backgroundColor = UIColor.white
                    self.txt_couponCode.textColor = .black
                    self.btn_apply.setTitle("Apply", for: .normal)
                    
                } else {
                    self.vw_coupon.isHidden = true
                    self.isButtonDisabled = false
//                    btn_Save.alpha = 1.0
                    vw_coupon.isHidden    = true
                    vw_service.isHidden   = totalServices == 0
                    vw_giftcard.isHidden  = totalGiftCard == 0
                    vw_total.isHidden     = price == 0.0
                    vw_discount.isHidden  = true
                    vw_grandTotal.isHidden = true
                    
                    self.txt_couponCode.text = ""
                    self.discountVal = 0
                    self.discountType = ""
                    self.upto = 0
                    recalcTotals()
                    
                }
            } else {
                self.vw_coupon.isHidden = true
                self.isButtonDisabled = false
//                btn_Save.alpha = 0.5
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
            self.isButtonDisabled = false
//            btn_Save.alpha = 0.5
        }
    }*/
    
    func setupDropdowns() {

        // 🔹 API values (example)
        var apiPaymentTypes: [String] = []

        if totalGiftCard == 0 {
            apiPaymentTypes = ["cash", "card", "giftcard"]
        } else {
            apiPaymentTypes = ["cash", "card"]
        }

        // 🔹 Convert API → Localized titles
        let paymentOptions = apiPaymentTypes.map {
            paymentTitle(from: $0)
        }

        DropdownManager.shared.setupDropdown(
            for: self.txt_paymentType,
            in: self.view,
            with: paymentOptions
        ) { [weak self] selected in
            guard let self = self else { return }

            self.txt_paymentType.setText(selected)
            paymentTypeSelectedFirst = selected

            let giftcardText = paymentTitle(from: "giftcard")

            if totalGiftCard == 0 && selected == giftcardText {

                self.vw_coupon.isHidden = false
                self.isButtonDisabled = true
                self.txt_couponCode.text = ""
                self.txt_couponCode.isEnabled = true
                self.txt_couponCode.backgroundColor = .white
                self.txt_couponCode.textColor = .black
                self.btn_apply.setTitle("Apply".localized, for: .normal)

            } else {

                self.vw_coupon.isHidden = true
                self.isButtonDisabled = false
                self.vw_service.isHidden = totalServices == 0
                self.vw_giftcard.isHidden = totalGiftCard == 0
                self.vw_total.isHidden = price == 0
                self.vw_discount.isHidden = true
                self.vw_grandTotal.isHidden = true

                self.txt_couponCode.text = ""
                self.discountVal = 0
                self.discountType = ""
                self.upto = 0
                self.recalcTotals()
            }
        }

        // 🔹 Second dropdown (Cash / Card only)
        let apiPaymentOptions1 = ["cash", "card"]
        let paymentOptions1 = apiPaymentOptions1.map {
            paymentTitle(from: $0)
        }

        DropdownManager.shared.setupDropdown(
            for: self.txt_payment1,
            in: self.view,
            with: paymentOptions1
        ) { [weak self] selected in
            self?.txt_payment1.setText(selected)
            self?.isButtonDisabled = false
        }
    }

    
    //MARK: Button Action
    @IBAction func act_close(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func act_save(_ sender: GradientButton) {
        if !isButtonDisabled {
            sender.isEnabled = false
//            btn_Save.alpha = 1.0
            print("Tapped!")
            self.AddServiceData()
        }
    }
    
    
    @IBAction func act_Apply(_ sender: GradientButton) {
        if self.btn_apply.currentTitle == "Apply".localized {
            
            if txt_couponCode.text!.isEmpty {
                self.alertWithMessageOnly(NSLocalizedString("Please enter coupon code",comment: ""))
            } else {
                self.checkCouponCode()
            }
        } else {
            // Apply
            
            self.txt_couponCode.text = ""
            self.txt_couponCode.isUserInteractionEnabled = true
            self.txt_couponCode.isEnabled = true
            self.txt_couponCode.backgroundColor = UIColor.white
            self.txt_couponCode.textColor = .black
            self.btn_apply.setTitle("Apply".localized, for: .normal)
            self.discountVal = 0
            self.discountType = ""
            self.upto = 0
            recalcTotals()
           
        }
        
    }

    
    //MARK: Text Changes
       @objc func miscPriceChanged(_ textField: UITextField) {
           guard let value = textField.text, !value.isEmpty else {
               miscPrice = "0"
               recalcTotals()
               return
           }
           if let _ = Double(value) {
               miscPrice = value
               recalcTotals()
           } else {
               textField.text = ""
           }
       }

       @objc func tipsValueChanged(_ textField: UITextField) {
           guard let value = textField.text, !value.isEmpty else {
               tips = "0"
               recalcTotals()
               
               return
           }
           if Double(value) != nil {
               tips = value
               
               recalcTotals()
           } else {
               textField.text = ""
           }
       }

       //MARK: Calculation
       func recalcTotals() {
           let misc = Double(miscPrice) ?? 0
           let tip  = Double(tips) ?? 0

           let baseTotal = widgetPrice + misc   // service + misc
           var discountAmount: Double = 0
           var remainDiscountAmount: Double = 0

           if discountType == "Flat" {
               discountAmount = min(discountVal, baseTotal)
           } else if discountType == "Percentage" {
               let calc = baseTotal * discountVal / 100.0
               discountAmount = (upto != 0 && calc > upto) ? upto : calc
           }
           
           if (discountVal > 0 && discountType == "Flat" && isGiftCard == 1) {
               remainDiscountAmount = discountVal - discountAmount
           }

           discount   = discountAmount
           price      = baseTotal + tip                // for Total label
           grandTotal = (baseTotal - discountAmount) + tip  // ✅ discount NOT on tip

           lbl_total.text      = "\(LocalData.symbol)\(String(format: "%.2f", price))"
           lbl_discount.text   = "- \(LocalData.symbol)\(String(format: "%.2f", discount))"
           lbl_grandTotal.text = "\(LocalData.symbol)\(String(format: "%.2f", grandTotal))"
           if remainDiscountAmount > 0 {
               vw_Remaining.isHidden = false
               lbl_Remaining.font = UIFont(name: "Lato-Regular", size: 14.0)
               lbl_Remaining.text = "Remaining \(LocalData.symbol)\(String(format: "%.2f", remainDiscountAmount)) amount will be elapsed. Use the full amount otherwise it will be lost."
               print("Test:-\(remainDiscountAmount)")
               
           }else{
               vw_Remaining.isHidden = true
           }
           
           
//           if (grandTotal > 0 && paymentTypeSelectedFirst == "Giftcard / Voucher") {
           /*if (grandTotal > 0 && paymentTypeSelectedFirst == "Gift Card / Voucher") {
               self.vw_payment1.isHidden = false
           } else {
               self.vw_payment1.isHidden = true
           }*/
           
           print("paymentTypeSelectedFirst:- \(paymentTypeSelectedFirst)")
//           if paymentTypeSelectedFirst == "Gift Card / Voucher" {
           if paymentTypeSelectedFirst == NSLocalizedString("Gift Card / Voucher", comment: "") {
               self.vw_payment1.isHidden = false
               vw_grandTotal.isHidden = false
           } else {
               self.vw_payment1.isHidden = true
               vw_grandTotal.isHidden = true
           }
           
           vw_discount.isHidden   = discount == 0
//           vw_grandTotal.isHidden = false
       }



    func updateTotals() {
        lbl_total.text = "\(LocalData.symbol)\(String(format: "%.2f", price))"
        lbl_grandTotal.text = "\(LocalData.symbol)\(String(format: "%.2f", grandTotal))"
    }

    var isGiftCard = 0;
    
    //MARK: Api Call
    func checkCouponCode() {
            let bookingDate = convertDateString(Date.now)
            APIService.shared.CheckCouponCode(vendor_id: LocalData.userId,
                                              code: self.txt_couponCode.text ?? "",
                                              bookingDate: bookingDate) { result in
                guard let model = result else { return }
                let checkCouponData = model.data

                if checkCouponData?.is_coupon == 1 {
                    APIService.shared.ApplyCouponCode(vendor_id: LocalData.userId,
                                                      code: self.txt_couponCode.text ?? "") { result in
                        guard let model = result else { return }
                        let data = model.data
                        if model.error == "" || model.error == nil {
                            if let coupon = data?.results.first {
                                self.isGiftCard = 0;
                                self.alertWithMessageOnly(NSLocalizedString("Coupon applied successfully",comment: ""))
                                let amount = Double(coupon.amount)
                                let type   = coupon.discount_type
                                let upto   = Double(coupon.highest_amount)
                                self.discountType = type
                                self.discountVal  = amount
                                self.upto         = upto
                                self.btn_apply.setTitle("Remove".localized, for: .normal)
                                self.txt_couponCode.isUserInteractionEnabled = false
                                self.txt_couponCode.isEnabled = false
                                self.txt_couponCode.isUserInteractionEnabled = false
                                self.txt_couponCode.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
                                self.txt_couponCode.textColor = .gray
                                DispatchQueue.main.async { self.recalcTotals() }
                            }
                        } else {
                            self.alertWithMessageOnly(NSLocalizedString("Invalid Coupon Code",comment: ""))
                        }
                    }
                } else if checkCouponData?.is_gift == 1 {
                    APIService.shared.ApplyGiftCard(vendor_id: LocalData.userId,
                                                    code: self.txt_couponCode.text ?? "",
                                                    total: String(self.widgetPrice)) { result in
                        guard let model = result else { return }
                        if model.error == "" || model.error == nil {
                            if let giftCard = model.data?.results.first {
                                self.isGiftCard = 1;
                                self.discountType = "Flat"
                                self.discountVal  = Double(giftCard.price)
                                self.btn_apply.setTitle("Remove".localized, for: .normal)
                                self.txt_couponCode.isUserInteractionEnabled = false
                                self.txt_couponCode.isEnabled = false
                                self.txt_couponCode.isUserInteractionEnabled = false
                                self.txt_couponCode.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
                                self.txt_couponCode.textColor = .gray
                                
                                DispatchQueue.main.async { self.recalcTotals() }
                            }
                        } else {
                            self.alertWithMessageOnly(NSLocalizedString("Invalid gift card code",comment: ""))
                        }
                    }
                } else {
                    self.alertWithMessageOnly(NSLocalizedString("Invalid gift card code",comment: ""))
                }
            }
        }
    

    func AddServiceData() {
            var payment = ""
            if self.txt_paymentType.text == "Cash" {
                payment = "cash"
            } else if self.txt_paymentType.text == "Giftcard / Voucher" {
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
        if (payment == "card" || payment == "giftcard,card") && posId != "" {
            self.startTerminalTransaction(price: self.widgetPrice, miscPrice: miscPrice, notes: self.txt_miscServiNotes.text ?? "", paymentType: payment)
        }else{
            APIService.shared.addCartDetails(
                vendorId: LocalData.userId,
                subTotal: self.widgetPrice,
                grandTotal: self.grandTotal,
                discountAmount: String(format: "%.2f", self.discount),
                serviceIds: self.serviceId,
                couponCode: self.txt_couponCode.text ?? "",
                discountPercentage: discountType == "Percentage" ? String(discountVal) : "0",
                transactionId: "",
                paymentType: payment,
                discountType: self.discountType,
                giftCard: self.giftCards,
                miscellaneousNote: self.txt_miscServiNotes.text ?? "",
                miscellaneousPrice: Double(miscPrice) ?? 0,
                tips: Double(tips) ?? 0
            ) { result in
                guard let model = result else { return }
                if model.error == "" || model.error == nil {
                    DispatchQueue.main.async {
                        PrinterManager.shared.onConnect = {
                            self.showAlertToast(message: "Printer Connected ✅")
                            self.performPrint(serviceName: "Hair Cut",
                                         giftCard: "GC123",
                                         miscNote: "N/A",
                                         miscPrice: "10",
                                         tip: "5",
                                         paymentType: "Cash",
                                         total: "100",
                                         discount: "10",
                                         grandTotal: "90",
                                         couponCode: "WELCOME",
                                         isCashDrawerOpen: true)
                        }

                        PrinterManager.shared.onFail = {
                            print("Failed to connect ❌")
                        }

                        PrinterManager.shared.startScan()
                        self.delegate?.didClearData()
                        self.dismiss(animated: true)
                    }
                } else {
                    self.alertWithMessageOnly(NSLocalizedString("Failed to add cart details",comment: ""))
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
                self.alertWithMessageOnly(transactionModel?.error ?? "Error")
                return
            }

            if model.error == "" || model.error == nil {
                let tranId = model.data ?? ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    let popup = PaymentConfirmationPopupVC()
                    popup.modalPresentationStyle = .overFullScreen
                    popup.modalTransitionStyle = .crossDissolve
                    popup.onConfirm = {
                        self.verifyTransactionStatus(transactionId: tranId, price: price, miscPrice: miscPrice, notes: notes, paymentType: paymentType)
                        self.dismiss(animated: true)
                    }
                    self.present(popup, animated: true)
                }
            } else {
                self.alertWithMessageOnly(transactionModel?.error ?? "Error")
            }
        }
    }
    
    func verifyTransactionStatus(transactionId: String, price: Double, miscPrice: String, notes: String, paymentType: String) {
        showLoaderDialog(on: self, title: "Updating")

        APIService.shared.WalkinPayment(vendorId: LocalData.userId,
                                        transactionId: transactionId) { posPaymentStatus in
            

            guard let data = posPaymentStatus?.data else { return }

            switch data.transactionStatus {
            case "NOSTATUS":
                self.alertWithMessageOnly(NSLocalizedString("Still pending...",comment: ""))
            case "CANCELED", "REFUSED":
                self.alertWithMessageOnly(NSLocalizedString("Payment cancelled",comment: ""))
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
                self.alertWithMessageOnly(NSLocalizedString("Unknown status",comment: ""))
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
                    self.alertWithMessageOnly(NSLocalizedString("Booking completed successfully",comment: ""))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        // Printer Code
                        /*PrinterManager.shared.onConnect = {
                            print("Printer Connected ✅")
                            self.performPrint(serviceName: "Hair Cut",
                                         giftCard: "GC123",
                                         miscNote: "N/A",
                                         miscPrice: "10",
                                         tip: "5",
                                         paymentType: "Cash",
                                         total: "100",
                                         discount: "10",
                                         grandTotal: "90",
                                         couponCode: "WELCOME",
                                         isCashDrawerOpen: true)
                        }

                        PrinterManager.shared.onFail = {
                            print("Failed to connect ❌")
                        }

                        PrinterManager.shared.startScan()*/

                        self.delegate?.didClearData()
                        self.dismiss(animated: true)
                    }
                }
                
            } else {
                self.alertWithMessageOnly(NSLocalizedString("Failed to add cart details",comment: ""))
            }
        }
    }


    func performPrint(serviceName: String,
                      giftCard: String,
                      miscNote: String,
                      miscPrice: String,
                      tip: String,
                      paymentType: String,
                      total: String,
                      discount: String,
                      grandTotal: String,
                      couponCode: String,
                      isCashDrawerOpen: Bool) {
        
        var receipt = ""
        receipt += "----- The Crazy Beauty -----\n\n"
        receipt += "Date: \(Date())\n"
        receipt += "Service: \(serviceName.isEmpty ? "N/A" : serviceName)\n"
        receipt += "GiftCard: \(giftCard.isEmpty ? "N/A" : giftCard)\n"
        receipt += "Misc Note: \(miscNote.isEmpty ? "N/A" : miscNote)\n"
        receipt += "Misc Price: \(miscPrice)\n"
        receipt += "Tip: \(tip)\n"
        receipt += "Coupon: \(couponCode.isEmpty ? "N/A" : couponCode)\n"
        receipt += "Payment: \(paymentType.capitalized)\n"
        receipt += "Total: \(total)\n"
        receipt += "Discount: \(discount)\n"
        receipt += "Grand Total: \(grandTotal)\n"
        receipt += "-----------------------------\n"
        receipt += "Thank you for visiting!\n\n\n"
        
        PrinterManager.shared.printText(receipt)
        
        if isCashDrawerOpen {
            PrinterManager.shared.openCashDrawer()
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
        /*let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()*/

        // Create message label
        let messageLabel = UILabel()
        messageLabel.text = title
        messageLabel.numberOfLines = 3
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textAlignment = .left
        messageLabel.lineBreakMode = .byTruncatingTail
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        alert.view.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: alert.view.centerYAnchor),

            // Padding so text doesn't touch edges
            messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: alert.view.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: alert.view.trailingAnchor, constant: -20)
        ])
        
        // Create container view
        /*let container = UIStackView(arrangedSubviews: [spinner, messageLabel])
        container.axis = .horizontal
        container.spacing = 20
        container.alignment = .center
        container.translatesAutoresizingMaskIntoConstraints = false*/

        /*alert.view.addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 20),
            container.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: 20),
            container.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant: 20),
            container.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor, constant: 20),
        ])*/

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


enum PaymentType: String {
    case cash = "cash"
    case card = "card"
    case giftcard = "giftcard"
}

func paymentTitle(from apiValue: String) -> String {
    switch apiValue {
    case PaymentType.cash.rawValue:
        return "Cash1".localized
    case PaymentType.card.rawValue:
        return "Card1".localized
    case PaymentType.giftcard.rawValue:
        return "Gift Card / Voucher".localized
    default:
        return apiValue
    }
}
