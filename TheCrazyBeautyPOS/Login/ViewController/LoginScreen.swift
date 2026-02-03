//
//  LoginScreen.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 04/06/25.
//

import UIKit
import GoogleSignIn

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
    
    
    
    var vendorData: VendorDataItem?
    
    var staffLogin = String()
    var isPasswordVisible = false
    
    
    var googleId = ""
    var googleName = ""
    var googleEmail = ""
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.isHidden = true
        self.btn_eye.setImage(#imageLiteral(resourceName: "view"), for: .normal)
        self.txt_password.isSecureTextEntry = true
        self.btn_Login.isHidden = true
        self.btn_LoginasStaff.isHidden = true
        self.lbl_Or_Login.isHidden = true
        self.btn_Google.isHidden = true
        checkVendor()
        
        self.lbl_Login.text = NSLocalizedString("Log in to manage your business.",comment: "")
        self.lbl_AllField.text = NSLocalizedString("All fields marked with an asterisk (*) are required.", comment: "")
        let title = NSLocalizedString("Login", comment: "")
        
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 20.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        btn_Login.setAttributedTitle(attributedTitle, for: .normal)
        
        
        let LoginasStaff = NSLocalizedString("Login as Staff", comment: "")
        
        let LoginasStaff1 = NSAttributedString(
            string: LoginasStaff,
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 20.0)!,
                .foregroundColor: UIColor.black
            ]
        )
        btn_LoginasStaff.setAttributedTitle(LoginasStaff1, for: .normal)
        
        if staffLogin == "Staff"{
            self.btn_Login.isHidden = false
            self.btn_LoginasStaff.isHidden = true
            self.lbl_Or_Login.isHidden = true
            self.btn_Google.isHidden = true
//            self.Constraint_Bottom.constant = 35
        }
        /*else{
            self.btn_Login.isHidden = false
            self.btn_LoginasStaff.isHidden = false
            self.lbl_Or_Login.isHidden = false
            self.btn_Google.isHidden = false
//            self.Constraint_Bottom.constant = 246.5
        }*/
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
            self.txt_email.showErrorMessage(message: NSLocalizedString("Email ID is required.",comment: ""))
        } else if !self.txt_email.text!.isValidEmail() {
            self.txt_email.showErrorMessage(message: NSLocalizedString("Please provide valid email id.",comment: ""))
        } else if (self.txt_password.text == "") {
            self.txt_password.showErrorMessage(message: NSLocalizedString("Password is required.",comment: ""))
        } else {
            if staffLogin == "Staff"{
                subvendor()
            }else{
                self.performLogin()
            }
        }
    }
    
    @IBAction func act_loginStaff(_ sender: UIButton) {
        if (self.txt_email.text == "") {
            self.txt_email.showErrorMessage(message: NSLocalizedString("Email ID is required.",comment: ""))
        } else if !self.txt_email.text!.isValidEmail() {
            self.txt_email.showErrorMessage(message: NSLocalizedString("Please provide valid email id.",comment: ""))
        } else if (self.txt_password.text == "") {
            self.txt_password.showErrorMessage(message: NSLocalizedString("Password is required.",comment: ""))
        }else{
            subvendor()
        }
    }
    
    @IBAction func act_googleLogin(_ sender: UIButton) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            
        guard error == nil else { return }

          // If sign in succeeded, display the app's main content View.
            guard let signInResult = signInResult else { return }
            let user = signInResult.user

            self.googleEmail = user.profile?.email ?? ""
            self.googleName = user.profile?.name ?? ""
            self.googleId = user.userID ?? ""
            self.googlelogin(social_id: self.googleId, social_type: "google", email: self.googleEmail)
