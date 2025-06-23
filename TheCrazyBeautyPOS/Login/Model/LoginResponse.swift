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

