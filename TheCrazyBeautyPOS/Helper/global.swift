//
//  global.swift
//  Easy Homes Realty
//
//  Created by My Mac on 5/1/17.
//  Copyright © 2017 ciestosolutions. All rights reserved.
//

import UIKit

class global: NSObject
{
    
    //MARK:- Global Variable
    static let shared: global = global()
    
    //MARK:- Url
    
    
//    GOOGLE_MAP_KEY_RUSH_MALL=AIzaSyDNE-nH7aaKw21nG3yVaDtPZQm-6yaqHh8
    
    static let base_url = "https://staging.thecrazybeauty.com/"
    
//    static let base_url = "https://api.thecrazybeauty.com/" // LIVE
    static let server_url = global.base_url + "api/"
    
    static let CAL_WEB_URL = "https://tcb-ten.vercel.app/vendor/booking?id=%@&auth=%@&rand=%lld" //TCB
//    static let CAL_WEB_URL = "https://thecrazybeauty.com/vendor/booking?id=%@&auth=%@&rand=%lld" //LIVE

    static let TEAM_ROASTER_WEB_URL = "https://tcb-ten.vercel.app/vendor/team-roaster?id=%@&auth=%@&rand=%lld" //TCB
//    static let TEAM_ROASTER_WEB_URL = "https://thecrazybeauty.com/vendor/team-roaster?id=%@&auth=%@&rand=%lld" //LIVE
    
//    let Accesskey  = "THRIVE693JUICE753"
    static let apikey = "Ti99nbZ4zl9fu3AfUv8afirAiyXWAWtas7Kgm8jWY2wEUGthZ3jLsUO7kNWpcPng22mnIC0LM4torLEEjrgMBVcpmHrY40CLzXBBqredshUNRtrkXehq5a8pnwVC533f";
     
    let Device_Type = "IOS"
    var App_Version = Bundle.main.infoDictionary?["CFBundleVersion"] ?? ""
    var App_Package = Bundle.main.infoDictionary?["CFBundleIdentifier"] ?? ""
    var DeviceId = String() // DeviceId.getDeviceID()
    var Device_Name = UIDevice.modelName
 
// public_html/Food/Admin/Restaurant_Logo


    let PROFILE_IMG_PATH = global.base_url + "images/Profiles/"
    static let imageUrl = global.base_url + "uploads/";
    
    static let imageUrl_Profile = global.base_url + "upload/"
    static let reportUrl = global.base_url + "uploads/reports/";
    
    //Common Parameter
        
    //MARK:- Login & register
    var URL_LOGIN = global.server_url + "login"
    // Accesskey, Email_Id, Password
   
    var URL_SERVICE_DETAILS = global.server_url + "service_details"
    
    var URL_BUSINESS_SERVICES = global.server_url + "business_services"
    
    var URL_TEAM_DETAILS = global.server_url + "team_details"
    
    var URL_CURRENCY_DETAILS = global.server_url + "currency_details"
    var URL_UPDATE_CURRENCY = global.server_url + "update_currency"
    
    
    var URL_UPDATE_BOOKINGFLOW = global.server_url + "update_bookingflow"
    var URL_GET_BOOKINGFLOW = global.server_url + "get_bookingflow"
    
    
    var URL_UPDATE_BANKDETAILS = global.server_url + "bank_details"
    var URL_GET_BANKDETAILS = global.server_url + "get_bankdetails"
    
    var URL_GET_NOTES = global.server_url + "get_notes"
    var URL_UPDATE_NOTES = global.server_url + "update_notes"
    
    
    var URL_GET_Amount = global.server_url + "get_amount"
    var URL_UPDATE_Amount = global.server_url + "update_amount"
    
    var URL_Team_Details = global.server_url + "team_details"
    var URL_GET_STAFFSEQUENCE = global.server_url + "get_staffsequence"
    var URL_UPDATE_STAFFSEQUENCE = global.server_url + "update_staffsequence"
    
    var URL_UPDATE_TIMEGAP = global.server_url + "update_timegap"
    var URL_CHANGE_PASSWORD = global.server_url + "change_password"
    
    var URL_GET_IMAGE = global.server_url + "get_images"
    var URL_ADD_IMAGE = global.server_url + "add_images"
    
    var URL_UPDATE_REMINDERMAIL = global.server_url + "update_remindermail"
    var URL_SELECT_SERVICES = global.server_url + "select_services"
    var URL_SELECT_MAINCATEGORY = global.server_url + "select_maincategory"
    var URL_CATEGORY_DESCRIPTION = global.server_url + "category_description"
    var URL_UPDATE_CATEGORY_DESCRIPTION = global.server_url + "update_category_description"
    
    
    
    
    //MARK:-
    override init()
    {
        
    }
    
    //MARK:- Global Function
    func deg2rad(deg:Double) -> Double {
        return deg * Double.pi / 180
    }
    
    func rad2deg(rad:Double) -> Double {
        return rad * 180.0 / Double.pi
    }
    
    func distance(lat1:Double, lon1:Double, lat2:Double, lon2:Double, unit:String) -> Double {
        let theta = lon1 - lon2
        var dist = sin(deg2rad(deg: lat1)) * sin(deg2rad(deg: lat2)) + cos(deg2rad(deg: lat1)) * cos(deg2rad(deg: lat2)) * cos(deg2rad(deg: theta))
        dist = acos(dist)
        dist = rad2deg(rad: dist)
        dist = dist * 60 * 1.1515
        if (unit == "K") {
            dist = dist * 1.609344
        }
        else if (unit == "N") {
            dist = dist * 0.8684
        }
        return dist
    }
    
    
    /*
     print(distance(Double(32.9697), lon1: Double(-96.80322), lat2: Double(29.46786), lon2: Double(-98.53506), unit: "M"), "Miles")
     print(distance(Double(32.9697), lon1: Double(-96.80322), lat2: Double(29.46786), lon2: Double(-98.53506), unit: "K"), "Kilometers")
     print(distance(Double(32.9697), lon1: Double(-96.80322), lat2: Double(29.46786), lon2: Double(-98.53506), unit: "N"), "Nautical Miles")
     */
}



