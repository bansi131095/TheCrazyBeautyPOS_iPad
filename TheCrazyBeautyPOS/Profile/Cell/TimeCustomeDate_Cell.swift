//
//  TimeCustomeDate_Cell.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 07/04/26.
//

import UIKit

class TimeCustomeDate_Cell: UITableViewCell {

    
    @IBOutlet weak var vw_Time: UIView!
    @IBOutlet weak var lbl_Time: UILabel!
    
    @IBOutlet weak var lbl_Line: UILabel!
    @IBOutlet weak var vw_FromToTime: UIView!
    @IBOutlet weak var lbl_FromTime: UILabel!
    @IBOutlet weak var lbl_ToTime: UILabel!
    
    
    @IBOutlet weak var vw_Date: UIView!
    @IBOutlet weak var txt_FromDate: UITextField!
    @IBOutlet weak var txt_ToDate: UITextField!
    
    @IBOutlet weak var vw_UpdateCancel: UIStackView!
    
    @IBOutlet weak var btn_Update: GradientButton!
    
    @IBOutlet weak var lbl_Dates: UILabel!
    @IBOutlet weak var btn_Cancel: UIButton!
    @IBOutlet weak var tbl_Dates: UITableView!
    @IBOutlet weak var tbl_DateHeight: NSLayoutConstraint!
    
    var onEditIndex = -1
    
    var editFromDate: String?
    var editToDate: String?
    
    var dateRanges: [DateRange] = []
    var selectedEditIndex: Int? = nil
    
    var isEditingDateRange: Bool = false
    
    
    //var onEditTapped: ((_ from: String, _ to: String) -> Void)?
    
    var onClose: (() -> Void)?
    var onEdit_NEW_Tapped: (() -> Void)?
    var onRemove_Tapped: ((_ range: DateRange) -> Void)?
    var onEditTapped: ((_ from: String, _ to: String, _ rangeIndex: Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.btn_Update.setTitle("Add Dates", for: .normal)
        setTableView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tbl_Dates.layoutIfNeeded()
        tbl_DateHeight.constant = tbl_Dates.contentSize.height
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.tbl_Dates.reloadData()
            self.tbl_Dates.layoutIfNeeded()
            self.tbl_DateHeight.constant = self.tbl_Dates.contentSize.height
            /*DispatchQueue.main.async {
                self.onUpdateHeight?()
            }*/
        }
    }
    
    func setTableView(){
        tbl_Dates.register(UINib(nibName: "CustomDate_Cell", bundle: nil), forCellReuseIdentifier: "CustomDate_Cell")
        tbl_Dates.delegate = self
        tbl_Dates.dataSource = self
        tbl_Dates.rowHeight = UITableView.automaticDimension
        tbl_Dates.isScrollEnabled = false
    }
    
    // The VC stash pattern already removes the edited range's dates from the live
    // data array before reloading, so groupConsecutiveDates already returns only
    // the non-edited ranges. We just display all of them — no extra filtering needed.
    func visibleRanges() -> [DateRange] {
        return dateRanges
    }
        
    var Act_From:(()->Void)?
    @IBAction func act_From(_ sender: UIButton) {
        self.Act_From?()
    }

    var Act_To:(()->Void)?
    @IBAction func act_To(_ sender: UIButton) {
        self.Act_To?()
    }
    
    var Act_Close:(()->Void)?
    @IBAction func act_Close(_ sender: UIButton) {
        self.Act_Close?()
    }
    
    var Act_Update:(()->Void)?
    @IBAction func act_Update(_ sender: UIButton) {
        self.Act_Update?()
    }
    
    var Act_Cancel:(()->Void)?
    @IBAction func act_Cancel(_ sender: UIButton) {
        self.editFromDate = ""
        self.editToDate = ""
        
        onEditIndex = -1
        
        self.tbl_Dates.reloadData()
        self.tbl_Dates.layoutIfNeeded()
        self.tbl_DateHeight.constant = self.tbl_Dates.contentSize.height
        
        self.Act_Cancel?()
    }
    
    var Act_FromDate:(()->Void)?
    @IBAction func act_FromDate(_ sender: UIButton) {
        self.Act_FromDate?()
    }
    
    var Act_ToDate:(()->Void)?
    @IBAction func act_ToDate(_ sender: UIButton) {
        self.Act_ToDate?()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        contentView.layoutIfNeeded()
        return contentView.systemLayoutSizeFitting(targetSize)
    }
}

