//
//  AddGiftCard_VC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 28/07/25.
//

import UIKit
import DropDown

class AddGiftCard_VC: UIViewController {
    
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var btn_AddGiftCard: GradientButton!
    @IBOutlet weak var img_User: UIImageView!
    @IBOutlet weak var txt_CardName: TextInputLayout!
    @IBOutlet weak var txt_Price: TextInputLayout!
    @IBOutlet weak var txt_ExpiryDate: TextInputLayout!
    @IBOutlet weak var txt_Status: TextInputLayout!
    
    @IBOutlet weak var lbl_AllField: UILabel!
    @IBOutlet weak var btn_Cancel: UIButton!
    
    // API values (DO NOT localize)
    let statusKeys = ["Active", "Inactive"]
    
    var arr_Status: [String] {
        return [
            NSLocalizedString("Active", comment: ""),
            NSLocalizedString("Inactive", comment: "")
        ]
    }
    var selectedStatus = "Active"
    
    var isEdit = false
    var GiftCardData: GiftCardData?
    var selectedImage: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomFont()
        self.lbl_AllField.text = NSLocalizedString("All fields marked with an asterisk (*) are required.", comment: "")
        txt_Status.text = arr_Status.first
        selectedStatus = statusKeys.first!

        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if self.isEdit {
                self.lbl_Title.text = NSLocalizedString("Edit Gift Card",comment: "")
                self.btn_AddGiftCard.setTitle(NSLocalizedString("Update Gift Card",comment: ""), for: .normal)
                self.setData()
            } else {
                self.lbl_Title.text = NSLocalizedString("Add Gift Card",comment: "")
                self.btn_AddGiftCard.setTitle(NSLocalizedString("Add Gift Card",comment: ""), for: .normal)
                
                if let lang = UserDefaults.standard.object(forKey: global().kSaveLanguageDefaultKey) as? String {
                    if lang == "en"{
                        self.img_User.image = UIImage(named: "img_Upload")
                    }
                    if lang == "zh"{
                        self.img_User.image = UIImage(named: "img_Upload_Chinese")
                    }
                    if lang == "vi"{
                        self.img_User.image = UIImage(named: "img_Upload_VI")
                    }
                }else{
                    self.img_User.image = UIImage(named: "img_Upload")
                }
            }
        }
        let Cancel = NSAttributedString(
            string: NSLocalizedString("Cancel",comment: ""),
            attributes: [
                .font: UIFont(name: "Lato-Regular", size: 16.0)!,
                .foregroundColor: UIColor.red
            ]
        )
        btn_Cancel.setAttributedTitle(Cancel, for: .normal)
    }
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Regular", size: 20.0) {
            txt_CardName.font = customFont
            txt_Price.font = customFont
            txt_ExpiryDate.font = customFont
            txt_Status.font = customFont
        }
    }
    
    func setData(){
        if let photo = GiftCardData?.image, photo != "" {
            let imgUrl = global.imageUrl + photo
            if let url = URL(string: imgUrl) {
                self.img_User.sd_setImage(with: url, completed: { (image, error, _, _) in
                    if let error = error {
                        print("❌ Failed to load image: \(error.localizedDescription)")
                        self.img_User.image = UIImage(named: "user")
                    } else {
                        self.img_User.image = image
                    }
                })
            }
        }
        self.txt_CardName.text = GiftCardData?.card_name
        self.txt_Price.text = GiftCardData?.price
        self.txt_ExpiryDate.text = "\(GiftCardData?.expired_in ?? 0)"
        
        
        self.txt_CardName.showLabel()
        self.txt_Price.showLabel()
        self.txt_ExpiryDate.showLabel()
        self.txt_Status.showLabel()
        if GiftCardData?.status == "Active"{
            selectedStatus = "Active"
            self.txt_Status.text = NSLocalizedString("Active",comment: "")
        }else if GiftCardData?.status == "Inactive"{
            selectedStatus = "Inactive"
            self.txt_Status.text = NSLocalizedString("Inactive",comment: "")
        }
//        self.txt_Status.text = GiftCardData?.status
    }
    
    @IBAction func btn_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_ImgUser(_ sender: UIButton) {
        showImagePickerActionSheet(sourceView: sender)
    }
    
    @IBAction func btn_StatusDropdown(_ sender: Any) {
        openStatus()
    }
    
    @IBAction func btn_Cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_AddGiftCard(_ sender: Any) {
        if !isEdit && selectedImage == nil {
            self.alertWithMessageOnly(NSLocalizedString("Please upload image",comment: ""))
        }else if txt_CardName.text == ""{
            self.alertWithMessageOnly(NSLocalizedString("Card Name is required",comment: ""))
        }else if txt_Price.text == ""{
            self.alertWithMessageOnly(NSLocalizedString("Price is required.",comment: ""))
        }else if txt_ExpiryDate.text == ""{
            self.alertWithMessageOnly(NSLocalizedString("Expire date is required.",comment: ""))
        }else{
            if isEdit{
                updateGiftCard(Id: GiftCardData?.id ?? 0)
            }else{
                AddGiftCard()
            }
        }
    }
    
    //MARK: Function
    func showImagePickerActionSheet(sourceView: UIView) {
        let actionSheet = UIAlertController(title: "Select Image", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.presentImagePicker(sourceType: .camera)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
                self.presentImagePicker(sourceType: .photoLibrary)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // ✅ Important: iPad compatibility
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = sourceView
            popoverController.sourceRect = sourceView.bounds
        }
        
        self.present(actionSheet, animated: true)
    }
    
    
    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true)
    }
    
    func openStatus() {
        let slotDuration = DropDown()
        slotDuration.anchorView = txt_Status
        slotDuration.bottomOffset = CGPoint(x: 0, y:(slotDuration.anchorView?.plainView.bounds.height)!)
        slotDuration.direction = .bottom
        slotDuration.dataSource = arr_Status
        slotDuration.backgroundColor = UIColor.white
        slotDuration.textFont = UIFont(name: "Lato-Regular", size: 18.0)!
        slotDuration.cellHeight = 35
        slotDuration.show()
        
        slotDuration.selectionAction = {  [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            selectedStatus = self.statusKeys[index]
            self.txt_Status.text = NSLocalizedString(item, comment: "")
            
        }
    }
    
    func AddGiftCard(){
        showLoader()
        if self.selectedImage != nil{
            APIService.shared.addGiftCard(card_name: self.txt_CardName.text ?? "", price: self.txt_Price.text ?? "", expired_in: self.txt_ExpiryDate.text ?? "", vendor_id: LocalData.userId, status: selectedStatus, image: self.selectedImage, imageKey: "file") { result in
                self.hideLoader()
                if result != nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        // safe UI code here
                        self.alertWithMessageOnly(NSLocalizedString("Gift card added successfully",comment: ""))
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                    self.alertWithMessageOnly(NSLocalizedString("Failed to insert gift card details",comment: ""))
                }
            }
        }else{
            APIService.shared.addGiftCard(card_name: self.txt_CardName.text ?? "", price: self.txt_Price.text ?? "", expired_in: self.txt_ExpiryDate.text ?? "", vendor_id: LocalData.userId, status: selectedStatus, image: nil, imageKey: "file") { result in
                self.hideLoader()
                if result != nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        // safe UI code here
                        self.alertWithMessageOnly(NSLocalizedString("Gift card added successfully",comment: ""))
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                    self.alertWithMessageOnly(NSLocalizedString("Failed to insert gift card details",comment: ""))
                }
            }
        }
        
    }
    
    func updateGiftCard(Id:Int){
        showLoader()
        if self.selectedImage != nil{
            APIService.shared.UpdateGiftCard(Id: Id, card_name: self.txt_CardName.text ?? "", price: self.txt_Price.text ?? "", expired_in: self.txt_ExpiryDate.text ?? "", vendor_id: LocalData.userId, status: selectedStatus, image: selectedImage, imageKey: "file") { result in
                self.hideLoader()
                if result != nil {
                    self.alertWithMessageOnly(NSLocalizedString("Gift card updated successfully",comment: ""))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                    self.alertWithMessageOnly(NSLocalizedString("Failed to update gift card",comment: ""))
                }
            }
        }else{
            APIService.shared.UpdateGiftCard(Id: Id, card_name: self.txt_CardName.text ?? "", price: self.txt_Price.text ?? "", expired_in: self.txt_ExpiryDate.text ?? "", vendor_id: LocalData.userId, status: selectedStatus, image: nil, imageKey: "file") { result in
                self.hideLoader()
                if result != nil {
                    self.alertWithMessageOnly(NSLocalizedString("Gift card updated successfully",comment: ""))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                    self.alertWithMessageOnly(NSLocalizedString("Failed to update gift card",comment: ""))
                }
            }
        }
        
    }
}

extension AddGiftCard_VC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        if let selectedImage = info[.originalImage] as? UIImage {
            // Use selectedImage (e.g. assign to UIImageView)
            print("Image selected")
            self.img_User.image = selectedImage
            self.selectedImage = selectedImage
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

}

