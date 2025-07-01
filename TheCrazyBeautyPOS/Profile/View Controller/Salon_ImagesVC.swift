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


class Salon_ImagesVC: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var img_Profile: UIImageView!
    @IBOutlet weak var cv_Imgs: UICollectionView!
    @IBOutlet weak var cv_HeightConst: NSLayoutConstraint!
    
    //MARK: - Global Variable
    var arr_photo: [UIImage] = []
    var profileModel: [profileDetailsModel] = []
    var galleryImageArray: [String] = []

    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    @IBAction func btn_UploadImage(_ sender: Any) {
        if arr_photo.count >= 5{
            print("Photo photo")
        }else{
            self.showActionSheet()
        }
        
    }
    
    @IBAction func btn_Save(_ sender: Any) {
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
            //print("Finish: \(assets)")
            //self.array = assets
            print("Array:\(assets)")
            
                
            for imageData in assets  {
                if imageData.mediaType == .image {
                    let imageData1 = self.convertImageFromAsset(asset: imageData)
                    self.arr_photo.append(imageData1)
                    self.cv_Imgs.isHidden = false
                    self.cv_Imgs.reloadData()
                    self.cv_HeightConst.constant = 600
//                    self.updateCollectionViewHeight()
                }
            }
            DispatchQueue.main.async(){
                if self.arr_photo.count != 0 {
                    self.cv_Imgs.isHidden = false
                    self.cv_Imgs.reloadData()
                    self.cv_HeightConst.constant = 600
//                    self.updateCollectionViewHeight()
                }
            }
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

            let imgUrl = global.imageUrl_Profile + (model.profile_photo ?? "")
            print("🌐 Loading image from: \(imgUrl)")
            
            if let galleryString = model.gallery_images, !galleryString.isEmpty {
                self.galleryImageArray = galleryString
                    .components(separatedBy: ", ")
                    /*.map { $0.trimmingCharacters(in: .whitespacesAndNewlines)
                    }*/
                DispatchQueue.main.async {
                    self.cv_Imgs.isHidden = false
                    self.cv_Imgs.reloadData()
                    self.cv_HeightConst.constant = 600
                }
            }
            
            if let url = URL(string: imgUrl) {
                self.img_Profile.sd_setImage(with: url, placeholderImage: UIImage(named: "ProductDemo")) { image, error, _, _ in
                    if let error = error {
                        print("❌ Failed to load image: \(error.localizedDescription)")
                        self.img_Profile.image = UIImage(named: "ProductDemo")
                    } else {
                        print("✅ Image loaded successfully")
                        self.img_Profile.image = image
                    }
                }
            } else {
                print("❌ Invalid URL: \(imgUrl)")
                self.img_Profile.image = UIImage(named: "ProductDemo")
            }
        }
    }
}

extension Salon_ImagesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.galleryImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.cv_Imgs.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let imageName = galleryImageArray[indexPath.item]
        let imgUrl = global.imageUrl_Profile + imageName
        
        if let url = URL(string: imgUrl) {
            cell.img_Upload.sd_setImage(with: url, placeholderImage: UIImage(named: "ProductDemo"))
        }else{
            cell.img_Upload.image = UIImage(named: "ProductDemo")
        }
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
    
}

extension Salon_ImagesVC :UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
}
