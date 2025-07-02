//
//  Business_CategoriesVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 25/06/25.
//

import UIKit

class Business_CategoriesVC: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var cv_BusinessCategories: UICollectionView!
    @IBOutlet weak var cv_BusinessCategoriesHeight: NSLayoutConstraint!
    
    //MARK: - Global Variable
    var categoryList: [ServiceDatas] = []
    var categoryNames: [String] = []
    
    var ServiceCategoryList: [ServiceItem] = []
    
    var selectedIndexes: Set<Int> = []
    var alredaySelected: Set<Int> = []
    
    var mergedUniqueIDs: [Int] = []

    var selectedCategoryName = ""
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCollectCategory()
        self.get_CategoryList()
    }
    
    //MARK: -  Button Action
    @IBAction func btn_Save(_ sender: UIButton) {
        for category in self.categoryList {
            if category.color != ""{
                self.alredaySelected.insert(category.id)
            }
        }
        
        let selectedArray = Array(self.selectedIndexes)
        let alreadyArray = Array(self.alredaySelected)
        self.mergedUniqueIDs = mergeUniqueValuesPreservingOrder(selectedArray, alreadyArray)
        
        let joinedString = mergedUniqueIDs.map { String($0) }.joined(separator: ",")
        
        print("JOINEDSTRING:- \(joinedString)")
        update_CategoryList(service_id: joinedString)
    }
    
    //MARK: - Function
    func mergeUniqueValuesPreservingOrder(_ first: [Int], _ second: [Int]) -> [Int] {
        var seen: Set<Int> = []
        var result: [Int] = []
        
        for id in first + second {
            if !seen.contains(id) {
                seen.insert(id)
                result.append(id)
            }
        }
        return result
    }
    
    func setCollectCategory() {
        self.cv_BusinessCategories.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
        cv_BusinessCategories.dataSource = self
        cv_BusinessCategories.delegate = self
    }
    //MARK: - Web Api Calling
    
    func get_CategoryList() {
        APIService.shared.fetchBusinessServices { businessResult in
            guard let businessModel = businessResult else {
                return
            }
            self.categoryList = businessModel.data.filter {
                self.categoryNames.contains($0.service_name)
            }
            /*for category in self.categoryList {
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
            }*/
            self.categoryList = businessModel.data
            /*for category in self.categoryList {
                if category.color != ""{
                    self.selectedIndexes.insert(category.id)
                }
            }
            */
            /*for category in self.categoryList {
                if !category.color.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    self.selectedIndexes.insert(category.id)
                }
            }*/
            
            print("Filtered Category List: \(self.categoryList)")
//            print("Service Category List: \(self.serviceCategoryList)")
            DispatchQueue.main.async {
                let collectionViewWidth = self.cv_BusinessCategories.bounds.width
                let itemsPerRow: CGFloat = collectionViewWidth > 700 ? 6 :
                                           collectionViewWidth > 600 ? 5 :
                                           collectionViewWidth > 500 ? 4 : 3

                let cellHeight: CGFloat = 150
                let verticalSpacing: CGFloat = 10
                let sectionInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)

                let totalItems = self.categoryList.count

                let calculatedHeight = self.calculateCollectionViewHeight(
                    totalItems: totalItems,
                    itemsPerRow: itemsPerRow,
                    cellHeight: cellHeight,
                    verticalSpacing: verticalSpacing,
                    sectionInsets: sectionInsets
                )
                self.cv_BusinessCategoriesHeight.constant = calculatedHeight
                self.cv_BusinessCategories.reloadData()
            }
        }
    }
    
    func update_CategoryList(service_id: String){
        APIService.shared.UpdateSelectServices(service_id: service_id, vendorId: LocalData.userId, completion: { result in
            if let message = result?.data?.message {
                self.alertWithMessageOnly(message)
            }else{
                self.alertWithMessageOnly("Something went wrong.")
            }
        })
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
    
    
}

extension Business_CategoriesVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoryList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = cv_BusinessCategories.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {
            fatalError("Unable to dequeue CategoryCell")
        }
        let category = self.categoryList[indexPath.row] // Get the category data
        cell.vw_count.isHidden = true
        cell.lbl_name.text = category.service_name
        if selectedIndexes.contains(category.id) {
            cell.img_back.image = #imageLiteral(resourceName: "sel_cat")
        } else {
            if category.color != ""{
                cell.img_back.image = UIImage(named: "Tint_cat_back")
                cell.img_back.tintColor = UIColor(hexString: category.color)
            }else{
                cell.img_back.image = UIImage(named: "cat_back")
            }
        }
        
        /*if category.color != ""{
            selectedIndexes.insert(category.id)
        }*/
        
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
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = cv_BusinessCategories.bounds.width
        let sectionInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        let interItemSpacing: CGFloat = 10
        
        let totalSpacing = sectionInsets.left + sectionInsets.right + (interItemSpacing * 3) // 4 items → 3 gaps
        let itemsPerRow: CGFloat = collectionViewWidth > 700 ? 6 : collectionViewWidth > 500 ? 4 : 3
        
        let availableWidth = collectionViewWidth - totalSpacing
        let itemWidth = floor(availableWidth / itemsPerRow)
        let itemHeight = 150.0 // Adjust as needed
        
        return CGSize(width: itemWidth, height: itemHeight)
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
        let selectedCategory = categoryList[indexPath.row]
        let categoryId = selectedCategory.id
        if selectedIndexes.contains(categoryId) {
            selectedIndexes.remove(categoryId)
        } else {
            selectedIndexes.insert(categoryId)
        }
        cv_BusinessCategories.reloadData()
    }
    
}
