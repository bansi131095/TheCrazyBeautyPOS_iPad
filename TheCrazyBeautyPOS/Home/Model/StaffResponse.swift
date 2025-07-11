//
//  StaffResponse.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 20/06/25.
//

import Foundation
import ObjectMapper


class StaffResponse: Mappable {
    var total: Int?
    var totalPages: Int?
    var data: [StaffData]?
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        total        <- map["total"]
        totalPages   <- map["totalpages"]
        data         <- map["data"]
        error        <- map["error"]
    }
}

class StaffData: Mappable {
    var id: Int?
    var vendorId: Int?
    var serviceIds: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var phone: String?
    var dob: String?
    var photo: String?
    var gender: String?
    var jobTitle: String?
    var jobBio: String?
    var workingHours: [WorkingHour]?
    var shiftTimings: [ShiftTiming]?
    var blockTimings: [BlockTiming]?
    var holidayDates: [HolidayDate]?
    var showCustomer: Int?
    var showInCalendar: Int?
    var averageRating: String?
    var isDeleted: Int?
    var createdAt: String?
    var updatedAt: String?
    var status: String?
    var totalHours: String?

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
        isDeleted       <- map["is_deleted"]
        createdAt       <- map["created_at"]
        updatedAt       <- map["updated_at"]
        status          <- map["status"]
        totalHours      <- map["total_hours"]
    }
}


class WorkingHour: Mappable {
    var day: String?
    var from: String?
    var to: String?
    var off: Bool?

    required init?(map: Map) {}

    func mapping(map: Map) {
        day  <- map["day"]
        from <- map["from"]
        to   <- map["to"]
        off  <- map["off"]
    }
}

class ShiftTiming: Mappable {
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

class BlockTiming: Mappable {
    var day: String?
    var startTime: String?
    var endTime: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        day       <- map["day"]
        startTime <- map["startTime"]
        endTime   <- map["endTime"]
    }
}

class HolidayDate: Mappable {
    var from: String?
    var to: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        from <- map["from"]
        to   <- map["to"]
    }
}
