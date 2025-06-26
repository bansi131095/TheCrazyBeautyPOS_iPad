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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    
    func setTableView(){
        tbl_TeamSequnence.register(UINib(nibName: "TeamSequnenceCell", bundle: nil), forCellReuseIdentifier: "TeamSequnenceCell")
        tbl_TeamSequnence.delegate = self
        tbl_TeamSequnence.dataSource = self
        tbl_TeamSequnence.rowHeight = UITableView.automaticDimension
        tbl_TeamSequnence.estimatedRowHeight = 70
        tbl_TeamSequnence.reloadData()
        tbl_Height.constant = self.tbl_TeamSequnence.contentSize.height
    }
    
    
    @IBAction func btn_Save(_ sender: Any) {
    }
    
}

extension Team_SequenceVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl_TeamSequnence.dequeueReusableCell(withIdentifier: "TeamSequnenceCell") as! TeamSequnenceCell
        return cell
    }
}