//            self.call_SignUpAPI(socialId: self.googleId)
             
        }
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
                    
                    UserDefaults.standard.set("0", forKey: "Passcode")
                    UserDefaults.standard.synchronize()
                
                    SharedPrefs.setEmail(data.email ?? "")
                    SharedPrefs.setUserId(String(data.id ?? 0))
                    SharedPrefs.setUserName((data.first_name ?? "") + " " + (data.last_name ?? ""))
                    SharedPrefs.setSalonId(String(data.salon_id ?? 0))
                    SharedPrefs.setSalonName(data.salon_name ?? "")
                    SharedPrefs.setLoginToken(data.token ?? "")
                    SharedPrefs.setStaffLogin(false)
                    SharedPrefs.setSubvendor("Vendor")
                    SharedPrefs.setPosId(data.pos_id ?? "")
                    let currentTimeMillis = Int(Date().timeIntervalSince1970 * 1000)
                    let timeString = String(currentTimeMillis)
                    SharedPrefs.setLoginTime(timeString)
                    LocalData.getUserData()
                    let sb = UIStoryboard(name: "Home", bundle:nil)
                    let navDashboard = sb.instantiateViewController(withIdentifier: "NavigateHome") as! UINavigationController
                     navDashboard.modalPresentationStyle = .fullScreen
                    self.present(navDashboard, animated: true, completion: nil)
                } else {
                    self.alertWithMessageOnly(NSLocalizedString("You are not registered yet",comment: ""))
                }
            }
        }
    
    func subvendor(){
        let email = txt_email.text ?? ""
        let password = txt_password.text ?? ""
        self.loader.hidesWhenStopped = false
        self.loader.startAnimating()
        APIService.shared.subvendorLogin(email: email, password: password) { result in
            self.loader.stopAnimating()
            self.loader.hidesWhenStopped = true
            if (result?.error != nil && result?.error != "") {
                self.alertWithMessageOnly(NSLocalizedString("You are not registered yet",comment: ""))
                return
            }
            if let data = result {
                self.alertWithMessageOnly(NSLocalizedString("Logged in successfully",comment: ""))
                
                UserDefaults.standard.set("0", forKey: "Passcode")
                UserDefaults.standard.synchronize()
                
                SharedPrefs.setEmail(result?.vendorData.first?.email ?? "")
                SharedPrefs.setUserId(String(result?.vendorData.first?.id ?? 0))
                SharedPrefs.setUserName((result?.vendorData.first?.firstName ?? "") + " " + (result?.vendorData.first?.lastName ?? ""))
                SharedPrefs.setSalonId(String(result?.vendorData.first?.salonId ?? 0))
                SharedPrefs.setSalonName(result?.vendorData.first?.salonName ?? "")
                SharedPrefs.setLoginToken(data.token ?? "")
                SharedPrefs.setPosId(result?.vendorData.first?.posId ?? "")
                SharedPrefs.setSubvendor("Subvendor")
                let sb = UIStoryboard(name: "Home", bundle:nil)
                let navDashboard = sb.instantiateViewController(withIdentifier: "NavigateHome") as! UINavigationController
                 navDashboard.modalPresentationStyle = .fullScreen
                self.present(navDashboard, animated: true, completion: nil)
            }else{
                self.alertWithMessageOnly(NSLocalizedString("You are not registered yet",comment: ""))
            }
            
        }
    }
    
    func checkVendor(){
        APIService.shared.getCheckVendor { result in
            if (result?.error != nil && result?.error != "") {
                self.alertWithMessageOnly(NSLocalizedString("Failed to check vendor",comment: ""))
                return
            }
            if result?.data == "0"{
                self.btn_Login.isHidden = false
                self.btn_LoginasStaff.isHidden = true
                self.lbl_Or_Login.isHidden = true
                self.btn_Google.isHidden = true
//                self.Constraint_Bottom.constant = 35
            }else{
                self.btn_Login.isHidden = false
                self.btn_LoginasStaff.isHidden = false
                self.lbl_Or_Login.isHidden = false
                self.btn_Google.isHidden = false
//                self.Constraint_Bottom.constant = 246.5
            }
            
        }
    }
    
    
    func googlelogin(social_id:String,social_type:String,email:String){
        self.loader.hidesWhenStopped = false
        self.loader.startAnimating()
        APIService.shared.soicalLogin(social_id: social_id, social_type: social_type, email: email) { result in
            self.loader.stopAnimating()
            self.loader.hidesWhenStopped = true
            if let data = result {
                print("✅ Login successful!")
                print("🔑 Token: \(data.token ?? "N/A")")
                
                UserDefaults.standard.set("0", forKey: "Passcode")
                UserDefaults.standard.synchronize()
            
                SharedPrefs.setEmail(data.email ?? "")
                SharedPrefs.setUserId(String(data.id ?? 0))
                SharedPrefs.setUserName((data.first_name ?? "") + " " + (data.last_name ?? ""))
                SharedPrefs.setSalonId(String(data.salon_id ?? 0))
                SharedPrefs.setSalonName(data.salon_name ?? "")
                SharedPrefs.setLoginToken(data.token ?? "")
                SharedPrefs.setPosId(data.pos_id ?? "")
                
                
                print("ASDASD:- \(data.pos_id ?? "")")
                SharedPrefs.setStaffLogin(false)
                SharedPrefs.setSubvendor("Vendor")
                let currentTimeMillis = Int(Date().timeIntervalSince1970 * 1000)
                let timeString = String(currentTimeMillis)
                SharedPrefs.setLoginTime(timeString)
                LocalData.getUserData()
                let sb = UIStoryboard(name: "Home", bundle:nil)
                let navDashboard = sb.instantiateViewController(withIdentifier: "NavigateHome") as! UINavigationController
                 navDashboard.modalPresentationStyle = .fullScreen
                self.present(navDashboard, animated: true, completion: nil)
            }else {
                self.alertWithMessageOnly(NSLocalizedString("You are not registered yet",comment: ""))
            }

        }
    }
    /*func Subvendor(){
        SharedPrefs.setSubvendor("Subvendor")
        let sb = UIStoryboard(name: "Home", bundle: nil)
            let navDashboard = sb.instantiateViewController(withIdentifier: "NavigateHome") as! UINavigationController
            
            // Get HomeVC (root of navigation)
            if let homeVC = navDashboard.viewControllers.first as? HomeVC {
                homeVC.isPass = "isPass"
            }
            
            navDashboard.modalPresentationStyle = .fullScreen
            self.present(navDashboard, animated: true, completion: nil)
    }*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



