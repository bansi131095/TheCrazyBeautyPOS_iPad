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




class ClientBooking: Mappable {
    var data: [ClientBookingModelData] = []
    var past_bookings: TodayBookingModelData?
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        data        <- map["data"]
        past_bookings        <- map["past_bookings"]
        error       <- map["error"]
    }
}

class ClientBookingModelData: Mappable {
    var id: Int = 0
    var staff_id: String?
    var service_id: String?
    var booking_date: String?
    var booking_time: String?
    var booking_status: String?
    var duration: String?
    var booking_number: String?
    var sub_total: Int = 0
    var discount_amount: String?
    var grand_total: String?
    var staff_booking: String?
    var miscellaneous_notes: String?
    var miscellaneous_price: String?
    var tip: String?
    var payment_type: String?
    var c_id: Int = 0
    var service_name: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id     <- map["id"]
        staff_id     <- map["staff_id"]
        service_id     <- map["service_id"]
        booking_date     <- map["booking_date"]
        booking_time     <- map["booking_time"]
        booking_status     <- map["booking_status"]
        duration     <- map["duration"]
        booking_number     <- map["booking_number"]
        sub_total     <- map["sub_total"]
        discount_amount     <- map["discount_amount"]
        grand_total     <- map["grand_total"]
        staff_booking     <- map["staff_booking"]
        miscellaneous_notes     <- map["miscellaneous_notes"]
        miscellaneous_price     <- map["miscellaneous_price"]
        tip     <- map["tip"]
        payment_type     <- map["payment_type"]
        c_id     <- map["c_id"]
        service_name     <- map["service_name"]
    }
}


class TodayBookingModel: Mappable {
    var data: TodayBookingModelData?
    var error: String = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        data  <- map["data"]
        error <- map["error"]
    }
}


class TodayBookingModelData: Mappable {
    var total_bookings: Int = 0
    var calendar_total: Int = 0
    var calendar_total_amount: Double = 0.0
    var cancel_total: Int = 0
    var cancel_total_amount: Int = 0
    var noshow_total: Int = 0
    var noshow_total_amount: Int = 0
    var walkin_total: Int = 0
    var walkin_total_amount: Double = 0.0
    var total_cash: Double = 0.0
    var total_card: Double = 0.0
    
    var complete_total: Int = 0
    var complete_total_amount: Double = 0.0
    
    required init?(map: Map) {}

    func mapping(map: Map) {
        total_bookings               <- map["total_bookings"]
        calendar_total          <- map["calendar_total"]
        cancel_total        <- map["cancel_total"]
        calendar_total_amount        <- map["calendar_total_amount"]
        cancel_total_amount        <- map["cancel_total_amount"]
        noshow_total        <- map["noshow_total"]
        noshow_total_amount         <- map["noshow_total_amount"]
        walkin_total            <- map["walkin_total"]
        walkin_total_amount       <- map["walkin_total_amount"]
        total_cash            <- map["total_cash"]
        total_card       <- map["total_card"]
        
        complete_total       <- map["complete_total"]
        complete_total_amount       <- map["complete_total_amount"]
    }
}
