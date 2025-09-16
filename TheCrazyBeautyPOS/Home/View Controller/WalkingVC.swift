//
//  WalkingVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 12/06/25.
//

import UIKit
import SDWebImage
import SDWebImageSVGCoder

class WalkingVC: UIViewController, WalkingDelegate {

    // Walkin View
    
    @IBOutlet weak var lbl_TitleCategory: UILabel!
    @IBOutlet weak var lbl_TitleGiftCard: UILabel!
    
    @IBOutlet weak var collect_category: UICollectionView!
    @IBOutlet weak var collectCategoryHeight: NSLayoutConstraint!
    @IBOutlet weak var lbl_service: UILabel!
    @IBOutlet weak var lbl_serviceTop: NSLayoutConstraint!
    @IBOutlet weak var lbl_serviceLine: UIView!
    @IBOutlet weak var collect_service: UICollectionView!
    @IBOutlet weak var collectServiceHeight: NSLayoutConstraint!
    @IBOutlet weak var vw_30Count: UIView!
    @IBOutlet weak var lbl_30Count: UILabel!
    @IBOutlet weak var vw_50Count: UIView!
    @IBOutlet weak var lbl_50Count: UILabel!
    @IBOutlet weak var lbl_emptyCart: UILabel!
    
    @IBOutlet weak var lbl_SubServiceTop: NSLayoutConstraint!
    @IBOutlet weak var lbl_SubServiceTitle: UILabel!
    @IBOutlet weak var collect_SubService: UICollectionView!
    @IBOutlet weak var collectSubServiceHeight: NSLayoutConstraint!
    @IBOutlet weak var lbl_SubServiceLine: UIView!
    
    @IBOutlet weak var height_SubService: NSLayoutConstraint!
    // Cart View
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var vw_service: UIView!
//    @IBOutlet weak var vw_serviceHeightConst: NSLayoutConstraint!
    @IBOutlet weak var lbl_serviceTotal: UILabel!

    @IBOutlet weak var vw_giftCard: UIView!
//    @IBOutlet weak var vw_giftHeightConst: NSLayoutConstraint!
    @IBOutlet weak var lbl_giftCardTotal: UILabel!
    @IBOutlet weak var vw_total: UIView!
//    @IBOutlet weak var vw_totalHeightConst: NSLayoutConstraint!
    @IBOutlet weak var lbl_Total: UILabel!
    @IBOutlet weak var btn_clear: UIButton!
    @IBOutlet weak var btn_payNow: GradientButton!
    
    
    var serviceList: [ServiceData] = []
    var categoryList: [ServiceDatas] = []
    var categoryNames: [String] = []
    var serviceCategoryList: [ServiceCategory] = []
    var cartDataList: [ServiceCategory] = []
    var ServiceCategoryList: [ServiceItem] = []
    var selectedCategoryName = ""
    var gift30Count = 0;
    var gift50Count = 0;
    var totalServices = 0
    var totalGiftCard = 0
    var totalPrice = 0
    
    var selectedServiceIndexForSubService: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCollectCategory()
        self.setCollectService()
        self.setServiceCell()
        self.setTableCell()
        self.loadAllData()
        self.vw_30Count.isHidden = true
        self.lbl_30Count.text = "0"
        self.vw_50Count.isHidden = true
        self.lbl_50Count.text = "0"
        self.vw_service.isHidden = true
        self.vw_giftCard.isHidden = true
        self.vw_total.isHidden = true
        self.btn_clear.isHidden = true
        self.btn_payNow.isHidden = true
        self.setCustomFont()
        tbl_vw.tableFooterView = UIView()
            
