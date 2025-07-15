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
    
    //MARK: - Global Variable
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Button Action
    @IBAction func btn_First(_ sender: Any) {
    }
    
    @IBAction func btn_Second(_ sender: Any) {
        applyGradient(to: vw_Second, startColor: #colorLiteral(red: 0.8039215686, green: 0.1882352941, blue: 1, alpha: 1), endColor: #colorLiteral(red: 0.4784313725, green: 0.2235294118, blue: 0.9725490196, alpha: 1))
        lbl_Second.textColor = .white
    }
    
    @IBAction func btn_Third(_ sender: Any) {
        applyGradient(to: vw_Third, startColor: #colorLiteral(red: 0.8039215686, green: 0.1882352941, blue: 1, alpha: 1), endColor: #colorLiteral(red: 0.4784313725, green: 0.2235294118, blue: 0.9725490196, alpha: 1))
        lbl_Third.textColor = .white
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



    
    //MARK: - Web Api Calling
}
