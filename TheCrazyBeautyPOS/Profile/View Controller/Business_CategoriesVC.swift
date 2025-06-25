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
    //MARK: - Global Variable
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCollectCategory()
    }
    
    //MARK: -  Button Action
    @IBAction func btn_Save(_ sender: UIButton) {
    }
    
    //MARK: - Function
    func setCollectCategory() {
        self.cv_BusinessCategories.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
//        collect_category.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        // Set the data source and delegate
        cv_BusinessCategories.dataSource = self
        cv_BusinessCategories.delegate = self
    }
    //MARK: - Web Api Calling
}

extension Business_CategoriesVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv_BusinessCategories.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
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
    }*/
    
}
