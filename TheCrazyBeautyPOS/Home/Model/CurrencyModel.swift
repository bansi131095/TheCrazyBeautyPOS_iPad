//
//  CurrencyModel.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 30/06/25.
//

import Foundation
import ObjectMapper


class CurrencyModel: Mappable {
    var data: [CurrencyData] = []
    var error: String = ""

    init() {}

    required init?(map: Map) {}

    func mapping(map: Map) {
        data  <- map["data"]
        error <- map["error"]
    }
}

class CurrencyData : Mappable{
    
    var symbol: String = ""
    var currency_code: String = ""
    var currency: String = ""
    var is_selected = Bool()
    
    init() {}

    required init?(map: Map) {}
    
    func mapping(map: Map) {
        symbol  <- map["symbol"]
        currency_code <- map["currency_code"]
        currency <- map["currency"]
    }
}




class CurrencyResponse: Mappable {
    var data: String?
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        data    <- map["data"]
        error   <- map["error"]
    }
}


//Booking FLOW
class BookingFlow : Mappable {
    
    var data: BookingFlowData?
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        data    <- map["data"]
        error   <- map["error"]
    }
    
}

class BookingFlowData : Mappable{
    var booking_flow: Int?
    
    required init?(map: Map) {}
    
    func mapping(map: ObjectMapper.Map) {
        booking_flow  <- map["booking_flow"]
    }
}

//BANK DETAILS
class BankDetailsResponse: Mappable {
    var data: [BankDetailData]?
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        data    <- map["data"]
        error   <- map["error"]
    }
}

// Each item in `data` array
class BankDetailData: Mappable {
    var id: Int?
    var bankDetails: BankDetailsOne?

    required init?(map: Map) {}

    func mapping(map: Map) {
        id <- map["id"]

        // Parse the stringified JSON
        var bankDetailsString: String?
        bankDetailsString <- map["bank_details"]
        
        if let jsonStr = bankDetailsString,
           let jsonData = jsonStr.data(using: .utf8),
           let parsed = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            bankDetails = BankDetailsOne(JSON: parsed)
        }
    }
}

// Model for actual bank detail fields
class BankDetailsOne: Mappable {
    var accountHolderName: String?
    var accountNumber: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        accountHolderName <- map["account holder name"]
        accountNumber     <- map["account number"]
    }
}


//NOTES
class NotesModel: Mappable {
    var data: [GetNotesModel] = []
    var error: String = ""

    init() {}

    required init?(map: Map) {}

    func mapping(map: Map) {
        data  <- map["data"]
        error <- map["error"]
    }
}

class GetNotesModel: Mappable {
    var notes: String = ""
    
    init() {}

    required init?(map: Map) {}

    func mapping(map: Map) {
        notes <- map["notes"]
    }
}


//AMOUNT
class AmountModel: Mappable {
//    var data: [GetAmountModel] = []
    var data: [GetAmountModel]?
    var error: String = ""

    init() {}

    required init?(map: Map) {}

    func mapping(map: Map) {
        data  <- map["data"]
        error <- map["error"]
    }
}

class GetAmountModel: Mappable {
    var advance_pay: Int = 0
    var penalty_fees: Int = 0
    var penalty_duration: Int = 0
    var cancellation_policy: String?
    
    init() {}

    required init?(map: Map) {}

    func mapping(map: Map) {
        advance_pay <- map["advance_pay"]
        penalty_fees <- map["penalty_fees"]
        penalty_duration <- map["penalty_duration"]
        cancellation_policy <- map["cancellation_policy"]
    }
}


// Team_Details
class TeamModel: Mappable {
    
    var total: Int = 0
    var totalpages: Int = 0
    var data: [TeamDetailsModel] = []
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        total        <- map["total"]
        totalpages   <- map["totalpages"]
        data         <- map["data"]
        error        <- map["error"]
    }
}

class TeamDetailsModel: Mappable {
    
    var id: Int = 0
    var vendor_id: Int = 0
    var service_ids: String = ""
    var first_name: String = ""
    var last_name: String = ""
    var email: String = ""
    var phone: String = ""
    var dob: String = ""
    var photo: String = ""
    var gender: String = ""
    var job_title: String = ""
    var job_bio: String?
    var working_hours: String = ""
    var shift_timings: String = ""
    var block_timings: String = ""
    var holiday_dates: String?
    var show_customer: Int = 0
    var show_in_calandar: Int = 0
    var average_rating: String?
    var is_deleted: Int = 0
    var created_at: String = ""
    var updated_at: String?
    var status: String?
    var total_hours: String = ""
    var sequence: String = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        id                <- map["id"]
        vendor_id         <- map["vendor_id"]
        service_ids       <- map["service_ids"]
        first_name        <- map["first_name"]
        last_name         <- map["last_name"]
        email             <- map["email"]
        phone             <- map["phone"]
        dob               <- map["dob"]
        photo             <- map["photo"]
        gender            <- map["gender"]
        job_title         <- map["job_title"]
        job_bio           <- map["job_bio"]
        working_hours     <- map["working_hours"]
        shift_timings     <- map["shift_timings"]
        block_timings     <- map["block_timings"]
        holiday_dates     <- map["holiday_dates"]
        show_customer     <- map["show_customer"]
        show_in_calandar  <- map["show_in_calandar"]
        average_rating    <- map["average_rating"]
        is_deleted        <- map["is_deleted"]
        created_at        <- map["created_at"]
        updated_at        <- map["updated_at"]
        status            <- map["status"]
        total_hours       <- map["total_hours"]
    }
}


//StaffSequenceModel

class GetStaffSequenceModel: Mappable {
    var data: [StaffSequenceWrapper] = []
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        data   <- map["data"]
        error  <- map["error"]
    }
}


