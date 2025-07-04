//
//  ServicesVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 12/06/25.
//

import UIKit

class ServicesVC: UIViewController {
    
    @IBOutlet weak var scroll_vw: UIScrollView!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var txt_search: UITextField!
    @IBOutlet weak var lbl_totalClient: UILabel!
    
    var serviceList: [ServiceData] = []
    var searchWorkItem: DispatchWorkItem?
    var currentPage = 1
    var totalCount = 0
    var isLoadingMore = false
    var hasMoreData = true

    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        contentViewWidthConstraint.constant = 700 // or any dynamic value
        self.setTableView()
        self.txt_search.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadData(Search: "")
    }
    
    
    //MARK: Setup Views
    func setTableView(){
        tbl_vw.register(UINib(nibName: "ServiceItemCell", bundle: nil), forCellReuseIdentifier: "ServiceItemCell")
        tbl_vw.register(UINib(nibName: "ServiceHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "ServiceHeaderCell")
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
            self.serviceList.removeAll()
            self.hasMoreData = true
        }

        APIService.shared.getServiceDetails(page: "\(currentPage)", limit: "15", vendorId: LocalData.userId, search: Search, booking: "", categoryId: "", isGroup: true) { staffResult in
            guard let model = staffResult else {
                self.isLoadingMore = false
                return
            }

            let newItems = model.data
            self.totalCount = model.total // Make sure this field exists in your response model
            self.lbl_totalClient.text = "\(self.totalCount) Services"
            if newItems.isEmpty || self.serviceList.count + newItems.count >= self.totalCount {
                self.hasMoreData = false
            }

            self.serviceList += newItems
            self.currentPage += 1
            self.isLoadingMore = false
            self.tbl_vw.reloadData()
        }
    }
    
    
    //MARK: Button Action
    @IBAction func act_addNew(_ sender: UIButton) {
        let addNew = self.storyboard?.instantiateViewController(withIdentifier: "AddServiceVC") as! AddServiceVC
        addNew.isEdit = false
        self.navigationController?.pushViewController(addNew, animated: true)
    }
    
    @IBAction func act_serviceSequence(_ sender: UIButton) {
        
    }
    
    
    //MARK: Delete API
    func deleteServiceData(serviceId: Int) {
        APIService.shared.deleteServiceData(serviceId: serviceId) { staffResult in
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
                self.show_alert(msg: model.error ?? "", title: "Delete Service")
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

extension ServicesVC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.serviceList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ServiceHeaderCell") as? ServiceHeaderCell else {
                return nil
            }

            // Customize your header view
            return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbl_vw.dequeueReusableCell(withIdentifier: "ServiceItemCell", for: indexPath) as? ServiceItemCell else {
            return UITableViewCell()
        }
        let service = self.serviceList[indexPath.item]
        cell.lbl_no.text = "\(indexPath.item + 1)"
        cell.lbl_category.text = service.category
        cell.lbl_service.text = service.service
        cell.lbl_time.text = "\(service.duration) Min"
        cell.lbl_serviceFor.text = service.service_for
        cell.lbl_price.text = "\(LocalData.symbol)\(service.price)"
        cell.Act_Edit = {
            let addNew = self.storyboard?.instantiateViewController(withIdentifier: "AddServiceVC") as! AddServiceVC
            addNew.isEdit = true
            addNew.dictService = service
            self.navigationController?.pushViewController(addNew, animated: true)
        }
        cell.Act_Delete = {
            let popup = ConfirmDeletePopupVC()
            popup.modalPresentationStyle = .overFullScreen
            popup.modalTransitionStyle = .crossDissolve
            popup.titleText = "Are you sure you want to delete this service?"
            popup.onConfirm = {
                print("User confirmed delete")
                // Call your delete logic here
                self.deleteServiceData(serviceId: service.id)
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
