//
//  BusinessThird_InformationVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 15/07/25.
//

import UIKit

class BusinessThird_InformationVC: UIViewController {

    
    //MARK: - Outlet
    @IBOutlet weak var cv_BusinessCategories: UICollectionView!
    @IBOutlet weak var cv_BusinessCategoriesHeight: NSLayoutConstraint!
    
    //MARK: - Global Variable
    var categoryList: [ServiceDatas] = []
    var category_Second: [ServiceDatas] = []
    var categoryNames: [String] = []
    
    var excludedCategoryIDs: Set<Int> = []
    var selectedIndexes: Set<Int> = []
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectCategory()
        fetchCategoryData()
    }
    
    //MARK: -  Button Action
    @IBAction func btn_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    //MARK: - Function
    func setCollectCategory() {
        self.cv_BusinessCategories.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
        cv_BusinessCategories.dataSource = self
        cv_BusinessCategories.delegate = self
    }
    
    func calculateCollectionViewHeight(totalItems: Int,itemsPerRow: CGFloat,cellHeight: CGFloat,verticalSpacing: CGFloat,sectionInsets: UIEdgeInsets) -> CGFloat {
        let rows = ceil(CGFloat(totalItems) / itemsPerRow)
        let totalSpacing = verticalSpacing * (rows - 1)
        let totalInsets = sectionInsets.top + sectionInsets.bottom

        let height = (rows * cellHeight) + totalSpacing + totalInsets
        return height
    }
    
    //MARK: - Web Api Calling
    func fetchCategoryData() {
        APIService.shared.fetchBusinessServices { businessResult in
            guard let businessModel = businessResult else { return }

            self.categoryList = businessModel.data

            APIService.shared.fetch_MainCategory { result in
                self.category_Second = result?.data as! [ServiceDatas]
                
                
                if let excludedList = result?.data as? [ServiceDatas] {
                    self.category_Second = result?.data as! [ServiceDatas]
                    // Match IDs
                    
                    let fetchedIDs = self.categoryList.map { $0.id }
                    let excluded = excludedList.filter { fetchedIDs.contains($0.id) }.map { $0.id }
                    self.excludedCategoryIDs = Set(excluded)
                    self.selectedIndexes.formUnion(self.excludedCategoryIDs)
                }

                DispatchQueue.main.async {
                    self.adjustCollectionHeight()
                    self.cv_BusinessCategories.reloadData()
                }
            }
        }
    }

    func adjustCollectionHeight() {
        let collectionViewWidth = self.cv_BusinessCategories.bounds.width
        let itemsPerRow: CGFloat = collectionViewWidth > 700 ? 6 :
                                   collectionViewWidth > 600 ? 5 :
                                   collectionViewWidth > 500 ? 4 : 3

        let cellHeight: CGFloat = 150
        let verticalSpacing: CGFloat = 10
        let sectionInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)

        let calculatedHeight = self.calculateCollectionViewHeight(totalItems: self.categoryList.count,itemsPerRow: itemsPerRow,cellHeight: cellHeight,verticalSpacing: verticalSpacing,sectionInsets: sectionInsets)
        
        self.cv_BusinessCategoriesHeight.constant = calculatedHeight
    }

    
}

extension BusinessThird_InformationVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        
        /*if isSelected {
            cell.img_back.image = UIImage(named: "sel_cat")
        } else {
            if category.color != "" {
                cell.img_back.image = UIImage(named: "Tint_cat_back")
                cell.img_back.tintColor = UIColor(hexString: category.color)
            } else {
                cell.img_back.image = UIImage(named: "cat_back")
            }
        }
        
        if isExcluded {
            cell.contentView.alpha = 0.5
            cell.isUserInteractionEnabled = false
        } else {
            cell.contentView.alpha = 1.0
            cell.isUserInteractionEnabled = true
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
    
    /*func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = categoryList[indexPath.row]
        let categoryId = selectedCategory.id
        if selectedIndexes.contains(categoryId) {
            selectedIndexes.remove(categoryId)
        } else {
            selectedIndexes.insert(categoryId)
        }
        cv_BusinessCategories.reloadData()
    }*/
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categoryList[indexPath.row]
        let id = category.id

        // Prevent toggle for excluded ones
        if excludedCategoryIDs.contains(id) { return }

        if selectedIndexes.contains(id) {
            selectedIndexes.remove(id)
        } else {
            selectedIndexes.insert(id)
        }

        cv_BusinessCategories.reloadData()
    }

    
}


