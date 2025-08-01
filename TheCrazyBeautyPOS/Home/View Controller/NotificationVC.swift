//
//  NotificationVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 14/07/25.
//

import UIKit

class NotificationVC: UIViewController {

    @IBOutlet weak var segmentCard: UISegmentedControl!
    @IBOutlet weak var contentView: UIView!
    
    private var currentVC: UIViewController?

    @IBOutlet weak var vw_AccountActivity: UIView!
    @IBOutlet weak var lbl_AccountActivity: UILabel!
    @IBOutlet weak var vw_BookingHistory: UIView!
    @IBOutlet weak var lbl_BookingHistory: UILabel!
    
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomFont()
        lbl_AccountActivity.textColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
        vw_AccountActivity.backgroundColor = .white
        vw_BookingHistory.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 0.3000000119)
        loadSegment(at: 0)
    }
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Bold", size: 20.0) {
            lbl_AccountActivity.font = customFont
            lbl_BookingHistory.font = customFont
        }
    }
    //MARK: Button Action
    @IBAction func act_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Set Segment
    func setSegment() {
        
        // MARK: - Style the UISegmentedControl
        segmentCard.selectedSegmentTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)// selected segment background

        segmentCard.setTitleTextAttributes([
            .foregroundColor: #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1),
            .font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ], for: .selected)

        segmentCard.setTitleTextAttributes([
            .foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            .font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ], for: .normal)

        segmentCard.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        segmentCard.layer.cornerRadius = 8
        segmentCard.clipsToBounds = true
        
        segmentCard.removeAllSegments()
        ["Account Activity", "Booking History"].enumerated().forEach {
            segmentCard.insertSegment(withTitle: $0.element, at: $0.offset, animated: false)
        }
        segmentCard.selectedSegmentIndex = 0
        segmentCard.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        loadSegment(at: 0)

    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        loadSegment(at: sender.selectedSegmentIndex)
    }

    
    
    @IBAction func btn_AccountActivity(_ sender: Any) {
        lbl_AccountActivity.textColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
        lbl_BookingHistory.textColor = .black
        
        vw_AccountActivity.backgroundColor = .white
        vw_BookingHistory.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 0.3000000119)
        loadSegment(at: 0)
    }
    
    @IBAction func btn_BookingHistory(_ sender: Any) {
        lbl_BookingHistory.textColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
        lbl_AccountActivity.textColor = .black
        
        vw_BookingHistory.backgroundColor = .white
        vw_AccountActivity.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 0.3000000119)
        loadSegment(at: 1)
    }
    
    private func loadSegment(at index: Int) {
        currentVC?.willMove(toParent: nil)
        currentVC?.view.removeFromSuperview()
        currentVC?.removeFromParent()

        var vc: UIViewController?

        switch index {
        case 0:
            vc = storyboard?.instantiateViewController(withIdentifier: "AccountActivityVC")
        case 1:
            vc = storyboard?.instantiateViewController(withIdentifier: "BookingHistoryVC")
        default:
            return
        }

        if let childVC = vc {
            addChild(childVC)
            childVC.view.frame = contentView.bounds
            contentView.addSubview(childVC.view)
            childVC.didMove(toParent: self)
            currentVC = childVC
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
