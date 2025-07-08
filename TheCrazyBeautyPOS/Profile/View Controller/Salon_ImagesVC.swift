//
//  Salon_ImagesVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 26/06/25.
//

import UIKit
import BSImagePicker
import Photos
import SDWebImage


struct DisplayImage {
    var imageUrl: String?
    var image: UIImage?
}


class Salon_ImagesVC: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var img_Profile: UIImageView!
    @IBOutlet weak var cv_Imgs: UICollectionView!
    @IBOutlet weak var cv_HeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var lbl_Atleast1: UILabel!
    //MARK: - Global Variable
//    var arr_photo: [UIImage] = []
    var profileModel: [profileDetailsModel] = []
//    var galleryImageArray: [String] = []
    var allImages: [DisplayImage] = []
    var isProfileImageSelection = false
    var isProfileImageRemoved = false
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_Atleast1.isHidden = true
        self.cv_HeightConst.constant = 0
        self.cv_Imgs.isHidden = true
        setCollectCategory()
        get_Image()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCollectionViewHeight()
    }
    
    
    
    //MARK: -  Button Action
    @IBAction func btn_DeleteProfile(_ sender: Any) {
        img_Profile.image = UIImage(named: "img_Upload") // Placeholder
        isProfileImageRemoved = true
    }
    
    @IBAction func btn_UploadImage(_ sender: Any) {
        isProfileImageSelection = false
        if allImages.count >= 5{
            print("Photo photo")
        }else{
            self.showActionSheet()
        }
        /*if arr_photo.count >= 5{
            print("Photo photo")
        }else{
            self.showActionSheet()
        }*/
        
    }
    
    @IBAction func btn_Save(_ sender: Any) {
        if allImages.isEmpty{
            self.lbl_Atleast1.isHidden = false
        }else{
            self.lbl_Atleast1.isHidden = true
        }
        upload_Image()
    }
    
    @IBAction func btn_Profile(_ sender: Any) {
        isProfileImageSelection = true
        self.showActionSheet()
    }
    
    
    //MARK: - Function
    func setCollectCategory() {
        self.cv_Imgs.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        cv_Imgs.dataSource = self
        cv_Imgs.delegate = self
    }
    
    func updateCollectionViewHeight() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.cv_Imgs.layoutIfNeeded()
            self.cv_HeightConst.constant = self.cv_Imgs.collectionViewLayout.collectionViewContentSize.height
        }
    }
    
    //MARK: - OPEN ACTIONSHEET FOR SELECT PHOTOS
    func showActionSheet() {
        let actionSheet = UIAlertController(title: "Select Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Open Gallery", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 100)
            popoverController.permittedArrowDirections = []
        }
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - imagePicker methods
    func camera() {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = UIImagePickerController.SourceType.camera
            self.present(myPickerController, animated: true, completion: nil)
        } else {
            if UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiom.pad {
                self.showAlertToast(message: "You can not open camera in simulator.")
            } else {
                self.showAlertToast(message: "You can not open camera in simulator.")
            }
        }
    }
    
    // MARK: - MULTIPLE IMAGE SELECTION
    func photoLibrary() {
        let vc = ImagePickerController()
        
        vc.settings.fetch.assets.supportedMediaTypes = [.image]
        vc.settings.selection.max = 1
//        vc.settings.fetch.assets.options.fetchLimit = 5
        presentImagePicker(vc, animated: true, select: { (asset: PHAsset) -> Void in
            
            //print("Selected: \(asset)")
        }, deselect: { (asset: PHAsset) -> Void in
            //print("Deselected: \(asset)")
        }, cancel: { (assets: [PHAsset]) -> Void in
            //print("Cancel: \(assets)")
        }, finish: { (assets: [PHAsset]) -> Void in
            guard let asset = assets.first else { return }
            let image = self.convertImageFromAsset(asset: asset)
            if self.isProfileImageSelection {
                    // ✅ Set profile image
                    self.img_Profile.image = image
                self.isProfileImageRemoved = false
                    print("✅ Profile image selected")
                } else {
                    // ✅ Add to gallery images
                    self.allImages.append(DisplayImage(imageUrl: nil, image: image))
                    self.cv_Imgs.isHidden = false
                    self.cv_Imgs.reloadData()
                    self.cv_HeightConst.constant = 600
                    print("✅ Gallery image added")
                }
            self.isProfileImageSelection = false
            /*for imageData in assets  {
                if imageData.mediaType == .image {
                    let imageData1 = self.convertImageFromAsset(asset: imageData)
//                    self.arr_photo.append(imageData1)
                    self.allImages.append(DisplayImage(imageUrl: nil, image: imageData1))
                    self.cv_Imgs.isHidden = false
                    self.cv_Imgs.reloadData()
                    self.cv_HeightConst.constant = 600
                }
            }*/
            /*DispatchQueue.main.async(){
                if self.arr_photo.count != 0 {
                    self.cv_Imgs.isHidden = false
                    self.cv_Imgs.reloadData()
                    self.cv_HeightConst.constant = 600
                }
            }*/
        }, completion: nil)
    }

    func convertImageFromAsset(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var image = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            
            image = result!
        })
        return image
    }
    //MARK: - Web Api Calling
    func get_Image() {
            APIService.shared.fetchProfileImage { result in
                guard let model = result?.data.first else {
                    print("⚠️ No profile data found")
                    return
                }

                // Load profile image
                let imgUrl = global.imageUrl_Profile + (model.profile_photo ?? "")
                if let url = URL(string: imgUrl) {
                    self.img_Profile.sd_setImage(with: url, placeholderImage: UIImage(named: "ProductDemo"))
                }

                // Load gallery images
                if let galleryString = model.gallery_images, !galleryString.isEmpty {
                    let galleryImages = galleryString
                        .components(separatedBy: ", ")

                    self.allImages = galleryImages.map {
                        DisplayImage(imageUrl: global.imageUrl_Profile + $0, image: nil)
                    }

                    DispatchQueue.main.async {
                        self.cv_Imgs.isHidden = false
                        self.cv_Imgs.reloadData()
                        self.cv_HeightConst.constant = 600
                    }
                }
            }
        }
    
    /*func upload_Image() {
        // 1. Separate new and existing images
        let newImages = allImages.filter { $0.image != nil }.compactMap { $0.image }

        let oldImageNames = allImages.compactMap { display -> String? in
            guard let fullUrl = display.imageUrl else { return nil }
            return fullUrl.replacingOccurrences(of: global.imageUrl_Profile, with: "")
        }

        // 2. Prepare profile image from img_Profile (loaded from URL)
        guard let profileImage = img_Profile.image else {
            self.showAlertToast(message: "Profile photo not available")
            return
        }

        print("🟢 Starting upload...")
            print("➡️ New Images Count: \(newImages.count)")
            print("➡️ Existing Images: \(oldImageNames)")
        
        // 3. Upload the data
        APIService.shared.uploadSalonImages(
            vendorId: LocalData.userId,
            photo: profileImage, // ✅ use the image loaded in img_Profile
            photos: newImages,
            otherPhotos: oldImageNames
        ) { response in
            if let res = response {
                print("✅ Upload Success: \(res)")
                self.alertWithMessageOnly("Images uploaded successfully!")
            } else {
                print("❌ Upload failed")
                self.alertWithMessageOnly("Upload failed, please try again.")
            }
        }
    }*/
    
    func upload_Image() {
        // 1. Separate profile image (from imageView)
        guard let profileImage = img_Profile.image, !isProfileImageRemoved else {
            self.alertWithMessageOnly("Profile image not set.")
            return
        }

        // 2. Get all new (local) images picked from gallery/camera
        let galleryImages = allImages.filter { $0.image != nil }.compactMap { $0.image }

        // 3. Get all old image filenames (not URLs, just names like photo-xxx.png)
        let oldImageNames: [String] = allImages.compactMap { display -> String? in
            guard let fullUrl = display.imageUrl else { return nil }
            return fullUrl.replacingOccurrences(of: global.imageUrl_Profile, with: "")
        }

        // 4. Call the API
        APIService.shared.uploadSalonImages(photo: profileImage, otherPhotos: oldImageNames, photos: galleryImages
        ) { response in
            if let result = response {
                print("✅ Upload complete: \(result)")
                self.alertWithMessageOnly("Images uploaded successfully.")
            } else {
                print("❌ Upload failed or response error")
                self.alertWithMessageOnly("Upload failed. Try again.")
            }
        }
    }
    
    @objc func deleteGalleryImage(_ sender: UIButton) {
        let index = sender.tag
        guard index < allImages.count else { return }

        // Remove image from array
        allImages.remove(at: index)

        // Reload collectionView
        cv_Imgs.reloadData()

        // Update height if needed
        if allImages.isEmpty {
            cv_Imgs.isHidden = true
            cv_HeightConst.constant = 0
        } else {
            updateCollectionViewHeight()
        }
    }
}

