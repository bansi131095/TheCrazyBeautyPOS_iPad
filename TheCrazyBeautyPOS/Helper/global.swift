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
    
//    static let base_url = "https://staging.thecrazybeauty.com/" staging
    
    static let base_url = "https://api.thecrazybeauty.com/" // LIVE
    static let server_url = global.base_url + "api/"
    
//    static let CAL_WEB_URL = "https://tcb-ten.vercel.app/vendor/booking_touch?id=%@&auth=%@&rand=%lld&ios=true" //TCB
    static let CAL_WEB_URL = "https://thecrazybeauty.com/vendor/booking_touch?id=%@&auth=%@&rand=%lld&ios=true" //LIVE
    
    //un use TEAM_ROASTER_WEB_URL
//    static let TEAM_ROASTER_WEB_URL = "https://tcb-ten.vercel.app/vendor/team-roaster?id=%@&auth=%@&rand=%lld" //TCB
//    static let TEAM_ROASTER_WEB_URL = "https://thecrazybeauty.com/vendor/team-roaster?id=%@&auth=%@&rand=%lld" //LIVE
    
//    let Accesskey  = "THRIVE693JUICE753"
    static let apikey = "Ti99nbZ4zl9fu3AfUv8afirAiyXWAWtas7Kgm8jWY2wEUGthZ3jLsUO7kNWpcPng22mnIC0LM4torLEEjrgMBVcpmHrY40CLzXBBqredshUNRtrkXehq5a8pnwVC533f";
     
    let Device_Type = "IOS"
//    var App_Version = Bundle.main.infoDictionary?["CFBundleVersion"] ?? ""
    
    var App_Version = "\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "") (\(Bundle.main.infoDictionary?["CFBundleVersion"] ?? ""))"
    
    var App_Package = Bundle.main.infoDictionary?["CFBundleIdentifier"] ?? ""
    var DeviceId = String() // DeviceId.getDeviceID()
    var Device_Name = UIDevice.modelName
 
// public_html/Food/Admin/Restaurant_Logo


    let PROFILE_IMG_PATH = global.base_url + "images/Profiles/"
    static let imageUrl = global.base_url + "uploads/";
    
    static let imageUrl_Profile = global.base_url + "upload/"
    static let reportUrl = global.base_url + "upload/reports/";
    
    //Common Parameter
        
    //MARK:- Login & register
    var URL_LOGIN = global.server_url + "login"
    // Accesskey, Email_Id, Password
   
    var URL_SERVICE_DETAILS = global.server_url + "service_details_v1"
    
    var URL_BUSINESS_SERVICES = global.server_url + "business_services"
    var URL_SELECT_MAINSERVICES = global.server_url + "select_mainservices/"
    
    var URL_TEAM_DETAILS = global.server_url + "team_details"
    