class StaffSequenceWrapper: Mappable {
    var staff_sequence: String = ""
    var staffSequenceArray: [StaffSequenceItem] = []

    required init?(map: Map) {}

    func mapping(map: Map) {
        staff_sequence <- map["staff_sequence"]

        // Decode JSON string to array
        if let data = staff_sequence.data(using: .utf8) {
            if let decoded = try? JSONDecoder().decode([StaffSequenceItem].self, from: data) {
                self.staffSequenceArray = decoded
            }
        }
    }
}

struct StaffSequenceItem: Codable {
    let staff_id: String
    let sequence: String
}

//Profile
class ProfileModel: Mappable {
    
    var data: [profileDetailsModel] = []
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        data         <- map["data"]
        error        <- map["error"]
    }
}

class profileDetailsModel: Mappable {
    
    
    var id: Int?
    var profile_photo: String?
    var gallery_images: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        id                   <- map["id"]
        profile_photo        <- map["profile_photo"]
        gallery_images        <- map["gallery_images"]
    }
    
}



class SelectedService: Mappable {
    var data: SelectedServiceModel?
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        data    <- map["data"]
        error   <- map["error"]
    }
}



class SelectedServiceModel: Mappable {
    var message: String?
    var bussiness_verified: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        message <- map["message"]
        bussiness_verified     <- map["bussiness_verified"]
    }
}


class CategoryModel: Mappable {
    
    var data: [CategoryDetailsModel] = []
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        data         <- map["data"]
        error        <- map["error"]
    }
}

class CategoryDetailsModel: Mappable {
    
    
    var id: Int = 0
    var service_name: String = ""
    var sequence: String = ""
    var descriptionText: String = ""
    var icon: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        id                  <- map["id"]
        service_name        <- map["service_name"]
        icon                <- map["icon"]
    }
    
}

class CategoryStaffSequenceModel: Mappable {
    var data: [categorydescriptionModel] = []
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        data   <- map["data"]
        error  <- map["error"]
    }
}


class categorydescriptionModel: Mappable {
    var category_description: String = ""
    var staffSequenceArray: [categoryData] = []

    required init?(map: Map) {}

    func mapping(map: Map) {
        category_description <- map["category_description"]

        if let data = category_description.data(using: .utf8) {
            if let decoded = try? JSONDecoder().decode([categoryData].self, from: data) {
                self.staffSequenceArray = decoded
            } else {
                print("❌ Failed to decode category_description")
            }
        }
    }
}

struct categoryData: Codable {
    let category_id: Int
    let description: String
    let sequence: String
}



class GetKioskModel: Mappable {
    
    var data: [KioskDetailsModel] = []
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        data         <- map["data"]
        error        <- map["error"]
    }
}

class KioskData: Mappable {
    var id: Int?
    var updated_at: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        id            <- map["id"]
        updated_at    <- map["updated_at"]
    }
}


class KioskDetailsModel: Mappable {
    
    
    var id: Int = 0
    var vendor_id: Int = 0
    var email: String = ""
    var password: String = ""
    var created_at: String?
    var name: String?
    var updated: String?
    

    required init?(map: Map) {}

    func mapping(map: Map) {
        id                  <- map["id"]
        vendor_id           <- map["vendor_id"]
        email               <- map["email"]
        password            <- map["password"]
        created_at          <- map["created_at"]
        name          <- map["name"]
        updated             <- map["updated"]
    }
    
}





class GetKioskModel1: Mappable {
    var data: [KioskData1] = []
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        data  <- map["data"]
        error <- map["error"]
    }
}


class KioskData1: Mappable {
    var id: Int?
    var working_hours: String?
    var updated_at: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        id            <- map["id"]
        working_hours <- map["working_hours"]
        updated_at    <- map["updated_at"]
    }
}


class WorkingHour1: Mappable {
    var day: String?
    var from: String?
    var to: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        day  <- map["day"]
        from <- map["from"]
        to   <- map["to"]
    }
}


class BreakTime1: Mappable {
    var day: String = ""
    var startTime: String = ""
    var endTime: String = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        day         <- map["day"]
        startTime   <- map["startTime"]
        endTime     <- map["endTime"]
    }
}

class BreakTimeDataModel: Mappable {
    var id: Int = 0
    var break_time: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        id          <- map["id"]
        break_time  <- map["break_time"]
    }
}

class GetBreakTimeModel: Mappable {
    var data: [BreakTimeDataModel] = []
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        data    <- map["data"]
        error   <- map["error"]
    }
}



class SMSDetailsModel: Mappable {
    var data: [SMSDetailsData] = []
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        data    <- map["data"]
        error   <- map["error"]
    }
}

class SMSDetailsData: Mappable {
    
    var sms_credit: Int?
    var sms_settings: String?
    var reminder_time: Int?
    var email_notifications: Int?
    var email_settings: String?


    required init?(map: Map) {}

    func mapping(map: Map) {
        sms_credit          <- map["sms_credit"]
        sms_settings        <- map["sms_settings"]
        reminder_time       <- map["reminder_time"]
        email_notifications <- map["email_notifications"]
        email_settings      <- map["email_settings"]
    }
}

struct Addresses : Mappable {
    var address_Id : String?
    var city : String?
    var postal_Code : String?
    var landmark : String?
    var address : String?
    var address_Latitude : String?
    var address_Longitude : String?
    var is_Selected : Bool?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        address_Id <- map["Address_Id"]
        city <- map["City"]
        postal_Code <- map["Postal_Code"]
        landmark <- map["Landmark"]
        address <- map["Address"]
        address_Latitude <- map["Address_Latitude"]
        address_Longitude <- map["Address_Longitude"]
        is_Selected <- map["Is_Selected"]
    }

}

