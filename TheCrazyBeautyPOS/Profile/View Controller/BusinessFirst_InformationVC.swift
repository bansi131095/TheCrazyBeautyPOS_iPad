//
//  BusinessFirst_InformationVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 15/07/25.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces
import DropDown

class BusinessFirst_InformationVC: UIViewController {

    
    var colorApplyMode: ColorApplyMode = .text
    var arr_SalonType = ["Male","Female","Unisex"]
    
    
    
    //MARK: - Outlet
    
    @IBOutlet weak var txt_BusinessName: TextInputLayout!
    @IBOutlet weak var txt_SalonType: TextInputLayout!
    
    @IBOutlet weak var txt_Address: TextInputLayout!
    @IBOutlet weak var map_vw: UIView!
    @IBOutlet weak var switch_visible: UISwitch!
    @IBOutlet weak var btn_Continue: GradientButton!
    
    //MARK: - Global Variable
    var web_status : Int?
    var vendor_ID = Int()
    var locationManager = CLLocationManager()
    var userLatitude:CLLocationDegrees! = 0
    var userLongitude:CLLocationDegrees! = 0
    let marker : GMSMarker = GMSMarker()
    var MapView:GMSMapView = GMSMapView()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let title = NSLocalizedString("Continue", comment: "")
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont(name: "Lato-Bold", size: 20.0)!,
                .foregroundColor: UIColor.white
            ]
        )
        btn_Continue.setAttributedTitle(attributedTitle, for: .normal)
        setCustomFont()
        txt_SalonType.text = arr_SalonType.first
        self.determineMyCurrentLocation()
        apicall()
    }
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Medium", size: 18.0) {
            txt_BusinessName.font = customFont
            txt_SalonType.font = customFont
            txt_Address.font = customFont
        }
    }
    
    //MARK: -  Button Action
    
    @IBAction func btn_SalonType(_ sender: Any) {
        openSalonType()
    }
    
    @IBAction func btn_Address(_ sender: Any) {
        openAutocomplete()
    }
    
    @IBAction func btn_Continue(_ sender: Any) {
        if txt_BusinessName.text == ""{
            alertWithImage(title: "Business Informatin", Msg: "Business Name is required.")
        }else{
            AddBusiness()
            
        }
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
    
    //MARK: - Function
    //MARK: - Web Api Calling
    func apicall(){
        showLoader()
        APIService.shared.AddVendorData(salon_id: LocalData.userId) { result in
            self.hideLoader()
            if let response = result {
                if let results = response.data?.result {
                    for vendor in results {
                        self.vendor_ID = vendor.id ?? 0
                    }
                }
            }
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
        /*if let salon = SalonDetails.first,
           let lat = salon.latitude,
           let lon = salon.longitude {
            userLatitude = lat
            userLongitude = lon
            setupMapWithCoordinates()
        }*/
        // Check location authorization
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways,
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
        reverseGeocode(coordinate: marker.position)
        // Only reverse geocode if we don't have address from salon
        /*if SalonDetails.first?.address == nil || SalonDetails.first?.address?.isEmpty == true {
            reverseGeocode(coordinate: marker.position)
        }*/
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
            
            let fullAddress = lines.joined(separator: ", ")
            let country = address.country ?? ""
            
            DispatchQueue.main.async {
                self.txt_Address.text = "\(fullAddress)"
            }
            
            // Extract street address only
            /*let fullLine = lines[0]
            let components = fullLine.components(separatedBy: ",")
            let streetOnly = components.first?.trimmingCharacters(in: .whitespaces) ?? ""
            
            DispatchQueue.main.async {
                self.txt_Address.text = streetOnly
            }*/
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
    
    func updateLocation(latitude: Double, longitude: Double, name: String) {
        // Example: set marker on Google Map
        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let marker = GMSMarker(position: position)
        marker.title = name
        marker.map = MapView
        MapView.animate(toLocation: position)
    }
    
    func openSalonType() {
        let slotDuration = DropDown()
        slotDuration.anchorView = txt_SalonType
        slotDuration.bottomOffset = CGPoint(x: 0, y:(slotDuration.anchorView?.plainView.bounds.height)!)
        slotDuration.direction = .bottom
        slotDuration.dataSource = arr_SalonType
        slotDuration.cellHeight = 35
        slotDuration.show()
        slotDuration.textFont = UIFont(name: "Lato-Regular", size: 18.0)!
        slotDuration.backgroundColor = .white
        slotDuration.selectionAction = {  [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.txt_SalonType.text = item
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .notDetermined:
                self.locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
                print("Authorization status is not determined.")
                
            case .restricted, .denied:
                let alert = UIAlertController(title: "Allow Location Access",
                                              message: "GC Shop needs access to your location. Turn on Location Services in your device settings.",
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (_) in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { success in
                            print("Settings opened: \(success)")
                        })
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print("Location access is denied!")
                
            case .authorizedWhenInUse, .authorizedAlways:
                print("Access granted for location.")
                self.showCurrentLocation()
                
            default:
                break
            }
        }else {
            self.showCurrentLocation()
        }
    }
    
    func showCurrentLocation() {
        /*vw_map.isMyLocationEnabled = false
        vw_map.isUserInteractionEnabled = true*/
        if let locationObj = locationManager.location {
            let coord = locationObj.coordinate
            let lattitude = coord.latitude
            let longitude = coord.longitude
            print(" lat in  updating \(lattitude) ")
            print(" long in  updating \(longitude)")
            
            let center = CLLocationCoordinate2D(latitude: locationObj.coordinate.latitude, longitude: locationObj.coordinate.longitude)
            marker.position = center
            marker.isFlat = true
            marker.icon = UIImage(named: "ic_location")
//            marker.setIconSize(scaledToSize: CGSize(width: 70, height: 70))
            marker.map = MapView
//            let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: lattitude, longitude: longitude, zoom: 16.0)
//            marker.vw_map.animate(to: camera)
        }
    }
    
    func AddBusiness(){
        let url = global.shared.URL_UPDATE_BUSINESS_INFORMATION + "/\(vendor_ID)"
        print("URL:- \(url)")
        showLoader()
        APIService.shared.BusinessInformation(url: url, address: self.txt_Address.text ?? "", latitude: "\(userLatitude ?? 0.0)", longitude: "\(userLongitude ?? 0.0)", postcode: "", salon_name: self.txt_BusinessName.text ?? "", salon_type: self.txt_SalonType.text ?? "", web_status: "\(web_status ?? 0)") { result in
            self.hideLoader()
            if let data = result?.data {
                        DispatchQueue.main.async {
                            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "BusinessSecond_InformationVC") as! BusinessSecond_InformationVC
                            vc.vendor_Id = self.vendor_ID
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                            // Safely unwrap message string
                            if let messageString = data as? String {
                                self.alertWithMessageOnly(messageString)
                            } else {
                                self.alertWithMessageOnly("Business information updated successfully.")
                            }
                        }
                    }else{
                self.alertWithMessageOnly("Something went wrong.")
            }
        }
    }
}

extension BusinessFirst_InformationVC: CLLocationManagerDelegate, GMSMapViewDelegate{
    
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
}

extension BusinessFirst_InformationVC: GMSAutocompleteViewControllerDelegate{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
//        txt_Address.text = place.name ?? ""
        txt_Address.text = place.formattedAddress ?? place.name ?? ""
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