extension Salon_ImagesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell

        let item = allImages[indexPath.item]
        if let urlStr = item.imageUrl, let url = URL(string: urlStr) {
            print("🌐 Loading gallery image from URL: \(urlStr)")
            cell.img_Upload.sd_setImage(with: url, placeholderImage: UIImage(named: "ProductDemo"))
        } else if let localImage = item.image {
            print("📸 Displaying picked image")
            cell.img_Upload.image = localImage
        }
        cell.btn_Delete.addTarget(self, action: #selector(deleteGalleryImage(_:)), for: .touchUpInside)
        cell.btn_Delete.tag = indexPath.item
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cv_Imgs.frame.width / 3 - 10, height: cv_Imgs.frame.width / 3 - 10)
    }
}

extension Salon_ImagesVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let pickedImage = info[.originalImage] as? UIImage {
            if isProfileImageSelection {
                img_Profile.image = pickedImage
                isProfileImageRemoved = false
            }else{
                self.allImages.append(DisplayImage(imageUrl: nil, image: pickedImage))
                DispatchQueue.main.async {
                    self.cv_Imgs.isHidden = false
                    self.cv_Imgs.reloadData()
                    self.cv_HeightConst.constant = 600
                }
            }
        }
        isProfileImageSelection = false
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isProfileImageSelection = false
        picker.dismiss(animated: true, completion: nil)
    }
}

/*extension Salon_ImagesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("COUNT:-\(self.galleryImageArray.count)")
        return self.galleryImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.cv_Imgs.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let imageName = galleryImageArray[indexPath.item]
        let imgUrl = global.imageUrl_Profile + imageName
        print("📷 Loading gallery image at: \(imgUrl)")
        cell.img_Upload.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "ProductDemo"))
        cell.btn_Delete.tag = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cv_Imgs.frame.size.width/3, height: cv_Imgs.frame.size.height/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.select_coverImageIndex = indexPath.item
        self.cv_Imgs.reloadData()
    }
    
}*/

/*extension Salon_ImagesVC :UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            arr_photo.append(pickedImage)
            self.cv_Imgs.isHidden = false
            self.cv_Imgs.reloadData()
            self.cv_Imgs.layoutIfNeeded()
            self.cv_HeightConst.constant = 600
//            self.updateCollectionViewHeight()
        }
        self.dismiss(animated: true, completion: nil)
    }
}*/