extension TimeCustomeDate_Cell: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleRanges().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbl_Dates.dequeueReusableCell(withIdentifier: "CustomDate_Cell", for: indexPath) as? CustomDate_Cell else {
            return UITableViewCell()
        }
        let data = visibleRanges()[indexPath.row]
        /*if data.from == data.to {
            cell.lbl_Date.text = "\(data.from)"
        }else{
            
        }*/
        cell.lbl_Date.text = "\(data.from) To \(data.to)"
        /*if (onEditIndex == indexPath.row) {
            cell.vw_Date.isHidden = true
            cell.vw_Height.constant = 0
        } else {
            cell.vw_Date.isHidden = false
            cell.vw_Height.constant = 40
        }*/
        
        cell.Act_Edit = {
            let range = self.visibleRanges()[indexPath.row]
            self.onEditIndex = indexPath.row
            // Pre-fill the date fields with the selected range's values
            self.txt_FromDate.text = range.from
            self.txt_ToDate.text = range.to
            self.editFromDate = range.from
            self.editToDate = range.to
            // Track which range is being edited by finding its original index
            if let originalIndex = self.dateRanges.firstIndex(where: {
                $0.from == range.from && $0.to == range.to
            }) {
                self.selectedEditIndex = originalIndex
            }
            self.onEdit_NEW_Tapped?()
            print("Sub Index:- \(indexPath.row)")
        }
        
        cell.Act_Remove = {
            let range = self.visibleRanges()[indexPath.row]
            // Find the original DateRange (with its indices) before removing
            if let originalRange = self.dateRanges.first(where: {
                $0.from == range.from && $0.to == range.to
            }) {
                self.onRemove_Tapped?(originalRange)
            }
        }
        
        return cell
    }
}


//  customer_Hours Mate
/*
extension TimeCustomeDate_Cell: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleRanges().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbl_Dates.dequeueReusableCell(withIdentifier: "CustomDate_Cell", for: indexPath) as? CustomDate_Cell else {
            return UITableViewCell()
        }
        let data = visibleRanges()[indexPath.row]
        cell.lbl_Date.text = "\(data.from) To \(data.to)"
        
        if (onEditIndex == indexPath.row) {
            cell.vw_Date.isHidden = true
            cell.vw_Height.constant = 0
        } else {
            cell.vw_Date.isHidden = false
            cell.vw_Height.constant = 40
        }
        
        /*cell.Act_Edit = {[weak self] in
            guard let self = self else { return }
            // 🔥 find original index
            if let originalIndex = self.dateRanges.firstIndex(where: {
                $0.from == data.from && $0.to == data.to
            }) {
               self.selectedEditIndex = originalIndex
            }
            self.vw_Time.isHidden = true
            self.vw_FromToTime.isHidden = false
            self.vw_Date.isHidden = false
            self.vw_UpdateCancel.isHidden = false
            
            self.txt_FromDate.text = "\(data.from)"
            self.txt_ToDate.text = "\(data.to)"
            
            self.lbl_Line.isHidden = true
            
            self.btn_Update.setTitle("Update", for: .normal)
            
            DispatchQueue.main.async {
                self.tbl_Dates.reloadData()
                self.tbl_Dates.layoutIfNeeded()
                self.tbl_DateHeight.constant = self.tbl_Dates.contentSize.height
            }
        }*/
        
        cell.Act_Edit = { [weak self] in
            guard let self = self else { return }
            
            onEditIndex = indexPath.row
            
            self.editFromDate = data.from
            self.editToDate = data.to

            /*if let originalIndex = self.dateRanges.firstIndex(where: {
                $0.from == data.from && $0.to == data.to
            }) {
                self.selectedEditIndex = originalIndex
            }*/

            guard let originalIndex = self.dateRanges.firstIndex(where: {
                    $0.from == data.from && $0.to == data.to
                }) else { return }
            
            self.txt_FromDate.text = "\(data.from)"
            self.txt_ToDate.text = "\(data.to)"
            
            self.isEditingDateRange = true
            self.btn_Update.setTitle("Update", for: .normal)
            
            self.onEditTapped?(data.from, data.to, originalIndex)
            
            DispatchQueue.main.async {
                self.tbl_Dates.reloadData()
                self.tbl_Dates.layoutIfNeeded()
                self.tbl_DateHeight.constant = self.tbl_Dates.contentSize.height
            }
        }
        
        cell.Act_Remove = {
            self.dateRanges.remove(at: indexPath.row)
            self.tbl_Dates.reloadData()
            self.tbl_Dates.layoutIfNeeded()
            self.tbl_DateHeight.constant = self.tbl_Dates.contentSize.height
            self.onClose?()
        }
        
        return cell
    }
}

*/
