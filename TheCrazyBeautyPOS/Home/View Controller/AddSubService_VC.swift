//
//  AddSubService_VC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 23/03/26.
//

import UIKit

class AddSubService_VC: UIViewController {

    
    
    @IBOutlet weak var lbl_Titla: UILabel!
    @IBOutlet weak var tbl_SubService: UITableView!
    @IBOutlet weak var lbl_NoData: UILabel!
    
    
    var serviceList: [ServiceData] = []
    var service_Id = String()
    var service_Name = String()
    
    var onDismiss: (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let format = NSLocalizedString("Sub Services Of", comment: "")
        let serviceName = String(format: format, "\(service_Name)")
        self.lbl_Titla.text = serviceName

        self.lbl_NoData.text = "\(NSLocalizedString("There is no sub service added yet.", comment: ""))"
        setTableView()
        api_ServiceDetails()
    }
    
    func setTableView(){
        tbl_SubService.register(UINib(nibName: "SubService_Cell", bundle: nil), forCellReuseIdentifier: "SubService_Cell")
        tbl_SubService.register(UINib(nibName: "SubServiceHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "SubServiceHeaderCell")
        tbl_SubService.delegate = self
        tbl_SubService.dataSource = self
        tbl_SubService.rowHeight = UITableView.automaticDimension
        tbl_SubService.estimatedRowHeight = 50
    }
    
    @IBAction func btn_Close(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    func api_ServiceDetails(){
        self.showLoader()
        APIService.shared.subServiceDetails(service_id: service_Id) { serviceDetails in
            self.hideLoader()
            self.serviceList = serviceDetails?.data ?? []
            if self.serviceList.count == 0 {
                self.tbl_SubService.isHidden = true
                self.lbl_NoData.isHidden = false
                self.tbl_SubService.reloadData()
            }else{
                self.tbl_SubService.isHidden = false
                self.lbl_NoData.isHidden = true
                self.tbl_SubService.reloadData()
            }
        }
    }
    
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
                self.api_ServiceDetails()
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
                            self.api_ServiceDetails()
                        }
                }
             } else {
                 self.alertWithMessageOnly(NSLocalizedString("Failed to insert service",comment: ""))
             }
         }
     }
    
}


extension AddSubService_VC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.serviceList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SubServiceHeaderCell") as? SubServiceHeaderCell else {
                return nil
            }

            // Customize your header view
            return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbl_SubService.dequeueReusableCell(withIdentifier: "SubService_Cell", for: indexPath) as? SubService_Cell else {
            return UITableViewCell()
        }
        let service = self.serviceList[indexPath.item]
        cell.lbl_no.text = "\(indexPath.item + 1)"
        cell.lbl_service.text = service.service
        
        
        if service.has_sub_service == 1{
            cell.lbl_time.text! = "-"
            cell.lbl_serviceFor.text = "-"
        }else{
            if service.service_for == "Unisex"{
                cell.lbl_serviceFor.text = NSLocalizedString("Unisex", comment: "")
            }else if service.service_for == "Female"{
                cell.lbl_serviceFor.text = NSLocalizedString("Female", comment: "")
            }else if service.service_for == "Male"{
                cell.lbl_serviceFor.text = NSLocalizedString("Male", comment: "")
            }
            cell.lbl_time.text = "\(service.duration) " + NSLocalizedString("Min", comment: "")
        }
        
        
        cell.lbl_salePrice.text = ""
        cell.lbl_price.attributedText = nil
        cell.lbl_price.textColor = .black
        
        let price = Double(service.price_Price)
        let salePrice = Double(service.saleprice_Price)
        let priceType = service.price_type

        // Price Label
        if service.price_type.lowercased() != "fixed" && !(Double(service.saleprice_Price) > 0) {
            if service.price_type.lowercased() == "starts from"{
                cell.lbl_price.text = "\(NSLocalizedString("Starts From", comment: "")) \(LocalData.symbol)\(String(format: "%.2f", price))"
            }else if service.price_type.lowercased() == "fixed"{
                cell.lbl_price.text = "\(NSLocalizedString("Fixed", comment: "")) \(LocalData.symbol)\(String(format: "%.2f", price))"
            }
        } else {
            cell.lbl_price.text = "\(LocalData.symbol)\(String(format: "%.2f", price))"
        }

        // Sale Price Label
        if salePrice > 0 {
            if priceType.lowercased() != "fixed" {
                if service.price_type.lowercased() == "starts from"{
                    cell.lbl_salePrice.text = "\(NSLocalizedString("Starts From", comment: "")) \(LocalData.symbol)\(String(format: "%.2f", salePrice))"
                }else if service.price_type.lowercased() == "fixed"{
                    cell.lbl_salePrice.text = "\(NSLocalizedString("Fixed", comment: "")) \(LocalData.symbol)\(String(format: "%.2f", salePrice))"
                }
            } else {
                cell.lbl_salePrice.text = "\(LocalData.symbol)\(String(format: "%.2f", salePrice))"
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
            addNew.newAddServiceEdit = "newAddServiceEdit"
            if let nav = self.presentingViewController as? UINavigationController {
                self.dismiss(animated: true) {
                    nav.pushViewController(addNew, animated: true)
                }
            } else if let nav = self.presentingViewController?.navigationController {
                self.dismiss(animated: true) {
                    nav.pushViewController(addNew, animated: true)
                }
            }
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
            let popup = ConfirmDeletePopupVC()
            popup.modalPresentationStyle = .overFullScreen
            popup.modalTransitionStyle = .crossDissolve
            popup.titleText = NSLocalizedString("Are you sure you want to copy this service?",comment: "")
            popup.onConfirm = {
                self.addServiceData(serviceName: service.service,parentId: String(service.category_id), vendorId: LocalData.userId, description: service.description, serviceFor: service.service_for, duration: String(service.duration), priceType: service.price_type, price: String(service.price_Price), salePrice: String(service.saleprice_Price), vendorOnly: String(service.isVendorOnly), contactSalon: String(service.conatctSalon), testRequired: String(service.patchTest), staffId: service.staff_id, addon_Id: service.addon_id, hasSubService: String(service.has_sub_service), isSubService: String(service.is_sub_service), resoucreId: service.resource_id)
            }
            self.present(popup, animated: true, completion: nil)
        }
        return cell
    }
}
