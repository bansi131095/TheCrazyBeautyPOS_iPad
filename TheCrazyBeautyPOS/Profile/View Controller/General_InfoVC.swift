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

class General_InfoVC: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
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
    
    @IBOutlet weak var txt_BusinessName: TextInputLayout!
    
    @IBOutlet weak var txt_MobileNumber: TextInputLayout!
    @IBOutlet weak var txt_Aboutus: UITextView!
    @IBOutlet weak var txt_SalonType: TextInputLayout!
    
    @IBOutlet weak var txt_Address: TextInputLayout!
    @IBOutlet weak var map_vw: UIView!
    @IBOutlet weak var map_height_const: NSLayoutConstraint!
    
    @IBOutlet weak var switch_visible: UISwitch!
    @IBOutlet weak var switch_Salon: UISwitch!
    
    
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
    var allow_search : Int?
    var web_status : Int?
    var phone = String()
    var postcode = String()
    var city = String()
    var country = String()
    var time_gap = Int()
    var reminder_mail = Int()
    
    var SalonDetails: [SalonDetailsModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        get_fetchSalon()
    }
    
    @IBAction func switch_Visible(_ sender: UISwitch) {
        if sender.isOn{
            switch_visible.isOn = true
            web_status = 1
        }else{
            switch_visible.isOn = false
            web_status = 0
        }
    }
    
    
    @IBAction func switch_Salon(_ sender: UISwitch) {
        if sender.isOn{
            switch_Salon.isOn = true
            allow_search = 1
        }else{
            switch_Salon.isOn = false
            allow_search = 0
        }
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
    
    @IBAction func btn_AddressChange(_ sender: Any) {
        openAutocomplete()
    }
    
    @IBAction func btn_Save(_ sender: Any) {
        update_Salon()
    }
    
    //MARK: - Api Call
    func get_fetchSalon(){
        APIService.shared.fetchSalonDetails  { result in
            self.SalonDetails = result!.data
            self.phone = self.SalonDetails.first?.phone ?? ""
            self.postcode = self.SalonDetails.first?.postcode ?? ""
            self.city = self.SalonDetails.first?.city ?? ""
            self.country = self.SalonDetails.first?.country ?? ""
            self.reminder_mail = self.SalonDetails.first?.reminder_mail ?? 0
            self.time_gap = self.SalonDetails.first?.time_gap ?? 0
            
            self.txt_Address.text = self.SalonDetails.first?.address
            self.txt_SalonType.text = self.SalonDetails.first?.salon_type
            self.txt_BusinessName.text = self.SalonDetails.first?.salon_name
            self.txt_MobileNumber.text = self.SalonDetails.first?.salon_phone
            self.userLatitude = self.SalonDetails.first?.latitude
            self.userLongitude = self.SalonDetails.first?.longitude
            self.txt_Aboutus.attributedText = self.SalonDetails.first?.about_us?.htmlToAttributedString
            if self.SalonDetails.first?.allow_search == 0{
                self.switch_Salon.isOn = false
            }else{
                self.switch_Salon.isOn = true
            }
            if self.SalonDetails.first?.web_status == 0{
                self.switch_visible.isOn = false
            }else{
                self.switch_visible.isOn = true
            }
            self.determineMyCurrentLocation()
        }
    }
    
    func update_Salon(){
        APIService.shared.UpdateBusinessInformation(id: LocalData.userId, salon_name: txt_BusinessName.text ?? "", salon_type: txt_SalonType.text ?? "", phone: phone, salon_phone: self.txt_MobileNumber.text ?? "", postcode: postcode, address: self.txt_Address.text ?? "", city: city, country: country, latitude: "\(String(describing: userLatitude))", longitude: "\(userLongitude ?? 0.0)", web_status: "\(web_status ?? 0)", allow_search: "\(allow_search ?? 0)", time_gap: "\(time_gap)", reminder_mail: "\(reminder_mail)", about_us: self.txt_Aboutus.text ?? "") { result in
            if let message = result?.data{
                self.alertWithMessageOnly(message)
            }else{
                self.alertWithMessageOnly("Something went wrong.")
            }
            
        }
    }
    
    //MARK: - Map function
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
    
    
    // MARK: - Map function
    func determineMyCurrentLocation() {
        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        // Get authorization status
        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        // Check if we have salon coordinates
        if let salon = SalonDetails.first,
           let lat = salon.latitude,
           let lon = salon.longitude {
            userLatitude = lat
            userLongitude = lon
            setupMapWithCoordinates()
        }
        // Check location authorization
        else if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways,
                let location = locationManager.location {
            userLatitude = location.coordinate.latitude
            userLongitude = location.coordinate.longitude
            setupMapWithCoordinates()
        }
        // Fallback to default location
        else {
            userLatitude = 53.3498
            userLongitude = 6.2603
            setupMapWithCoordinates()
        }
    }

    // MARK: - Setup map with coordinates
    private func setupMapWithCoordinates() {
        let camera = GMSCameraPosition.camera(
            withLatitude: userLatitude,
            longitude: userLongitude,
            zoom: 15
        )
        
        MapView = GMSMapView(frame: map_vw.bounds)
        MapView.camera = camera
        MapView.delegate = self
        map_vw.addSubview(MapView)
        
        marker.position = CLLocationCoordinate2D(
            latitude: userLatitude,
            longitude: userLongitude
        )
        marker.isFlat = true
        marker.icon = UIImage(named: "ic_location")
        marker.map = MapView
        
        // Only reverse geocode if we don't have address from salon
        if SalonDetails.first?.address == nil || SalonDetails.first?.address?.isEmpty == true {
            reverseGeocode(coordinate: marker.position)
        }
    }

    // MARK: - Reverse Geocoding
    func reverseGeocode(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard error == nil,
                  let address = response?.firstResult(),
                  let lines = address.lines,
                  !lines.isEmpty else {
                return
            }
            
            // Extract street address only
            let fullLine = lines[0]
            let components = fullLine.components(separatedBy: ",")
            let streetOnly = components.first?.trimmingCharacters(in: .whitespaces) ?? ""
            
            DispatchQueue.main.async {
                self.txt_Address.text = streetOnly
            }
        }
    }
    
    func openAutocomplete() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func autocompleteClicked() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: GMSPlaceField.name.rawValue | GMSPlaceField.placeID.rawValue | GMSPlaceField.coordinate.rawValue | GMSPlaceField.formattedAddress.rawValue)
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
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
    
    func updateLocation(latitude: Double, longitude: Double, name: String) {
        // Example: set marker on Google Map
        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let marker = GMSMarker(position: position)
        marker.title = name
        marker.map = MapView
        MapView.animate(toLocation: position)
    }

    
}

extension General_InfoVC: GMSAutocompleteViewControllerDelegate{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        txt_Address.text = place.name ?? ""
        
        print("Place ID: \(place.placeID ?? "")")
        print("Place attributions: \(String(describing: place.attributions))")
        self.dismiss(animated: true, completion: nil)
        self.userLatitude = place.coordinate.latitude
        self.userLongitude = place.coordinate.longitude
        marker.position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        marker.icon = UIImage(named: "ic_location")
        marker.isFlat = true
        marker.title = place.name
        marker.map = self.MapView
        updateLocation(latitude: userLatitude, longitude: userLongitude, name: place.name ?? "")
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: any Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
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


