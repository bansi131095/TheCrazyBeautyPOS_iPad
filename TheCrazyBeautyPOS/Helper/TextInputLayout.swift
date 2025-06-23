//
//  TextInputLayout.swift
//  AladdinCMMS
//
//  Created by Developer on 05/06/2018.
//  Copyright © 2018 SGE. All rights reserved.
//

import Foundation
import UIKit

enum PlaceHolderDirection: String {
    case placeholderUp = "up"
    case placeholderDown = "down"
    
}
class TextInputLayout: UITextField {
    var enableMaterialPlaceHolder : Bool = true
    var placeholderAttributes = NSDictionary()
    var lblPlaceHolder = UILabel()
    var defaultFont = UIFont()
    @IBInspectable var difference: CGFloat = 20.0
    var directionMaterial = PlaceHolderDirection.placeholderUp
    let underLine: UIImageView = UIImageView()
    @IBInspectable var isUnderLineAvailabe : Bool = false {
        didSet {
            if self.isUnderLineAvailabe {
                self.addSubview(self.underLine)
            }
            else {
                self.underLine.removeFromSuperview()
            }
        }
    }
    @IBInspectable var underLineColor: UIColor? = UIColor.white {
        didSet {
            underLine.backgroundColor = underLineColor?.withAlphaComponent(0.0)
        }
    }
    
