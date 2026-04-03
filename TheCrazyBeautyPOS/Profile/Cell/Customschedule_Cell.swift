//
//  Customschedule_Cell.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 27/03/26.
//

import UIKit

class Customschedule_Cell: UICollectionViewCell {

    @IBOutlet weak var lbl_FromTime: UILabel!
    @IBOutlet weak var lbl_ToTime: UILabel!
    @IBOutlet weak var tbl_Dates: UITableView!
    @IBOutlet weak var tbl_DateHeight: NSLayoutConstraint!
    @IBOutlet weak var txt_OpeningDate: TextInputLayout!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setTableView()
    }
    
    func setTableView(){
        tbl_Dates.register(UINib(nibName: "CustomDate_Cell", bundle: nil), forCellReuseIdentifier: "CustomDate_Cell")
        tbl_Dates.delegate = self
        tbl_Dates.dataSource = self
        tbl_Dates.rowHeight = UITableView.automaticDimension
        tbl_Dates.estimatedRowHeight = 50
        tbl_Dates.backgroundColor = .red
        tbl_Dates.isScrollEnabled = false
    }
    
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.tbl_Dates.reloadData()
            self.tbl_Dates.layoutIfNeeded()
            self.tbl_DateHeight.constant = self.tbl_Dates.contentSize.height
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async {
            self.tbl_DateHeight.constant = self.tbl_Dates.contentSize.height
        }
    }
    
    var Act_From:(()->Void)?
    @IBAction func act_From(_ sender: Any) {
        self.Act_From?()
    }

    var Act_To:(()->Void)?
    @IBAction func act_To(_ sender: Any) {
        self.Act_To?()
    }
    
    var Act_Close:(()->Void)?
    @IBAction func act_Close(_ sender: Any) {
        self.Act_Close?()
    }
    
}
extension Customschedule_Cell: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbl_Dates.dequeueReusableCell(withIdentifier: "CustomDate_Cell", for: indexPath) as? CustomDate_Cell else {
            return UITableViewCell()
        }
        cell.lbl_Date.text = "29-04-2026"
        
//        cell.btnDelete.setTitle("", for: .normal)
        /*let data = self.salonHolidaysList[indexPath.row]
        cell.lbl_fromTo.text = "\(data.from ?? "") to \(data.to ?? "")"
        cell.Act_Delete = {
            self.salonHolidaysList.remove(at: indexPath.row)
            self.tbl_vw.reloadData()
            self.updateHolidaysDate()
        }*/
        return cell
    }


    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
}
