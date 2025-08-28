//
//  PatchTestList_VC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 11/08/25.
//

import UIKit
import DropDown
import FSCalendar

class PatchTestList_VC: UIViewController,UIPopoverPresentationControllerDelegate {

    
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var vw_MainPopup: UIView!
    @IBOutlet weak var vw_SubPopup: UIView!
    @IBOutlet weak var txt_Title: TextInputLayout!
    @IBOutlet weak var txt_DateOfBirth: TextInputLayout!
    @IBOutlet weak var txt_Status: TextInputLayout!
    @IBOutlet weak var txt_TestedBy: TextInputLayout!
    @IBOutlet weak var txt_Desc: FloatingTextView!
    
    var id = String()
    var teamList: [TeamListResponseModel] = []
    var arr_Status = ["Pending","Passed","Failed"]
    var staffList: [StaffData] = []
    
    
    var calendar: FSCalendar!
    var calendarVC: UIViewController?
    var selectedDate: Date = Date.now
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vw_MainPopup.isHidden = true
        self.vw_SubPopup.isHidden = true
        setTableView()
        test(id:id)
        loadData()
        setCustomFont()
        // Do any additional setup after loading the view.
    }
    
    func setTableView(){
        tbl_vw.register(UINib(nibName: "PatchTestCell", bundle: nil), forCellReuseIdentifier: "PatchTestCell")
        tbl_vw.register(UINib(nibName: "PatchTestHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "PatchTestHeaderCell")
        tbl_vw.delegate = self
        tbl_vw.dataSource = self
        tbl_vw.rowHeight = UITableView.automaticDimension
        tbl_vw.estimatedRowHeight = 60
    }
    
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Regular", size: 20.0) {
            txt_Title.font = customFont
            txt_DateOfBirth.font = customFont
            txt_Status.font = customFont
            txt_TestedBy.font = customFont
        }
    }
    
    func test(id:String){
        self.showLoader()
        APIService.shared.fetchTestDetails(customer_id: id) { (result) in
            self.hideLoader()
        guard let model = result else {
            return
        }
            let newItems = model.data
            if newItems.isEmpty{
                self.tbl_vw.isHidden = true
                self.showNoDataMessage("No more data found", in: self.view)
            }else{
                self.teamList = result?.data ?? []
                self.tbl_vw.isHidden = false
                self.tbl_vw.reloadData()
                self.hideNoDataMessage()
            }
        }
    }
    
    func loadData() {
        showLoader()
        APIService.shared.getteamDetails(page: "", limit: "10", vendorId: LocalData.userId, search: "", isTeamDetails: 1) { staffResult in
            self.hideLoader()
            self.staffList = staffResult?.data ?? []
        }
    }
    
    func openStaff() {
       var itemArray: [String] = []

       for i in self.staffList {
           itemArray.append("\(i.firstName ?? "")" + "\(i.lastName ?? "")")
       }

       let slotDuration = DropDown()
       slotDuration.anchorView = txt_TestedBy
       slotDuration.bottomOffset = CGPoint(x: 0, y: (slotDuration.anchorView?.plainView.bounds.height) ?? 0)
       slotDuration.direction = .bottom
       slotDuration.dataSource = itemArray
       slotDuration.cellHeight = 35
       slotDuration.show()

       slotDuration.selectionAction = { [unowned self] (index: Int, item: String) in
           txt_TestedBy.text = item
           for i in self.staffList {
               if "\(i.firstName ?? "")" + "\(i.lastName ?? "")" == item {
                   txt_TestedBy.text = "\(i.firstName ?? "")" + "\(i.lastName ?? "")"
                   break
               }
           }
       }
    }
    
    func openStatus() {
        let Status = DropDown()
        Status.anchorView = txt_Status
        Status.bottomOffset = CGPoint(x: 0, y:(Status.anchorView?.plainView.bounds.height)!)
        Status.direction = .bottom
        Status.dataSource = arr_Status
        Status.cellHeight = 35
        Status.show()
        
        Status.selectionAction = {  [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.txt_Status.text = item
        }
    }
    
    func showCalendarPopup(sourceView: UIView) {
        calendarVC = UIViewController()
        calendarVC?.modalPresentationStyle = .popover
        calendarVC?.preferredContentSize = CGSize(width: 500, height: 400)

        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 500, height: 400))
        calendar.delegate = self
        calendar.dataSource = self
        calendar.select(selectedDate)
        calendarVC?.view.addSubview(calendar)

        if let popover = calendarVC?.popoverPresentationController {
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
            popover.permittedArrowDirections = .any
        }

        self.present(calendarVC!, animated: true, completion: nil)
    }
    
    func Apiservice(customer_id:String,description:String,status:String,tested_by:String,tested_date:String,title:String) {
        showLoader()
        APIService.shared.UpdateNewTest(customer_id: customer_id, description: description, status: status, tested_by: tested_by, tested_date: tested_date, title: title) { result in
            self.hideLoader()
                guard let model = result else {
                    return
                }
                self.hideLoader()
                if model.error == "" || model.error == nil {
                    self.showToast(message: "Test details added successfully")
                    self.txt_Title.text = ""
                    self.txt_DateOfBirth.text = ""
                    self.txt_Status.text = ""
                    self.txt_TestedBy.text = ""
                    self.txt_Desc.text = ""
                    self.test(id:self.id)
                }else{
                    self.show_alert(msg: model.error ?? "", title: "Update Staff")
                }
            }
        }
    
    @IBAction func btn_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    @IBAction func btn_TestAdd(_ sender: Any) {
        self.vw_MainPopup.isHidden = false
        self.vw_SubPopup.isHidden = false
        self.hideNoDataMessage()
    }
    
    @IBAction func btn_Close(_ sender: Any) {
        self.vw_MainPopup.isHidden = true
        self.vw_SubPopup.isHidden = true
        self.test(id: id)
        self.txt_Title.text = ""
        self.txt_DateOfBirth.text = ""
        self.txt_Status.text = ""
        self.txt_TestedBy.text = ""
        self.txt_Desc.text = ""
    }
    
    @IBAction func btn_AddTest(_ sender: Any) {
        if txt_Title.text == "" {
            alertWithImage(title: "Add New Test", Msg: "Title is required.")
        }else if self.txt_DateOfBirth.text == "" {
            alertWithImage(title: "Add New Test", Msg: "Test Date is required.")
        }else if self.txt_Status.text == ""{
            alertWithImage(title: "Add New Test", Msg: "Status is required.")
        }else if self.txt_TestedBy.text == ""{
            alertWithImage(title: "Add New Test", Msg: "Tested By is required.")
        }else{
            self.vw_MainPopup.isHidden = true
            self.vw_SubPopup.isHidden = true
            Apiservice(customer_id: self.id, description: self.txt_Desc.text, status: self.txt_Status.text ?? "", tested_by: self.txt_TestedBy.text ?? "", tested_date: self.txt_DateOfBirth.text ?? "", title: self.txt_Title.text ?? "")
        }
    }
    
    @IBAction func btn_Cancel(_ sender: Any) {
        self.vw_MainPopup.isHidden = true
        self.vw_SubPopup.isHidden = true
        self.test(id: id)
        self.txt_Title.text = ""
        self.txt_DateOfBirth.text = ""
        self.txt_Status.text = ""
        self.txt_TestedBy.text = ""
        self.txt_Desc.text = ""
    }
    
    @IBAction func btn_TestedBy(_ sender: Any) {
        openStaff()
    }
    
    @IBAction func btn_Status(_ sender: Any) {
        openStatus()
    }
    
}

extension PatchTestList_VC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PatchTestHeaderCell") as? PatchTestHeaderCell else {
                return nil
            }

            // Customize your header view
            return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl_vw.dequeueReusableCell(withIdentifier: "PatchTestCell", for: indexPath) as! PatchTestCell
        let data = teamList[indexPath.row]
        cell.lbl_Name.text = data.title?.capitalized ?? ""
        cell.lbl_Test_Date.text = data.tested_date?.capitalized ?? ""
        cell.lbl_TestBy.text = data.tested_by?.capitalized ?? ""
        cell.lbl_TestStatus.text = data.status?.capitalized ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
}

extension PatchTestList_VC: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        self.txt_DateOfBirth.text = formatter.string(from: selectedDate)
        self.txt_DateOfBirth.showLabel()
        calendarVC?.dismiss(animated: true)
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
            return Date() // today's date as max
        }
}

extension PatchTestList_VC: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == txt_DateOfBirth) {
            showCalendarPopup(sourceView: textField)
            return false // Prevent keyboard
        } else {
            return true
        }
    }
    
}