    var errorLabel: UILabel? = nil
    var errorIcon: UIImageView? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Initialize ()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Initialize ()
    }
    func Initialize(){
        self.clipsToBounds = false
        self.addTarget(self, action: #selector(TextInputLayout.textFieldDidChange), for: .editingChanged)
        self.EnableMaterialPlaceHolder(enableMaterialPlaceHolder: true)
        
        underLine.backgroundColor = underLineColor?.withAlphaComponent(0.6)
        //            underLine.frame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)
        underLine.frame = CGRect(x: 0, y: self.frame.size.height-1, width : self.frame.size.width, height : 1)
        
        underLine.clipsToBounds = true
        
        defaultFont = self.font!
        
    }
    

    //    @IBInspectable var placeHolderColor: UIColor? = Constants.COLOR_PRIMARY_DARK {
    //        didSet {
    //            self.attributedPlaceholder = NSAttributedString(string: self.placeholder! as String, attributes:[NSAttributedStringKey.foregroundColor: placeHolderColor!])
    //        }
    //    }
    override internal var placeholder:String?  {
        didSet {
            //  NSLog("placeholder = \(placeholder)")
        }
        willSet {
            let atts  = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.631372549, green: 0.631372549, blue: 0.631372549, alpha: 1), NSAttributedString.Key.font: UIFont.labelFontSize] as [NSAttributedString.Key : Any]
            self.attributedPlaceholder = NSAttributedString(string: newValue!, attributes:atts)
            self.EnableMaterialPlaceHolder(enableMaterialPlaceHolder: self.enableMaterialPlaceHolder)
        }
        
    }
    override internal var attributedText:NSAttributedString?  {
        didSet {
            //  NSLog("text = \(text)")
        }
        willSet {
            if (self.placeholder != nil) && (self.text != "")
            {
                let string = NSString(string : self.placeholder!)
                self.placeholderText(string)
            }
            
        }
    }
    @objc func textFieldDidChange(){
        showLabel()
        removeErrorMessage()
    }
    
    func showLabel(){
        if self.enableMaterialPlaceHolder {
            if (self.text == nil) || (self.text?.count)! > 0 {
                self.lblPlaceHolder.alpha = 1
                self.attributedPlaceholder = nil
                self.lblPlaceHolder.textColor = #colorLiteral(red: 0.631372549, green: 0.631372549, blue: 0.631372549, alpha: 1)
                let fontSize =  self.font!.pointSize;
                self.lblPlaceHolder.font = UIFont.init(name: (self.font?.fontName)!, size: fontSize)
            }
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {() -> Void in
                if (self.text == nil) || (self.text?.count)! <= 0 {
                    self.lblPlaceHolder.font = self.defaultFont
                    self.lblPlaceHolder.frame = CGRect(x: self.lblPlaceHolder.frame.origin.x, y : 0, width :self.frame.size.width, height : self.frame.size.height)
                }
                else {
                    if self.directionMaterial == PlaceHolderDirection.placeholderUp {
                        self.lblPlaceHolder.frame = CGRect(x : self.lblPlaceHolder.frame.origin.x, y : -self.difference, width : self.frame.size.width, height : self.frame.size.height)
                    }else{
                        self.lblPlaceHolder.frame = CGRect(x : self.lblPlaceHolder.frame.origin.x, y : self.difference, width : self.frame.size.width, height : self.frame.size.height)
                    }
                    
                }
            }, completion: {(finished: Bool) -> Void in
            })
        }
    }
    
    func EnableMaterialPlaceHolder(enableMaterialPlaceHolder: Bool){
        self.lblPlaceHolder.removeFromSuperview()
        self.enableMaterialPlaceHolder = enableMaterialPlaceHolder
        self.lblPlaceHolder = UILabel()
        self.lblPlaceHolder.frame = CGRect(x: 0, y : 0, width : 0, height :self.frame.size.height)
        self.lblPlaceHolder.font = UIFont.systemFont(ofSize: 10)
        self.lblPlaceHolder.alpha = 0
        self.lblPlaceHolder.clipsToBounds = true
        self.addSubview(self.lblPlaceHolder)
        self.lblPlaceHolder.attributedText = self.attributedPlaceholder
        //self.lblPlaceHolder.sizeToFit()
    }
    func placeholderText(_ placeholder: NSString){
        let atts  = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.631372549, green: 0.631372549, blue: 0.631372549, alpha: 1), NSAttributedString.Key.font: UIFont.labelFontSize] as [NSAttributedString.Key : Any]
        self.attributedPlaceholder = NSAttributedString(string: placeholder as String , attributes:atts)
        self.EnableMaterialPlaceHolder(enableMaterialPlaceHolder: self.enableMaterialPlaceHolder)
    }
    
    
    func showErrorMessage (message: String) {
        if(errorLabel != nil){
            errorLabel?.removeFromSuperview()
            errorLabel = nil
        }
        if(errorIcon != nil){
            errorIcon?.removeFromSuperview()
            errorIcon = nil
        }
        
        errorIcon = UIImageView ()
        errorIcon?.image = UIImage(named: "error_icon")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        errorIcon?.frame = CGRect(x: self.frame.width - self.frame.height * 0.5, y: self.frame.height * 0.25, width: self.frame.height * 0.55, height: self.frame.height * 0.5)
        
        let size = StringUtils.getSizeForText(text: message, font: UIFont.systemFont(ofSize: 12.0), maxSize: self.frame.size)
        errorLabel = UILabel ()
        errorLabel?.font = UIFont.systemFont(ofSize: 12.0)
        errorLabel?.textColor = UIColor(red: 213 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1.0)
        errorLabel?.text = message
        errorLabel?.frame = CGRect(x: self.frame.width - self.frame.height * 0.5 - 8 - size.width, y: (self.frame.height - size.height) / 2, width: size.width, height: size.height)
        
        self.addSubview(errorIcon!)
        self.addSubview(errorLabel!)
    }
    
    func removeErrorMessage () {
        if(errorLabel != nil){
            errorLabel?.removeFromSuperview()
            errorLabel = nil
        }
        if(errorIcon != nil){
            errorIcon?.removeFromSuperview()
            errorIcon = nil
        }
    }
    
    
    override func becomeFirstResponder()->(Bool){
        let returnValue = super.becomeFirstResponder()
        return returnValue
    }
    override func resignFirstResponder()->(Bool){
        let returnValue = super.resignFirstResponder()
        return returnValue
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: self.difference, left: 0, bottom: 8, right: 12))
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: self.difference, left: 0, bottom: 8, right: 12))
    }
    
}
