//
//  LoginResponse.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 05/06/25.
//

import ObjectMapper

class LoginResponse: Mappable {
    var data: LoginData?
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        data    <- map["data"]
        error   <- map["error"]
    }
}

class LoginData: Mappable {
    var message: String?
    var error: String?
    var id: Int?
    var salon_id: Int?
    var service_id: String?
    var salon_name: String?
    var first_name: String?
    var last_name: String?
    var email: String?
    var phone: String?
    var token: String?
    var working_hours: [WorkingHour]?
    var break_time: [BreakTime]?
    var staff_sequence: [StaffSequence]?
    var bank_details: BankDetails?
    var sub_vendors: SubVendor?
    var category_description: [CategoryDescription]?

    required init?(map: Map) {}

    func mapping(map: Map) {
        message             <- map["message"]
        error             <- map["error"]
        id                  <- map["id"]
        salon_id            <- map["salon_id"]
        service_id          <- map["service_id"]
        salon_name          <- map["salon_name"]
        first_name          <- map["first_name"]
        last_name           <- map["last_name"]
        email               <- map["email"]
        phone               <- map["phone"]
        token               <- map["token"]
        working_hours       <- map["working_hours"]
        break_time          <- map["break_time"]
        staff_sequence      <- map["staff_sequence"]
        bank_details        <- (map["bank_details"], BankDetailsTransform())
        sub_vendors         <- map["sub_vendors"]
        category_description <- map["category_description"]
    }
}

//class WorkingHour: Mappable {
//    var day: String?
//    var from: String?
//    var to: String?
//
//    required init?(map: Map) {}
//
//    func mapping(map: Map) {
//        day     <- map["day"]
//        from    <- map["from"]
//        to      <- map["to"]
//    }
//}

class BreakTime: Mappable {
    var day: String?
    var startTime: String?
    var endTime: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        day         <- map["day"]
        startTime   <- map["startTime"]
        endTime     <- map["endTime"]
    }
}

class StaffSequence: Mappable {
    var staff_id: String?
    var sequence: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        staff_id    <- map["staff_id"]
        sequence    <- map["sequence"]
    }
}

class BankDetails: Mappable {
    var accountNumber: String?
    var accountHolderName: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        accountNumber      <- map["account number"]
        accountHolderName  <- map["account holder name"]
    }
}

class SubVendor: Mappable {
    var id: Int?
    var vendor_id: Int?
    var name: String?
    var email: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        id         <- map["id"]
        vendor_id  <- map["vendor_id"]
        name       <- map["name"]
        email      <- map["email"]
    }
}

class CategoryDescription: Mappable {
    var category_id: Int?
    var description: String?
    var sequence: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        category_id     <- map["category_id"]
        description     <- map["description"]
        sequence        <- map["sequence"]
    }
}


class BankDetailsTransform: TransformType {
    typealias Object = BankDetails
    typealias JSON = String

    func transformFromJSON(_ value: Any?) -> BankDetails? {
        guard let jsonString = value as? String,
              let data = jsonString.data(using: .utf8),
              let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        else {
            return nil
        }
        return BankDetails(JSON: dict)
    }

    func transformToJSON(_ value: BankDetails?) -> String? {
        guard let value = value else { return nil }
        return try? value.toJSONString()
    }
}

class subVendor: Mappable {
    var data: String = ""
    var result: [ResultItem] = []
    var vendorData: [VendorDataItem] = []
    var token: String?
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        data        <- map["data"]
        result      <- map["result"]
        vendorData  <- map["vendor_data"]
        token       <- map["token"]
        error       <- map["error"]
    }
}

class ResultItem: Mappable {
    var id: Int = 0
    var vendorId: Int = 0
    var name: String = ""
    var email: String = ""
    var createdAt: String = ""
    var updatedAt: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        id          <- map["id"]
        vendorId    <- map["vendor_id"]
        name        <- map["name"]
        email       <- map["email"]
        createdAt   <- map["created_at"]
        updatedAt   <- map["updated_at"]
    }
}

