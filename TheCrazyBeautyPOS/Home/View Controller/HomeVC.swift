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
    
//    MARK: - Popup
    @IBOutlet weak var vwPopup: UIView!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_Version: UILabel!
    
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
    
    @IBAction func btn_Profile(_ sender: Any) {
        vwPopup.isHidden = false
    }
    
    @IBAction func btn_MyProfile(_ sender: Any) {
        let sb = UIStoryboard(name: "Profile", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btn_Logout(_ sender: Any) {
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
