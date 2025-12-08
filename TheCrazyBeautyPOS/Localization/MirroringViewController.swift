//
//  MirroringViewController.swift
//  tesing ms
//
//  Created by Moath_Othman on 1/27/16.
//  Copyright © 2016 Moath_Othman. All rights reserved.
//

import UIKit
extension UIViewController {
    func loopThroughSubViewAndFlipTheImageIfItsAUIImageView(subviews: [UIView]) {
        if subviews.count > 0 {
            for subView in subviews {
                if (subView is UIImageView) && subView.tag < 0 {
                    let toRightArrow = subView as! UIImageView
                    if let _img = toRightArrow.image {
                        toRightArrow.image = UIImage(cgImage: _img.cgImage!, scale:_img.scale , orientation: UIImage.Orientation.upMirrored)
                    }
                }
                loopThroughSubViewAndFlipTheImageIfItsAUIImageView(subviews: subView.subviews)
            }
        }
    }
    
    func openExernalLink(site:URL?) {
        if site == nil {return}
        let appplink : URL = site!
        if UIApplication.shared.canOpenURL(appplink){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appplink, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appplink)
            }
        }
        else {
//            Commonfunction().showToast(msg: "")
        }
    }
}
class MirroringViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if L102Language.currentAppleLanguage() == "ar" {
            loopThroughSubViewAndFlipTheImageIfItsAUIImageView(subviews: self.view.subviews)
        }
    }
}

