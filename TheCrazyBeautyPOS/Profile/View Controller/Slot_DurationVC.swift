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
    
    var arr_SlotDuration: [String] = ["5 Minutes","10 Minutes","15 Minutes","20 Minutes","25 Minutes","30 Minutes"]
    var select_Slot: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func openSlotDuration() {
        let slotDuration = DropDown()
        slotDuration.anchorView = txt_SlotDuration
        slotDuration.bottomOffset = CGPoint(x: 0, y:(slotDuration.anchorView?.plainView.bounds.height)!)
        slotDuration.direction = .bottom
        slotDuration.dataSource = arr_SlotDuration
        slotDuration.cellHeight = 35
        slotDuration.show()
        
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
        let selectedTimeGap = getPenaltyDurationValue() // e.g. "6", "10", etc.
        
        APIService.shared.updateTimeGap(vendorId: LocalData.userId, time_gap: selectedTimeGap) { result in
            if result?.data != nil {
                self.alertWithMessageOnly(result?.data ?? "")
            } else {
                self.alertWithMessageOnly(result?.error ?? "")
            }
        }
    }
}