class VendorDataItem: Mappable {
    var id: Int = 0
    var salonId: Int = 0
    var serviceId: String = ""
    var blockCustomers: String = ""
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
    var fcmToken: String?
    var lastLogin: String?
    var averageRating: Double = 0.0
    var paypalEmail: String?
    var bankDetails: String = ""
    var profilePhoto: String = ""
    var galleryImages: String = ""
    var otherImages: String = ""
    var aboutSalon: String?
    var workingHours: String = ""
    var breakTime: String = ""
    var businessVerified: Int = 0
    var facebookProfile: String?
    var twitterProfile: String?
    var instagramProfile: String?
    var whatsappProfile: String?
    var address: String = ""
    var city: String = ""
    var country: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var passcodeStatus: Int = 0
    var isPaid: Int = 0
    var allowServices: Int = 0
    var advancePay: Int = 0
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
    var membership: String?
    var metaTitle: String?
    var metaDescription: String?
    var openingDate: String?
    var holidayDates: String = ""
    var timeGap: String = ""
    var reminderMail: Int = 0
    var categoryDescription: String = ""
    var cardEnable: Int = 0
    var penaltyFees: Int = 0
    var penaltyDuration: Int = 0
    var createdAt: String = ""
    var updatedAt: String = ""
    var currency: String = ""
    var symbol: String = ""
    var emailNotifications: Int = 0
    var emailSettings: String = ""
    var bookingFlow: Int = 0
    var allowNoshow: Int?
    var noshowLimit: Int = 0
    var allowSearch: Int = 0
    var bookingGuest: Int = 0
    var setReschedule: Int = 0
    var aboutUs: String = ""
    var status: Int = 0

    required init?(map: Map) {}

    func mapping(map: Map) {
        id                  <- map["id"]
        salonId             <- map["salon_id"]
        serviceId           <- map["service_id"]
        blockCustomers      <- map["block_customers"]
        salonName           <- map["salon_name"]
        firstName           <- map["first_name"]
        lastName            <- map["last_name"]
        email               <- map["email"]
        isVerified          <- map["is_verified"]
        phone               <- map["phone"]
        salonPhone          <- map["salon_phone"]
        postcode            <- map["postcode"]
        salonType           <- map["salon_type"]
        staffSequence       <- map["staff_sequence"]
        resetToken          <- map["reset_token"]
        deviceToken         <- map["device_token"]
        fcmToken            <- map["fcm_token"]
        lastLogin           <- map["last_login"]
        averageRating       <- map["average_rating"]
        paypalEmail         <- map["paypal_email"]
        bankDetails         <- map["bank_details"]
        profilePhoto        <- map["profile_photo"]
        galleryImages       <- map["gallery_images"]
        otherImages         <- map["other_images"]
        aboutSalon          <- map["about_salon"]
        workingHours        <- map["working_hours"]
        breakTime           <- map["break_time"]
        businessVerified    <- map["business_verified"]
        facebookProfile     <- map["facebook_profile"]
        twitterProfile      <- map["twitter_profile"]
        instagramProfile    <- map["instagram_profile"]
        whatsappProfile     <- map["whatsapp_profie"]
        address             <- map["address"]
        city                <- map["city"]
        country             <- map["country"]
        latitude            <- map["latitude"]
        longitude           <- map["longitude"]
        passcodeStatus      <- map["passcode_status"]
        isPaid              <- map["is_paid"]
        allowServices       <- map["allow_services"]
        advancePay          <- map["advance_pay"]
        webStatus           <- map["web_status"]
        staffStatus         <- map["staff_status"]
        cancellationPolicy  <- map["cancellation_policy"]
        notes               <- map["notes"]
        smsCredit           <- map["sms_credit"]
        smsSettings         <- map["sms_settings"]
        reminderTime        <- map["reminder_time"]
        allowPos            <- map["allow_pos"]
        posId               <- map["pos_id"]
        isDeleted           <- map["is_deleted"]
        membership          <- map["membership"]
        metaTitle           <- map["meta_title"]
        metaDescription     <- map["meta_description"]
        openingDate         <- map["opening_date"]
        holidayDates        <- map["holiday_dates"]
        timeGap             <- map["time_gap"]
        reminderMail        <- map["reminder_mail"]
        categoryDescription <- map["category_description"]
        cardEnable          <- map["card_enable"]
        penaltyFees         <- map["penalty_fees"]
        penaltyDuration     <- map["penalty_duration"]
        createdAt           <- map["created_at"]
        updatedAt           <- map["updated_at"]
        currency            <- map["currency"]
        symbol              <- map["symbol"]
        emailNotifications  <- map["email_notifications"]
        emailSettings       <- map["email_settings"]
        bookingFlow         <- map["booking_flow"]
        allowNoshow         <- map["allow_noshow"]
        noshowLimit         <- map["noshow_limit"]
        allowSearch         <- map["allow_search"]
        bookingGuest        <- map["booking_guest"]
        setReschedule       <- map["set_reschedule"]
        aboutUs             <- map["about_us"]
        status              <- map["status"]
    }
}
