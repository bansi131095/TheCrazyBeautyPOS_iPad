//
//  AddServiceVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 03/07/25.
//

import UIKit

class AddServiceVC: UIViewController {
    
    @IBOutlet weak var txt_serviceName: TextInputLayout!
    @IBOutlet weak var txt_mainCategory: TextInputLayout!
    @IBOutlet weak var txt_serviceFor: TextInputLayout!
    @IBOutlet weak var txt_description: FloatingTextView!
    @IBOutlet weak var txt_serviceDuration: TextInputLayout!
    @IBOutlet weak var txt_regulatPrice: TextInputLayout!
    @IBOutlet weak var txt_salesPrice: TextInputLayout!
    @IBOutlet weak var btn_vendorOnly: UIButton!
    @IBOutlet weak var btn_needToContact: UIButton!
    @IBOutlet weak var btn_patchTest: UIButton!
    @IBOutlet weak var staffTextField: TextInputLayout!
    @IBOutlet weak var tagHolderView: UIView!
    
    var isEdit = false
    var durationList:[DurationItem] = []
    var categoryList: [ServiceDatas] = []
    var staffList: [StaffData] = []
    var selectedStaffList: [StaffData] = []
    let durationTableView = UITableView()
    var isDurationVisible = false
    let categoryTableView = UITableView()
    var isCategoryVisible = false
    let serviceForTableView = UITableView()
    var isServiceForVisible = false
    
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDuationData()
        self.loadCategoryData()
        self.loadData()
        let options: [String] = ["Male", "Female", "Unisex"]
        DropdownManager.shared.setupDropdown(for: self.txt_serviceFor, in: self.view, with: options)
        staffTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openStaffPopup))
        staffTextField.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: Button Action
    @IBAction func act_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func act_cancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func act_addEditService(_ sender: GradientButton) {
        
    }
    
    @IBAction func act_vendorOnly(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "rdCheck") {
            sender.setImage(UIImage(named: "rdUncheck"), for: .normal)
        } else if sender.currentImage == UIImage(named: "rdUncheck") {
            sender.setImage(UIImage(named: "rdCheck"), for: .normal)
        }
    }
    
    @IBAction func act_needToContact(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "rdCheck") {
            sender.setImage(UIImage(named: "rdUncheck"), for: .normal)
        } else if sender.currentImage == UIImage(named: "rdUncheck") {
            sender.setImage(UIImage(named: "rdCheck"), for: .normal)
        }
    }
    
    @IBAction func act_patchTest(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "rdCheck") {
            sender.setImage(UIImage(named: "rdUncheck"), for: .normal)
        } else if sender.currentImage == UIImage(named: "rdUncheck") {
            sender.setImage(UIImage(named: "rdCheck"), for: .normal)
        }
    }


    @objc func openStaffPopup() {
        var selected:[Int] = []
        if !self.selectedStaffList.isEmpty {
            for staff in self.selectedStaffList {
                selected.append(staff.id ?? 0)
            }
        }
        let popup = PreferredStaffPopupViewController()
        popup.staffList = staffList
        popup.selectedStaff = selected
        popup.onComplete = { selected in
            print("Selected staff: \(selected)")
            self.selectedStaffList = []
            for staff in self.staffList {
                if selected.contains(staff.id ?? 0) {
                    self.selectedStaffList.append(staff)
                }
            }
            self.refreshTags()
        }
        self.present(popup, animated: true)
    }

    func refreshTags() {
        tagHolderView.subviews.forEach { $0.removeFromSuperview() }
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        let padding: CGFloat = 8
        let maxWidth = tagHolderView.frame.width
        
        for tag in selectedStaffList {
            let name = (tag.firstName ?? "") + " " + (tag.lastName ?? "")
            let tagView = TagView(text: name)
            tagView.onRemove = {
                if let index = self.selectedStaffList.firstIndex(where: { $0.id == tag.id }) {
                    self.selectedStaffList.remove(at: index)
                }
                self.refreshTags()
            }
            let size = tagView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            if x + size.width > maxWidth {
                x = 0
                y += size.height + padding
            }
            tagView.frame = CGRect(x: x, y: y, width: size.width, height: size.height)
            tagHolderView.addSubview(tagView)
            x += size.width + padding
        }
        
        // Adjust container height if needed
        let totalHeight = y + 40
        tagHolderView.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
    }
    
    
    //MARK: Load Api
    func loadDuationData() {
    
        APIService.shared.getDurationDetails() { staffResult in
            guard let model = staffResult else {
                return
            }
            let newItems = model.data
            if !newItems.isEmpty {
                self.durationList = newItems
                var options: [String] = []
                for dur in self.durationList {
                    options.append(dur.label)
                }
                DropdownManager.shared.setupDropdown(for: self.txt_serviceDuration, in: self.view, with: options)
            }
            
        }
    }
    
    func loadCategoryData() {
    
        APIService.shared.getselectMainCategory() { staffResult in
            guard let model = staffResult else {
                return
            }
            let newItems = model.data
            if !newItems.isEmpty {
                self.categoryList = newItems
                var options: [String] = []
                for cate in self.categoryList {
                    options.append(cate.service_name)
                }
                DropdownManager.shared.setupDropdown(for: self.txt_mainCategory, in: self.view, with: options)
            }
            
        }
    }
    
    func loadData() {
    
        APIService.shared.getteamDetails(page: "1", limit: "100000", vendorId: LocalData.userId, search: "") { staffResult in
            guard let model = staffResult else {
                return
            }

            let newItems = model.data ?? []
            self.staffList += newItems
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


extension AddServiceVC: UITextFieldDelegate {
    
    
    
}