//<<<<<<< HEAD
    var URL_CLIENT_DETAILS = global.server_url + "client_guest_details"
    var URL_CLIENT_REPORT = global.server_url + "client_report"
    
    var URL_INVENTORY_DETAILS = global.server_url + "inventory_details"
    
    var URL_GIFTCARD_DETAILS = global.server_url + "giftcard_details"
    
    var URL_COUPON_DETAILS = global.server_url + "coupon_details"
    
    var URL_GIFT_CARDS = global.server_url + "gift_cards"
    
    var URL_BOOKINGS_HISTORY = global.server_url + "bookings_history"
    
    var URL_GET_CURRENCY = global.server_url + "get_currency/"
    
    var URL_ADD_CLIENT = global.server_url + "add_client"
    
    var URL_UPDATE_CLIENT = global.server_url + "update_client/"
    
    var URL_DELETE_CLIENT = global.server_url + "delete_client/"
    
    var URL_ADD_SERVICE = global.server_url + "add_service"
    
    var URL_UPDATE_SERVICE = global.server_url + "edit_service/"
    
    var URL_DELETE_SERVICE = global.server_url + "delete_service/"
    
    var URL_ADD_TEAM = global.server_url + "add_member"
    
    var URL_UPDATE_TEAM = global.server_url + "update_member/"
    
    var URL_DELETE_TEAM = global.server_url + "delete_member/"
    
    var URL_DURATION_DETAILS = global.server_url + "duration_details"
    
    var URL_SELECT_MAINCATEGORY = global.server_url + "select_maincategory/"
    
    var URL_SERVICE_DETAILS_V1 = global.server_url + "service_details_v1"
    
    var URL_GET_TIMING = global.server_url + "get_timing"
    
    var URL_STAFF_SHIFTS = global.server_url + "staff_shifts"
    
    var URL_GET_HOLIDAYS = global.server_url + "get_holidays"
    
    var URL_STAFF_HOLIDAYS = global.server_url + "staff_holidays"
    
    var URL_UPDATE_SHIFTS = global.server_url + "update_shifts"
    
    var URL_UPDATE_STAFFHOLIDAYS = global.server_url + "update_staffholidays"
    
    var URL_UPDATE_SERVICE_SEQUENCE = global.server_url + "update_service_sequence"
    
    var URL_GET_ALL_SALONS = global.server_url + "get_all_salons"
    
    var URL_GET_ACTIVITIES = global.server_url + "get_activities"
    
    var URL_UPDATE_ACTIVITIES = global.server_url + "update_activities"
    
    var URL_SALON_DATA = global.server_url + "salon_data/"
    
    var URL_ADD_CART_DETAILS = global.server_url + "add_cart_details"
    
    var URL_WALKIN_TRANSACTION = global.server_url + "walkin_transaction"
    
    var URL_WALKIN_PAYMENT = global.server_url + "walkin_payment"
    
//=======
    var URL_CURRENCY_DETAILS = global.server_url + "currency_details"
    var URL_UPDATE_CURRENCY = global.server_url + "update_currency"
    var URL_GET_CURRENCY1 = global.server_url + "get_currency"
    
    
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
    var URL_UPDATE_STAFFSEQUENCE = global.server_url + "update_staffsequence/v1"
    
    var URL_UPDATE_TIMEGAP = global.server_url + "update_timegap"
    var URL_CHANGE_PASSWORD = global.server_url + "change_password"
    
    var URL_GET_IMAGE = global.server_url + "get_images"
    var URL_ADD_IMAGE = global.server_url + "add_images"
    
    var URL_UPDATE_REMINDERMAIL = global.server_url + "update_remindermail"
    var URL_SELECT_SERVICES = global.server_url + "select_services"
    
    var URL_SELECT_MAINCATEGORY1 = global.server_url + "select_maincategory"
    var URL_CATEGORY_DESCRIPTION = global.server_url + "category_description"
    var URL_UPDATE_CATEGORY_DESCRIPTION = global.server_url + "update_category_description"
    
    var URL_GET_KIOSK = global.server_url + "get_kiosk"
    var URL_UPDATE_ADD_KIOSK = global.server_url + "add_kiosk"
    
    var URL_GET_SUBVENDOR = global.server_url + "get_subvendor"
    var URL_UPDATE_SUBVENDOR = global.server_url + "create_subvendor"
    
//    var URL_GET_TIMING = global.server_url + "get_timing"
    var URL_UPDATE_BUSINESS_TIMING = global.server_url + "business_timing"
    var URL_GET_BREAK_TIME = global.server_url + "get_breaktime"
    
    var URL_UPDATE_BREAK_TIME = global.server_url + "update_breaktime"
    
    var URL_GET_SMS_DETAILS = global.server_url + "get_smsDetails"
    var URL_UPDATE_SMS_DETAILS = global.server_url + "add_smsdetails"
    
    var URL_GET_SALON_INFORMATION = global.server_url + "salon_information"
    
