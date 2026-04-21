//
//  ServicesVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 12/06/25.
//

import UIKit

class ServicesVC: UIViewController,DismissDelegate {
    
    
    @IBOutlet weak var lbl_TitleServices: UILabel!
    @IBOutlet weak var scroll_vw: UIScrollView!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var txt_search: UITextField!
    @IBOutlet weak var lbl_totalClient: UILabel!
    
    @IBOutlet weak var lbl_NoDataFound: UILabel!
    @IBOutlet weak var btnResources: GradientButton!
    
    @IBOutlet weak var vw_SubResource: UIView!
    @IBOutlet weak var btn_AddNew: GradientButton!
    @IBOutlet weak var btn_ServiceSequence: GradientButton!
    
    @IBOutlet weak var btn_Addon: GradientButton!
    @IBOutlet weak var vw_Addon: UIView!
    @IBOutlet weak var btn_AddAddon: UIButton!
    @IBOutlet weak var btn_ViewAddon: UIButton!
    
    var serviceList: [ServiceData] = []
    var searchWorkItem: DispatchWorkItem?
    var currentPage = 1
    var totalCount = 0
    var isLoadingMore = false
    var hasMoreData = true

    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vw_SubResource.isHidden = true
        contentViewWidthConstraint.constant = 10 // or any dynamic value
        
