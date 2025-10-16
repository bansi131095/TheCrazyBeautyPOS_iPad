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
    
    @IBOutlet weak var btnSync: GradientButton!
    @IBOutlet weak var btn_Done: GradientButton!
    
    //MARK: - Global Variable
    var categoryList: [ServiceDatas] = []
    var category_Second: [ServiceDatas] = []
    var categoryNames: [String] = []
    
    var excludedCategoryIDs: Set<Int> = []
    var selectedIndexes: Set<Int> = []
    var salon_Id = Int()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributedTitle = NSAttributedString(
            string: "Done",
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 20.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        btn_Done.setAttributedTitle(attributedTitle, for: .normal)
        let attributedTitleSync = NSAttributedString(
            string: "Sync Team And Services As Well",
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 20.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        btnSync.setAttributedTitle(attributedTitleSync, for: .normal)
        setCollectCategory()
        fetchCategoryData()
    }
    
    //MARK: -  Button Action
    @IBAction func btn_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btn_SyncTeam(_ sender: Any) {
        SyncApiCall()
    }
    
    @IBAction func btn_Done(_ sender: Any) {
        let userSelectedIDs = selectedIndexes.subtracting(excludedCategoryIDs)
        let finalIDs = userSelectedIDs.union(excludedCategoryIDs)
        let serviceIDString = finalIDs.map { String($0) }.joined(separator: ",")
        
        update_CategoryList(service_id: serviceIDString)
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
    /*func fetchCategoryData() {
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
    }*/
    
    func fetchCategoryData() {
        showLoader()
        APIService.shared.fetchBusinessServices { businessResult in
            self.hideLoader()
            guard let businessModel = businessResult else { return }
            self.categoryList = businessModel.data

            APIService.shared.fetch_MainCategory { result in
                guard let excludedList = result?.data else { return }

                // Match IDs
                let categoryIDs = self.categoryList.map { $0.id }
                let matchedIDs = excludedList.compactMap { item -> Int? in
                    return categoryIDs.contains(item.id) ? item.id : nil
                }

                // ✅ Print matched IDs
                print("Matched IDs: \(matchedIDs)")

                // Save to exclude and select
                self.excludedCategoryIDs = Set(matchedIDs)
                self.selectedIndexes.formUnion(self.excludedCategoryIDs)

                DispatchQueue.main.async {
                    self.adjustCollectionHeight()
                    self.cv_BusinessCategories.reloadData()
                }
            }
        }
    }

    func SyncApiCall() {
        showLoader()
        APIService.shared.AddTeamData(salon_id: String(salon_Id)) { (result) in
            self.hideLoader()
            if let message = result?.data {
                self.btnSync.alpha = 0.5
                self.btnSync.isUserInteractionEnabled = false
                self.alertWithMessageOnly(message)
            }else{
                self.alertWithMessageOnly("Something went wrong.")
            }
        }
    }
    
    func update_CategoryList(service_id: String){
        showLoader()
        APIService.shared.UpdateSelectServices(service_id: service_id, vendorId: String(salon_Id), completion: { result in
            self.hideLoader()
            if let message = result?.data?.message {
                let sb = UIStoryboard(name: "Home", bundle:nil)
                let navDashboard = sb.instantiateViewController(withIdentifier: "NavigateHome") as! UINavigationController
                 navDashboard.modalPresentationStyle = .fullScreen
                self.present(navDashboard, animated: true, completion: nil)
                self.alertWithMessageOnly(message)
            }else{
                self.alertWithMessageOnly("Something went wrong.")
            }
        })
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
        let category = self.categoryList[indexPath.row]
        let isSelected = selectedIndexes.contains(category.id)
        let isExcluded = excludedCategoryIDs.contains(category.id)
        
        cell.vw_count.isHidden = true
        cell.lbl_name.text = category.service_name
        
        /*if excludedCategoryIDs.contains(category.id) {
            cell.contentView.alpha = 0.5
            cell.isUserInteractionEnabled = false
        } else {
            cell.contentView.alpha = 1.0
            cell.isUserInteractionEnabled = true
        }*/
        
        if isExcluded {
            cell.contentView.alpha = 0.5
            cell.isUserInteractionEnabled = false
        } else {
            cell.contentView.alpha = 1.0
            cell.isUserInteractionEnabled = true
        }
        
        if isSelected && !isExcluded {
            cell.img_back.image = UIImage(named: "sel_cat")
        } else {
            cell.img_back.image = UIImage(named: "cat_back")
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


