//
//  SalonData.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 10/07/25.
//

import Foundation
import ObjectMapper

class SalonDataModel: Mappable {
    var data: SalonData?
    var error: String = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        data  <- map["data"]
        error <- map["error"]
    }
}


class SalonData: Mappable {
    var id: Int = 0
    var salonId: Int = 0
    var serviceId: String = ""
    var salonName: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var isVerified: Int = 0
    var phone: String = ""
    var salonPhone: String = ""
    var postcode: String = ""
    var salonType: String = ""
    var staffSequence: String = ""
    var resetToken: String = ""
    var deviceToken: String = ""
    var fcmToken: String = ""
    var lastLogin: String = ""
    var averageRating: String = ""
    var paypalEmail: String = ""
    var bankDetails: String = ""
    var profilePhoto: String = ""
    var galleryImages: String = ""
    var otherImages: String = ""
    var aboutSalon: String = ""
    var workingHours: [WorkingHours] = []
    var breakTime: String = ""
    var businessVerified: Int = 0
    var facebookProfile: String = ""
    var twitterProfile: String = ""
    var instagramProfile: String = ""
    var whatsappProfile: String = ""
    var address: String = ""
    var city: String = ""
    var country: String = ""
    var latitude: String = ""
    var longitude: String = ""
    var passcodeStatus: Int = 0
    var isPaid: Int = 0
    var allowServices: Int = 0
    var advancePay: String = ""
    var webStatus: Int = 0
    var staffStatus: Int = 0
    var cancellationPolicy: String = ""
    var notes: String = ""
    var smsCredit: Int = 0
    var smsSettings: String = ""
    var reminderTime: Int = 0
    var allowPos: Int = 0
    var posId: String = ""
    var isDeleted: Int = 0
    var membership: String = ""
    var metaTitle: String = ""
    var metaDescription: String = ""
    var openingDate: String = ""
    var holidayDates: String = ""
    var timeGap: String = ""
    var reminderMail: Int = 0
    var categoryDescription: String = ""
    var cardEnable: Int = 0
    var penaltyFees: String = ""
    var createdAt: String = ""
    var updatedAt: String = ""
    var currency: String = ""
    var symbol: String = ""
    var emailNotifications: Int = 0
    var status: Int = 0
    var token: String = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        id               <- map["id"]
        salonId          <- map["salon_id"]
        serviceId        <- map["service_id"]
        salonName        <- map["salon_name"]
        firstName        <- map["first_name"]
        lastName         <- map["last_name"]
        email            <- map["email"]
        isVerified       <- map["is_verified"]
        phone            <- map["phone"]
        salonPhone       <- map["salon_phone"]
        postcode         <- map["postcode"]
        salonType        <- map["salon_type"]
        staffSequence    <- map["staff_sequence"]
        resetToken       <- map["reset_token"]
        deviceToken      <- map["device_token"]
        fcmToken         <- map["fcm_token"]
        lastLogin        <- map["last_login"]
        averageRating    <- map["average_rating"]
        paypalEmail      <- map["paypal_email"]
        bankDetails      <- map["bank_details"]
        profilePhoto     <- map["profile_photo"]
        galleryImages    <- map["gallery_images"]
        otherImages      <- map["other_images"]
        aboutSalon       <- map["about_salon"]
        breakTime        <- map["break_time"]
        businessVerified <- map["business_verified"]
        facebookProfile  <- map["facebook_profile"]
        twitterProfile   <- map["twitter_profile"]
        instagramProfile <- map["instagram_profile"]
        whatsappProfile  <- map["whatsapp_profile"]
        address          <- map["address"]
        city             <- map["city"]
        country          <- map["country"]
        latitude         <- map["latitude"]
        longitude        <- map["longitude"]
        passcodeStatus   <- map["passcode_status"]
        isPaid           <- map["is_paid"]
        allowServices    <- map["allow_services"]
        advancePay       <- map["advance_pay"]
        webStatus        <- map["web_status"]
        staffStatus      <- map["staff_status"]
        cancellationPolicy <- map["cancellation_policy"]
        notes            <- map["notes"]
        smsCredit        <- map["sms_credit"]
        smsSettings      <- map["sms_settings"]
        reminderTime     <- map["reminder_time"]
        allowPos         <- map["allow_pos"]
        posId            <- map["pos_id"]
        isDeleted        <- map["is_deleted"]
        membership       <- map["membership"]
        metaTitle        <- map["meta_title"]
        metaDescription  <- map["meta_description"]
        openingDate      <- map["opening_date"]
        holidayDates     <- map["holiday_dates"]
        timeGap          <- map["time_gap"]
        reminderMail     <- map["reminder_mail"]
        categoryDescription <- map["category_description"]
        cardEnable       <- map["card_enable"]
        penaltyFees      <- map["penalty_fees"]
        createdAt        <- map["created_at"]
        updatedAt        <- map["updated_at"]
        currency         <- map["currency"]
        symbol           <- map["symbol"]
        emailNotifications <- map["email_notifications"]
        status           <- map["status"]
        token            <- map["token"]

        // Parse working_hours as JSON string into array
        var workingHoursString: String?
        workingHoursString <- map["working_hours"]
        if let jsonStr = workingHoursString,
           let data = jsonStr.data(using: .utf8),
           let decoded = try? JSONDecoder().decode([WorkingHours].self, from: data) {
            workingHours = decoded
        }
    }
}


class WorkingHours: Codable { // ✅ Codable = Decodable + Encodable
    var day: String = ""
    var from: String = ""
    var to: String = ""

    init() {}

    // Required for ObjectMapper (if you still use it)
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        day   <- map["day"]
        from  <- map["from"]
        to    <- map["to"]
    }
}


