//
//  CouponVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 26/06/25.
//

import UIKit

class CouponVC: UIViewController {
    
    @IBOutlet weak var scroll_vw: UIScrollView!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var txt_search: UITextField!
    @IBOutlet weak var lbl_totalClient: UILabel!
    
    var couponList: [CouponData] = []
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
        tbl_vw.register(UINib(nibName: "CouponCell", bundle: nil), forCellReuseIdentifier: "CouponCell")
        tbl_vw.register(UINib(nibName: "CouponHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "CouponHeaderCell")
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
            self.couponList.removeAll()
            self.hasMoreData = true
        }

        APIService.shared.getcouponDetails(page: "\(currentPage)", limit: "15", vendorId: LocalData.userId, search: Search){ staffResult in
            guard let model = staffResult else {
                self.isLoadingMore = false
                return
            }

            let newItems = model.data
            self.totalCount = model.total // Make sure this field exists in your response model
            self.lbl_totalClient.text = "\(self.totalCount) Coupons"
            if newItems.isEmpty || self.couponList.count + newItems.count >= self.totalCount {
                self.hasMoreData = false
            }

            self.couponList += newItems
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

extension CouponVC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.couponList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CouponHeaderCell") as? CouponHeaderCell else {
                return nil
            }

            // Customize your header view
            return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbl_vw.dequeueReusableCell(withIdentifier: "CouponCell", for: indexPath) as? CouponCell else {
            return UITableViewCell()
        }
        let coupon = self.couponList[indexPath.item]
        cell.lbl_couponName.text = coupon.coupon_name
        if coupon.discount_type == "Percentage" {
            cell.lbl_amount.text = "\(coupon.amount)%"
        } else {
            cell.lbl_amount.text = "\(LocalData.symbol)\(coupon.amount)"
        }
        if coupon.highest_amount != 0 {
            cell.lbl_upto.text = "\(LocalData.symbol)\(coupon.highest_amount)"
        } else {
            cell.lbl_upto.text = "0"
        }
        cell.lbl_code.text = coupon.coupon_code
        cell.lbl_startDate.text = "\(coupon.start_date)"
        cell.lbl_endDate.text = "\(coupon.end_date)"
        cell.lbl_status.text = coupon.status
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
