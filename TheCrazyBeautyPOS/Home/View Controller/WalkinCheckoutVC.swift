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
    @IBOutlet weak var lbl_service: UILabel!
    @IBOutlet weak var lbl_total: UILabel!
    
    
    let paymentOptions = ["Cash", "Card", "Giftcard / Voucher"]
    let dropdownView = UITableView()
    var isDropdownVisible = false
    
    var price: Double = 0.0
    var serviceId: String = ""
    var giftCards: String = ""
    var totalServices: Int = 0
    var totalGiftCard: Int = 0

    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPaymentTextField()
        setupDropdownTable()
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
    }
}
