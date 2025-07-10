//
//  ServiceSequenceVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 10/07/25.
//

import UIKit

class ServiceSequenceVC: UIViewController {

    @IBOutlet weak var scroll_vw: UIScrollView!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var txt_category: TextInputLayout!
    @IBOutlet weak var tbl_vw: UITableView!
    
    var serviceList: [ServiceData] = []
    var categoryList: [String] = []
    var selectedCategory: String = "Select Category"

    
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        contentViewWidthConstraint.constant = 400 // or any dynamic value
        self.setTableView()
        self.loadCategoryData()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: Button Action
    @IBAction func act_cancel(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func act_saveSequence(_ sender: GradientButton) {
        self.updateServiceSequence()
    }
    
    
    //MARK: Setup Views
    func setTableView(){
        tbl_vw.register(UINib(nibName: "ServiceSeqCell", bundle: nil), forCellReuseIdentifier: "ServiceSeqCell")
        tbl_vw.register(UINib(nibName: "ServiceSeqHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "ServiceSeqHeaderCell")
        tbl_vw.delegate = self
        tbl_vw.dataSource = self
        tbl_vw.dragDelegate = self
        tbl_vw.dropDelegate = self
        tbl_vw.dragInteractionEnabled = true
        tbl_vw.rowHeight = UITableView.automaticDimension
        tbl_vw.estimatedRowHeight = 60
    }
    
    
    //MARK: Load Api
    func loadData() {
//        self.showLoader()
        APIService.shared.getServiceDetails(page: "1", limit: "10000", vendorId: LocalData.userId, search: "", booking: "", categoryId: self.selectedCategory, isGroup: false) { staffResult in
            guard let model = staffResult else {
                return
            }
            self.hideLoader()
            let newItems = model.data
            self.serviceList += newItems
            self.tbl_vw.reloadData()
        }
    }
    
    func loadCategoryData() {
    
        self.showLoader()
        APIService.shared.getselectMainCategory() { staffResult in
            guard let model = staffResult else {
                return
            }
            self.hideLoader()
            let newItems = model.data
            if !newItems.isEmpty {
                let CategoryList = newItems
                for cate in CategoryList {
                    self.categoryList.append(cate.service_name)
                }
                self.selectedCategory = self.categoryList.first ?? ""
                self.txt_category.setText(self.selectedCategory)
                self.loadData()
                DropdownManager.shared.setupDropdown(
                    for: self.txt_category,
                    in: self.view,
                    with: self.categoryList
                ) { [weak self] selected in
                    guard let self = self else { return }
                    self.showLoader()
                    self.selectedCategory = selected
                    self.txt_category.setText(selected)
                    self.serviceList = []
                    self.tbl_vw.reloadData()
                    self.loadData()
                }
            }
        }
    }
    
    func updateServiceSequence() {
        var servicesMap: [[String: Any]] = []

        for (index, service) in serviceList.enumerated() {
            let item: [String: Any] = [
                "service_id": service.id,
                "order": index + 1
            ]
            servicesMap.append(item)
        }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: servicesMap, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Service Sequence Data Update: \(jsonString)")
                APIService.shared.updateServiceSequence(serviceSequence: jsonString) { result in
                    guard let model = result else {
                        return
                    }
                    self.hideLoader()
                    if model.error == "" || model.error == nil {
                        self.showToast(message: model.data)
                
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.dismiss(animated: true)
                        }
                    } else {
                        self.show_alert(msg: model.error ?? "", title: "Update Staff Sequence")
                    }
                }
            }
        } catch {
            print("❌ JSON Encoding Error: \(error.localizedDescription)")
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

extension ServiceSequenceVC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UITableViewDragDelegate, UITableViewDropDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.serviceList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ServiceSeqHeaderCell") as? ServiceSeqHeaderCell else {
                return nil
            }

            // Customize your header view
            return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbl_vw.dequeueReusableCell(withIdentifier: "ServiceSeqCell", for: indexPath) as? ServiceSeqCell else {
            return UITableViewCell()
        }
        let service = self.serviceList[indexPath.item]
        cell.lbl_no.text = "\(indexPath.item + 1)"
        cell.lbl_service.text = service.service
        cell.lbl_time.text = "\(service.duration) Min"
        cell.lbl_serviceFor.text = service.service_for
        cell.lbl_price.text = "\(LocalData.symbol)\(service.price)"
        
        return cell
    }

    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = self.serviceList[indexPath.row]
        let itemProvider = NSItemProvider(object: item.service as NSString) // ✅ safe
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }

        coordinator.items.forEach { dropItem in
            if let sourceIndexPath = dropItem.sourceIndexPath,
               let service = dropItem.dragItem.localObject as? ServiceData {
                tableView.performBatchUpdates {
                    let movedItem = serviceList.remove(at: sourceIndexPath.row)
                    serviceList.insert(movedItem, at: destinationIndexPath.row)
                    tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
                }
                coordinator.drop(dropItem.dragItem, toRowAt: destinationIndexPath)
            }
        }
    }

    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.localDragSession != nil // only allow internal drag/drop
    }


    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if tableView.hasActiveDrag {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        } else {
            return UITableViewDropProposal(operation: .forbidden)
        }
    }

    
    
}