            if #available(iOS 15.0, *) {
                tbl_vw.sectionHeaderTopPadding = 0
            }
        // Do any additional setup after loading the view.
    }
    
    func setCollectCategory() {
        self.collect_category.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
//        collect_category.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        // Set the data source and delegate
        collect_category.dataSource = self
        collect_category.delegate = self
    }
    
    func setCollectService() {
        self.collect_service.register(UINib(nibName: "ServiceCell", bundle: nil), forCellWithReuseIdentifier: "ServiceCell")
        // Set the data source and delegate
        collect_service.dataSource = self
        collect_service.delegate = self
        self.collect_service.isHidden = true
        self.collectServiceHeight.constant = 0
        self.lbl_serviceTop.constant = 0
        self.lbl_service.text = ""
        self.lbl_serviceLine.isHidden = true
    }
    
    func setServiceCell(){
        self.collect_SubService.register(UINib(nibName: "ServiceCell", bundle: nil), forCellWithReuseIdentifier: "ServiceCell")
        // Set the data source and delegate
        collect_SubService.dataSource = self
        collect_SubService.delegate = self
        self.collect_SubService.isHidden = true
        self.collectSubServiceHeight.constant = 0
        self.lbl_SubServiceTop.constant = 0
        self.height_SubService.constant = 0
        self.lbl_SubServiceTitle.isHidden = true
    }
    func setTableCell() {
        self.tbl_vw.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        // Set the data source and delegate
        tbl_vw.delegate = self
        tbl_vw.dataSource = self
        tbl_vw.isHidden = false
        tbl_vw.isScrollEnabled = true
        tbl_vw.estimatedRowHeight = 80
        tbl_vw.rowHeight = UITableView.automaticDimension
        tbl_vw.separatorStyle = .none
        tbl_vw.layoutIfNeeded()
        tbl_vw.contentInset = .zero
    }
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Bold", size: 22.0) {
            lbl_TitleGiftCard.font = customFont
            lbl_TitleCategory.font = customFont
            lbl_service.font = customFont
            lbl_SubServiceTitle.font = customFont
        }
    }
    
    @IBAction func btn_30Gift(_ sender: UIButton) {
        self.gift30Count += 1
        self.totalGiftCard += 1
        self.setGiftCard()
    }
    
    @IBAction func btn_50Gift(_ sender: UIButton) {
        self.gift50Count += 1
        self.totalGiftCard += 1
        self.setGiftCard()
    }
    
    @IBAction func act_clear(_ sender: UIButton) {
        // 1. Clear cart data
        self.cartDataList.removeAll()

        // 2. Reset gift card counts
        self.gift30Count = 0
        self.gift50Count = 0
        self.totalGiftCard = 0
        self.totalServices = 0

        // 3. Reset all counts in serviceCategoryList
        for i in 0..<self.serviceCategoryList.count {
            self.serviceCategoryList[i].totalCount = 0
            for j in 0..<self.serviceCategoryList[i].services.count {
                self.serviceCategoryList[i].services[j].count = 0
            }
        }

        // 4. Reset displayed services as well
        for i in 0..<self.ServiceCategoryList.count {
            self.ServiceCategoryList[i].count = 0
        }

        // 5. Hide UI sections
        self.vw_service.isHidden = true
        self.vw_giftCard.isHidden = true
        self.vw_total.isHidden = true

        // 6. Reset labels
        self.vw_30Count.isHidden = true
        self.vw_50Count.isHidden = true
        self.lbl_30Count.text = "0"
        self.lbl_50Count.text = "0"
        self.lbl_serviceTotal.text = "x0"
        self.lbl_giftCardTotal.text = "x0"
        self.lbl_Total.text = "₹0"

        // 7. Reload views
        self.tbl_vw.reloadData()
        self.collect_category.reloadData()
        self.collect_service.reloadData()
        self.collect_SubService.reloadData()
        self.btn_clear.isHidden = true
        self.btn_payNow.isHidden = true
        self.lbl_emptyCart.isHidden = false
        
    }
    
    @IBAction func act_payNow(_ sender: GradientButton) {
        var teamServicesMap: [[String: Any]] = []
        var giftServicesMap: [[String: Any]] = []

        for cart in cartDataList {
            for selectedService in cart.services {
                if selectedService.id != 0 {
                    let val: [String: Any] = [
                        "service_id": selectedService.id,
                        "name": selectedService.name,
                        "qty": selectedService.count
                    ]
                    teamServicesMap.append(val)
                } else {
                    let val: [String: Any] = [
                        "price": selectedService.price,
                        "qty": selectedService.count
                    ]
                    giftServicesMap.append(val)
                }
            }
        }

        var GiftBookingJson = ""
        var ServiceBookingJson = ""
        // Debug print
        print("selected ServiceId: \(teamServicesMap)")
        if let serviceBookingData = try? JSONSerialization.data(withJSONObject: teamServicesMap, options: []),
           let serviceBookingJson = String(data: serviceBookingData, encoding: .utf8) {
            print("staffBookingJson: \(serviceBookingJson)")
            ServiceBookingJson = serviceBookingJson
        }

        print("selected GiftCardId: \(giftServicesMap)")
        if let giftBookingData = try? JSONSerialization.data(withJSONObject: giftServicesMap, options: []),
           let giftBookingJson = String(data: giftBookingData, encoding: .utf8) {
            print("giftBookingJson: \(giftBookingJson)")
            GiftBookingJson = giftBookingJson
        }
        
        let checkout = self.storyboard?.instantiateViewController(withIdentifier: "WalkinCheckoutVC") as! WalkinCheckoutVC
        checkout.modalPresentationStyle = .overCurrentContext
        checkout.modalTransitionStyle = .crossDissolve
        checkout.giftCards = GiftBookingJson
        checkout.serviceId = ServiceBookingJson
        checkout.price = Double(totalPrice)
        checkout.totalServices = totalServices
        checkout.totalGiftCard = totalGiftCard
        checkout.delegate = self
        self.present(checkout, animated: true)

    }
    
    func didClearData() {
        self.showToast(message: "Booking completed successfully")
        // 1. Clear cart data
        self.cartDataList.removeAll()

        // 2. Reset gift card counts
        self.gift30Count = 0
        self.gift50Count = 0
        self.totalGiftCard = 0
        self.totalServices = 0
        self.vw_30Count.isHidden = true
        self.vw_50Count.isHidden = true
        
        self.lbl_30Count.text = "0"
        self.lbl_50Count.text = "0"
        
        // 3. Reset all counts in serviceCategoryList
        for i in 0..<self.serviceCategoryList.count {
            self.serviceCategoryList[i].totalCount = 0
            for j in 0..<self.serviceCategoryList[i].services.count {
                self.serviceCategoryList[i].services[j].count = 0
            }
        }

        // 4. Reset displayed services as well
        for i in 0..<self.ServiceCategoryList.count {
            self.ServiceCategoryList[i].count = 0
        }

        // 5. Hide UI sections
        self.vw_service.isHidden = true
        self.vw_giftCard.isHidden = true
        self.vw_total.isHidden = true

        // 6. Reset labels
        self.lbl_30Count.text = "0"
        self.lbl_50Count.text = "0"
        self.lbl_serviceTotal.text = "x0"
        self.lbl_giftCardTotal.text = "x0"
        self.lbl_Total.text = "₹0"

        // 7. Reload views
        self.tbl_vw.reloadData()
        self.collect_category.reloadData()
        self.collect_service.reloadData()
        self.btn_clear.isHidden = true
        self.btn_payNow.isHidden = true
    }
    
    func setGiftCard() {
        var serviceGift: [ServiceItem] = []
        
        if (self.gift30Count > 0) {
            self.vw_30Count.isHidden = false
            let service1 = ServiceItem(
                id: 0, category_id: 0, has_sub_service: 0,
                name: "Gift Card 1",
                price: 30.0,
                count: gift30Count
            )
            serviceGift.append(service1)
            
        }
        self.lbl_30Count.text = "\(self.gift30Count)"
        if (self.gift50Count > 0) {
            self.vw_50Count.isHidden = false
            let service2 = ServiceItem(
                id: 0, category_id: 0, has_sub_service: 0,
                name: "Gift Card 2",
                price: 50.0,
                count: gift50Count
            )
            serviceGift.append(service2)
        }
        self.lbl_50Count.text = "\(self.gift50Count)"
        if (totalGiftCard > 0) {
            self.vw_giftCard.isHidden = false
            self.lbl_giftCardTotal.text = "x\(totalGiftCard)"
            if let index = cartDataList.firstIndex(where: { $0.categoryName == "Gift Card" }) {
                // Update properties as needed
                cartDataList[index].totalCount = gift30Count+gift50Count
                cartDataList[index].services = serviceGift
            } else {
                let serviceCategoryGift = ServiceCategory(
                    categoryName: "Gift Card",
                    icon: "",
                    services: serviceGift,
                    totalCount: gift30Count + gift50Count
                )
                cartDataList.append(serviceCategoryGift)
            }
        }
        let nonGiftCards = cartDataList.filter { $0.categoryName != "Gift Card" }
        let giftCards = cartDataList.filter { $0.categoryName == "Gift Card" }
        cartDataList = nonGiftCards + giftCards
        calculateTotalPrice()
        self.tbl_vw.reloadData()
        self.tbl_vw.layoutIfNeeded()
    }
    
    func setSelectedCategoryItem() {
        totalServices = 0
        for cart in self.serviceCategoryList {
            if cart.totalCount != 0 {
                let count = cart.totalCount
                if cart.categoryName != "Gift Card" {
                    totalServices += count
                }
//                self.serviceCategoryList
                let items = cart.services.filter { $0.count != 0 }
                if let index = cartDataList.firstIndex(where: { $0.categoryName == cart.categoryName }) {
                    // Update properties as needed
                    cartDataList[index].totalCount = cart.totalCount
                    cartDataList[index].services = items
                } else {
                    let data = ServiceCategory(
                        categoryName: cart.categoryName,
                        icon: cart.icon,
                        services: items,
                        totalCount: cart.totalCount // or count, if needed
                    )
                    cartDataList.append(data)
                }
            
            }
        }
        
        self.vw_service.isHidden = false
        self.lbl_serviceTotal.text = "x\(totalServices)"
        let nonGiftCards = cartDataList.filter { $0.categoryName != "Gift Card" }
        let giftCards = cartDataList.filter { $0.categoryName == "Gift Card" }
        cartDataList = nonGiftCards + giftCards
        self.calculateTotalPrice()
        self.tbl_vw.reloadData()
    }
    
    /*func setSelectedCategoryItem() {
        totalServices = 0
        for cart in self.serviceCategoryList {
            if cart.totalCount != 0 {
                let count = cart.totalCount
                if cart.categoryName != "Gift Card" {
                    totalServices += count
                }
//                self.serviceCategoryList
                let items = cart.services.filter { $0.count != 0 }
                if let index = cartDataList.firstIndex(where: { $0.categoryName == cart.categoryName }) {
                    // Update properties as needed
                    cartDataList[index].totalCount = cart.totalCount
                    cartDataList[index].services = items
                    
                    for i in cart.services {
                        if i.has_sub_service == 1 && i.sub_service.count > 0 {
                            let Subitems = cart.services.filter { $0.count != 0 }
                            if let index = cartDataList.firstIndex(where: { $0.categoryName == cart.categoryName }) {
                                cartDataList[index].totalCount = cart.totalCount
                                cartDataList[index].services = Subitems
                            }else{
                                let data = ServiceCategory(
                                    categoryName: i.name, icon: "", services: Subitems, totalCount: i.count
                                )
                                cartDataList.append(data)
                            }
                        }
                    }
                } else {
                    let data = ServiceCategory(
                        categoryName: cart.categoryName,
                        icon: cart.icon,
                        services: items,
                        totalCount: cart.totalCount // or count, if needed
                    )
                    cartDataList.append(data)
                }
            
            }
        }
        
        self.vw_service.isHidden = false
        self.lbl_serviceTotal.text = "x\(totalServices)"
        let nonGiftCards = cartDataList.filter { $0.categoryName != "Gift Card" }
        let giftCards = cartDataList.filter { $0.categoryName == "Gift Card" }
        cartDataList = nonGiftCards + giftCards
        self.calculateTotalPrice()
        self.tbl_vw.reloadData()
    }*/
    
    func calculateTotalPrice() {
        var total: Double = 0.0

        for category in cartDataList {
            for service in category.services {
                total += Double(service.count) * service.price
            }
        }

        // Store the total in the variable used for checkout
        self.totalPrice = Int(total)

        // Update total label in the UI
        self.lbl_Total.text = "\(LocalData.symbol)\(String(format: "%.2f", total))"
        
        // Show Pay Now and Clear buttons if total > 0
        self.btn_clear.isHidden = totalServices == 0 && totalGiftCard == 0
        self.btn_payNow.isHidden = totalServices == 0 && totalGiftCard == 0
        if total != 0 || totalServices != 0 || totalGiftCard != 0 {
            self.lbl_emptyCart.isHidden = true
            self.vw_total.isHidden = false
        } else {
            self.lbl_emptyCart.isHidden = false
            self.vw_total.isHidden = true
        }
    }


    func updateCartTotals() {
        self.totalServices = cartDataList
            .filter { $0.categoryName != "Gift Card" }
            .reduce(0) { $0 + $1.totalCount }

        self.totalGiftCard = cartDataList
            .first(where: { $0.categoryName == "Gift Card" })?.totalCount ?? 0

        // --- Separate Gift Card counts ---
                var gift30total = 0
                var gift50total = 0
         
                if let giftCategory = cartDataList.first(where: { $0.categoryName == "Gift Card" }) {
                    for item in giftCategory.services {
                        if item.price == 30 {
                            gift30total += item.count
                        } else if item.price == 50 {
                            gift50total += item.count
                        }
                    }
                }
            
                self.gift30Count = gift30total
                self.gift50Count = gift50total
        
        // Update service and gift card UI
        self.lbl_serviceTotal.text = "x\(totalServices)"
        self.lbl_giftCardTotal.text = "x\(totalGiftCard)"
        if self.gift30Count == 0{
            self.lbl_30Count.text = ""
            vw_30Count.isHidden = true
        }else{
            vw_30Count.isHidden = false
            self.lbl_30Count.text = "\(self.gift30Count)"
        }
        
        if self.gift50Count == 0{
            self.lbl_50Count.text = ""
            vw_50Count.isHidden = true
        }else{
            vw_50Count.isHidden = false
            self.lbl_50Count.text = "\(self.gift50Count)"
        }
        
        self.vw_service.isHidden = totalServices == 0
        self.vw_giftCard.isHidden = totalGiftCard == 0
        self.calculateTotalPrice()
    }

    
    func loadAllData() {
        showLoader()
        APIService.shared.getServiceDetails(page: "1", limit: "100000", vendorId: LocalData.userId, search: "", booking: "", categoryId: "", isGroup: true) { serviceResult in
            guard let model = serviceResult else {
                return
            }
            
            self.serviceList = model.data
        
            if !self.serviceList.isEmpty {
                self.categoryNames = Array(Set(self.serviceList.map { $0.category }))
                
                APIService.shared.fetchBusinessServices { businessResult in
                    guard let businessModel = businessResult else {
                        return
                    }
                    self.categoryList = businessModel.data.filter {
                        self.categoryNames.contains($0.service_name)
                    }
                    for category in self.categoryList {
                        let services: [ServiceItem] = self.serviceList
                        .filter { $0.category == category.service_name }
                        .map {
                            ServiceItem(id: $0.id, category_id: $0.category_id, has_sub_service: $0.has_sub_service, name: $0.service, price: Double($0.price) ?? 0.0, count: 0)
                        }
                        for i in services {
                            if i.has_sub_service == 1{
                                i.sub_service = self.serviceList
                                    .filter { $0.is_sub_service == 1 && $0.category_id == i.id }
                                    .map {
                                        ServiceItem(id: $0.id, category_id: $0.category_id, has_sub_service: $0.has_sub_service, name: $0.service, price: Double($0.price) ?? 0.0, count: 0)
                                        
                                    }
                            }
                        }
                        let serviceCategory = ServiceCategory(
                            categoryName: category.service_name,
                            icon: category.icon,
                            services: services,
                            totalCount: 0
                        )
                        self.serviceCategoryList.append(serviceCategory)
                    }
                    print("Filtered Category List: \(self.categoryList)")
                    print("Service Category List: \(self.serviceCategoryList)")
                    DispatchQueue.main.async {
                        let collectionViewWidth = self.collect_category.bounds.width
                        let itemsPerRow: CGFloat = collectionViewWidth > 700 ? 6 :
                                                   collectionViewWidth > 600 ? 5 :
                                                   collectionViewWidth > 500 ? 4 : 3

                        let cellHeight: CGFloat = 150
                        let verticalSpacing: CGFloat = 10
                        let sectionInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)

                        let totalItems = self.serviceCategoryList.count

                        let calculatedHeight = self.calculateCollectionViewHeight(
                            totalItems: totalItems,
                            itemsPerRow: itemsPerRow,
                            cellHeight: cellHeight,
                            verticalSpacing: verticalSpacing,
                            sectionInsets: sectionInsets
                        )
                        self.collectCategoryHeight.constant = calculatedHeight
                        self.collect_category.reloadData()
                        self.hideLoader()
                    }
                }
            } else {
                print("❌ Login failed or invalid response.")
            }
        }
    }
    
    func calculateCollectionViewHeight(
        totalItems: Int,
        itemsPerRow: CGFloat,
        cellHeight: CGFloat,
        verticalSpacing: CGFloat,
        sectionInsets: UIEdgeInsets
    ) -> CGFloat {
        let rows = ceil(CGFloat(totalItems) / itemsPerRow)
        let totalSpacing = verticalSpacing * (rows - 1)
        let totalInsets = sectionInsets.top + sectionInsets.bottom

        let height = (rows * cellHeight) + totalSpacing + totalInsets
        return height
    }
    
    func calculateCollectionServiceViewHeight(for services: [ServiceItem], collectionViewWidth: CGFloat) -> CGFloat {
        let itemHeight: CGFloat = 60.0
        let horizontalPadding: CGFloat = 50.0
        let interItemSpacing: CGFloat = 10.0
        let lineSpacing: CGFloat = 15.0

        let font = UIFont(name: "Lato-Medium", size: 16.0) ?? UIFont.systemFont(ofSize: 20.0)
        print("Font ", font)
        var rowWidths: CGFloat = 0
        var rowCount: Int = 1

       /* for service in services {
            let text = service.name
            let textSize = (text as NSString).size(withAttributes: [.font: font])
            let itemWidth = ceil(textSize.width + horizontalPadding)

            if rowWidths + itemWidth > collectionViewWidth {
                // Start a new row
                rowCount += 1
                rowWidths = itemWidth //+ interItemSpacing
            } else {
                // Add to current row
                rowWidths += itemWidth  //+ interItemSpacing
            }
        } */
        
        for (index, service) in services.enumerated() {
            let text = service.name
            let textSize = (text as NSString).size(withAttributes: [.font: font])
            let countWidth: CGFloat = service.count > 0 ? 40.0 : 0.0
            let itemWidth = ceil(textSize.width + horizontalPadding + countWidth)

            if rowWidths + itemWidth > collectionViewWidth {
                rowCount += 1
                rowWidths = itemWidth
            } else {
                rowWidths += index == 0 ? itemWidth : (itemWidth + interItemSpacing)
            }
        }

        return (CGFloat(rowCount) * itemHeight) + (CGFloat(rowCount - 1) * lineSpacing)
    }


    func sizeForText(_ text: String, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 45)
        let boundingBox = text.boundingRect(
            with: constraintRect,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        return ceil(boundingBox.width)
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


extension WalkingVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of items you want to display in your collection view.
        // For example, if you have an array of categories:
        if collectionView == self.collect_category {
            return self.serviceCategoryList.count// Replace with your actual data source
        } else if collectionView == self.collect_service {
            return self.ServiceCategoryList.count// Replace with your actual data source
        } else if collectionView == self.collect_SubService{
//            return self.serviceCategoryList.count
            /*guard let index = selectedServiceIndexForSubService else { return 0 }
            return self.ServiceCategoryList[index].sub_service.count*/
            
            guard let index = selectedServiceIndexForSubService else {
                    print("⚠️ selectedServiceIndexForSubService is nil")
                    return 0
                }
                let count = self.ServiceCategoryList[index].sub_service.count
                print("📌 SubService items in section:", count)
                return count
            
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collect_category {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {
                fatalError("Unable to dequeue CategoryCell")
            }

            // Configure your cell with data from your data source
            let category = self.serviceCategoryList[indexPath.item] // Get the category data

    //         Example of setting cell properties:
            cell.lbl_name.text = category.categoryName
            cell.lbl_count.text = "\(category.totalCount)"
            if category.categoryName == selectedCategoryName {
                cell.img_back.image = #imageLiteral(resourceName: "sel_cat")
            } else {
                cell.img_back.image = #imageLiteral(resourceName: "cat_back")
            }
            // Assuming category.imageName or category.image exists
            let icon = category.icon
            let isSvg = icon.lowercased().hasSuffix(".svg")
            if isSvg {
                // Handle SVG loading (e.g., using SVGKit or SDWebImageSVGCoder)
                print("This is an SVG image.")
                if category.icon != "" {
                    let imgUrl = global.imageUrl + category.icon
                    if let url = URL(string: imgUrl) {
                        let placeholder = UIImage(named: "ProductDemo")
                        cell.img_image.sd_setImage(with: url, placeholderImage: placeholder, options: [.retryFailed], completed: { image, error, _, _ in
                            if let error = error {
                                print("❌ Failed to load image: \(error.localizedDescription)")
                                cell.img_image.image = placeholder
                            } else {
                                cell.img_image.image = image
                            }
                        })
                    }
                }
            } else {
                // Load regular image (e.g., .png, .jpg)
                print("This is a standard image.")
                if category.icon != "" {
                    let imgUrl = global.imageUrl + category.icon
                    if let url = URL(string: imgUrl) {
                        cell.img_image.sd_setImage(with: url, completed: { (image, error, _, _) in
                            if let error = error {
                                print("❌ Failed to load image: \(error.localizedDescription)")
                                cell.img_image.image = UIImage(named: "user")
                            } else {
                                cell.img_image.image = image
                            }
                        })
                    }
                }
            }
            cell.vw_count.isHidden = category.totalCount == 0
            return cell
        } else if collectionView == self.collect_service {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCell", for: indexPath) as? ServiceCell else {
                fatalError("Unable to dequeue CategoryCell")
            }

            // Configure your cell with data from your data source
            let service = self.ServiceCategoryList[indexPath.item] // Get the category data

            cell.lbl_services.text = service.name
            cell.lbl_serviceCount.text = "\(service.count)"
            cell.lbl_serviceCount.isHidden = service.count == 0
            if service.count == 0 {
                cell.lbl_countWidth.constant = 0.0
            } else {
                cell.lbl_countWidth.constant = 28.0
                self.tbl_vw.reloadData()
                self.tbl_vw.layoutIfNeeded()
            }
            return cell
        }else if collectionView == self.collect_SubService {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCell", for: indexPath) as? ServiceCell else {
                fatalError("Unable to dequeue CategoryCell")
            }
            guard let index = selectedServiceIndexForSubService else { return cell }
            let service = self.ServiceCategoryList[index].sub_service[indexPath.row] // Get the category data

            cell.lbl_services.text = service.name
            print("service.name:- \(service.name)")
            cell.lbl_serviceCount.text = "\(service.count)"
            cell.lbl_serviceCount.isHidden = service.count == 0
            if service.count == 0 {
                cell.lbl_countWidth.constant = 0.0
            } else {
                cell.lbl_countWidth.constant = 28.0
                self.tbl_vw.reloadData()
                self.tbl_vw.layoutIfNeeded()
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
        
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collect_category {
            let collectionViewWidth = collectionView.bounds.width
            let sectionInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
            let interItemSpacing: CGFloat = 5
            
            let totalSpacing = sectionInsets.left + sectionInsets.right + (interItemSpacing * 3) // 4 items → 3 gaps
            let itemsPerRow: CGFloat = collectionViewWidth > 700 ? 6 : collectionViewWidth > 500 ? 5 : 4
            
            let availableWidth = collectionViewWidth - totalSpacing
            let itemWidth = floor(availableWidth / itemsPerRow)
            let itemHeight = 150.0 // Adjust as needed
            
            return CGSize(width: itemWidth, height: itemHeight)
        } else if collectionView == collect_service {
            let service = ServiceCategoryList[indexPath.item]
            let text = service.name
            let count = service.count
            let font = UIFont(name: "Lato-Medium", size: 17.0) ?? UIFont.systemFont(ofSize: 17.0)

            // Get more accurate text width
          /*  let textWidth = sizeForText(text, font: font)

            // Apply padding
            let horizontalPadding: CGFloat = 40  // Tune this to match your capsule style
            var totalWidth = 0.0
            if (count > 0) {
                totalWidth = textWidth + horizontalPadding + 40.0
            } else {
                totalWidth = textWidth + horizontalPadding
            }
            return CGSize(width: totalWidth, height: 45) */
            
            let countWidth: CGFloat = count > 0 ? 40.0 : 0.0
            let horizontalPadding: CGFloat = 25.0 // Less padding = tighter wrap

            let textWidth = sizeForText(text, font: font) + 20.0
            let totalWidth = textWidth + horizontalPadding + countWidth

            return CGSize(width: ceil(totalWidth), height: 50)

            
        }else if collectionView == collect_SubService {
            let service = ServiceCategoryList[indexPath.item]
            let text = service.name
            let count = service.count
            let font = UIFont(name: "Lato-Medium", size: 17.0) ?? UIFont.systemFont(ofSize: 17.0)

            // Get more accurate text width
          /*  let textWidth = sizeForText(text, font: font)

            // Apply padding
            let horizontalPadding: CGFloat = 40  // Tune this to match your capsule style
            var totalWidth = 0.0
            if (count > 0) {
                totalWidth = textWidth + horizontalPadding + 40.0
            } else {
                totalWidth = textWidth + horizontalPadding
            }
            return CGSize(width: totalWidth, height: 45) */
            
            let countWidth: CGFloat = count > 0 ? 40.0 : 0.0
            let horizontalPadding: CGFloat = 25.0 // Less padding = tighter wrap

            let textWidth = sizeForText(text, font: font) + 70.0
            let totalWidth = textWidth + horizontalPadding + countWidth

            return CGSize(width: ceil(totalWidth), height: 50)

            
        } else  {
            return CGSize(width: 0.0, height: 0.0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collect_category {
            let category = self.serviceCategoryList[indexPath.item]
            selectedCategoryName = category.categoryName
            if let matchedCategory = self.serviceCategoryList.first(where: { $0.categoryName == selectedCategoryName }) {
                self.ServiceCategoryList = matchedCategory.services
                self.collect_service.isHidden = false
                let calculatedHeight = self.calculateCollectionServiceViewHeight(for: self.ServiceCategoryList, collectionViewWidth: collect_service.bounds.width)
                self.collectServiceHeight.constant = calculatedHeight
                self.lbl_serviceTop.constant = 15
                self.lbl_service.text = "Select Service"
                self.lbl_serviceLine.isHidden = false
                self.collect_service.reloadData()
            } else {
                serviceCategoryList = []
            }
            collectionView.reloadData()
        }else if collectionView == self.collect_service {
            let service = self.ServiceCategoryList[indexPath.item]

            if service.has_sub_service == 1 && service.sub_service.count > 0 {
                // 👉 Show sub services
                self.selectedServiceIndexForSubService = indexPath.item
                self.collect_SubService.isHidden = false
                self.lbl_SubServiceTitle.isHidden = false
                self.lbl_SubServiceTitle.text = "Select Sub Service"
                self.lbl_SubServiceTop.constant = 10
                self.height_SubService.constant = 30
                let calculatedHeight = self.calculateCollectionServiceViewHeight(for: service.sub_service, collectionViewWidth: collect_SubService.bounds.width)
                self.collectSubServiceHeight.constant = calculatedHeight
                self.collect_SubService.reloadData()
                self.collect_SubService.layoutIfNeeded()
            } else {
                self.lbl_SubServiceTop.constant = 0
                self.height_SubService.constant = 0
                self.lbl_SubServiceTitle.isHidden = true
                self.collectSubServiceHeight.constant = 0
                self.collect_SubService.isHidden = true
                self.lbl_SubServiceTitle.isHidden = true
                
                // 👉 Normal service (no sub-services) → add to cart
                service.count += 1

                // Update category total
                if let categoryIndex = self.serviceCategoryList.firstIndex(where: { $0.categoryName == self.selectedCategoryName }) {
                    self.serviceCategoryList[categoryIndex].totalCount =
                        self.serviceCategoryList[categoryIndex].services.reduce(0) { $0 + $1.count }
                }

                // Refresh cart + UI
                self.updateCartTotals()
                self.tbl_vw.reloadData()
                self.tbl_vw.layoutIfNeeded()
                self.collect_service.reloadData()
                self.collect_category.reloadData()
                self.setSelectedCategoryItem()
            }
        }else if collectionView == self.collect_SubService {
            guard let mainIndex = selectedServiceIndexForSubService else { return }

            let subService = self.ServiceCategoryList[mainIndex].sub_service[indexPath.item]
            subService.count += 1

            // Update parent service count
            let parentService = self.ServiceCategoryList[mainIndex]
            parentService.count = parentService.sub_service.reduce(0) { $0 + $1.count }

            // Update category total
            if let categoryIndex = self.serviceCategoryList.firstIndex(where: { $0.categoryName == self.selectedCategoryName }) {
                self.serviceCategoryList[categoryIndex].totalCount =
                    self.serviceCategoryList[categoryIndex].services.reduce(0) { $0 + $1.count }
            }

            // Refresh cart + UI
            self.updateCartTotals()
            self.tbl_vw.reloadData()
            self.tbl_vw.layoutIfNeeded()
            self.collect_service.reloadData()
            self.collect_SubService.reloadData()
            self.collect_category.reloadData()
            self.setSelectedCategoryItem()
        }
        
        /*else if collectionView == self.collect_service {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCell", for: indexPath) as? ServiceCell else {
                fatalError("Unable to dequeue CategoryCell")
            }
            
            
            let service = self.ServiceCategoryList[indexPath.item]
            service.count += 1
    
            for category in self.serviceCategoryList {
                // category.services.sort { $0.count > $1.count }
                category.totalCount = category.services.reduce(0) { $0 + $1.count }
            }
            
            if service.has_sub_service == 1 && service.sub_service.count > 0{
                self.selectedServiceIndexForSubService = indexPath.item
                let subServices = service.sub_service
                
                print("✅ Sub services count:", subServices.count)
                cell.vw_Main.backgroundColor = UIColor.black
                self.collect_SubService.isHidden = false
                self.lbl_SubServiceTitle.isHidden = false
                self.lbl_SubServiceTitle.text = "Select Sub Service"
                self.lbl_SubServiceTop.constant = 10
                self.height_SubService.constant = 30
                let calculatedHeight = self.calculateCollectionServiceViewHeight(for: subServices, collectionViewWidth: collect_SubService.bounds.width)
                self.collectSubServiceHeight.constant = calculatedHeight
                
                self.collect_SubService.reloadData()
                self.collect_SubService.layoutIfNeeded()
            }else{
                
                self.lbl_SubServiceTop.constant = 0
                self.height_SubService.constant = 0
                self.lbl_SubServiceTitle.isHidden = true
                self.collectSubServiceHeight.constant = 0
                self.collect_SubService.isHidden = true
                self.lbl_SubServiceTitle.isHidden = true
            }
            
            /*let newServiceList = self.serviceList[indexPath.item]
            print("newServiceList.has_sub_service:- \(newServiceList.has_sub_service)")
            */
            self.updateCartTotals()
            self.tbl_vw.reloadData()
            self.tbl_vw.layoutIfNeeded()
            collect_service.reloadData()
            collect_SubService.reloadData()
            collectionView.reloadData()
            self.collect_category.reloadData()
            self.setSelectedCategoryItem()
        }else if collectionView == collect_SubService {
            guard let mainIndex = selectedServiceIndexForSubService else { return }
            
            let subService = self.ServiceCategoryList[mainIndex].sub_service[indexPath.item]
            subService.count += 1
            
            // Update parent service count as sum of subservices
            let parentService = self.ServiceCategoryList[mainIndex]
            parentService.count = parentService.sub_service.reduce(0) { $0 + $1.count }
            
            // Update total count in category
            for category in self.serviceCategoryList {
                category.totalCount = category.services.reduce(0) { $0 + $1.count }
            }
            
            self.updateCartTotals()
            self.tbl_vw.reloadData()
            self.tbl_vw.layoutIfNeeded()
            collect_service.reloadData()
            collect_SubService.reloadData()
            self.collect_category.reloadData()
            self.setSelectedCategoryItem()
        }*/

    }
    
}

extension WalkingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cartDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell") as? CartCell else {
            fatalError("The cell is not registered")
        }
        let category = cartDataList[indexPath.row]
        cell.lbl_category.text = self.cartDataList[indexPath.row].categoryName
