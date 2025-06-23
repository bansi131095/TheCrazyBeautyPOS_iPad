//
//  SharedPrefs.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 05/06/25.
//

import Foundation

class SharedPrefs {
    
    // MARK: - UserId
    static func setUserId(_ userId: String) {
        UserDefaults.standard.set(userId, forKey: "User_Id")
    }
    
    static func getUserId() -> String {
        return UserDefaults.standard.string(forKey: "User_Id") ?? ""
    }
    
    // MARK: - UserName
    static func setUserName(_ userName: String) {
        UserDefaults.standard.set(userName, forKey: "User_Name")
    }
    
    static func getUserName() -> String {
        return UserDefaults.standard.string(forKey: "User_Name") ?? ""
    }
    
    // MARK: - Email
    static func setEmail(_ email: String) {
        UserDefaults.standard.set(email, forKey: "email")
    }
    
    static func getEmail() -> String {
        return UserDefaults.standard.string(forKey: "email") ?? ""
    }
    
    // MARK: - SalonName
    static func setSalonName(_ salonName: String) {
        UserDefaults.standard.set(salonName, forKey: "Salon_name")
    }
    
    static func getSalonName() -> String {
        return UserDefaults.standard.string(forKey: "Salon_name") ?? ""
    }
    
    // MARK: - SalonId
    static func setSalonId(_ salonId: String) {
        UserDefaults.standard.set(salonId, forKey: "Salon_id")
    }
    
    static func getSalonId() -> String {
        return UserDefaults.standard.string(forKey: "Salon_id") ?? ""
    }
    
    // MARK: - LoginToken
    static func setLoginToken(_ loginToken: String) {
        UserDefaults.standard.set(loginToken, forKey: "Login_Token")
    }
    
    static func getLoginToken() -> String {
        return UserDefaults.standard.string(forKey: "Login_Token") ?? ""
    }
    
    // MARK: - Verified
    static func setVerified(_ isVerified: Bool) {
        UserDefaults.standard.set(isVerified, forKey: "IS_VERIFIED")
    }
    
    static func isVerified() -> Bool {
        return UserDefaults.standard.bool(forKey: "IS_VERIFIED")
    }
    
    // MARK: - StaffLogin
    static func setStaffLogin(_ isStaffLogin: Bool) {
        UserDefaults.standard.set(isStaffLogin, forKey: "Staff_Login")
    }
    
    static func isStaffLogin() -> Bool {
        return UserDefaults.standard.bool(forKey: "Staff_Login")
    }
    
    // MARK: - Currency
    static func setCurrency(_ currency: String) {
        UserDefaults.standard.set(currency, forKey: "currency")
    }
    
    static func getCurrency() -> String {
        return UserDefaults.standard.string(forKey: "currency") ?? ""
    }
    
    // MARK: - Symbol
    static func setSymbol(_ symbol: String) {
        UserDefaults.standard.set(symbol, forKey: "symbol")
    }
    
    static func getSymbol() -> String {
        return UserDefaults.standard.string(forKey: "symbol") ?? ""
    }
    
    // MARK: - LoginTime
    static func setLoginTime(_ loginTime: String?) {
        UserDefaults.standard.set(loginTime, forKey: "loginTime")
    }

    static func getLoginTime() -> String {
        return UserDefaults.standard.string(forKey: "loginTime") ?? ""
    }

    // MARK: - Clear User Data
    static func clearUserData() {
        setUserId("")
        setLoginToken("")
        setVerified(false)
        
        // Assuming you have some LocalData struct/class to update, you can do like:
        // LocalData.userId = ""
        // LocalData.loginToken = ""
        // LocalData.isVerified = false
        // But this part depends on your app structure.
    }
}
