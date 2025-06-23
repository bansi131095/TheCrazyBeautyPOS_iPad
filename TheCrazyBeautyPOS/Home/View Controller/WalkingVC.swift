//
//  WalkingVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 12/06/25.
//

import UIKit
import SDWebImage
import SDWebImageSVGCoder

class WalkingVC: UIViewController {

    // Walkin View
    @IBOutlet weak var collect_category: UICollectionView!
    @IBOutlet weak var collectCategoryHeight: NSLayoutConstraint!
    @IBOutlet weak var lbl_service: UILabel!
    @IBOutlet weak var lbl_serviceLine: UIView!
    @IBOutlet weak var collect_service: UICollectionView!
    @IBOutlet weak var collectServiceHeight: NSLayoutConstraint!
    @IBOutlet weak var vw_30Count: UIView!
    @IBOutlet weak var lbl_30Count: UILabel!
    @IBOutlet weak var vw_50Count: UIView!
    @IBOutlet weak var lbl_50Count: UILabel!
    
    // Cart View
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var vw_service: UIView!
    @IBOutlet weak var vw_serviceHeightConst: NSLayoutConstraint!
    @IBOutlet weak var lbl_serviceTotal: UILabel!

    @IBOutlet weak var vw_giftCard: UIView!
    @IBOutlet weak var vw_giftHeightConst: NSLayoutConstraint!
    @IBOutlet weak var lbl_giftCardTotal: UILabel!
    @IBOutlet weak var vw_total: UIView!
    @IBOutlet weak var vw_totalHeightConst: NSLayoutConstraint!
    @IBOutlet weak var lbl_Total: UILabel!

    
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCollectCategory()
        self.setCollectService()
        self.setTableCell()
        self.loadAllData()
        self.vw_30Count.isHidden = true
        self.lbl_30Count.text = "0"
        self.vw_50Count.isHidden = true
        self.lbl_50Count.text = "0"
        self.vw_service.isHidden = true
        self.vw_giftCard.isHidden = true
        self.vw_total.isHidden = true
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
        self.lbl_service.text = ""
        self.lbl_serviceLine.isHidden = true
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
    
    func setGiftCard() {
        var serviceGift: [ServiceItem] = []
        
        if (self.gift30Count > 0) {
            self.vw_30Count.isHidden = false
            let service1 = ServiceItem(
                id: 0,
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
                id: 0,
                name: "Gift Card 2",
                price: 50.0,
                count: gift50Count
            )
            serviceGift.append(service2)
        }
        self.lbl_50Count.text = "\(self.gift50Count)"
        if (totalGiftCard > 0) {
            self.vw_giftCard.isHidden = false
            self.vw_giftHeightConst.constant = 50
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
        self.tbl_vw.reloadData()
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
        self.vw_serviceHeightConst.constant = 50
        self.lbl_serviceTotal.text = "x\(totalServices)"
        let nonGiftCards = cartDataList.filter { $0.categoryName != "Gift Card" }
        let giftCards = cartDataList.filter { $0.categoryName == "Gift Card" }
        cartDataList = nonGiftCards + giftCards
        self.tbl_vw.reloadData()
    }
    
    func loadAllData() {
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
                            ServiceItem(id: $0.id, name: $0.service, price: Double($0.price) ?? 0.0, count: 0)
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

        for service in services {
            let text = service.name
            let textSize = (text as NSString).size(withAttributes: [.font: font])
            let itemWidth = ceil(textSize.width + horizontalPadding)

            if rowWidths + itemWidth > collectionViewWidth {
                // Start a new row
                rowCount += 1
                rowWidths = itemWidth + interItemSpacing
            } else {
                // Add to current row
                rowWidths += itemWidth + interItemSpacing
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
                                cell.img_image.image = UIImage(named: "ProductDemo")
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
            let interItemSpacing: CGFloat = 10
            
            let totalSpacing = sectionInsets.left + sectionInsets.right + (interItemSpacing * 3) // 4 items → 3 gaps
            let itemsPerRow: CGFloat = collectionViewWidth > 700 ? 6 : collectionViewWidth > 500 ? 4 : 3
            
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
            let textWidth = sizeForText(text, font: font)

            // Apply padding
            let horizontalPadding: CGFloat = 40  // Tune this to match your capsule style
            var totalWidth = 0.0
            if (count > 0) {
                totalWidth = textWidth + horizontalPadding + 40.0
            } else {
                totalWidth = textWidth + horizontalPadding
            }
            return CGSize(width: totalWidth, height: 45)

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
                self.lbl_service.text = "Select Service"
                self.lbl_serviceLine.isHidden = false
                self.collect_service.reloadData()
            } else {
                serviceCategoryList = []
            }
            collectionView.reloadData()
        } else if collectionView == self.collect_service {
            let service = self.ServiceCategoryList[indexPath.item]
            service.count += 1
    
            for category in self.serviceCategoryList {
                // category.services.sort { $0.count > $1.count }
                category.totalCount = category.services.reduce(0) { $0 + $1.count }
            }
            collectionView.reloadData()
            self.collect_category.reloadData()
            self.setSelectedCategoryItem()
        }
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
        cell.lbl_category.text = self.cartDataList[indexPath.row].categoryName
        cell.setTableView()
        cell.data = self.cartDataList[indexPath.row].services
        cell.tbl_item.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
