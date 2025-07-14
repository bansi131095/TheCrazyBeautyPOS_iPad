//
//  Category_DescriptionVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 26/06/25.
//

import UIKit

class Category_DescriptionVC: UIViewController {

    @IBOutlet weak var tbl_CategoriesDescription: UITableView!
    @IBOutlet weak var tbl_Height: NSLayoutConstraint!
    
    
    var CategoryDetails: [CategoryDetailsModel] = []
    var CategoryDetailsModel: [categorydescriptionModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        get_CategoryDescription()
    }
    
    func setTableView(){
        tbl_CategoriesDescription.register(UINib(nibName: "CategoryDescriptionCell", bundle: nil), forCellReuseIdentifier: "CategoryDescriptionCell")
        tbl_CategoriesDescription.delegate = self
        tbl_CategoriesDescription.dataSource = self
        tbl_CategoriesDescription.rowHeight = UITableView.automaticDimension
        tbl_CategoriesDescription.reloadData()
    }
    
    @IBAction func btn_Save(_ sender: Any) {
        var sequenceArray: [[String: String]] = []

            for i in 0..<CategoryDetails.count {
                let indexPath = IndexPath(row: i, section: 0)
                if let cell = tbl_CategoriesDescription.cellForRow(at: indexPath) as? CategoryDescriptionCell {
                    
                    let sequenceText = cell.txt_Sequence.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                    let descriptionText = cell.txt_Description.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                    
                    if sequenceText.isEmpty {
                        alertWithImage(title: "Validation", Msg: "Sequence cannot be empty!")
                        return
                    }

                    // Optional: check for duplicate sequence
                    /*if sequenceArray.contains(where: { $0["sequence"] == sequenceText }) {
                        alertWithImage(title: "Validation", Msg: "Duplicate sequence found!")
                        return
                    }*/

                    // Update local model (optional)
                    CategoryDetails[i].sequence = sequenceText
                    CategoryDetails[i].descriptionText = descriptionText

                    let dict: [String: String] = [
                        "category_id": "\(CategoryDetails[i].id)",
                        "description": descriptionText,
                        "sequence": sequenceText
                    ]
                    sequenceArray.append(dict)
                }
            }

            // Now call API with payload
            update_CategoryDescription(category: sequenceArray)
        
    }
    
    
    //MARK: - API CALL
    
    func get_CategoryDescription(){
        APIService.shared.fetchCategory  { result in
            self.CategoryDetails = result!.data
            self.get_CategoryDescriptionNew()
        }
    }
    
    /*func get_CategoryDescriptionNew() {
        APIService.shared.fetchcategory_description { result in
            guard let result = result else { return }

            self.CategoryDetailsModel = result.data

            // Only one category_description expected
            if let first = self.CategoryDetailsModel.first {
                let staffArray = first.staffSequenceArray

                for i in 0..<self.CategoryDetails.count {
                    let category = self.CategoryDetails[i]

                    if let matched = staffArray.first(where: { $0.category_id == category.id }) {
                        category.sequence = matched.sequence
                        category.descriptionText = matched.description
                    }
                }
            }

            DispatchQueue.main.async {
                self.tbl_CategoriesDescription.reloadData()
                self.tbl_Height.constant = self.tbl_CategoriesDescription.contentSize.height
            }
        }
    }*/
    
    func get_CategoryDescriptionNew() {
        APIService.shared.fetchcategory_description { result in
            guard let result = result else {
                print("❌ Failed to fetch category description")
                return
            }

            self.CategoryDetailsModel = result.data

            if let first = self.CategoryDetailsModel.first {
                let staffArray = first.staffSequenceArray
                print("📦 Staff Array Count: \(staffArray.count)")

                for i in 0..<self.CategoryDetails.count {
                    let category = self.CategoryDetails[i]
                    let catIdStr = "\(category.id)".trimmingCharacters(in: .whitespacesAndNewlines)

                    var matchedFound = false

                    for staff in staffArray {
                        let staffIdStr = (staff.category_id)

                        if catIdStr == "\(staffIdStr)" {
                            print("✅ Match: \(catIdStr) == \(staffIdStr)")
                            category.sequence = staff.sequence
                            category.descriptionText = staff.description
                            matchedFound = true
                            break
                        } else {
                            print("❌ Mismatch: \(catIdStr) != \(staffIdStr)")
                        }
                    }

                    if !matchedFound {
                        print("❌ No match found for category_id: \(catIdStr)")
                        category.sequence = ""
                        category.descriptionText = ""
                    }
                }
            }

            DispatchQueue.main.async {
                self.tbl_CategoriesDescription.reloadData()
                self.tbl_Height.constant = self.tbl_CategoriesDescription.contentSize.height
            }
        }
    }

    
    
    func update_CategoryDescription(category: [[String: String]]) {
        APIService.shared.updateCategoryDescription(category_description: category,vendorid: LocalData.userId
        ) { response in
            if let message = response?.data {
                self.alertWithMessageOnly(message)
            } else {
                self.alertWithMessageOnly("Something went wrong, please try again.")
            }
        }
    }
}

extension Category_DescriptionVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategoryDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl_CategoriesDescription.dequeueReusableCell(withIdentifier: "CategoryDescriptionCell") as! CategoryDescriptionCell
        let data = CategoryDetails[indexPath.row]
        
        cell.lbl_CategoryName.text = data.service_name
        if data.icon != "" {
            let imgUrl = global.imageUrl + (data.icon ?? "")
            if let url = URL(string: imgUrl) {
                cell.img_Category.sd_setImage(with: url, completed: { (image, error, _, _) in
                    if let error = error {
                        print("❌ Failed to load image: \(error.localizedDescription)")
                        cell.img_Category.image = UIImage(named: "ProductDemo")
                    } else {
                        cell.img_Category.image = image
                    }
                })
            }
        }
        if data.descriptionText != ""{
            cell.txt_Description.text = data.descriptionText
        }else{
            cell.txt_Description.text = ""
        }
        
        if data.sequence != ""{
            cell.txt_Sequence.text = data.sequence
        }else{
            cell.txt_Sequence.text = ""
        }
        
        return cell
    }
}

