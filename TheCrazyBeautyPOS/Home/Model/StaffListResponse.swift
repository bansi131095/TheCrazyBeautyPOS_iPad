//
//  StaffListResponse.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 24/07/25.
//

import Foundation
import ObjectMapper

class StaffListResponse: Mappable {
    var data: [StaffMember] = []
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        data    <- map["data"]
        error   <- map["error"]
    }
}


class StaffMember: Mappable {
    var id = 0
    var vendorId = 0
    var serviceIds = ""
    var firstName = ""
    var lastName = ""
    var email = ""
    var phone = ""
    var dob = ""
    var photo = ""
    var gender = ""
    var jobTitle = ""
    var jobBio: String?
    var workingHours = ""
    var shiftTimings = ""
    var blockTimings = ""
    var holidayDates = ""
    var showCustomer = 0
    var showInCalendar = 0
    var averageRating: String?
    var sequence = 0
    var isDeleted = 0
    var createdAt = ""
    var updatedAt: String?
    var status: String?
    var salonTiming: [TimeSlot] = []
    var holidays: [String] = []
    var totalHours = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        id              <- map["id"]
        vendorId        <- map["vendor_id"]
        serviceIds      <- map["service_ids"]
        firstName       <- map["first_name"]
        lastName        <- map["last_name"]
        email           <- map["email"]
        phone           <- map["phone"]
        dob             <- map["dob"]
        photo           <- map["photo"]
        gender          <- map["gender"]
        jobTitle        <- map["job_title"]
        jobBio          <- map["job_bio"]
        workingHours    <- map["working_hours"]
        shiftTimings    <- map["shift_timings"]
        blockTimings    <- map["block_timings"]
        holidayDates    <- map["holiday_dates"]
        showCustomer    <- map["show_customer"]
        showInCalendar  <- map["show_in_calandar"]
        averageRating   <- map["average_rating"]
        sequence        <- map["sequence"]
        isDeleted       <- map["is_deleted"]
        createdAt       <- map["created_at"]
        updatedAt       <- map["updated_at"]
        status          <- map["status"]
        salonTiming     <- (map["salon_timing"], JSONArrayTransform<TimeSlot>())
        holidays        <- map["holidays"]
        totalHours      <- map["total_hours"]
    }
}


class TimeSlot: Mappable {
    var day = ""
    var from = ""
    var to = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        day   <- map["day"]
        from  <- map["from"]
        to    <- map["to"]
    }
}

class BlockTime: Mappable {
    var day = ""
    var startTime = ""
    var endTime = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        day       <- map["day"]
        startTime <- map["startTime"]
        endTime   <- map["endTime"]
    }
}

class HolidayRange: Mappable {
    var from = ""
    var to = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        from <- map["from"]
        to   <- map["to"]
    }
}


class JSONArrayTransform<T: Mappable>: TransformType {
    typealias Object = [T]
    typealias JSON = String

    func transformFromJSON(_ value: Any?) -> [T]? {
        if let jsonString = value as? String,
           let data = jsonString.data(using: .utf8),
           let array = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
            return Mapper<T>().mapArray(JSONArray: array)
        }
        return nil
    }

    func transformToJSON(_ value: [T]?) -> String? {
        guard let array = value else { return nil }
        let jsonArray = array.map { $0.toJSON() }
        if let data = try? JSONSerialization.data(withJSONObject: jsonArray, options: []),
           let jsonStr = String(data: data, encoding: .utf8) {
            return jsonStr
        }
        return nil
    }
}