//    var URL_GET_HOLIDAYS = global.server_url + "get_holidays"
    var URL_UPDATE_HOLIDAYS = global.server_url + "update_holidays"
    
    var URL_GET_OPENDATE = global.server_url + "get_opendate"
    var URL_UPDATE_OPENDATE = global.server_url + "update_opendate"
    var URL_UPDATE_BUSINESS_INFORMATION = global.server_url + "business_information"

    var URL_UPDATE_BLOCK_CUSTOMERS = global.server_url + "update_block_customers"
    var URL_BLOCK_CUSTOMERS = global.server_url + "block_customers"
    
    var URL_ADD_VENDOR_DATA = global.server_url + "add_vendor_data"
    var URL_MAIN_CATAGORIES = global.server_url + "maincategories"
    var URL_ADD_TEAM_DATA = global.server_url + "add_team_data"
    var URL_SELECT_SERIVICES = global.server_url + "select_services"
    var URL_SERIVICES_SALES_DATA = global.server_url + "service_sales_data"
    var URL_GIFT_DETAILS = global.server_url + "gift_details"
    var URL_PAYMENT_HISTORY = global.server_url + "payment_history_v1"
    var URL_WALKIN_DETAILS = global.server_url + "walkin_details"
    var URL_SALES_DATA = global.server_url + "sales_data"
    
    var URL_GIFT_REPORT = global.server_url + "gift_report"
    var URL_WALKIN_REPORT = global.server_url + "walkin_report"
    var URL_BOOKING_HISTORY_REPORT = global.server_url + "booking_history_report"
    var URL_SALES_REPORT = global.server_url + "sales_report"
    var URL_SARVICE_REPORT = global.server_url + "service_report"
    
    var URL_CHECK_COUPON = global.server_url + "check_coupon"
    var URL_APPLY_COUPON = global.server_url + "apply_coupon"
    var URL_APPLY_GIFTCARD = global.server_url + "apply_giftcard"
    
    var URL_GET_SHIFTS = global.server_url + "get_shifts"
    var URL_STAFF_REPORT = global.server_url + "staff_report"
    
    var URL_Add_OFFGIFT = global.server_url + "add_offgift"
    
    var URL_Add_Coupon = global.server_url + "add_coupon"
    var URL_UPDATE_Coupon = global.server_url + "edit_coupon/"
    var URL_DELETE_COUPON = global.server_url + "delete_coupon/"
    
    var URL_Add_GIFTCARD = global.server_url + "add_giftcard"
    var URL_UPDATE_GIFTCARD = global.server_url + "edit_giftcard/"
    var URL_DELETE_GIFTCARD = global.server_url + "delete_giftcard/"
    
    
    
    var URL_Add_INVENTORY = global.server_url + "add_inventory"
    var URL_UPDATE_INVENTORY = global.server_url + "edit_inventory/"
    var URL_DELETE_INVENTORY = global.server_url + "delete_inventory/"
    
    
    var URL_GET_NoShowLimit = global.server_url + "get_noshowlimit"
    var URL_UPDATE_NoShowLimit = global.server_url + "update_noshowlimit"
    var URL_SEND_INVOICE = global.server_url + "send_invoice"
    var URL_VERIFY_PASSCODE = global.server_url + "verify_passcode"
    var URL_CLIENT_BOOKINGS = global.server_url + "client_bookings"
    
    var URL_GET_STAFF = global.server_url + "get_staff/"
    var URL_TEST_DETAILS = global.server_url + "test_details"
    var URL_ADD_TEST = global.server_url + "add_test"
    var URL_SELECT_SLOT = global.server_url + "select_slot"
    var URL_PAST_REBOOKING = global.server_url + "past_rebooking"
    var URL_DELETE_WALKIN = global.server_url + "delete_walkin/"
    var URL_DELETE_BOOKING = global.server_url + "delete_booking"
    var URL_RESOURCE_DETAILS = global.server_url + "resource_details"
    
    var URL_UPDATE_RESOURCE = global.server_url + "update_resource"
    var URL_ADD_RESOURCE = global.server_url + "add_resource"
    var URL_DELETE_RESOURCE = global.server_url + "delete_resource/"
    
    var URL_LOGIN_SUBVENDOR = global.server_url + "login_subvendor"
    
    var noDataLabel: UILabel?
    var hasUnreadNotification: Bool = false
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



