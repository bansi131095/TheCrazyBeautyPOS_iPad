//
//  Business_InformationVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 14/07/25.
//

import UIKit

class Business_InformationVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var lbl_First: UILabel!
    @IBOutlet weak var lbl_Second: UILabel!
    @IBOutlet weak var lbl_Third: UILabel!
    
    @IBOutlet weak var vw_First: GradientButton!
    @IBOutlet weak var vw_Second: UIView!
    @IBOutlet weak var vw_Third: UIView!
    @IBOutlet weak var containerView: UIView!
    
    //MARK: - Global Variable
    var id = Int()
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEmbeddedViewController(for: 0)
        apicall()
    }
    
    //MARK: - Button Action
    @IBAction func btn_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_First(_ sender: Any) {
    }
    
    @IBAction func btn_Second(_ sender: Any) {
        /*applyGradient(to: vw_Second, startColor: #colorLiteral(red: 0.8039215686, green: 0.1882352941, blue: 1, alpha: 1), endColor: #colorLiteral(red: 0.4784313725, green: 0.2235294118, blue: 0.9725490196, alpha: 1))
        lbl_Second.textColor = .white*/
    }
    
    @IBAction func btn_Third(_ sender: Any) {
        /*applyGradient(to: vw_Third, startColor: #colorLiteral(red: 0.8039215686, green: 0.1882352941, blue: 1, alpha: 1), endColor: #colorLiteral(red: 0.4784313725, green: 0.2235294118, blue: 0.9725490196, alpha: 1))
        lbl_Third.textColor = .white*/
    }
    
    
    //MARK: - Function
    func applyGradient(to view: UIView, startColor: UIColor, endColor: UIColor) {
        // Remove old gradient if it exists
        view.layer.sublayers?
            .filter { $0 is CAGradientLayer }
            .forEach { $0.removeFromSuperlayer() }

        let gradient = CAGradientLayer()
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.frame = view.bounds
        gradient.cornerRadius = view.layer.cornerRadius

        view.layer.insertSublayer(gradient, at: 0)
    }

    func loadEmbeddedViewController(for index: Int) {
            // Optionally switch based on index if you have multiple VCs
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        var selectedVC: UIViewController?

        switch index {
        case 0:
            selectedVC = storyboard.instantiateViewController(withIdentifier: "BusinessFirst_InformationVC") as? BusinessFirst_InformationVC
//            selectedVC.Vendor_ID = id
        default:
            print("Invalid index")
            return
        }

        // Remove old child
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }

        if let vc = selectedVC {
            addChild(vc)
            vc.view.frame = containerView.bounds
            containerView.addSubview(vc.view)
            vc.didMove(toParent: self)
        }
    }

    //MARK: - Web Api Calling
    func apicall(){
        APIService.shared.AddVendorData(salon_id: LocalData.userId) { result in
            if let response = result {
                if let results = response.data?.result {
                    for vendor in results {
                        self.id = vendor.id ?? 0
                    }
                }
            }
        }
    }
}
