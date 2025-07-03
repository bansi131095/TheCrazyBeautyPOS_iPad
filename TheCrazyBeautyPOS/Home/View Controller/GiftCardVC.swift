//
//  GiftCardVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 26/06/25.
//

import UIKit

class GiftCardVC: UIViewController {
    
    @IBOutlet weak var scroll_vw: UIScrollView!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var txt_search: UITextField!
    @IBOutlet weak var lbl_totalClient: UILabel!
    
    var giftCardList: [GiftCardData] = []
    var searchWorkItem: DispatchWorkItem?
    var currentPage = 1
    var totalCount = 0
    var isLoadingMore = false
    var hasMoreData = true


    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        contentViewWidthConstraint.constant = 700 // or any dynamic value
        self.setTableView()
        self.txt_search.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.loadData(Search: "")
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: Setup Views
    func setTableView(){
        tbl_vw.register(UINib(nibName: "GiftCardCell", bundle: nil), forCellReuseIdentifier: "GiftCardCell")
        tbl_vw.register(UINib(nibName: "GiftCardHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "GiftCardHeaderCell")
        tbl_vw.delegate = self
        tbl_vw.dataSource = self
        tbl_vw.rowHeight = UITableView.automaticDimension
        tbl_vw.estimatedRowHeight = 60
    }
    

    @objc func textFieldDidChange(_ textField: UITextField) {
        searchWorkItem?.cancel()

        let newWorkItem = DispatchWorkItem { [weak self] in
            self?.loadData(Search: textField.text ?? "")
        }

        searchWorkItem = newWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: newWorkItem)
    }
    
    
    //MARK: Load Api
    func loadData(Search: String, isPagination: Bool = false) {
        if isPagination {
            self.isLoadingMore = true
        } else {
            self.currentPage = 1
            self.giftCardList.removeAll()
            self.hasMoreData = true
        }

        APIService.shared.getGiftCardDetails(page: "\(currentPage)", limit: "15", vendorId: LocalData.userId, search: Search){ staffResult in
            guard let model = staffResult else {
                self.isLoadingMore = false
                return
            }

            let newItems = model.data
            self.totalCount = model.total // Make sure this field exists in your response model
            self.lbl_totalClient.text = "\(self.totalCount) Cards"
            if newItems.isEmpty || self.giftCardList.count + newItems.count >= self.totalCount {
                self.hasMoreData = false
            }

            self.giftCardList += newItems
            self.currentPage += 1
            self.isLoadingMore = false
            self.tbl_vw.reloadData()
        }
    }
    
    
    //MARK: Button Action
    @IBAction func act_addNew(_ sender: UIButton) {
        
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

extension GiftCardVC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.giftCardList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "GiftCardHeaderCell") as? GiftCardHeaderCell else {
                return nil
            }

            // Customize your header view
            return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbl_vw.dequeueReusableCell(withIdentifier: "GiftCardCell", for: indexPath) as? GiftCardCell else {
            return UITableViewCell()
        }
        let giftCard = self.giftCardList[indexPath.item]
        cell.lbl_no.text = "\(indexPath.row+1)"
        cell.lbl_name.text = giftCard.card_name
        cell.lbl_price.text = "\(LocalData.symbol)\(giftCard.price)"
        cell.lbl_ExpiryDate.text = "\(giftCard.expired_in)"
        cell.lbl_status.text = giftCard.status
        if giftCard.image != "" {
            let imgUrl = global.imageUrl + giftCard.image
            if let url = URL(string: imgUrl) {
                cell.img_vw.sd_setImage(with: url, completed: { (image, error, _, _) in
                    if let error = error {
                        print("❌ Failed to load image: \(error.localizedDescription)")
                        cell.img_vw.image = UIImage(named: "ProductDemo")
                    } else {
                        cell.img_vw.image = image
                    }
                })
            }
        }
        cell.Act_Edit = {

        }
        cell.Act_Delete = {

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
