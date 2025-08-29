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
    
    
    var arr_Status = ["Active","Inactive"]
    var isEdit = false
    var GiftCardData: GiftCardData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomFont()
        txt_Status.text = arr_Status.first
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if self.isEdit {
                self.lbl_Title.text = "Edit Gift Card"
                self.btn_AddGiftCard.setTitle("Update Gift Card", for: .normal)
                self.setData()
            } else {
                self.lbl_Title.text = "Add Gift Card"
                self.btn_AddGiftCard.setTitle("Add Gift Card", for: .normal)
            }
        }
        
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
        self.txt_Status.text = GiftCardData?.status
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
        if img_User.image == nil || img_User.image == UIImage(named: "upload") {
            self.showToast(message: "Please select a user image.")
        }else if txt_CardName.text == ""{
            self.showToast(message: "Card Name is required.")
        }else if txt_Price.text == ""{
            self.showToast(message: "Price is required.")
        }else if txt_ExpiryDate.text == ""{
            self.showToast(message: "Expiry In Days is required.")
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
            self.txt_Status.text = item
        }
    }
    
    func AddGiftCard(){
        showLoader()
        APIService.shared.addGiftCard(card_name: self.txt_CardName.text ?? "", price: self.txt_Price.text ?? "", expired_in: self.txt_ExpiryDate.text ?? "", vendor_id: LocalData.userId, status: self.txt_Status.text ?? "", image: self.img_User.image, imageKey: "file") { result in
            self.hideLoader()
            if result != nil {
                DispatchQueue.main.async {
                    // safe UI code here
                    self.showToast(message: result?.data?.message ?? "")
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                self.showToast(message: "Something went wrong")
            }
        }
    }
    
    func updateGiftCard(Id:Int){
        showLoader()
        APIService.shared.UpdateGiftCard(Id: Id, card_name: self.txt_CardName.text ?? "", price: self.txt_Price.text ?? "", expired_in: self.txt_ExpiryDate.text ?? "", vendor_id: LocalData.userId, status: self.txt_Status.text ?? "", image: self.img_User.image, imageKey: "file") { result in
            self.hideLoader()
            if result != nil {
                DispatchQueue.main.async {
                    // safe UI code here
                    self.showToast(message: result?.data?.message ?? "")
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                self.showToast(message: "Something went wrong")
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
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

}

