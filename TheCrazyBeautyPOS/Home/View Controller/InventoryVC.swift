//
//  InventoryVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 12/06/25.
//

import UIKit

class InventoryVC: UIViewController {
    
    
    @IBOutlet weak var lbl_InventoryTitle: UILabel!
    @IBOutlet weak var scroll_vw: UIScrollView!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var txt_search: UITextField!
    @IBOutlet weak var lbl_totalClient: UILabel!
    
    @IBOutlet weak var btn_AddNew: GradientButton!
    
    var inventoryList: [InventoryData] = []
    var searchWorkItem: DispatchWorkItem?
    var currentPage = 1
    var totalCount = 0
    var isLoadingMore = false
    var hasMoreData = true
    
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_InventoryTitle.text = NSLocalizedString("Inventory", comment: "")
        contentViewWidthConstraint.constant = 0 // or any dynamic value
        self.setTableView()
        setCustomFont()
        self.txt_search.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        let AddNew = NSAttributedString(
            string: NSLocalizedString("Add New",comment: ""),
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 18.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        btn_AddNew.setAttributedTitle(AddNew, for: .normal)
//        self.loadData(Search: "")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadData(Search: "")
    }
    
    
    //MARK: Setup Views
    func setTableView(){
        tbl_vw.register(UINib(nibName: "InventoryCell", bundle: nil), forCellReuseIdentifier: "InventoryCell")
        tbl_vw.register(UINib(nibName: "InventoryHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "InventoryHeaderCell")
        tbl_vw.delegate = self
        tbl_vw.dataSource = self
        tbl_vw.rowHeight = UITableView.automaticDimension
        tbl_vw.estimatedRowHeight = 60
    }
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Bold", size: 22.0) {
            lbl_InventoryTitle.font = customFont
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        /*searchWorkItem?.cancel()

        let newWorkItem = DispatchWorkItem { [weak self] in
            self?.loadData(Search: textField.text ?? "")
        }

        searchWorkItem = newWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: newWorkItem)*/
        self.loadData(Search: textField.text ?? "")
    }
    
    
    //MARK: Load Api
    func loadData(Search: String, isPagination: Bool = false) {
        if isPagination {
            self.isLoadingMore = true
        } else {
            self.currentPage = 1
            self.inventoryList.removeAll()
            self.hasMoreData = true
//            showLoader()
        }

        APIService.shared.getInventoryDetails(page: "\(currentPage)", limit: "15", vendorId: LocalData.userId, search: Search) { staffResult in
            self.hideLoader()
            guard let model = staffResult else {
                self.isLoadingMore = false
                return
            }

            let newItems = model.data
            self.totalCount = model.total // Make sure this field exists in your response model
            self.lbl_totalClient.text = "\(self.totalCount) " + NSLocalizedString("Inventories", comment: "")
            if newItems.isEmpty || self.inventoryList.count + newItems.count >= self.totalCount {
                self.hasMoreData = false
            }

            self.inventoryList += newItems
            self.currentPage += 1
            self.isLoadingMore = false
            self.tbl_vw.backgroundView = self.inventoryList.isEmpty ? self.getNoDataLabel() : nil
            self.tbl_vw.reloadData()
        }
    }
    
    func getNoDataLabel() -> UILabel {
        let noDataLabel = UILabel()
        noDataLabel.text = NSLocalizedString("No Inventory Data Found", comment: "")
        noDataLabel.textAlignment = .center
        noDataLabel.textColor = .gray
        noDataLabel.font = UIFont(name: "Lato-Bold", size: 20.0)
        return noDataLabel
    }
    
    //MARK: Button Action
    @IBAction func act_addNew(_ sender: UIButton) {
        let addNew = self.storyboard?.instantiateViewController(withIdentifier: "AddInventory_VC") as! AddInventory_VC
        self.navigationController?.pushViewController(addNew, animated: true)
    }
    
    func deleteInventory(InventoryId: Int) {
        APIService.shared.deleteInventory(Id: InventoryId) { result in
            guard let model = result else {
                return
            }
            self.hideLoader()
            if model.error == "" || model.error == nil {
                DispatchQueue.main.async {
                    self.alertWithMessageOnly(NSLocalizedString("Inventory deleted successfully",comment: ""))
                }
                self.loadData(Search: "")
            } else {
                self.alertWithMessageOnly(NSLocalizedString("Failed to delete inventory",comment: ""))
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

extension InventoryVC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.inventoryList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "InventoryHeaderCell") as? InventoryHeaderCell else {
                return nil
            }

            // Customize your header view
            return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbl_vw.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as? InventoryCell else {
            return UITableViewCell()
        }
        let inventory = self.inventoryList[indexPath.item]
        cell.lbl_no.text = "\(indexPath.item + 1)"
        cell.lbl_productName.text = inventory.product_name
        cell.lbl_price.text = "\(LocalData.symbol)\(inventory.price)"
        cell.lbl_qty.text = "\(inventory.qty)"
        cell.Act_Edit = {
            let addNew = self.storyboard?.instantiateViewController(withIdentifier: "AddInventory_VC") as! AddInventory_VC
            addNew.isEdit = true
            addNew.InventoryService = inventory
            self.navigationController?.pushViewController(addNew, animated: true)
        }
        cell.Act_Delete = {
            let popup = ConfirmDeletePopupVC()
            popup.modalPresentationStyle = .overFullScreen
            popup.modalTransitionStyle = .crossDissolve
            popup.titleText = NSLocalizedString("Are you sure you want to delete this Inventory?", comment: "")
            popup.onConfirm = {
                self.deleteInventory(InventoryId: inventory.id)
            }
            self.present(popup, animated: true, completion: nil)
        }
        return cell
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if offsetY > contentHeight - frameHeight - 400 {
            if !isLoadingMore && hasMoreData {
                self.loadData(Search: txt_search.text ?? "", isPagination: true)
            }
        }
    }

    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if isLoadingMore {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            return spinner
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return isLoadingMore ? 50 : 0
    }
    
}
