//
//  General_InfoVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 04/07/25.
//

enum ColorApplyMode {
    case text
    case background
}

enum TextAlignmentType {
    case left
    case center
    case right
}

import UIKit
import DropDown
import GoogleMaps
import CoreLocation
import GooglePlaces

class General_InfoVC: UIViewController, CLLocationManagerDelegate, GMSAutocompleteViewControllerDelegate, GMSMapViewDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name ?? "")")
        print("Place ID: \(place.placeID ?? "")")
        print("Place attributions: \(String(describing: place.attributions))")
        self.dismiss(animated: true, completion: nil)
        self.userLatitude = place.coordinate.latitude
        self.userLongitude = place.coordinate.longitude
        marker.position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        marker.icon = #imageLiteral(resourceName: "location1")
        marker.isFlat = true
        marker.map = self.MapView
        self.SetUpMap()
        //            Pickmarker.isDraggable = true
        self.reverseGeocode(coordinate: place.coordinate)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: any Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func SetUpMap() {
        let camera = GMSCameraPosition.camera(withLatitude:self.userLatitude, longitude: self.userLongitude, zoom: 16)
        self.MapView.camera = camera
//        self.map_vw.bringSubviewToFront(self.img_pin)
    }
    
    func moveMapToCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 15)
        MapView.animate(to: camera)
        
        marker.position = coordinate
        marker.map = MapView
    }
    
    var colorApplyMode: ColorApplyMode = .text
    var arr_SalonType = ["Male","Female","Unisex"]
    
    @IBOutlet weak var txt_Aboutus: UITextView!
    @IBOutlet weak var txt_SalonType: TextInputLayout!
    @IBOutlet weak var map_vw: UIView!
    @IBOutlet weak var map_height_const: NSLayoutConstraint!
    
    
    
    var locationManager = CLLocationManager()
    var userLatitude:CLLocationDegrees! = 0
    var userLongitude:CLLocationDegrees! = 0
    let marker : GMSMarker = GMSMarker()
    var check_current = true
    var fullAdress : String = ""
    var address : String = ""
    var pincode : String = ""
    var MapView:GMSMapView = GMSMapView()
    var str_edit = false
    var dictAddresss: Addresses?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        determineMyCurrentLocation()
    }
    

    @IBAction func btn_Bold(_ sender: Any) {
        toggleBold(textView: txt_Aboutus)
    }
    
    @IBAction func btn_Italic(_ sender: Any) {
        toggleItalic(textView: txt_Aboutus)
    }
    
    @IBAction func btn_Underline(_ sender: Any) {
        toggleUnderline(textView: txt_Aboutus)
    }
    
    @IBAction func btn_Strikethrough(_ sender: Any) {
        toggleStrikethrough(textView: txt_Aboutus)
    }
    
    @IBAction func btn_Superscriptx²(_ sender: Any) {
//        toggleSuperscript(textView: txt_Aboutus)
    }
    
    @IBAction func btn_Subscriptx₂(_ sender: Any) {
//        toggleSubscript(textView: txt_Aboutus)
    }
    
    @IBAction func btn_H1(_ sender: Any) {
        applyHeading(textView: txt_Aboutus, level: 1)
    }
    
    @IBAction func btn_H2(_ sender: Any) {
        applyHeading(textView: txt_Aboutus, level: 2)
    }
    
    @IBAction func btn_H3(_ sender: Any) {
        applyHeading(textView: txt_Aboutus, level: 3)
    }
    
    @IBAction func btn_H4(_ sender: Any) {
        applyHeading(textView: txt_Aboutus, level: 4)
    }
    
    @IBAction func btn_H5(_ sender: Any) {
        applyHeading(textView: txt_Aboutus, level: 5)
    }
    
    @IBAction func btn_H6(_ sender: Any) {
        applyHeading(textView: txt_Aboutus, level: 6)
    }
    
    @IBAction func btn_TextColor(_ sender: Any) {
        showColorPicker(mode: .text)
    }
    
    @IBAction func btn_TextBackgroundColor(_ sender: Any) {
        showColorPicker(mode: .background)
    }
    
    @IBAction func btn_indentButtonTapped(_ sender: UIButton) {
        increaseIndent(textView: txt_Aboutus)
    }
    
    @IBAction func btn_DecreaseIndentButtonTapped(_ sender: UIButton) {
        decreaseIndent(textView: txt_Aboutus)
    }
    
    @IBAction func btn_AlignRight(_ sender: UIButton) {
        applyTextAlignment(textView: txt_Aboutus, alignment: .left)
    }
    
    @IBAction func btn_AlignCenter(_ sender: UIButton) {
        applyTextAlignment(textView: txt_Aboutus, alignment: .center)
    }
    
    @IBAction func btn_AlignLeft(_ sender: UIButton) {
        applyTextAlignment(textView: txt_Aboutus, alignment: .right)
    }
    
    
    @IBAction func btn_Dot(_ sender: Any) {
        toggleBulletList(textView: txt_Aboutus)
    }
    
    @IBAction func btn_Number(_ sender: Any) {
        toggleNumberedList(textView: txt_Aboutus)
    }
    
    
    @IBAction func btn_SalonType(_ sender: Any) {
        openSalonType()
    }
    
    //MARK: - Map function
    func determineMyCurrentLocation()    {
        self.location()
    }
    
    
    //MARK:- display Map on view
    func location()
    {
        locationManager.startUpdatingLocation()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
//        DispatchQueue.main.async {
        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14, *) {
            authorizationStatus = self.locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
            if authorizationStatus == CLAuthorizationStatus.authorizedWhenInUse ||
            authorizationStatus == CLAuthorizationStatus.authorizedAlways {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startMonitoringSignificantLocationChanges()
            self.locationManager.startUpdatingLocation()
            self.MapView.setMinZoom(0, maxZoom: 20)
            if self.str_edit {
                if let dict = self.dictAddresss {
                    if let lat = CLLocationDegrees(dict.address_Latitude ?? ""), let long = CLLocationDegrees(dict.address_Longitude ?? "") {
                        self.userLatitude = lat
                        self.userLongitude = long
                        
                        let camera = GMSCameraPosition.camera(withLatitude: self.userLatitude, longitude: self.userLongitude, zoom: 15)
                        let options = GMSMapViewOptions()
                        options.camera = camera
                        options.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 340)
                        self.MapView = GMSMapView(options: options)
                        //                self.vw_map = MapView
                        self.map_vw.addSubview(self.MapView)
                        self.MapView.delegate = self
                        self.MapView.delegate = self
                        let center = CLLocationCoordinate2D(latitude: self.userLatitude, longitude: self.userLongitude)
                        self.marker.position = center
                        self.marker.isFlat = true
                        self.marker.icon = #imageLiteral(resourceName: "location1")
                        self.marker.map = self.MapView
                    }
                }
            } else {
                if (self.locationManager.location != nil) {
                    // do your things
                    self.userLatitude = self.locationManager.location?.coordinate.latitude
                    self.userLongitude = self.locationManager.location?.coordinate.longitude
                    let camera = GMSCameraPosition.camera(withLatitude: self.userLatitude, longitude: self.userLongitude, zoom: 15)
                    let options = GMSMapViewOptions()
                    options.camera = camera
                    options.frame = self.map_vw.bounds
                    self.MapView = GMSMapView(options: options)
                    //                self.vw_map = MapView
                    self.map_vw.addSubview(self.MapView)
                    self.MapView.delegate = self
                    self.MapView.delegate = self
                    let center = CLLocationCoordinate2D(latitude: self.userLatitude, longitude: self.userLongitude)
                    self.marker.position = center
                    self.marker.isFlat = true
                    self.marker.icon = #imageLiteral(resourceName: "location1")
                    self.marker.map = self.MapView
                } else { }
            }
            
        } else {
            if self.str_edit {
                if let dict = self.dictAddresss {
                    if let lat = CLLocationDegrees(dict.address_Latitude ?? ""), let long = CLLocationDegrees(dict.address_Longitude ?? "") {
                        self.userLatitude = lat
                        self.userLongitude = long
                        
                        let camera = GMSCameraPosition.camera(withLatitude: self.userLatitude, longitude: self.userLongitude, zoom: 15)
                        let options = GMSMapViewOptions()
                        options.camera = camera
                        options.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 340)
                        self.MapView = GMSMapView(options: options)
                        //                self.vw_map = MapView
                        self.map_vw.addSubview(self.MapView)
                        self.MapView.delegate = self
                        self.MapView.delegate = self
                        let center = CLLocationCoordinate2D(latitude: self.userLatitude, longitude: self.userLongitude)
                        self.marker.position = center
                        self.marker.isFlat = true
                        self.marker.icon = #imageLiteral(resourceName: "location1")
                        self.marker.map = self.MapView
                    }
//                    self.txt_Address.text = dict.address
//                    self.adjustTextViewHeight()
//                    self.txt_city.text = dict.city
//                    self.txt_Pincode.text = dict.postal_Code
                }
            }else{
                self.userLatitude = 52.1259096161503
                self.userLongitude = -106.67167916893959
                let camera = GMSCameraPosition.camera(withLatitude: self.userLatitude, longitude: self.userLongitude, zoom: 15)
                let options = GMSMapViewOptions()
                options.camera = camera
                options.frame = self.map_vw.bounds
                self.MapView = GMSMapView(options: options)
                //                self.vw_map = MapView
                self.map_vw.addSubview(self.MapView)
                self.MapView.delegate = self
                self.MapView.delegate = self
                let center = CLLocationCoordinate2D(latitude: self.userLatitude, longitude: self.userLongitude)
                self.marker.position = center
                self.marker.isFlat = true
                self.marker.icon = #imageLiteral(resourceName: "location1")
                self.marker.map = self.MapView
            }
