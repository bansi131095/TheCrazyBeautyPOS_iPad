//
//  LoginScreen.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 04/06/25.
//

import UIKit

class LoginScreen: UIViewController {

    
    @IBOutlet weak var txt_email: TextInputLayout!
    
    @IBOutlet weak var txt_password: TextInputLayout!
    
    @IBOutlet weak var btn_eye: UIButton!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    @IBOutlet weak var lbl_Login: UILabel!
    @IBOutlet weak var lbl_AllField: UILabel!
    @IBOutlet weak var btn_Login: GradientButton!
    @IBOutlet weak var btn_LoginasStaff: UIButton!
    @IBOutlet weak var lbl_Or_Login: UILabel!
    @IBOutlet weak var btn_Google: UIButton!
    
    @IBOutlet weak var Constraint_Bottom: NSLayoutConstraint!
    
    var staffLogin = String()
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.isHidden = true
        self.btn_eye.setImage(#imageLiteral(resourceName: "view"), for: .normal)
        self.txt_password.isSecureTextEntry = true
        if staffLogin == "Staff"{
            self.btn_Login.isHidden = false
            self.btn_LoginasStaff.isHidden = true
            self.lbl_Or_Login.isHidden = true
            self.btn_Google.isHidden = true
            self.Constraint_Bottom.constant = 35
        }else{
            self.btn_Login.isHidden = false
            self.btn_LoginasStaff.isHidden = false
            self.lbl_Or_Login.isHidden = false
            self.btn_Google.isHidden = false
            self.Constraint_Bottom.constant = 246.5
        }
        /*if staffLogin != "Staff"{
            self.btn_Login.isHidden = false
            self.btn_LoginasStaff.isHidden = false
            self.lbl_Or_Login.isHidden = false
            self.btn_Google.isHidden = false
            self.Constraint_Bottom.constant = 246.5
        }*/
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: Button Action
    @IBAction func act_login(_ sender: GradientButton) {
        if (self.txt_email.text == "") {
            self.txt_email.showErrorMessage(message: "Please enter email")
        } else if !self.txt_email.text!.isValidEmail() {
            self.txt_email.showErrorMessage(message: "Please enter valid email")
        } else if (self.txt_password.text == "") {
            self.txt_password.showErrorMessage(message: "Please enter password")
        } else {
            if staffLogin == "Staff"{
                print("Staff")
                print("Staff")
                print("Staff")
                print("Staff")
            }else{
                self.performLogin()
            }
        }
    }
    
    @IBAction func act_loginStaff(_ sender: UIButton) {
    }
    
    @IBAction func act_googleLogin(_ sender: UIButton) {
    }
    
    @IBAction func act_passwordHideShow(_ sender: UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "view.png") {
            sender.setImage(#imageLiteral(resourceName: "hidden"), for: .normal)
            self.txt_password.isSecureTextEntry = false
        } else {
            sender.setImage(#imageLiteral(resourceName: "view"), for: .normal)
            self.txt_password.isSecureTextEntry = true
        }
    }
    
    func performLogin() {
        let email = txt_email.text ?? ""
        let password = txt_password.text ?? ""
        self.loader.hidesWhenStopped = false
        self.loader.startAnimating()
            APIService.shared.login(email: email, password: password) { loginData in
                self.loader.stopAnimating()
                self.loader.hidesWhenStopped = true
                if let data = loginData {
                    print("✅ Login successful!")
                    print("🔑 Token: \(data.token ?? "N/A")")
                
                    SharedPrefs.setEmail(data.email ?? "")
                    SharedPrefs.setUserId(String(data.id ?? 0))
                    SharedPrefs.setUserName((data.first_name ?? "") + " " + (data.last_name ?? ""))
                    SharedPrefs.setSalonId(String(data.salon_id ?? 0))
                    SharedPrefs.setSalonName(data.salon_name ?? "")
                    SharedPrefs.setLoginToken(data.token ?? "")
                    SharedPrefs.setStaffLogin(false)
                    let currentTimeMillis = Int(Date().timeIntervalSince1970 * 1000)
                    let timeString = String(currentTimeMillis)
                    SharedPrefs.setLoginTime(timeString)
                    LocalData.getUserData()
                    let sb = UIStoryboard(name: "Home", bundle:nil)
                    let navDashboard = sb.instantiateViewController(withIdentifier: "NavigateHome") as! UINavigationController
                     navDashboard.modalPresentationStyle = .fullScreen
                    self.present(navDashboard, animated: true, completion: nil)
                } else {
                    print("❌ Login failed or invalid response.")
                }
            }
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



