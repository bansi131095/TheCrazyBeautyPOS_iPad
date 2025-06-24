//
//  ProfileVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 23/06/25.
//

struct SectionModel {
    let title: String
    let items: [String]
    var isExpanded: Bool = false
}

import UIKit

class ProfileVC: UIViewController,SettingCellDelegate {
    
    

    //MARK: - Outlets
    @IBOutlet weak var tbl_Categories_List: UITableView!
    @IBOutlet weak var containerView: UIView!
    
    //MARK: - Global Variable
    let arr_ImageList = ["ic_Store","ic_Notification","ic_Booking","ic_Team","ic_Schedule","ic_Payment","ic_Team","ic_Privacy"]
    let arr_ListName = ["Salon Details","Notifications","Booking","Team","Schedule","Payment","Kiosk & Customers","Privacy & Security"]
    
    var arrSelectIndex: [Int] = []
    var selectedIndex: Int? = nil
    var sections: [SectionModel] = []
    
    //MARK: - View Lify Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setUpTableView()
        loadEmbeddedViewController(for: 0)
    }
    
    //MARK: - Button Action
    @IBAction func btn_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_AddSalon(_ sender: Any) {
    }
    
    
    //MARK: - Function
    func setUpTableView() {
        let nib = UINib(nibName: "SettingCell", bundle: nil)
        self.tbl_Categories_List.register(nib, forCellReuseIdentifier: "SettingCell")
        
        self.tbl_Categories_List.delegate = self
        self.tbl_Categories_List.dataSource = self
        
    }
    
    func setupData() {
            sections = [
                SectionModel(title: "Salon Details", items: ["General Information", "Salon Images", "Categories", "Categories Description"]),
                SectionModel(title: "Notifications", items: ["Notifications", "Booking Reminder"]),
                SectionModel(title: "Booking", items: ["Slot Duration", "Booking Preference", "Booking Policy"]),
                SectionModel(title: "Team", items: ["Team Login", "Team Sequence"]),
                SectionModel(title: "Schedule", items: ["Opening Date", "Business Hours", "Salon Off Days/Hours", "Salon Holiday"]),
                SectionModel(title: "Payment", items: ["Bank Details", "Set Advance Payment & Cancellation Duration", "Curreny"]),
                SectionModel(title: "Kiosk & Customers", items: ["Kiosk Users", "Block Customers"]),
                SectionModel(title: "Privacy & Security", items: ["Change Password"])
            ]
        }
    
    
    func loadEmbeddedViewController(for index: Int) {
            // Optionally switch based on index if you have multiple VCs
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        var selectedVC: UIViewController?

        switch index {
        case 0:
            selectedVC = storyboard.instantiateViewController(withIdentifier: "ChangePasswordVC") as? ChangePasswordVC
        case 1:
            selectedVC = storyboard.instantiateViewController(withIdentifier: "KioskUsersVC") as? KioskUsersVC
        case 2:
            selectedVC = storyboard.instantiateViewController(withIdentifier: "WalkingVC") as? WalkingVC
        case 3:
            selectedVC = storyboard.instantiateViewController(withIdentifier: "ServicesVC") as? ServicesVC
        case 4:
            selectedVC = storyboard.instantiateViewController(withIdentifier: "TeamVC") as? TeamVC
        case 5:
            selectedVC = storyboard.instantiateViewController(withIdentifier: "ClientsVC") as? ClientsVC
        case 6:
            selectedVC = storyboard.instantiateViewController(withIdentifier: "KioskUsersVC") as? KioskUsersVC
        case 7:
            selectedVC = storyboard.instantiateViewController(withIdentifier: "ChangePasswordVC") as? KioskUsersVC
        case 8:
            selectedVC = storyboard.instantiateViewController(withIdentifier: "ChangePasswordVC") as? ChangePasswordVC
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
    
    func didSelectInnerItem(sectionIndex: Int, rowIndex: Int, title: String) {
        print("Selected sub-item \(title) at Section \(sectionIndex), Row \(rowIndex)")
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        var vc: UIViewController?
        
    if sectionIndex == 0 {
            // Salon Details
            switch rowIndex {
            case 0:
                vc = storyboard.instantiateViewController(withIdentifier: "GeneralInfoVC")
            case 1:
                vc = storyboard.instantiateViewController(withIdentifier: "SalonImagesVC")
            case 2:
                vc = storyboard.instantiateViewController(withIdentifier: "CategoriesVC")
            case 3:
                vc = storyboard.instantiateViewController(withIdentifier: "CategoriesDescVC")
            default: break
            }
        } else if sectionIndex == 1 {
            // Notifications
            switch rowIndex {
            case 0:
                vc = storyboard.instantiateViewController(withIdentifier: "NotificationVC")
            case 1:
                vc = storyboard.instantiateViewController(withIdentifier: "BookingReminderVC")
            default: break
            }
        } else if sectionIndex == 2 {
            // Booking
            switch rowIndex {
            case 0:
                vc = storyboard.instantiateViewController(withIdentifier: "SlotDurationVC")
            case 1:
                vc = storyboard.instantiateViewController(withIdentifier: "BookingPreferenceVC")
            case 2:
                vc = storyboard.instantiateViewController(withIdentifier: "BookingPolicyVC")
            default: break
            }
        } else if sectionIndex == 3 {
            // Team
            switch rowIndex {
            case 0:
                vc = storyboard.instantiateViewController(withIdentifier: "Team_LoginVC")
            case 1:
                vc = storyboard.instantiateViewController(withIdentifier: "TeamSequenceVC")
            default: break
            }
        } else if sectionIndex == 4 {
            // Schedule
            switch rowIndex {
            case 0:
                vc = storyboard.instantiateViewController(withIdentifier: "OpeningDateVC")
            case 1:
                vc = storyboard.instantiateViewController(withIdentifier: "BusinessHoursVC")
            case 2:
                vc = storyboard.instantiateViewController(withIdentifier: "SalonOffDaysVC")
            case 3:
                vc = storyboard.instantiateViewController(withIdentifier: "SalonHolidayVC")
            default: break
            }
        } else if sectionIndex == 5 {
            // Payment
            switch rowIndex {
            case 0:
                vc = storyboard.instantiateViewController(withIdentifier: "AddBankVC")
            case 1:
                vc = storyboard.instantiateViewController(withIdentifier: "Payment_CancellationVC")
            case 2:
                vc = storyboard.instantiateViewController(withIdentifier: "CurrencyVC")
            default: break
            }
        } else if sectionIndex == 6 {
            // Kiosk & Customers
            switch rowIndex {
            case 0:
                vc = storyboard.instantiateViewController(withIdentifier: "KioskUsersVC")
            case 1:
                vc = storyboard.instantiateViewController(withIdentifier: "BlockCustomersVC")
            default: break
            }
        } else if sectionIndex == 7 {
            // Privacy & Security
            if rowIndex == 0 {
                vc = storyboard.instantiateViewController(withIdentifier: "ChangePasswordVC")
            }
        }
        
        if let selectedVC = vc {
            // If you want to embed:
            for child in children {
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                child.removeFromParent()
            }

            addChild(selectedVC)
            selectedVC.view.frame = containerView.bounds
            containerView.addSubview(selectedVC.view)
            selectedVC.didMove(toParent: self)
        }
        
//        loadEmbeddedViewController(for: sectionIndex)
    }

}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl_Categories_List.dequeueReusableCell(withIdentifier: "SettingCell") as! SettingCell
        let section = sections[indexPath.row]

        cell.lbl_Title.text = section.title
        cell.img_List.image = UIImage(named: arr_ImageList[indexPath.row])
        cell.data = section.items
        cell.tbl_Categories_Height.constant = cell.tbl_Categories.contentSize.height
        
        let isExpanded = selectedIndex == indexPath.row

        if isExpanded {
            cell.img_List.tintColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
            cell.lbl_Title.textColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
            cell.img_Arrow.image = UIImage(named: "ic_Up")
            cell.tbl_Categories.isHidden = false
            cell.tbl_Categories_Height.constant = cell.tbl_Categories.contentSize.height
        } else {
            cell.img_List.tintColor = .black
            cell.lbl_Title.textColor = .black
            cell.img_Arrow.image = UIImage(named: "ic_Down")
            cell.tbl_Categories.isHidden = true
            cell.tbl_Categories_Height.constant = 0
        }
        cell.sectionIndex = indexPath.row
        cell.delegate = self
        cell.setTableView()
        cell.tbl_Categories.reloadData()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndex == indexPath.row{
            selectedIndex = nil
        }else{
            selectedIndex = indexPath.row
        }
        self.tbl_Categories_List.reloadData()
    }
}
