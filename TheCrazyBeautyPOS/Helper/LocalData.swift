//
//  LocalData.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 05/06/25.
//

import Foundation
import UIKit

class LocalData {
    
    // Navigator key equivalent in Swift UIKit:
    // Usually, you don't use a GlobalKey like Flutter,
    // but you might keep a reference to UINavigationController or UIWindow if needed.
    // Here we leave it out as it’s framework specific.

    // Static vars
    static var type: String = ""
    static var id: String = ""

    static var selectedDate: String = ""

    static var setUserId: String = ""
    static var userId: String = ""
    static var userName: String = ""
    static var email: String = ""
    static var salonName: String = ""
    static var salonId: String = ""
    static var loginToken: String = ""
    static var currency: String = ""
    static var symbol: String = ""
    static var isVerified: Bool = false
    static var isStaffLogin: Bool = false

    static var allStaffIds: String = ""
    
    static var selectedCurrencyCode: String?
    static var selectedSymbol: String?
    static var setSlotDuration: String?
    static var setHours: String?
    
    // Assuming SearchBookedData is a custom struct/class in your app,
    // declare it accordingly. Here, just an example empty array placeholder.
//    static var searchSelectServiceBooking: [SearchBookedData] = []

    // MARK: - Load User Data from SharedPrefs / UserDefaults
    static func getUserData() {
        userId = SharedPrefs.getUserId()
        userName = SharedPrefs.getUserName()
        email = SharedPrefs.getEmail()
        salonName = SharedPrefs.getSalonName()
        salonId = SharedPrefs.getSalonId()
        loginToken = SharedPrefs.getLoginToken()
        isVerified = SharedPrefs.isVerified()
        isStaffLogin = SharedPrefs.isStaffLogin()
        currency = SharedPrefs.getCurrency()
        symbol = SharedPrefs.getSymbol()
        
//        return true
    }
    
    // MARK: - Device Data
    static func setDeviceData() -> Bool {
        // Assuming Utils class has static methods like getDeviceInfo() etc. returning synchronously.
        // If those are async, you may want to implement completion handlers or async/await in iOS 15+.
        
//        Utils.deviceInfo = Utils.getDeviceInfo()
//        Utils.appPackage = Utils.getAppPackage()
//        Utils.deviceId = Utils.getDeviceId()
//        Utils.appVersion = Utils.getAppVersion()
        
        return true
    }
}