        let ServiceSequence = NSAttributedString(
            string: NSLocalizedString("ServiceSequence",comment: ""),
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 18.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        btn_ServiceSequence.setAttributedTitle(ServiceSequence, for: .normal)
        
        let AddNew = NSAttributedString(
            string: NSLocalizedString("Add New",comment: ""),
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 18.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        btn_AddNew.setAttributedTitle(AddNew, for: .normal)
        
        let Resources = NSAttributedString(
            string: NSLocalizedString("           Resources",comment: ""),
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 18.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        btnResources.setAttributedTitle(Resources, for: .normal)
        
        let Addon = NSAttributedString(
            string: NSLocalizedString("         Addon",comment: ""),
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 18.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        btn_Addon.setAttributedTitle(Addon, for: .normal)
        
        self.setTableView()
        self.setCustomFont()
        self.txt_search.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadData(Search: "")
    }
    
    func didDismissScreen(data: String?) {
        self.loadData(Search: "")
    }
    
    
    //MARK: Setup Views
    func setTableView(){
        tbl_vw.register(UINib(nibName: "ServiceItemCell", bundle: nil), forCellReuseIdentifier: "ServiceItemCell")
        tbl_vw.register(UINib(nibName: "ServiceHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "ServiceHeaderCell")
        tbl_vw.delegate = self
        tbl_vw.dataSource = self
        tbl_vw.rowHeight = UITableView.automaticDimension
        tbl_vw.estimatedRowHeight = 50
    }
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Bold", size: 22.0) {
            lbl_TitleServices.font = customFont
            self.lbl_TitleServices.text = NSLocalizedString("Services", comment: "")
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
            self.serviceList.removeAll()
            self.hasMoreData = true
//            showLoader()
        }

        APIService.shared.getServiceDetails(page: "\(currentPage)", limit: "100000", vendorId: LocalData.userId, search: Search, booking: "", categoryId: "", isGroup: true) { staffResult in
            self.hideLoader()
            guard let model = staffResult else {
                self.isLoadingMore = false
                return
            }

            let newItems = model.data
            self.totalCount = model.total // Make sure this field exists in your response model
            self.lbl_totalClient.text = "\(self.totalCount) " + (NSLocalizedString("Services", comment: ""))
            if newItems.isEmpty || self.serviceList.count + newItems.count >= self.totalCount {
                self.hasMoreData = false
            }

            self.serviceList += newItems
            self.currentPage += 1
            self.isLoadingMore = false
            self.tbl_vw.backgroundView = self.serviceList.isEmpty ? self.getNoDataLabel() : nil
            self.tbl_vw.reloadData()
        }
    }
    
    func getNoDataLabel() -> UILabel {
        let noDataLabel = UILabel()
        noDataLabel.text = NSLocalizedString("No Services Data Found", comment: "")
        noDataLabel.textAlignment = .center
        noDataLabel.textColor = .gray
        noDataLabel.font = UIFont(name: "Lato-Bold", size: 20.0)
        return noDataLabel
    }
    
    //MARK: Button Action
    @IBAction func act_addNew(_ sender: UIButton) {
        let addNew = self.storyboard?.instantiateViewController(withIdentifier: "AddServiceVC") as! AddServiceVC
        addNew.isEdit = false
        self.navigationController?.pushViewController(addNew, animated: true)
    }
    
    @IBAction func act_serviceSequence(_ sender: UIButton) {
        let serviceSeq = self.storyboard?.instantiateViewController(withIdentifier: "ServiceSequenceVC") as! ServiceSequenceVC
        serviceSeq.modalPresentationStyle = .overCurrentContext
        serviceSeq.modalTransitionStyle = .crossDissolve
        self.present(serviceSeq, animated: true)
        
    }
    
    @IBAction func act_Resources(_ sender: Any) {
        self.vw_Addon.isHidden = true
        if vw_SubResource.isHidden == false {
            vw_SubResource.isHidden = true
        }else{
            vw_SubResource.isHidden = false
        }
//        self.vw_SubResource.isHidden = false
    }
    
    
    @IBAction func btn_AddResource(_ sender: Any) {
        vw_SubResource.isHidden = true
        let popup = self.storyboard?.instantiateViewController(withIdentifier: "AddResources_VC") as! AddResources_VC
        popup.AddResources = "AddResources"
        popup.modalPresentationStyle = .overCurrentContext
        popup.modalTransitionStyle = .crossDissolve
        self.present(popup, animated: true , completion: nil)
    }
    
    @IBAction func btn_ViewResource(_ sender: Any) {
        vw_SubResource.isHidden = true
        let popup = self.storyboard?.instantiateViewController(withIdentifier: "AddResources_VC") as! AddResources_VC
        popup.AddResources = "AllResources"
        popup.modalPresentationStyle = .overCurrentContext
        popup.modalTransitionStyle = .crossDissolve
        self.present(popup, animated: true , completion: nil)
        
    }
    
    @IBAction func btn_Addon(_ sender: Any) {
        self.vw_SubResource.isHidden = true
        if self.vw_Addon.isHidden == false{
            self.vw_Addon.isHidden = true
        }else{
            self.vw_Addon.isHidden = false
        }
    }
    
    
    @IBAction func btn_AddAddon(_ sender: Any) {
        self.vw_Addon.isHidden = true
        let popup = self.storyboard?.instantiateViewController(withIdentifier: "AddAddon_VC") as! AddAddon_VC
        popup.addAddon = "AddAddon"
        popup.modalPresentationStyle = .overCurrentContext
        popup.modalTransitionStyle = .crossDissolve
        self.present(popup, animated: true , completion: nil)
        
    }
    
    
    @IBAction func btn_ViewAddon(_ sender: Any) {
        self.vw_Addon.isHidden = true
        let popup = self.storyboard?.instantiateViewController(withIdentifier: "AddAddon_VC") as! AddAddon_VC
        popup.addAddon = "AllAddon"
        popup.modalPresentationStyle = .overCurrentContext
        popup.modalTransitionStyle = .crossDissolve
        self.present(popup, animated: true , completion: nil)
    }
    
    
    //MARK: Delete API
    func deleteServiceData(serviceId: Int) {
        showLoader()
        APIService.shared.deleteServiceData(serviceId: serviceId) { staffResult in
            self.hideLoader()
            guard let model = staffResult else {
                return
            }
            if model.error == "" || model.error == nil {
                DispatchQueue.main.async {
                    self.alertWithMessageOnly(NSLocalizedString("Service deleted successfully",comment: ""))
                }
                self.loadData(Search: "")
            } else {
                self.alertWithMessageOnly(NSLocalizedString("Failed to delete service",comment: ""))
            }
        }
    }
    
    
    // MARK: - AddSerivceData Api call
    func addServiceData(serviceName:String,
                        parentId: String,
                        vendorId:String,
                        description: String,
                        serviceFor: String,
                        duration: String,
                        priceType: String,
                        price: String,
                        salePrice:String,
                        vendorOnly:String,
                        contactSalon:String,
                        testRequired:String,
                        staffId:String,
                        addon_Id:String,
                        hasSubService:String,
                        isSubService:String,
                        resoucreId:String) {
        APIService.shared.addServiceData(serviceName: serviceName,
                                         parentId: String(parentId),
                                         vendorId: vendorId,
                                         description: description,
                                         serviceFor: serviceFor,
                                         duration: duration,
                                         priceType: priceType,
                                         price: price,
                                         salePrice: salePrice,
                                         vendorOnly: vendorOnly,
                                         contactSalon: contactSalon,
                                         testRequired: testRequired,
                                         staffId: staffId,
                                         addon_Id: addon_Id,
                                         has_sub_service: hasSubService,
                                         is_sub_service: isSubService,
                                         resource_id: resoucreId) { staffResult in
             self.hideLoader()
             guard let model = staffResult else {
                 return
             }

             if model.error == "" || model.error == nil {
                DispatchQueue.main.async {
                    self.hideLoader()
                        self.alertWithMessageOnly(NSLocalizedString("Service added successfully", comment: ""))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.loadData(Search: "")
                        }
                }
             } else {
                 self.alertWithMessageOnly(NSLocalizedString("Failed to insert service",comment: ""))
             }
         }
     }

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
        
        
        if service.has_sub_service == 1{
            cell.lbl_time.text! = "-"
            cell.lbl_serviceFor.text = "-"
            cell.btn_Duplication.setImage(UIImage(named: "black-EYE"), for: .normal)
        }else{
            if service.service_for == "Unisex"{
                cell.lbl_serviceFor.text = NSLocalizedString("Unisex", comment: "")
            }else if service.service_for == "Female"{
                cell.lbl_serviceFor.text = NSLocalizedString("Female", comment: "")
            }else if service.service_for == "Male"{
                cell.lbl_serviceFor.text = NSLocalizedString("Male", comment: "")
            }
//            cell.lbl_serviceFor.text = service.service_for
            cell.lbl_time.text = "\(service.duration) " + NSLocalizedString("Min", comment: "")
            cell.btn_Duplication.setImage(UIImage(named: "Duplication"), for: .normal)
        }
        
        if service.is_sub_service == 0{
            cell.lbl_type.text = "Main"
        }else{
            cell.lbl_type.text = "Sub"
        }
        /*if service.price_type != "Fixed" && !(service.sale_price != nil && service.sale_price! > 0) {
            cell.lbl_price.text = service.price_type + " \(LocalData.symbol)\(service.price)"
        }else{
            cell.lbl_price.text = "\(LocalData.symbol)\(service.price)"
        }
        
        
        if service.sale_price != nil && service.sale_price! > 0.00 {
            if service.price_type != "Fixed"{
                cell.lbl_SalePrice.text = service.price_type + " \(LocalData.symbol)\(service.sale_price ?? 0.00)"
            }else{
                cell.lbl_SalePrice.text = "\(LocalData.symbol)\(service.sale_price ?? 0.00)"
            }
        }*/
        
        cell.lbl_SalePrice.text = ""
        cell.lbl_price.attributedText = nil
        cell.lbl_price.textColor = .black
        
        let price = Double(service.price) ?? 0.0
        let salePrice = Double(service.sale_price) ?? 0.0
        let priceType = service.price_type

        // Price Label
        if service.price_type != "Fixed" && !(Double(service.sale_price) ?? 0.0 > 0) {
            if service.price_type == "Starts From"{
                cell.lbl_price.text = "\(NSLocalizedString("Starts From", comment: "")) \(LocalData.symbol)\(String(format: "%.2f", price))"
            }else if service.price_type == "Fixed"{
                cell.lbl_price.text = "\(NSLocalizedString("Fixed", comment: "")) \(LocalData.symbol)\(String(format: "%.2f", price))"
            }
        } else {
            cell.lbl_price.text = "\(LocalData.symbol)\(String(format: "%.2f", price))"
        }

        // Sale Price Label
        if salePrice > 0 {
            if priceType != "Fixed" {
                if service.price_type == "Starts From"{
                    cell.lbl_SalePrice.text = "\(NSLocalizedString("Starts From", comment: "")) \(LocalData.symbol)\(String(format: "%.2f", salePrice))"
                }else if service.price_type == "Fixed"{
                    cell.lbl_SalePrice.text = "\(NSLocalizedString("Fixed", comment: "")) \(LocalData.symbol)\(String(format: "%.2f", salePrice))"
                }
            } else {
                cell.lbl_SalePrice.text = "\(LocalData.symbol)\(String(format: "%.2f", salePrice))"
            }

            // Strike-through effect on the original price
            let attributeString = NSMutableAttributedString(string: cell.lbl_price.text ?? "")
            attributeString.addAttribute(.strikethroughStyle,
                                         value: NSUnderlineStyle.single.rawValue,
                                         range: NSMakeRange(0, attributeString.length))
            cell.lbl_price.attributedText = attributeString
        }
        
//        cell.lbl_price.text = "\(LocalData.symbol)\(service.price)"
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
            popup.titleText = NSLocalizedString("Are you sure you want to delete this service?",comment: "")
            popup.onConfirm = {
                print("User confirmed delete")
                // Call your delete logic here
                self.deleteServiceData(serviceId: service.id)
            }
            self.present(popup, animated: true, completion: nil)
        }
        
        cell.Act_Duplication = {
            
            if cell.btn_Duplication.currentImage == UIImage(named: "Duplication"){
                let popup = ConfirmDeletePopupVC()
                popup.modalPresentationStyle = .overFullScreen
                popup.modalTransitionStyle = .crossDissolve
                popup.titleText = NSLocalizedString("Are you sure you want to copy this service?",comment: "")
                popup.onConfirm = {
                    self.addServiceData(serviceName: service.service,parentId: String(service.category_id), vendorId: LocalData.userId, description: service.description, serviceFor: service.service_for, duration: String(service.duration), priceType: service.price_type, price: service.price, salePrice: service.sale_price, vendorOnly: String(service.isVendorOnly), contactSalon: String(service.conatctSalon), testRequired: String(service.patchTest), staffId: service.staff_id, addon_Id: service.addon_id, hasSubService: String(service.has_sub_service), isSubService: String(service.is_sub_service), resoucreId: service.resource_id)
                }
                self.present(popup, animated: true, completion: nil)
            }else {
                let addSubService = self.storyboard?.instantiateViewController(withIdentifier: "AddSubService_VC") as! AddSubService_VC
                addSubService.delegate = self
                addSubService.service_Id = String(service.id)
                addSubService.service_Name = service.service.capitalized
                addSubService.modalPresentationStyle = .overCurrentContext
                addSubService.modalTransitionStyle = .crossDissolve
                self.present(addSubService, animated: true)
            }
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
