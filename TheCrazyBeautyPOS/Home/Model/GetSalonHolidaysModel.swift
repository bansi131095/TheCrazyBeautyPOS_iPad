//
//  GetSalonHolidaysModel.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 09/07/25.
//

import Foundation
import ObjectMapper

class GetSalonHolidaysModel: Mappable {
    var data: [HolidayDatesData] = []
    var error: String = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        data  <- map["data"]
        error <- map["error"]
    }
}


class HolidayDatesData: Mappable {
    var holidayDates: String = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        holidayDates <- map["holiday_dates"]
    }
}


class SalonHoliday {
    var salonHoliday: SalonHolidayData

    init(salonHoliday: SalonHolidayData) {
        self.salonHoliday = salonHoliday
    }
}


class SalonHolidayData: Mappable {
    var from: String = ""
    var to: String = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        from <- map["from"]
        to   <- map["to"]
    }
}
