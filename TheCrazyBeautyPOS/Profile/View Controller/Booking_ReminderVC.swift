//
//  Booking_ReminderVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 25/06/25.
//

import UIKit
import DropDown

class Booking_ReminderVC: UIViewController {

    @IBOutlet weak var txt_Reminder: TextInputLayout!
    
    
    var select_Hours: String = ""
    
    let hoursArray = (1...24).map { "\($0) Hours" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txt_Reminder.text = hoursArray[0]
        select_Hours = "1 Hours"
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btn_Reminder(_ sender: Any) {
        openHours()
    }
    
    
    @IBAction func btn_Save(_ sender: Any) {
    }
    
    func openHours() {
        let slotDuration = DropDown()
        slotDuration.anchorView = txt_Reminder
        slotDuration.bottomOffset = CGPoint(x: 0, y: (slotDuration.anchorView?.plainView.bounds.height) ?? 0)
        slotDuration.direction = .bottom
        slotDuration.dataSource = hoursArray
        slotDuration.cellHeight = 35
        slotDuration.show()

        slotDuration.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.txt_Reminder.text = item
            self.select_Hours = item // Example: "5 Hours"
            print("Selected Slot: \(self.select_Hours)")
        }
    }

}