//            self.showLocationPermissionAlert()
            
//        }
        }
    }
    
    func showLocationPermissionAlert() {
        let alert = UIAlertController(title: "Location Permission Required",
                                      message: "Please enable location access in Settings to use this feature.",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                // Pop the current view controller
                self.navigationController?.popViewController(animated: true)
            }))
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            
            if let appSettings = URL(string: UIApplication.openSettingsURLString),
               UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }))

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK:- Map Function
    func reverseGeocode(coordinate: CLLocationCoordinate2D) {
        // 1
        let geocoder = GMSGeocoder()
        
        // 2
        /*geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard
                let address = response?.firstResult(),
                let lines = address.lines
            else {
                
                return
            }
            // 3
            self.txt_Address.text = lines.joined(separator: "\n")
            self.adjustTextViewHeight()
            self.txt_city.text = response?.firstResult()?.locality
            self.txt_Pincode.text = response?.firstResult()?.postalCode
            // 4
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }*/
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard
                let address = response?.firstResult(),
                let lines = address.lines,
                !lines.isEmpty
            else {
                return
            }

            // Example: lines[0] = "137 20th Street West, Saskatoon, Sk S7M 0W7, Canada"
            // Split by comma and take the first part
            let fullLine = lines[0]
            let components = fullLine.components(separatedBy: ",")
            let streetOnly = components.first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            /*DispatchQueue.main.async {
                self.txt_Address.text = streetOnly
                self.txt_city.text = address.locality
                self.txt_Pincode.text = address.postalCode
                self.adjustTextViewHeight()

                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            }*/
        }
    }
    
    
    // Present the Autocomplete view controller when the button is pressed.
    func autocompleteClicked() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: GMSPlaceField.name.rawValue | GMSPlaceField.placeID.rawValue | GMSPlaceField.coordinate.rawValue | GMSPlaceField.formattedAddress.rawValue)
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
//        filter.country = "IN"
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func wrapperFunctionToShowPosition(mapView:GMSMapView) {
        let geocoder = GMSGeocoder()
        let latitute = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        let position = CLLocationCoordinate2DMake(latitute, longitude)
        /*geocoder.reverseGeocodeCoordinate(position) { response , error in
            if error != nil {
                print("GMSReverseGeocode Error: \(String(describing: error?.localizedDescription))")
            } else {
                let result = response?.results()?.first
                let address = result?.lines?.reduce("") { $0 == "" ? $1 : $0 + ", " + $1 }
                                print("Address : \(address!)")
                if self.check_current {
                    self.txt_Address.text = address
                    self.adjustTextViewHeight()
                    self.txt_city.text = result?.locality
                    self.txt_Pincode.text = result?.postalCode
                } else {
                    print(address ?? "")
                }
            }
        }*/
        geocoder.reverseGeocodeCoordinate(position) { response, error in
            if let error = error {
                print("GMSReverseGeocode Error: \(error.localizedDescription)")
                return
            }

            guard let result = response?.results()?.first else {
                print("No address found")
                return
            }

            // Option 1: Get street using subThoroughfare + thoroughfare
            let streetNumber = result.subLocality ?? ""
            let streetName = result.thoroughfare ?? ""
            let streetAddress = "\(streetNumber) \(streetName)".trimmingCharacters(in: .whitespaces)

            // Option 2: fallback if thoroughfare data is missing, use first part of lines
            var fallbackAddress: String = ""
            if let lines = result.lines, let firstLine = lines.first {
                let components = firstLine.components(separatedBy: ",")
                fallbackAddress = components.first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            }

            let finalAddress = streetAddress.isEmpty ? fallbackAddress : streetAddress

            print("Street Address: \(finalAddress)")

            /*if self.check_current {
                self.txt_Address.text = finalAddress
                self.adjustTextViewHeight()
                self.txt_city.text = result.locality
                self.txt_Pincode.text = result.postalCode
            } else {
                print(finalAddress)
            }*/
        }
    }

    
    
    func openSalonType() {
        let slotDuration = DropDown()
        slotDuration.anchorView = txt_SalonType
        slotDuration.bottomOffset = CGPoint(x: 0, y:(slotDuration.anchorView?.plainView.bounds.height)!)
        slotDuration.direction = .bottom
        slotDuration.dataSource = arr_SalonType
        slotDuration.cellHeight = 35
        slotDuration.show()
        
        slotDuration.selectionAction = {  [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.txt_SalonType.text = item
        }
    }
    
    //MARK: - Bold
    func toggleBold(textView: UITextView) {
        let selectedRange = textView.selectedRange
        let mutableAttrText = NSMutableAttributedString(attributedString: textView.attributedText)

        if selectedRange.length > 0 {
            // ✅ If text is selected → toggle bold per portion
            mutableAttrText.enumerateAttributes(in: selectedRange, options: []) { attributes, range, _ in
                let currentFont = attributes[.font] as? UIFont ?? UIFont.systemFont(ofSize: 16)
                var traits = currentFont.fontDescriptor.symbolicTraits

                if traits.contains(.traitBold) {
                    traits.remove(.traitBold)
                } else {
                    traits.insert(.traitBold)
                }

                if let newDescriptor = currentFont.fontDescriptor.withSymbolicTraits(traits) {
                    let newFont = UIFont(descriptor: newDescriptor, size: currentFont.pointSize)
                    mutableAttrText.addAttribute(.font, value: newFont, range: range)
                }
            }

            textView.attributedText = mutableAttrText
            textView.selectedRange = selectedRange

        } else {
            // ✅ No selection → toggle typing attributes for future text
            let currentFont = textView.typingAttributes[.font] as? UIFont ?? UIFont.systemFont(ofSize: 16)
            var traits = currentFont.fontDescriptor.symbolicTraits

            if traits.contains(.traitBold) {
                traits.remove(.traitBold)
            } else {
                traits.insert(.traitBold)
            }

            if let newDescriptor = currentFont.fontDescriptor.withSymbolicTraits(traits) {
                let newFont = UIFont(descriptor: newDescriptor, size: currentFont.pointSize)
                textView.typingAttributes[.font] = newFont
            }
        }
    }
    
    //MARK: - Italic
    func toggleItalic(textView: UITextView) {
        let selectedRange = textView.selectedRange
        let mutableAttrText = NSMutableAttributedString(attributedString: textView.attributedText)

        if selectedRange.length > 0 {
            mutableAttrText.enumerateAttributes(in: selectedRange, options: []) { attributes, range, _ in
                let currentFont = attributes[.font] as? UIFont ?? UIFont.systemFont(ofSize: 16)
                var traits = currentFont.fontDescriptor.symbolicTraits

                if traits.contains(.traitItalic) {
                    traits.remove(.traitItalic)
                } else {
                    traits.insert(.traitItalic)
                }

                if let newDescriptor = currentFont.fontDescriptor.withSymbolicTraits(traits) {
                    let newFont = UIFont(descriptor: newDescriptor, size: currentFont.pointSize)
                    mutableAttrText.addAttribute(.font, value: newFont, range: range)
                }
            }

            textView.attributedText = mutableAttrText
            textView.selectedRange = selectedRange

        } else {
            let currentFont = textView.typingAttributes[.font] as? UIFont ?? UIFont.systemFont(ofSize: 16)
            var traits = currentFont.fontDescriptor.symbolicTraits

            if traits.contains(.traitItalic) {
                traits.remove(.traitItalic)
            } else {
                traits.insert(.traitItalic)
            }

            if let newDescriptor = currentFont.fontDescriptor.withSymbolicTraits(traits) {
                let newFont = UIFont(descriptor: newDescriptor, size: currentFont.pointSize)
                textView.typingAttributes[.font] = newFont
            }
        }
    }

    //MARK: - Underline
    func toggleUnderline(textView: UITextView) {
        let selectedRange = textView.selectedRange
        let mutableAttrText = NSMutableAttributedString(attributedString: textView.attributedText)

        if selectedRange.length > 0 {
            mutableAttrText.enumerateAttributes(in: selectedRange, options: []) { attributes, range, _ in
                let currentUnderline = attributes[.underlineStyle] as? Int ?? 0
                let newUnderline = currentUnderline == 0 ? NSUnderlineStyle.single.rawValue : 0
                mutableAttrText.addAttribute(.underlineStyle, value: newUnderline, range: range)
            }

            textView.attributedText = mutableAttrText
            textView.selectedRange = selectedRange

        } else {
            let currentUnderline = textView.typingAttributes[.underlineStyle] as? Int ?? 0
            let newUnderline = currentUnderline == 0 ? NSUnderlineStyle.single.rawValue : 0
            textView.typingAttributes[.underlineStyle] = newUnderline
        }
    }

    //MARK: - Strikethrough
    func toggleStrikethrough(textView: UITextView) {
        let selectedRange = textView.selectedRange
        let mutableAttrText = NSMutableAttributedString(attributedString: textView.attributedText)

        if selectedRange.length > 0 {
            mutableAttrText.enumerateAttributes(in: selectedRange, options: []) { attributes, range, _ in
                let currentStrike = attributes[.strikethroughStyle] as? Int ?? 0
                let newStrike = currentStrike == 0 ? NSUnderlineStyle.single.rawValue : 0
                mutableAttrText.addAttribute(.strikethroughStyle, value: newStrike, range: range)
            }

            textView.attributedText = mutableAttrText
            textView.selectedRange = selectedRange

        } else {
            let currentStrike = textView.typingAttributes[.strikethroughStyle] as? Int ?? 0
            let newStrike = currentStrike == 0 ? NSUnderlineStyle.single.rawValue : 0
            textView.typingAttributes[.strikethroughStyle] = newStrike
        }
    }

    //MARK: - Superscript
    func toggleSuperscript(textView: UITextView) {
        let selectedRange = textView.selectedRange
        let mutableAttrText = NSMutableAttributedString(attributedString: textView.attributedText)

        if selectedRange.length > 0 {
            mutableAttrText.enumerateAttributes(in: selectedRange, options: []) { attributes, range, _ in
                let currentOffset = attributes[.baselineOffset] as? CGFloat ?? 0
                let newOffset: CGFloat = currentOffset == 0 ? 8 : 0

                mutableAttrText.addAttribute(.baselineOffset, value: newOffset, range: range)
                // Optional: reduce font size for superscript
                let font = attributes[.font] as? UIFont ?? UIFont.systemFont(ofSize: 16)
                mutableAttrText.addAttribute(.font, value: font.withSize(font.pointSize * 0.7), range: range)
            }

            textView.attributedText = mutableAttrText
            textView.selectedRange = selectedRange
        } else {
            // Apply to future typing
            let currentOffset = textView.typingAttributes[.baselineOffset] as? CGFloat ?? 0
            let newOffset: CGFloat = currentOffset == 0 ? 8 : 0
            textView.typingAttributes[.baselineOffset] = newOffset

            let font = textView.typingAttributes[.font] as? UIFont ?? UIFont.systemFont(ofSize: 16)
            textView.typingAttributes[.font] = font.withSize(font.pointSize * 0.7)
        }
    }

    //MARK: - Subscript
    func toggleSubscript(textView: UITextView) {
        let selectedRange = textView.selectedRange
        let mutableAttrText = NSMutableAttributedString(attributedString: textView.attributedText)

        if selectedRange.length > 0 {
            mutableAttrText.enumerateAttributes(in: selectedRange, options: []) { attributes, range, _ in
                let currentOffset = attributes[.baselineOffset] as? CGFloat ?? 0
                let newOffset: CGFloat = currentOffset == 0 ? -4 : 0

                mutableAttrText.addAttribute(.baselineOffset, value: newOffset, range: range)
                let font = attributes[.font] as? UIFont ?? UIFont.systemFont(ofSize: 16)
                mutableAttrText.addAttribute(.font, value: font.withSize(font.pointSize * 0.7), range: range)
            }

            textView.attributedText = mutableAttrText
            textView.selectedRange = selectedRange
        } else {
            let currentOffset = textView.typingAttributes[.baselineOffset] as? CGFloat ?? 0
            let newOffset: CGFloat = currentOffset == 0 ? -4 : 0
            textView.typingAttributes[.baselineOffset] = newOffset

            let font = textView.typingAttributes[.font] as? UIFont ?? UIFont.systemFont(ofSize: 16)
            textView.typingAttributes[.font] = font.withSize(font.pointSize * 0.7)
        }
    }

    //MARK: - H1 TO H6
    func applyHeading(textView: UITextView, level: Int) {
        let selectedRange = textView.selectedRange
        let mutableAttrText = NSMutableAttributedString(attributedString: textView.attributedText)

        // Define font sizes for H1–H6
        let fontSize: CGFloat
        switch level {
        case 1: fontSize = 28
        case 2: fontSize = 24
        case 3: fontSize = 20
        case 4: fontSize = 18
        case 5: fontSize = 16
        case 6: fontSize = 14
        default: fontSize = 16
        }

        let headingFont = UIFont.boldSystemFont(ofSize: fontSize)

        if selectedRange.length > 0 {
            // Apply to selected text
            mutableAttrText.addAttribute(.font, value: headingFont, range: selectedRange)
            textView.attributedText = mutableAttrText
            textView.selectedRange = selectedRange
        } else {
            // Apply to future typing
            textView.typingAttributes[.font] = headingFont
        }
    }

    func applyTextColor(textView: UITextView, color: UIColor) {
        let selectedRange = textView.selectedRange
        let mutableAttrText = NSMutableAttributedString(attributedString: textView.attributedText)

        if selectedRange.length > 0 {
            mutableAttrText.addAttribute(.foregroundColor, value: color, range: selectedRange)
            textView.attributedText = mutableAttrText
            textView.selectedRange = selectedRange
        } else {
            textView.typingAttributes[.foregroundColor] = color
        }
    }
    
    func applyBackgroundColor(textView: UITextView, color: UIColor) {
        let selectedRange = textView.selectedRange
        let mutableAttrText = NSMutableAttributedString(attributedString: textView.attributedText)

        if selectedRange.length > 0 {
            // ✅ Apply background color to selected text
            mutableAttrText.addAttribute(.backgroundColor, value: color, range: selectedRange)
            textView.attributedText = mutableAttrText
            textView.selectedRange = selectedRange
        } else {
            // ✅ Apply to future typed text
            textView.typingAttributes[.backgroundColor] = color
        }
    }

    
    func showColorPicker(mode: ColorApplyMode) {
        colorApplyMode = mode
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        present(colorPicker, animated: true, completion: nil)
    }
    
    //MARK: - increaseIndent
    func increaseIndent(textView: UITextView) {
        let selectedRange = textView.selectedRange

        if selectedRange.length > 0 {
            // ✅ Apply to selected text
            let mutableAttrText = NSMutableAttributedString(attributedString: textView.attributedText)
            let paragraphRange = (textView.text as NSString).paragraphRange(for: selectedRange)

            mutableAttrText.enumerateAttributes(in: paragraphRange, options: []) { attributes, range, _ in
                let paragraphStyle = (attributes[.paragraphStyle] as? NSMutableParagraphStyle) ?? NSMutableParagraphStyle()
                paragraphStyle.headIndent += 20
                paragraphStyle.firstLineHeadIndent += 20

                mutableAttrText.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
            }

            textView.attributedText = mutableAttrText
            textView.selectedRange = selectedRange

        } else {
            // ✅ Apply to future typing (no selection)
            let currentStyle = (textView.typingAttributes[.paragraphStyle] as? NSMutableParagraphStyle) ?? NSMutableParagraphStyle()
            currentStyle.headIndent += 20
            currentStyle.firstLineHeadIndent += 20
            textView.typingAttributes[.paragraphStyle] = currentStyle
        }
    }

    //MARK: - DecreaseIndent
    func decreaseIndent(textView: UITextView) {
        let selectedRange = textView.selectedRange

        if selectedRange.length > 0 {
            // ✅ Apply to selected text
            let mutableAttrText = NSMutableAttributedString(attributedString: textView.attributedText)
            let paragraphRange = (textView.text as NSString).paragraphRange(for: selectedRange)

            mutableAttrText.enumerateAttributes(in: paragraphRange, options: []) { attributes, range, _ in
                let paragraphStyle = (attributes[.paragraphStyle] as? NSMutableParagraphStyle) ?? NSMutableParagraphStyle()

                // Prevent negative indent
                paragraphStyle.headIndent = max(0, paragraphStyle.headIndent - 20)
                paragraphStyle.firstLineHeadIndent = max(0, paragraphStyle.firstLineHeadIndent - 20)

                mutableAttrText.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
            }

            textView.attributedText = mutableAttrText
            textView.selectedRange = selectedRange

        } else {
            // ✅ Apply to future typing
            let currentStyle = (textView.typingAttributes[.paragraphStyle] as? NSMutableParagraphStyle) ?? NSMutableParagraphStyle()

            currentStyle.headIndent = max(0, currentStyle.headIndent - 20)
            currentStyle.firstLineHeadIndent = max(0, currentStyle.firstLineHeadIndent - 20)

            textView.typingAttributes[.paragraphStyle] = currentStyle
        }
    }
    
    //MARK: - Align,left,Right
    func applyTextAlignment(textView: UITextView, alignment: TextAlignmentType) {
        let selectedRange = textView.selectedRange
        let mutableAttrText = NSMutableAttributedString(attributedString: textView.attributedText)

        // If no selection, apply to current paragraph
        let targetRange = selectedRange.length > 0
            ? selectedRange
            : (textView.text as NSString).paragraphRange(for: selectedRange)

        mutableAttrText.enumerateAttributes(in: targetRange, options: []) { attributes, range, _ in
            let paragraphStyle = (attributes[.paragraphStyle] as? NSMutableParagraphStyle)?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()

            switch alignment {
            case .left:
                paragraphStyle.alignment = .left
            case .center:
                paragraphStyle.alignment = .center
            case .right:
                paragraphStyle.alignment = .right
            }

            mutableAttrText.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        }

        // Update the textView
        textView.attributedText = mutableAttrText
        textView.selectedRange = selectedRange

        // Also update future typing
        let paragraphStyle = NSMutableParagraphStyle()
        switch alignment {
        case .left:
            paragraphStyle.alignment = .left
        case .center:
            paragraphStyle.alignment = .center
        case .right:
            paragraphStyle.alignment = .right
        }
        textView.typingAttributes[.paragraphStyle] = paragraphStyle
    }

    
    
//    MARK: - bulletList
    func toggleBulletList(textView: UITextView) {
        let selectedRange = textView.selectedRange
        let mutableAttrText = NSMutableAttributedString(attributedString: textView.attributedText)
        let paragraphRange = (textView.text as NSString).paragraphRange(for: selectedRange)
        let fullText = mutableAttrText.string as NSString
        let lines = fullText.substring(with: paragraphRange).components(separatedBy: "\n")

        var resultText = ""

        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)

            if trimmed.hasPrefix("• ") {
                // ✅ Remove bullet
                resultText += line.replacingOccurrences(of: "• ", with: "") + "\n"
            } else if let range = trimmed.range(of: #"^\d+\.\s"#, options: .regularExpression) {
                // ✅ Remove number and add bullet
                let newLine = trimmed.replacingCharacters(in: range, with: "• ")
                resultText += newLine + "\n"
            } else {
                // ✅ Add bullet
                resultText += "• \(line)\n"
            }
        }

        mutableAttrText.replaceCharacters(in: paragraphRange, with: resultText.trimmingCharacters(in: .newlines))
        textView.attributedText = mutableAttrText
        textView.selectedRange = NSRange(location: paragraphRange.location, length: 0)
    }


    func toggleNumberedList(textView: UITextView) {
        let selectedRange = textView.selectedRange
        let mutableAttrText = NSMutableAttributedString(attributedString: textView.attributedText)
        let paragraphRange = (textView.text as NSString).paragraphRange(for: selectedRange)
        let fullText = mutableAttrText.string as NSString
        let lines = fullText.substring(with: paragraphRange).components(separatedBy: "\n")

        var resultText = ""
        let isNumbered = lines.first?.trimmingCharacters(in: .whitespaces).range(of: #"^\d+\.\s"#, options: .regularExpression) != nil

        for (index, line) in lines.enumerated() {
            let trimmed = line.trimmingCharacters(in: .whitespaces)

            if isNumbered {
                // ✅ Remove number
                let newLine = trimmed.replacingOccurrences(of: #"^\d+\.\s"#, with: "", options: .regularExpression)
                resultText += newLine + "\n"
            } else if trimmed.hasPrefix("• ") {
                // ✅ Remove bullet and add number
                let withoutBullet = trimmed.replacingOccurrences(of: "• ", with: "")
                resultText += "\(index + 1). \(withoutBullet)\n"
            } else {
                // ✅ Add number
                resultText += "\(index + 1). \(line)\n"
            }
        }

        mutableAttrText.replaceCharacters(in: paragraphRange, with: resultText.trimmingCharacters(in: .newlines))
        textView.attributedText = mutableAttrText
        textView.selectedRange = NSRange(location: paragraphRange.location, length: 0)
    }


    
}


extension General_InfoVC: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        applyColor(selectedColor: viewController.selectedColor)
    }

    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        // Live preview
        applyColor(selectedColor: viewController.selectedColor)
    }

    func applyColor(selectedColor: UIColor) {
        switch colorApplyMode {
        case .text:
            applyTextColor(textView: txt_Aboutus, color: selectedColor)
        case .background:
            applyBackgroundColor(textView: txt_Aboutus, color: selectedColor)
        }
    }
}


