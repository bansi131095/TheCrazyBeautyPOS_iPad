//
//  HomeVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 06/06/25.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var lbl_Title: UILabel!
    
    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var txt_salon: UITextField!
    @IBOutlet weak var vw_pending: UIView!
    @IBOutlet weak var btn_TopClick: UIButton!
    
    var salonList: [String] = []
    var selectedSalon: String = ""
    var OTP = String()
    var isPass = String()
    var window: UIWindow?
    
//    MARK: - Popup
    @IBOutlet weak var vwPopup: UIView!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_Version: UILabel!
    @IBOutlet weak var lbl_salonName: UILabel!
    
    
    @IBOutlet weak var vw_MyProfile: UIView!
    //MARK: - PASSCODE POPUP
    @IBOutlet weak var vwMainPasscode: UIView!
    @IBOutlet weak var vwPasscodePopup: UIView!
    
    
    @IBOutlet weak var txt_1: UITextField!
    @IBOutlet weak var txt_2: UITextField!
    @IBOutlet weak var txt_3: UITextField!
    @IBOutlet weak var txt_4: UITextField!
    @IBOutlet weak var txt_5: UITextField!
    @IBOutlet weak var txt_6: UITextField!
    
    @IBOutlet weak var vw_SalonType: UIView!
    
    @IBOutlet weak var img_SelectedImage: UIImageView!
    @IBOutlet weak var lbl_SelectedLanguage: UILabel!
    
    
    @IBOutlet weak var vw_Language: UIView!
    
    
    
    
    
    var imageArray: [UIImage] = [
        #imageLiteral(resourceName: "Dashboard.png"),
        #imageLiteral(resourceName: "Booking"),
        #imageLiteral(resourceName: "Walkin"),
        #imageLiteral(resourceName: "Services"),
        #imageLiteral(resourceName: "Team"),
        #imageLiteral(resourceName: "Clients"),
        #imageLiteral(resourceName: "Promotion"),
        #imageLiteral(resourceName: "Inventory"),
//        #imageLiteral(resourceName: "Report"),
    ]
    
    var imageArrayN : [UIImage] = [#imageLiteral(resourceName: "Booking"),#imageLiteral(resourceName: "Team"),#imageLiteral(resourceName: "Clients"),#imageLiteral(resourceName: "Promotion"),#imageLiteral(resourceName: "Inventory")]
    var notificationList: [MessageData] = []
    
    var selectedIndex: Int = 1
    var subvendorIndex: Int = 0
    private var tapCount = 0
    private let maxTaps = 8
    private var isReportImageAdded = false
    var vendor = ""
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getNotificationData()
        vendor = SharedPrefs.getSubvendor()
        
        
        if vendor == "Subvendor"{
            SubloadEmbeddedViewController(for: 0)
            vw_SalonType.isHidden = true
            lbl_UserName.isHidden = true
            lbl_salonName.isHidden = false
            vw_MyProfile.isHidden = true
            btn_TopClick.isHidden = true
        }else{
            loadEmbeddedViewController(for: 1)
            vw_SalonType.isHidden = false
            lbl_UserName.isHidden = false
            lbl_salonName.isHidden = false
            vw_MyProfile.isHidden = false
            btn_TopClick.isHidden = false
        }
        self.setUpTableView()
//        loadEmbeddedViewController(for: 1)
        self.getAllSalonData()
        let salonName = SharedPrefs.getSalonName()
        let userName = SharedPrefs.getUserName()
        self.txt_salon.text = salonName
        self.lbl_salonName.text = salonName
        self.lbl_UserName.text = userName
        self.lbl_Version.text = "V - \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "")" +  " (\(Bundle.main.infoDictionary?["CFBundleVersion"] ?? "")) "
        self.get_Image()
        txt_1.tag = 1
        txt_2.tag = 2
        txt_3.tag = 3
        txt_4.tag = 4
        txt_5.tag = 5
        txt_6.tag = 6
        setCustomFont()
        self.vwMainPasscode.isHidden = true
        
        if let lang = UserDefaults.standard.object(forKey: global().kSaveLanguageDefaultKey) as? String {
            if lang == "en"{
                img_SelectedImage.image = UIImage(named: "ic_UK")
                lbl_SelectedLanguage.text = "English"
            }
            if lang == "zh"{
                img_SelectedImage.image = UIImage(named: "ic_Chian")
                lbl_SelectedLanguage.text = "中文"
            }
            if lang == "vi"{
                img_SelectedImage.image = UIImage(named: "ic_VI")
                lbl_SelectedLanguage.text = "Tiếng Việt"
            }
        }else{
            img_SelectedImage.image = UIImage(named: "ic_UK")
            lbl_SelectedLanguage.text = "English"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getNotificationData()
    }
    
    
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Regular", size: 22.0) {
            txt_1.font = customFont
            txt_2.font = customFont
            txt_3.font = customFont
            txt_4.font = customFont
            txt_5.font = customFont
            txt_6.font = customFont
        }
    }
    
    func setUpTableView() {
        let nib = UINib(nibName: "HomeMenuCell", bundle: nil)
        self.tbl_vw.register(nib, forCellReuseIdentifier: "HomeMenuCell")
        
        self.tbl_vw.delegate = self
        self.tbl_vw.dataSource = self
        self.tbl_vw.rowHeight = 100
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

            guard let touch = touches.first else { return }
            let location = touch.location(in: self.view)

            // Hide popup if it's visible and touch is outside vwPopup
            if !vwPopup.isHidden && !vwPopup.frame.contains(location) {
                vwPopup.isHidden = true
            }
            // Dismiss dropdown if visible and tapped outside txt_salon
            if txt_salon.isFirstResponder {
                txt_salon.resignFirstResponder()
            }

            // Also dismiss dropdown manually if using a custom dropdown manager
            DropdownManager.shared.hideDropdown()
            vwPopup.isHidden = true
    }

    func loadEmbeddedViewController(for index: Int) {
            // Optionally switch based on index if you have multiple VCs
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        var selectedVC: UIViewController?

        switch index {
        case 0:
            selectedVC = storyboard.instantiateViewController(withIdentifier: "UpcomingAppointmentsVC") as? UpcomingAppointmentsVC
        case 1:
            selectedVC = storyboard.instantiateViewController(withIdentifier: "BookingVC") as? BookingVC
        case 2:
            selectedVC = storyboard.instantiateViewController(withIdentifier: "WalkingVC") as? WalkingVC
        case 3:
            selectedVC = storyboard.instantiateViewController(withIdentifier: "ServicesVC") as? ServicesVC
        case 4:
            selectedVC = storyboard.instantiateViewController(withIdentifier: "TeamVC") as? TeamVC
        case 5:
            selectedVC = storyboard.instantiateViewController(withIdentifier: "ClientsVC") as? ClientsVC
        case 6:
            selectedVC = storyboard.instantiateViewController(withIdentifier: "PromotionVC") as? PromotionVC
        case 7:
            selectedVC = storyboard.instantiateViewController(withIdentifier: "InventoryVC") as? InventoryVC
        case 8:
            selectedVC = storyboard.instantiateViewController(withIdentifier: "ReportVC") as? ReportVC
        default:
            print("Invalid index")
            return
        }

        // Remove old child
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }

        if let vc = selectedVC {
            addChild(vc)
            vc.view.frame = containerView.bounds
            containerView.addSubview(vc.view)
            vc.didMove(toParent: self)
        }
    }
  
    func SubloadEmbeddedViewController(for index: Int) {
            // Optionally switch based on index if you have multiple VCs
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        var selectedVC: UIViewController?

        switch index {
        case 0:
            selectedVC = storyboard.instantiateViewController(withIdentifier: "BookingVC") as? BookingVC
        case 1:
            selectedVC = storyboard.instantiateViewController(withIdentifier: "TeamVC") as? TeamVC
        case 2:
            selectedVC = storyboard.instantiateViewController(withIdentifier: "ClientsVC") as? ClientsVC
        case 3:
            selectedVC = storyboard.instantiateViewController(withIdentifier: "PromotionVC") as? PromotionVC
        case 4:
            selectedVC = storyboard.instantiateViewController(withIdentifier: "InventoryVC") as? InventoryVC
        default:
            print("Invalid index")
            return
        }

        // Remove old child
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }

        if let vc = selectedVC {
            addChild(vc)
            vc.view.frame = containerView.bounds
            containerView.addSubview(vc.view)
            vc.didMove(toParent: self)
        }
    }
    
    //<<<<<<< HEAD
    //MARK: Button Action
    @IBAction func act_notification(_ sender: UIButton) {
        let notification = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(notification, animated: true)
    }
    
    
    @IBAction func btn_TopClick(_ sender: Any) {
        tapCount += 1
        if tapCount == maxTaps {
           tapCount = 0

           if !isReportImageAdded {
               // Add the missing image
               isReportImageAdded = true
               self.vwMainPasscode.isHidden = false
           } else {
               print("Already not add")
           }
        }
    }
    
    @IBAction func btn_Close(_ sender: Any) {
        self.vwMainPasscode.isHidden = true
    }
    
    @IBAction func btn_PopupClose(_ sender: Any) {
        self.vwPopup.isHidden = true
    }
    
    @IBAction func btn_Language(_ sender: Any) {
        self.vw_Language.isHidden = true
    }
    
    @IBAction func btn_SalonType(_ sender: Any) {
        getAllSalonData()
        
        if vw_Language.isHidden == false {
            vw_Language.isHidden = true
        }
        
        if vwPopup.isHidden == false {
            vwPopup.isHidden = true
        }
    }
    
    @IBAction func btn_Continue(_ sender: Any) {
        if txt_1.text != "" && txt_2.text != "" && txt_3.text != "" && txt_4.text != "" && txt_5.text != "" && txt_6.text != "" {
            var otpStr = txt_1.text! + txt_2.text!
            otpStr.append(txt_3.text! + txt_4.text!)
            otpStr.append(txt_5.text! + txt_6.text!)
            if otpStr != ""{
                self.OTP = otpStr;
                verfiyPasscode1(passcode: OTP)
            }
        }
    }
    
    @IBAction func btn_LanguageMain(_ sender: Any) {
        if vw_Language.isHidden == false{
            self.vw_Language.isHidden = true
        }else{
            self.vw_Language.isHidden = false
        }
        
        if vwPopup.isHidden == false {
            vwPopup.isHidden = true
        }
    }
    
    
    @IBAction func btn_English(_ sender: Any) {
        setUpLanguage(lanCode: "en")
        vw_Language.isHidden = true
        img_SelectedImage.image = UIImage(named: "ic_UK")
        lbl_SelectedLanguage.text = "English"
    }
    
    @IBAction func btn_Chain(_ sender: Any) {
        setUpLanguage(lanCode: "zh")
        vw_Language.isHidden = true
        img_SelectedImage.image = UIImage(named: "ic_Chian")
        lbl_SelectedLanguage.text = "中文"
    }
    
    @IBAction func btn_vi(_ sender: Any) {
        setUpLanguage(lanCode: "vi")
        vw_Language.isHidden = true
        img_SelectedImage.image = UIImage(named: "ic_VI")
        lbl_SelectedLanguage.text = "Tiếng Việt"
    }
    
    
    // MARK: - Language
    func setUpLanguage(lanCode: String){
        let lan = lanCode
        UserDefaults.standard.set(lan, forKey: global().kSaveLanguageDefaultKey)
       
        L102Language.setAppleLAnguageTo(lang: lanCode)
        Localisator.init()
        let sb = UIStoryboard(name: "Home", bundle:nil)
        
        let navDashboard = sb.instantiateViewController(withIdentifier: "NavigateHome") as! UINavigationController
         navDashboard.modalPresentationStyle = .fullScreen
        
        window?.rootViewController = navDashboard
        window?.makeKeyAndVisible()
    }
    
    func verfiyPasscode1(passcode: String){
        showLoader()
        APIService.shared.verifyPasscode(passcode: passcode, vendorId: LocalData.userId) { result in
            self.hideLoader()
            if result?.data?.status == 1{
                self.vwMainPasscode.isHidden = true
                self.imageArray.append(#imageLiteral(resourceName: "Report"))
                self.tbl_vw.reloadData()
                self.showToast(message: result?.data?.message ?? "Passcode verified successfully")
            }else{
                self.showToast(message: result?.data?.error ?? "Please enter correct passcode")
            }
        }
    }
    
    //MARK: Api Data
    func getNotificationData() {
//        showLoader()
        APIService.shared.getNotificationList(page: "1", limit: "10") { activityResult in
//            self.hideLoader()
            guard let model = activityResult else { return }
            self.notificationList = model.data
            
            if let firstUnviewed = self.notificationList.first(where: { $0.viewed == 0 }) {
                global.shared.hasUnreadNotification = true
                self.vw_pending.isHidden = false
                print("Found unviewed notification with id:")
            } else {
                global.shared.hasUnreadNotification = false
                self.vw_pending.isHidden = true
                print("All notifications are viewed")
            }
        }
    }

    
    func getAllSalonData() {
    
        self.showLoader()
        APIService.shared.getAllSalonData() { staffResult in
            guard let model = staffResult else {
                return
            }
            self.hideLoader()
            let newItems = model.data
            if !newItems.isEmpty {
                let CategoryList = newItems
                for cate in CategoryList {
                    if cate.salonName != ""{
                        self.salonList.append(cate.salonName)
                    }else{
                        print("AS")
                    }
                }
                DropdownManager.shared.setupDropdown(
                    for: self.txt_salon,
                    in: self.view,
                    with: self.salonList,
                    width: 200.0,
                ) { [weak self] selected in
                    guard let self = self else { return }
                    for cate in CategoryList {
                        if cate.salonName == selected {
                            self.selectedSalon = "\(cate.id)"
                        }
                    }
                    self.txt_salon.text = selected
                    self.updateSalonData()
                }
            }
        }
    }
    
    
    func updateSalonData() {
        self.showLoader()
        APIService.shared.updateSalonData(salonId: self.selectedSalon) { result in
            guard let model = result else {
                return
            }
            self.hideLoader()
            if let salonData = model.data {
                if salonData.businessVerified == 1 {
                    SharedPrefs.setEmail(salonData.email)
                    SharedPrefs.setUserId(String(salonData.id))
                    SharedPrefs.setUserName((salonData.firstName) + " " + (salonData.lastName))
                    if salonData.salonId == 0 {
                        SharedPrefs.setSalonId(String(salonData.id))
                    } else {
                        SharedPrefs.setSalonId(String(salonData.salonId))
                    }
                    SharedPrefs.setSalonName(salonData.salonName)
                    SharedPrefs.setLoginToken(salonData.token)
                    SharedPrefs.setStaffLogin(false)
                    SharedPrefs.setVerified(true)
                    let currentTimeMillis = Int(Date().timeIntervalSince1970 * 1000)
                    let timeString = String(currentTimeMillis)
                    SharedPrefs.setLoginTime(timeString)
                    LocalData.getUserData()
                    let sb = UIStoryboard(name: "Home", bundle:nil)
                    let navDashboard = sb.instantiateViewController(withIdentifier: "NavigateHome") as! UINavigationController
                     navDashboard.modalPresentationStyle = .fullScreen
                    self.present(navDashboard, animated: true, completion: nil)
                }
            }
        }
    }
    
    func get_Image() {
        showLoader()
        APIService.shared.fetchProfileImage { result in
            self.hideLoader()
            guard let model = result?.data.first else {
                print("⚠️ No profile data found")
                return
            }

            // Load profile image
            let imgUrl = global.imageUrl_Profile + (model.profile_photo ?? "")
            if let url = URL(string: imgUrl) {
                self.img_profile.sd_setImage(with: url, placeholderImage: UIImage(named: "user"))
            }

        }
    }

    //=======
    @IBAction func btn_Profile(_ sender: UIButton) {
        if vwPopup.isHidden == false {
            vwPopup.isHidden = true
        }else{
            vwPopup.isHidden = false
        }
        
        if vw_Language.isHidden == false{
            vw_Language.isHidden = true
        }
    }
    
    @IBAction func btn_MyProfile(_ sender: Any) {
        let sb = UIStoryboard(name: "Profile", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
        vwPopup.isHidden = true
    }
    
    
    @IBAction func btn_Logout(_ sender: UIButton) {
        SharedPrefs.clearUserData()
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let navigation = sb.instantiateViewController(withIdentifier: "NavigateLogin") as! UINavigationController
        navigation.modalPresentationStyle = .fullScreen
        self.present(navigation, animated: true)
    }
    
    //>>>>>>> ajay_work
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    /*func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeMenuCell", for: indexPath) as? HomeMenuCell else {
            return UITableViewCell()
        }

        // Configure your cell
        if indexPath.row == imageArray.count {
            cell.img_bg.isHidden = false
            cell.img_bg.image = UIImage(named: "icon-bg")
            cell.menuIcon.image = UIImage(named: "up_arrow_into_square")
        } else {
            if self.selectedIndex == indexPath.row {
                cell.img_bg.isHidden = false
                cell.img_bg.image = UIImage(named: "icon-bg")
                cell.menuIcon.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                cell.img_bg.isHidden = true
                cell.menuIcon.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            cell.menuIcon.image = self.imageArray[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != imageArray.count {
            self.selectedIndex = indexPath.row
            self.tbl_vw.reloadData()
            loadEmbeddedViewController(for: self.selectedIndex)
        }
    }*/
   
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if vendor == "Subvendor" {
            return imageArrayN.count // include extra arrow
        } else {
            return imageArray.count + 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeMenuCell", for: indexPath) as? HomeMenuCell else {
            return UITableViewCell()
        }
        
        if vendor == "Subvendor" {
            if indexPath.row == imageArrayN.count {
                // Last "arrow" cell
                cell.img_bg.isHidden = false
                cell.img_bg.image = UIImage(named: "icon-bg")
                cell.menuIcon.image = UIImage(named: "up_arrow_into_square")
            } else {
                // Normal icon
                let isSelected = (self.subvendorIndex == indexPath.row)
                cell.img_bg.isHidden = !isSelected
                cell.menuIcon.tintColor = isSelected ? .white : .black
                cell.menuIcon.image = self.imageArrayN[indexPath.row]
            }
        } else {
            if indexPath.row == imageArray.count {
                cell.img_bg.isHidden = false
                cell.img_bg.image = UIImage(named: "icon-bg")
                cell.menuIcon.image = UIImage(named: "up_arrow_into_square")
            } else {
                let isSelected = (self.selectedIndex == indexPath.row)
                cell.img_bg.isHidden = !isSelected
                cell.menuIcon.tintColor = isSelected ? .white : .black
                cell.menuIcon.image = self.imageArray[indexPath.row]
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if vendor == "Subvendor" {
            if indexPath.row != imageArrayN.count { // avoid arrow row
                self.subvendorIndex = indexPath.row
                self.tbl_vw.reloadData()
                SubloadEmbeddedViewController(for: subvendorIndex)
            }
        } else {
            getNotificationData()
            if indexPath.row != imageArray.count { // avoid arrow row
                self.selectedIndex = indexPath.row
                self.tbl_vw.reloadData()
                loadEmbeddedViewController(for: selectedIndex)
            }
        }
    }

}



extension HomeVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txt_4 {
            textField.resignFirstResponder()
            textField.endEditing(true)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            if let previousTextField = view.viewWithTag(textField.tag - 1) as? UITextField {
                previousTextField.becomeFirstResponder()
            }
            textField.text = string
            return false
        }
        
        // Allow only one character per text field
        if let text = textField.text, text.count >= 1 {
            if let nextTextField = view.viewWithTag(textField.tag + 1) as? UITextField {
                nextTextField.becomeFirstResponder()
                nextTextField.text = string
                if (nextTextField.tag == 6) {
                    nextTextField.endEditing(true)
                }
            }
            return false
        }
        
        return true
    }
    
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
