//
//  OfflineGiftCardVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 26/06/25.
//

import UIKit
import DropDown

class OfflineGiftCardVC: UIViewController {
    
    @IBOutlet weak var lbl_TitleOfflineGiftCard: UILabel!
    @IBOutlet weak var scroll_vw: UIScrollView!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var txt_search: UITextField!
    @IBOutlet weak var lbl_totalClient: UILabel!
    
    @IBOutlet weak var txt_Filter: UITextField!
    @IBOutlet weak var btn_AddNew: GradientButton!
    
    
//    var arr_Filter = ["Active","Expired","Used"]
    var arr_Filter: [String] {
        return [
            NSLocalizedString("Active", comment: ""),
            NSLocalizedString("Expired", comment: ""),
            NSLocalizedString("Used", comment: "")
        ]
    }
    
    
    let filterApiMap: [String: String] = [
        NSLocalizedString("Active", comment: "")  : "active",
        NSLocalizedString("Expired", comment: "") : "expired",
        NSLocalizedString("Used", comment: "")    : "used"
    ]

    var OfflineGiftCardList: [OfflineGiftCardData] = []
    var searchWorkItem: DispatchWorkItem?
    var currentPage = 1
    var totalCount = 0
    var isLoadingMore = false
    var hasMoreData = true
    
    let dropDown = DropDown()
    
    //MARK:  View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_TitleOfflineGiftCard.text = NSLocalizedString("Offline Gift Card", comment: "")
        contentViewWidthConstraint.constant = 10
        txt_Filter.text = arr_Filter.first
        setTableView()
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
//        self.loadData(Search: "", filter: self.txt_Filter.text?.lowercased() ?? "active")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let apiFilter = filterApiMap[txt_Filter.text ?? ""] ?? "active"
        self.loadData(Search: "", filter: apiFilter)
    }
    
    @IBAction func btn_AddNew(_ sender: Any) {
        let addNew = self.storyboard?.instantiateViewController(withIdentifier: "AddOfflineGiftCard_VC") as! AddOfflineGiftCard_VC
        self.navigationController?.pushViewController(addNew, animated: true)
    }
    
    @IBAction func btn_Filter(_ sender: Any) {
        openFilter()
    }
    
    func openFilter() {
        let Filter = DropDown()
        Filter.anchorView = txt_Filter
        Filter.bottomOffset = CGPoint(x: 0, y:(Filter.anchorView?.plainView.bounds.height)!)
        Filter.direction = .bottom
        Filter.dataSource = arr_Filter
        Filter.cellHeight = 35
        Filter.textFont = UIFont(name: "Lato-Regular", size: 18.0)!
        Filter.backgroundColor = .white
        Filter.show()
        
        Filter.selectionAction = {  [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.txt_Filter.text = item
            let apiFilter = self.filterApiMap[item] ?? "active"
            
            self.loadData(Search: "", filter: apiFilter)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        /*searchWorkItem?.cancel()

        let newWorkItem = DispatchWorkItem { [weak self] in
            self?.loadData(Search: textField.text ?? "", filter: self?.txt_Filter.text?.lowercased() ?? "")
        }

        searchWorkItem = newWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: newWorkItem)*/
        let apiFilter = filterApiMap[txt_Filter.text ?? ""] ?? "active"
        self.loadData(Search: textField.text ?? "", filter: apiFilter)
    }
    
    
    //MARK: Load Api
    func loadData(Search: String, isPagination: Bool = false,filter:String) {
        if isPagination {
            self.isLoadingMore = true
        } else {
            self.currentPage = 1
            self.OfflineGiftCardList.removeAll()
            self.hasMoreData = true
//            showLoader()
        }

        APIService.shared.getOfflineGiftCardDetails(page: "\(currentPage)", limit: "10", vendorId: LocalData.userId, search: Search, filter: filter){ staffResult in
            self.hideLoader()
            guard let model = staffResult else {
                self.isLoadingMore = false
                return
            }
            
            let newItems = model.data
            self.totalCount = model.total // Make sure this field exists in your response model
            self.lbl_totalClient.text = "\(self.totalCount) "  +  NSLocalizedString("Cards", comment: "")
            if newItems.isEmpty || self.OfflineGiftCardList.count + newItems.count >= self.totalCount {
                self.hasMoreData = false
            }
            
            self.OfflineGiftCardList += newItems
            self.currentPage += 1
            self.isLoadingMore = false
            self.tbl_vw.backgroundView = self.OfflineGiftCardList.isEmpty ? self.getNoDataLabel() : nil
            self.tbl_vw.reloadData()
        }
    }
    
    func getNoDataLabel() -> UILabel {
        let noDataLabel = UILabel()
        noDataLabel.text = NSLocalizedString("No Offline Gift Cards Found", comment: "")
        noDataLabel.textAlignment = .center
        noDataLabel.textColor = .gray
        noDataLabel.font = UIFont(name: "Lato-Bold", size: 20.0)
        return noDataLabel
    }

    func setTableView(){
        tbl_vw.register(UINib(nibName: "OfflineGiftCardCell", bundle: nil), forCellReuseIdentifier: "OfflineGiftCardCell")
        tbl_vw.register(UINib(nibName: "OfflineGiftCardHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "OfflineGiftCardHeaderCell")
        tbl_vw.delegate = self
        tbl_vw.dataSource = self
        tbl_vw.rowHeight = UITableView.automaticDimension
        tbl_vw.estimatedRowHeight = 60
    }

    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Regular", size: 20.0) {
            txt_Filter.font = customFont
        }
        if let customFont = UIFont(name: "Lato-Bold", size: 20.0) {
            lbl_TitleOfflineGiftCard.font = customFont
        }
    }
    
}


extension OfflineGiftCardVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "OfflineGiftCardHeaderCell") as? OfflineGiftCardHeaderCell else {
                return nil
            }

            // Customize your header view
            return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OfflineGiftCardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbl_vw.dequeueReusableCell(withIdentifier: "OfflineGiftCardCell", for: indexPath) as? OfflineGiftCardCell else {
            return UITableViewCell()
        }
        let data = self.OfflineGiftCardList[indexPath.item]
        cell.lbl_Id.text = "\(indexPath.row+1)"
        cell.lbl_Name.text = data.gift_name.capitalized
        cell.lbl_Price.text = "\(SharedPrefs.getSymbol())" +  String(data.amount)
        cell.lbl_ExpiryDate.text = data.expiry_date
        cell.lbl_GiftCode.text = data.gift_code
        cell.lbl_Message.text = data.message.capitalized
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if offsetY > contentHeight - frameHeight - 400 {
            if !isLoadingMore && hasMoreData {
                let apiFilter = filterApiMap[txt_Filter.text ?? ""] ?? "active"
                self.loadData(Search: txt_search.text ?? "", isPagination: true, filter: apiFilter)
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
