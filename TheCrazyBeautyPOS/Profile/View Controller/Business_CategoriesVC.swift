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
    
    @IBOutlet weak var btn_Save: GradientButton!
    //MARK: - Global Variable
    var categoryList: [ServiceDatas] = []
    
    var categoryNames: [String] = []
    
    var selectedIndexes: Set<Int> = []
    var alredaySelected: Set<Int> = []
    var apiSelectedIDs: Set<Int> = []
    var selectedIDs: Set<Int> = []
    var mergedUniqueIDs: [Int] = []

    var apiPreselectedIDs: Set<Int> = []
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributedTitle = NSAttributedString(
            string: "Save",
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 22)!,
                .foregroundColor: UIColor.white
            ]
        )
        btn_Save.setAttributedTitle(attributedTitle, for: .normal)
        self.setCollectCategory()
//        self.get_CategoryList()
        self.getList_CategoryList()
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
        let finalIDs = apiPreselectedIDs.union(selectedIDs)
        let joinedString1 = finalIDs.map { String($0) }.joined(separator: ",")
        
        update_CategoryList(service_id: joinedString1)
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
        self.showLoader()
        APIService.shared.fetchBusinessServices { businessResult in
            self.hideLoader()
            guard let businessModel = businessResult else {
                return
            }
            self.categoryList = businessModel.data.filter {
                self.categoryNames.contains($0.service_name)
            }
            self.categoryList = businessModel.data
            DispatchQueue.main.async {
                let collectionViewWidth = self.cv_BusinessCategories.bounds.width
                let itemsPerRow: CGFloat = collectionViewWidth > 700 ? 6 :
                                           collectionViewWidth > 600 ? 5 :
                                           collectionViewWidth > 500 ? 4 : 3

                let cellHeight: CGFloat = 160
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
    
    func getList_CategoryList() {
        showLoader()
        
        APIService.shared.fetchBusinessServices { [weak self] businessResult in
            guard let self = self else { return }
            DispatchQueue.main.async { self.hideLoader() }
            
            guard let businessModel = businessResult else { return }
            self.categoryList = businessModel.data
            
            DispatchQueue.main.async {
                self.cv_BusinessCategories.reloadData()
                self.updateCollectionHeight()
            }
            
            // Second API
            APIService.shared.getselectMainCategory { [weak self] categoryResult in
                guard let self = self else { return }
                guard let categoryModel = categoryResult else { return }
                
                // ✅ Pre-selected IDs from backend
                self.apiSelectedIDs = Set(categoryModel.data.map { $0.id })
                
                // ✅ Initially mark them as selected
                self.selectedIDs = self.apiSelectedIDs
                
                DispatchQueue.main.async {
                    self.cv_BusinessCategories.reloadData()
                }
            }
        }
    }



    func updateCollectionHeight() {
        self.cv_BusinessCategories.layoutIfNeeded()
        self.cv_BusinessCategoriesHeight.constant =
            self.cv_BusinessCategories.collectionViewLayout.collectionViewContentSize.height
    }

    
    
    func update_CategoryList(service_id: String){
        self.showLoader()
        APIService.shared.UpdateSelectServices(service_id: service_id, vendorId: LocalData.userId, completion: { result in
            self.hideLoader()
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
        let isSelected = selectedIDs.contains(category.id)
        if isSelected {
           // ✅ Selected appearance
           if category.color.isEmpty {
               cell.img_back.image = UIImage(named: "sel_cat")// PINK
               cell.img_back.tintColor = nil
               cell.lbl_name.textColor = UIColor(red: 0.77, green: 0.4, blue: 0.89, alpha: 1)// PINK
           } else {
               cell.img_back.image = UIImage(named: "Tint_cat_back")//
               cell.img_back.tintColor = UIColor(hexString: category.color)
               cell.lbl_name.textColor = .black
           }
       } else {
           // ✅ Normal appearance
           cell.img_back.image = UIImage(named: "cat_back")//BLACK
           cell.lbl_name.textColor = .black
       }
        let icon = category.icon
        let isSvg = icon.lowercased().hasSuffix(".svg")
        if isSvg {
            // Handle SVG loading (e.g., using SVGKit or SDWebImageSVGCoder)
            print("This is an SVG image.")
            if category.icon != "" {
                let imgUrl = global.imageUrl + category.icon
                if let url = URL(string: imgUrl) {
                    let placeholder = UIImage(named: "user")
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
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = cv_BusinessCategories.bounds.width
        let sectionInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        let interItemSpacing: CGFloat = 10
        
        let totalSpacing = sectionInsets.left + sectionInsets.right + (interItemSpacing * 3) // 4 items → 3 gaps
        let itemsPerRow: CGFloat = collectionViewWidth > 700 ? 6 : collectionViewWidth > 500 ? 5 : 3
        
        let availableWidth = collectionViewWidth - totalSpacing
        let itemWidth = floor(availableWidth / itemsPerRow)
        let itemHeight = 160.0 // Adjust as needed
        
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
        if selectedIDs.contains(categoryId) {
            selectedIDs.remove(categoryId)
        } else {
            selectedIDs.insert(categoryId)
        }
        
        cv_BusinessCategories.reloadData()
    }
}
