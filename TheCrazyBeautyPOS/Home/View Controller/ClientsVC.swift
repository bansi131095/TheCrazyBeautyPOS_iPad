//
//  ClientsVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 12/06/25.
//

import UIKit

class ClientsVC: UIViewController {

    @IBOutlet weak var lbl_Title_Client: UILabel!
    @IBOutlet weak var scroll_vw: UIScrollView!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var tbl_Height: NSLayoutConstraint!
    @IBOutlet weak var txt_search: UITextField!
    @IBOutlet weak var lbl_totalClient: UILabel!
    
    @IBOutlet weak var btn_AddNew: GradientButton!
    
    
    var clientList: [CustomerData] = []
    var searchWorkItem: DispatchWorkItem?
    var currentPage = 1
    var totalCount = 0
    var isLoadingMore = false
    var hasMoreData = true
    var is_Block = String()
    var is_Guest = String()
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        contentViewWidthConstraint.constant = 250 // or any dynamic value
        self.setTableView()
        self.setCustomFont()
        self.txt_search.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        lbl_Title_Client.text = NSLocalizedString("Clients", comment: "")
        let attributedTitleSync_1 = NSAttributedString(
            string: NSLocalizedString("Add New",comment: ""),
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 20.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        btn_AddNew.setAttributedTitle(attributedTitleSync_1, for: .normal)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadData(Search: "")
    }
    
    
    //MARK: Table view
    func setTableView(){
        tbl_vw.register(UINib(nibName: "ClientCell", bundle: nil), forCellReuseIdentifier: "ClientCell")
        tbl_vw.register(UINib(nibName: "ClientHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "ClientHeaderCell")
        tbl_vw.delegate = self
        tbl_vw.dataSource = self
        tbl_vw.rowHeight = UITableView.automaticDimension
        tbl_vw.estimatedRowHeight = 60
    }
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Bold", size: 22.0) {
            lbl_Title_Client.font = customFont
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
    func loadData(Search: String, isPagination: Bool = false,sort:String = "asc") {
        if isPagination {
            self.isLoadingMore = true
        } else {
            self.currentPage = 1
            self.clientList.removeAll()
            self.hasMoreData = true
//            showLoader()
        }

        APIService.shared.getclientDetails(page: "\(currentPage)", limit: "10", sort: sort, vendorId: LocalData.userId, search: Search) { staffResult in
            self.hideLoader()
            guard let model = staffResult else {
                self.isLoadingMore = false
                return
            }

            let newItems = model.data
            self.totalCount = model.total // Make sure this field exists in your response model
            self.lbl_totalClient.text = "\(self.totalCount) " + NSLocalizedString("Clients", comment: "")
            if newItems.isEmpty || self.clientList.count + newItems.count >= self.totalCount {
                self.hasMoreData = false
            }

            self.clientList += newItems
            self.currentPage += 1
            self.isLoadingMore = false
            self.tbl_vw.backgroundView = self.clientList.isEmpty ? self.getNoDataLabel() : nil
            self.tbl_vw.reloadData()
        }
    }

    func getNoDataLabel() -> UILabel {
        let noDataLabel = UILabel()
        noDataLabel.text = NSLocalizedString("No Clients Data Found", comment: "")
        noDataLabel.textAlignment = .center
        noDataLabel.textColor = .gray
        noDataLabel.font = UIFont(name: "Lato-Bold", size: 20.0)
        return noDataLabel
    }
    
    
    //MARK: Button Action
    @IBAction func btn_Export(_ sender: Any) {
        downloadClientReport()
    }
    
    @IBAction func act_addNew(_ sender: UIButton) {
        let addNew = self.storyboard?.instantiateViewController(withIdentifier: "AddClientVC") as! AddClientVC
        addNew.isEdit = false
        self.navigationController?.pushViewController(addNew, animated: true)
    }
    
    
    //MARK: Delete API
    func deleteClientData(clientId: Int) {
        APIService.shared.deleteClientData(clientId: clientId) { staffResult in
            guard let model = staffResult else {
                return
            }

            if model.error == "" || model.error == nil {
                DispatchQueue.main.async {
                    // safe UI code here
                    self.showToast(message: model.data)
                }
                self.loadData(Search: "")
            } else {
                self.show_alert(msg: model.error ?? "", title: "Delete Client")
            }
        }
    }

    func downloadClientReport() {
        showLoader()
        APIService.shared.downloadClientReport(vendor_id: LocalData.userId,search: self.txt_search.text ?? "") { model in
            self.hideLoader()
            guard let filename = model?.filename else {
                self.alertWithMessageOnly("Download failed")
                return
            }

            let urlPath = "\(global.reportUrl)\(filename)"
            self.downloadAndSaveFile(urlString: urlPath, in: self)
        }
    }
    
    func BlockNumber(id: String,is_block:String,is_guest:String) {
        APIService.shared.BlockNumber(id: id, is_block: is_block, is_guest: is_guest) { staffResult in
            guard let model = staffResult else {
                return
            }

            if model.error == "" || model.error == nil {
                DispatchQueue.main.async {
                    // safe UI code here
                    self.showToast(message: model.data)
                }
                self.loadData(Search: "")
            } else {
                self.show_alert(msg: model.error ?? "", title: "")
            }
        }
    }

}


extension ClientsVC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, ClientSortDelegate{
    func btnSort_Action(cell: ClientHeaderCell) {
        print("SORT ACTION")

        if cell.img_AtoZ.image == UIImage(named: "a TO z") {
            // Currently A → Z, change to Z → A
            print("Switch to Descending")
            cell.img_AtoZ.image = UIImage(named: "az-up")
            loadData(Search: "", sort: "desc")
        } else {
            // Currently Z → A, change to A → Z
            print("Switch to Ascending")
            cell.img_AtoZ.image = UIImage(named: "a TO z")
            loadData(Search: "", sort: "asc")
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.clientList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ClientHeaderCell") as? ClientHeaderCell else {
                return nil
            }
        header.delegate = self
            // Customize your header view
            return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbl_vw.dequeueReusableCell(withIdentifier: "ClientCell", for: indexPath) as? ClientCell else {
            return UITableViewCell()
        }
        let client = self.clientList[indexPath.item]
        cell.lbl_name.text = (client.first_name).capitalized + " " + (client.last_name).capitalized
        cell.lbl_email.text = client.email
        cell.lbl_phone.text = client.phone
        if client.gender != ""{
            cell.lbl_gender.text = client.gender.capitalized
        }else{
            cell.lbl_gender.text = "-"
        }
        
        if client.kind != ""{
            cell.lbl_userType.text = client.kind.capitalized
        }else{
            cell.lbl_userType.text = "-"
        }
        
        if client.is_block == 0{
            cell.btn_Block.setImage(UIImage(named: "ic_Block"), for: .normal)
        }else{
            cell.btn_Block.setImage(UIImage(named: "ic_UnBlock"), for: .normal)
        }
        if client.kind.capitalized == "Customer"{
            cell.btn_Edit.isHidden = false
            cell.btn_Icon.isHidden = false
            cell.btn_Delete.isHidden = false
            cell.btn_Calender.isHidden = false
            cell.lbl_Line.isHidden = true
            cell.lbl_Line.text = ""
        }else{
            cell.btn_Edit.isHidden = true
            cell.btn_Icon.isHidden = true
            cell.btn_Delete.isHidden = true
            cell.btn_Calender.isHidden = true
            cell.lbl_Line.isHidden = false
            cell.lbl_Line.text = ""
        }
        if client.client_type == ""{
            cell.lbl_clientType.text = "-"
        }else{
            cell.lbl_clientType.text = client.client_type
        }
        
        cell.Act_Edit = {
            let addNew = self.storyboard?.instantiateViewController(withIdentifier: "AddClientVC") as! AddClientVC
            addNew.isEdit = true
            addNew.dictClient = client
            self.navigationController?.pushViewController(addNew, animated: true)
        }
        cell.Act_Delete = {
            let popup = ConfirmDeletePopupVC()
            popup.modalPresentationStyle = .overFullScreen
            popup.modalTransitionStyle = .crossDissolve
            popup.titleText = "Are you sure you want to delete this client?"
            popup.onConfirm = {
                print("User confirmed delete")
                // Call your delete logic here
                self.deleteClientData(clientId: client.id)
            }
            self.present(popup, animated: true, completion: nil)
        }
        cell.Act_Block = {
            let popup = ConfirmDeletePopupVC()
            popup.modalPresentationStyle = .overFullScreen
            popup.modalTransitionStyle = .crossDissolve
            if client.is_block == 0 {
                popup.titleText = "Are you sure you want to Block this client?"
            }else{
                popup.titleText = "Are you sure you want to Unblock this client?"
            }
            popup.onConfirm = {
                print("id \(client.id)")
                if client.is_block == 0 {
                    self.is_Block = String(1)
                    if client.kind.capitalized == "Customer"{
                        self.is_Guest = String(0)
                    }else{
                        self.is_Guest = String(1)
                    }
                }else {
                    self.is_Block = String(0)
                    if client.kind.capitalized == "Customer"{
                        self.is_Guest = String(0)
                    }else{
                        self.is_Guest = String(1)
                    }
                }
                self.BlockNumber(id: String(client.id), is_block: self.is_Block, is_guest: self.is_Guest)
                print("is_Block:- \(self.is_Block)")
                print("is_Guest:- \(self.is_Guest)")
                print("User confirmed delete")
            }
            self.present(popup, animated: true, completion: nil)
        }
        cell.Act_info = {
            let addNew = self.storyboard?.instantiateViewController(withIdentifier: "PatchTestList_VC") as! PatchTestList_VC
            addNew.id = "\(client.id)"
            self.navigationController?.pushViewController(addNew, animated: true)
        }
        cell.Act_Calender = {
            let addNew = self.storyboard?.instantiateViewController(withIdentifier: "BookingList_VC") as! BookingList_VC
            addNew.bookingId = "\(client.id)"
            self.navigationController?.pushViewController(addNew, animated: true)
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if offsetY > contentHeight - frameHeight - 10 {
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

extension ClientsVC: UITextFieldDelegate {
    
    
    
}
