//
//  TeamRosterItem.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 24/07/25.
//

import Foundation
import ObjectMapper

class TeamRosterItem: Mappable {
    var name: String = ""
    var totalHours: String = ""
    var schedule: [DaySchedule]?

    // Required for mapping from JSON
    required init?(map: Map) {}

    // Mapping keys
    func mapping(map: Map) {
        name        <- map["name"]
        totalHours  <- map["totalHours"]
        schedule    <- map["schedule"]
    }

    // ✅ Custom initializer for manual instantiation
    init(name: String, totalHours: String, schedule: [DaySchedule]?) {
        self.name = name
        self.totalHours = totalHours
        self.schedule = schedule
    }
}



class DaySchedule: Mappable {
    var timeText: String = ""
    var status: String = ""

    // ✅ ObjectMapper required initializer
    required init?(map: Map) {}

    // ✅ Mapping for JSON
    func mapping(map: Map) {
        timeText <- map["timeText"]
        status   <- map["status"]
    }

    // ✅ Add this custom initializer to fix the error
    init(timeText: String, status: String) {
        self.timeText = timeText
        self.status = status
    }
}


class DateTimeRange: Mappable {
    var start: String = ""
    var end: String = ""

    // Required by ObjectMapper
    required init?(map: Map) {}

    func mapping(map: Map) {
        start <- map["start"]
        end   <- map["end"]
    }

    // ✅ Custom initializer for manual use
    init(start: String, end: String) {
        self.start = start
        self.end = end
    }
}

