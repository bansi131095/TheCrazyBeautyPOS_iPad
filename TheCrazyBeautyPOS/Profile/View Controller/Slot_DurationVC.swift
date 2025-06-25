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
        self.txt_SlotDuration.text = arr_SlotDuration[0]
        select_Slot = "5 Minutes"
    }
    
    @IBAction func btn_SlotDuration(_ sender: Any) {
        openSlotDuration()
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
            if index == 0{
                select_Slot = "5 Minutes"
            }else if index == 1{
                select_Slot = "10 Minutes"
            }else if index == 2{
                select_Slot = "15 Minutes"
            }else if index == 3{
                select_Slot = "20 Minutes"
            }else if index == 4{
                select_Slot = "25 Minutes"
            }else if index == 5{
                select_Slot = "30 Minutes"
            }
            print(select_Slot)
        }
    }
}

