//
//  Team_SequenceVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 26/06/25.
//

import UIKit

class Team_SequenceVC: UIViewController {

    @IBOutlet weak var tbl_TeamSequnence: UITableView!
    @IBOutlet weak var tbl_Height: NSLayoutConstraint!
    
    var TeamDetails: [TeamDetailsModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        get_TeamDetails()
    }
    
    
    func setTableView(){
        tbl_TeamSequnence.register(UINib(nibName: "TeamSequnenceCell", bundle: nil), forCellReuseIdentifier: "TeamSequnenceCell")
        tbl_TeamSequnence.delegate = self
        tbl_TeamSequnence.dataSource = self
        tbl_TeamSequnence.rowHeight = UITableView.automaticDimension
        tbl_TeamSequnence.estimatedRowHeight = 70
        tbl_TeamSequnence.reloadData()
    }
    
    
    @IBAction func btn_Save(_ sender: Any) {
       var sequenceArray: [[String: String]] = []
        for i in 0..<TeamDetails.count {
            let indexPath = IndexPath(row: i, section: 0)
            if let cell = tbl_TeamSequnence.cellForRow(at: indexPath) as? TeamSequnenceCell {
                let sequenceText = cell.txt_Sequence.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                
                if sequenceText.isEmpty {
                    alertWithImage(title: "Team Sequence", Msg: "Duplicate sequence found!")
                    return
                }

                TeamDetails[i].sequence = sequenceText

                let dict: [String: String] = [
                    "staff_id": "\(TeamDetails[i].id)",
                    "sequence": sequenceText
                ]
                sequenceArray.append(dict)
            }
        }
        
        APIService.shared.updateStaffSequence(staffSequenceList: sequenceArray, vendorid: LocalData.userId) { result in
            if result?.data != nil {
                self.alertWithMessageOnly(result?.data ?? "")
            } else {
                self.alertWithMessageOnly(result?.error ?? "")
            }
        }
    }
    
    func get_TeamDetails(){
        APIService.shared.fetchTeamDetails(vendorId: LocalData.userId) { result in
            self.TeamDetails = result!.data
            self.get_staffSequence()
        }
    }
    
    func get_staffSequence(){
        APIService.shared.fetchStaffsequence(vendorId: LocalData.userId) { result in
            guard let sequenceArray = result?.data.first?.staffSequenceArray else { return }
            for i in 0..<self.TeamDetails.count {
                let staff = self.TeamDetails[i]
                if let matched = sequenceArray.first(where: { $0.staff_id == "\(staff.id)" }) {
                    self.TeamDetails[i].sequence = matched.sequence
                }
            }
            self.tbl_TeamSequnence.reloadData()
            self.tbl_Height.constant = self.tbl_TeamSequnence.contentSize.height
        }
    }
    
}

extension Team_SequenceVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TeamDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl_TeamSequnence.dequeueReusableCell(withIdentifier: "TeamSequnenceCell") as! TeamSequnenceCell
        let data = TeamDetails[indexPath.row]
        cell.lbl_UserName.text = "\(data.first_name)" + "\(data.last_name)"
        cell.txt_Sequence.text = data.sequence
        if data.photo != "" {
            let imgUrl = global.imageUrl + data.photo
            if let url = URL(string: imgUrl) {
                cell.img_User.sd_setImage(with: url, completed: { (image, error, _, _) in
                    if let error = error {
                        print("❌ Failed to load image: \(error.localizedDescription)")
                        cell.img_User.image = UIImage(named: "ProductDemo")
                    } else {
                        cell.img_User.image = image
                    }
                })
            }
        }
        return cell
    }
}
