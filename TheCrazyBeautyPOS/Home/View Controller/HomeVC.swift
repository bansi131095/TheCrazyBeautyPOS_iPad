//
//  HomeVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 06/06/25.
//

import UIKit

class HomeVC: UIViewController {

    
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var txt_salon: UITextField!
    @IBOutlet weak var vw_pending: UIView!
    
    var salonList: [String] = []
    var selectedSalon: String = ""
    
    
    let imageArray: [UIImage] = [
        #imageLiteral(resourceName: "Dashboard.png"),
        #imageLiteral(resourceName: "Booking"),
        #imageLiteral(resourceName: "Walkin"),
        #imageLiteral(resourceName: "Services"),
        #imageLiteral(resourceName: "Team"),
        #imageLiteral(resourceName: "Clients"),
        #imageLiteral(resourceName: "Promotion"),
        #imageLiteral(resourceName: "Inventory"),
        #imageLiteral(resourceName: "Report"),
    ]
    
    var selectedIndex: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
        loadEmbeddedViewController(for: 1)
        self.getAllSalonData()
        let salonName = SharedPrefs.getSalonName()
        self.txt_salon.text = salonName
    
        // Do any additional setup after loading the view.
    }
    
    func setUpTableView() {
        let nib = UINib(nibName: "HomeMenuCell", bundle: nil)
        self.tbl_vw.register(nib, forCellReuseIdentifier: "HomeMenuCell")
        
        self.tbl_vw.delegate = self
        self.tbl_vw.dataSource = self
        self.tbl_vw.rowHeight = 100
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
    
    //MARK: Button Action
    @IBAction func act_notification(_ sender: UIButton) {
        
    }
    
    //MARK: Api Data
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
                    self.salonList.append(cate.salonName)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    }
}
