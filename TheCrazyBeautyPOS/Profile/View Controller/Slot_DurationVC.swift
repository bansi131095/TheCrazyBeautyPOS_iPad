//
//  Slot_DurationVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 25/06/25.
//

import UIKit
import DropDown

class Slot_DurationVC: UIViewController {

    @IBOutlet weak var txt_SlotDuration: TextInputLayout!
    @IBOutlet weak var btn_Save: GradientButton!
    
    var arr_SlotDuration: [String] = [NSLocalizedString("5 Minutes", comment: ""),NSLocalizedString("10 Minutes",comment: ""),NSLocalizedString("15 Minutes",comment: ""),NSLocalizedString("20 Minutes",comment: ""),NSLocalizedString("25 Minutes", comment: ""),NSLocalizedString("30 Minutes", comment: "")]
    
    var select_Slot: String = ""
    var ReminderModel: [ReminderModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomFont()
        getTimeGap()
        let title = NSLocalizedString("Save", comment: "")
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 20.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        btn_Save.setAttributedTitle(attributedTitle, for: .normal)
        if let savedSlot = LocalData.setSlotDuration, arr_SlotDuration.contains(savedSlot) {
            select_Slot = savedSlot
        } else {
            select_Slot = arr_SlotDuration[0]
        }
        txt_SlotDuration.text = select_Slot
    }
    
    @IBAction func btn_SlotDuration(_ sender: Any) {
        openSlotDuration()
    }
    
    
    @IBAction func btn_Save(_ sender: UIButton) {
        update_TimeGap()
    }
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Medium", size: 18.0) {
            txt_SlotDuration.font = customFont
        }
    }
    
    func openSlotDuration() {
        let slotDuration = DropDown()
        slotDuration.anchorView = txt_SlotDuration
        slotDuration.bottomOffset = CGPoint(x: 0, y:(slotDuration.anchorView?.plainView.bounds.height)!)
        slotDuration.direction = .bottom
        slotDuration.dataSource = arr_SlotDuration
        slotDuration.cellHeight = 35
        slotDuration.show()
        slotDuration.textFont = UIFont(name: "Lato-Regular", size: 18.0)!
        slotDuration.backgroundColor = .white
        slotDuration.selectionAction = {  [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.txt_SlotDuration.text = item
            select_Slot = item
            LocalData.setSlotDuration = item
        }
    }
    
    func getPenaltyDurationValue() -> String {
        switch select_Slot {
        case "5 Minutes":
            return "5"
        case "10 Minutes":
            return "10"
        case "15 Minutes":
            return "15"
        case "20 Minutes":
            return "20"
        case "25 Minutes":
            return "25"
        case "30 Minutes":
            return "30"
        default:
            return "0"
        }
    }
    
    
    func update_TimeGap(){
        self.showLoader()
        let selectedTimeGap = getPenaltyDurationValue() // e.g. "6", "10", etc.
        
        APIService.shared.updateTimeGap(vendorId: LocalData.userId, time_gap: selectedTimeGap) { result in
            self.hideLoader()
            if result?.data != nil {
                self.alertWithMessageOnly(result?.data ?? "")
            } else {
                self.alertWithMessageOnly(result?.error ?? "")
            }
        }
    }
    
    func getTimeGap(){
        self.showLoader()
        APIService.shared.getTimeGap { result in
            self.hideLoader()
            if result?.data != nil {
                self.ReminderModel = (result?.data)!
                self.txt_SlotDuration.text = "\(self.ReminderModel[0].time_gap ?? "")" + " Minutes"
            }else{
                self.alertWithMessageOnly(result?.error ?? "")
            }
        }
    }
}

