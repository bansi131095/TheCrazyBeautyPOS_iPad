//
//  Booking_PolicyVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 25/06/25.
//

import UIKit

class Booking_PolicyVC: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var txtvw_Note: UITextView!
    
    @IBOutlet weak var btn_Save: GradientButton!
    //MARK: - Global Variable
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        get_Notes()
        let attributedTitle = NSAttributedString(
            string: "Save",
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 22)!,
                .foregroundColor: UIColor.white
            ]
        )
        btn_Save.setAttributedTitle(attributedTitle, for: .normal)
        setCustomFont()
    }
    
    //MARK: -  Button Action
    @IBAction func btn_Save(_ sender: Any) {
        update_Notes()
    }
    
    //MARK: - Function
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Medium", size: 20.0) {
            txtvw_Note.font = customFont
        }
    }
    
    //MARK: - Web Api Calling
    func get_Notes(){
        self.showLoader()
        APIService.shared.fetchNotes { result in
            self.hideLoader()
//            self.txtvw_Note.text = result?.data.first?.notes
            if let data = result?.data.first?.notes.data(using: .utf8) {
                do {
                    let attributedString = try NSAttributedString(
                        data: data,
                        options: [
                            .documentType: NSAttributedString.DocumentType.html,
                            .characterEncoding: String.Encoding.utf8.rawValue
                        ],
                        documentAttributes: nil
                    )
                    let mutableAttrStr = NSMutableAttributedString(attributedString: attributedString)
                       let fullRange = NSRange(location: 0, length: mutableAttrStr.length)
                       mutableAttrStr.addAttribute(.font, value: UIFont(name: "Lato-Medium", size: 20.0)!, range: fullRange)
                       
                       self.txtvw_Note.attributedText = mutableAttrStr
                    
                } catch {
                    print("❌ Error parsing HTML: \(error)")
//                    txtvw_Note.text = htmlString   fallback
                }
            }
        }
    }
    
    func update_Notes(){
        self.showLoader()
        APIService.shared.UpdateNotes(vendorId: LocalData.userId, notes: self.txtvw_Note.text ?? "") { result in
            self.hideLoader()
            if let message = result?.data{
                self.alertWithMessageOnly(message)
            }else{
                self.alertWithMessageOnly("Something went wrong.")
            }
        }
    }
}
