//
//  ClientsVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 12/06/25.
//

import UIKit

class ClientsVC: UIViewController {

    @IBOutlet weak var scroll_vw: UIScrollView!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var txt_search: UITextField!
    @IBOutlet weak var lbl_totalClient: UILabel!
    
    var clientList: [CustomerData] = []
    var searchWorkItem: DispatchWorkItem?
    var currentPage = 1
    var totalCount = 0
    var isLoadingMore = false
    var hasMoreData = true
    
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        contentViewWidthConstraint.constant = 100 // or any dynamic value
        self.setTableView()
        self.txt_search.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
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
    

    @objc func textFieldDidChange(_ textField: UITextField) {
        searchWorkItem?.cancel()

        let newWorkItem = DispatchWorkItem { [weak self] in
            self?.loadData(Search: textField.text ?? "")
        }

        searchWorkItem = newWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: newWorkItem)
    }
    
    //MARK: Load Api
    func loadData(Search: String, isPagination: Bool = false) {
        if isPagination {
            self.isLoadingMore = true
        } else {
            self.currentPage = 1
            self.clientList.removeAll()
            self.hasMoreData = true
        }

        APIService.shared.getclientDetails(page: "\(currentPage)", limit: "10", vendorId: LocalData.userId, search: Search) { staffResult in
            guard let model = staffResult else {
                self.isLoadingMore = false
                return
            }

            let newItems = model.data
            self.totalCount = model.total // Make sure this field exists in your response model
            self.lbl_totalClient.text = "\(self.totalCount) Clients"
            if newItems.isEmpty || self.clientList.count + newItems.count >= self.totalCount {
                self.hasMoreData = false
            }

            self.clientList += newItems
            self.currentPage += 1
            self.isLoadingMore = false
            self.tbl_vw.reloadData()
        }
    }

    
    //MARK: Button Action
    @IBAction func act_addNew(_ sender: UIButton) {
        let addNew = self.storyboard?.instantiateViewController(withIdentifier: "AddClientVC") as! AddClientVC
        addNew.isEdit = false
        self.navigationController?.pushViewController(addNew, animated: true)
    }
    
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ClientsVC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
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
        cell.lbl_gender.text = client.gender
        cell.lbl_clientType.text = client.client_type
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
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if offsetY > contentHeight - frameHeight - 100 {
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