//        cell.data = self.cartDataList[indexPath.row].services

        /*  for i in cell.data {
            if i.has_sub_service == 1 && i.sub_service.count > 0 {
                for j in i.sub_service{
                    cell.data.append(j)
                }
            }
        }*/
        let flatServices: [ServiceItem] = category.services.flatMap { service in
                    if service.has_sub_service == 1, !service.sub_service.isEmpty {
                        return [service] + service.sub_service
                    } else {
                        return [service]
                    }
                }
        cell.data = flatServices
        cell.setTableView()
        cell.tbl_item.reloadData()
        self.tbl_vw.layoutIfNeeded()
        cell.updateTableViewHeight()
        cell.tbl_item_heightConst.constant = cell.tbl_item.contentSize.height
        cell.onItemUpdate = {itemIndex, changeAmount in
//            guard let self = self else { return }

            let service = self.cartDataList[indexPath.row].services[itemIndex]
            service.count += changeAmount

            // ✅ Update cartDataList
            self.cartDataList[indexPath.row].services[itemIndex] = service
            // ✅ Update in ServiceCategoryList (visible services)
            let newTotal = self.cartDataList[indexPath.row].services.reduce(0) { $0 + $1.count }
            self.cartDataList[indexPath.row].totalCount = newTotal
            if let serviceIndex = self.ServiceCategoryList.firstIndex(where: { $0.id == service.id }) {
                self.ServiceCategoryList[serviceIndex].count = service.count
            }

            // ✅ Update in serviceCategoryList (entire list)
            if let categoryIndex = self.serviceCategoryList.firstIndex(where: { $0.categoryName == self.cartDataList[indexPath.row].categoryName }) {
                if let itemIndex = self.serviceCategoryList[categoryIndex].services.firstIndex(where: { $0.id == service.id }) {
                    self.serviceCategoryList[categoryIndex].services[itemIndex].count = service.count
                }

                // Update totalCount of that category
                let total = self.serviceCategoryList[categoryIndex].services.reduce(0) { $0 + $1.count }
                self.serviceCategoryList[categoryIndex].totalCount = total
            }
            
            if self.cartDataList[indexPath.row].services[itemIndex].count == 0 {
                self.cartDataList[indexPath.row].services.remove(at: itemIndex)
            }
         
            // ✅ Recalculate totalCount
            if self.cartDataList[indexPath.row].services.isEmpty {
                self.cartDataList.remove(at: indexPath.row)
            }
        
            // ✅ Refresh views
            self.updateCartTotals()
            self.tbl_vw.reloadData()
            cell.tbl_item.reloadData()
            self.tbl_vw.layoutIfNeeded()
            cell.tbl_item.layoutIfNeeded()
            self.collect_category.reloadData()
            self.collect_service.reloadData()
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
