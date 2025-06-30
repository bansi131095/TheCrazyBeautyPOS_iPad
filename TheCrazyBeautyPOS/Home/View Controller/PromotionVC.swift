//
//  PromotionVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 12/06/25.
//

import UIKit

class PromotionVC: UIViewController {

    @IBOutlet weak var segmentCard: UISegmentedControl!
    @IBOutlet weak var contentView: UIView!
    
    private var currentVC: UIViewController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSegment()
        // Do any additional setup after loading the view.
    }
    
    func setSegment() {
        
        // MARK: - Style the UISegmentedControl
        segmentCard.selectedSegmentTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)// selected segment background

        segmentCard.setTitleTextAttributes([
            .foregroundColor: #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1),
            .font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ], for: .selected)

        segmentCard.setTitleTextAttributes([
            .foregroundColor: #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1),
            .font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ], for: .normal)

        segmentCard.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        segmentCard.layer.cornerRadius = 8
        segmentCard.clipsToBounds = true
        
        segmentCard.removeAllSegments()
        ["Gift Card", "Coupon", "Offline Gift Card"].enumerated().forEach {
            segmentCard.insertSegment(withTitle: $0.element, at: $0.offset, animated: false)
        }
        segmentCard.selectedSegmentIndex = 0
        segmentCard.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        loadSegment(at: 0)

    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        loadSegment(at: sender.selectedSegmentIndex)
    }

    private func loadSegment(at index: Int) {
        currentVC?.willMove(toParent: nil)
        currentVC?.view.removeFromSuperview()
        currentVC?.removeFromParent()

        var vc: UIViewController?

        switch index {
        case 0:
            vc = storyboard?.instantiateViewController(withIdentifier: "GiftCardVC")
        case 1:
            vc = storyboard?.instantiateViewController(withIdentifier: "CouponVC")
        case 2:
            vc = storyboard?.instantiateViewController(withIdentifier: "OfflineGiftCardVC")
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
