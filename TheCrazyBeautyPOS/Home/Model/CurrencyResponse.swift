//
//  CurrencyResponse.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 02/07/25.
//

import Foundation
import ObjectMapper



// MARK: - CurrencyResponse
class CurrencyResponse: Mappable {
    var data: [CurrencyData]?
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        data  <- map["data"]
        error <- map["error"]
    }
}

// MARK: - CurrencyData
class CurrencyData: Mappable {
    
    var currency: String?
    var symbol: String?
    var currency_code: String = ""
    var is_selected = Bool()

    required init?(map: Map) {}

    func mapping(map: Map) {
        currency <- map["currency"]
        symbol   <- map["symbol"]
    }
}


class Reminder: Mappable {
    var data: [ReminderModel]?
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        data  <- map["data"]
        error <- map["error"]
    }
}

class ReminderModel: Mappable {
    var reminder_mail: Int?
    var time_gap: String?
    
    required init?(map: Map) {}

    func mapping(map: Map) {
        reminder_mail  <- map["reminder_mail"]
        time_gap  <- map["time_gap"]
    }
}


class TopServices: Mappable {
    var data: [Service_ModelData]?
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        data  <- map["data"]
        error <- map["error"]
    }
}

// MARK: - CurrencyData
class Service_ModelData: Mappable {
    
    var id: Int?
    var service_id: Int?
    var booking_count: Int?
    var service_name: String?
    var fullname: String?
    var total_price: Int?
    
    required init?(map: Map) {}

    func mapping(map: Map) {
        id <- map["id"]
        service_id <- map["service_id"]
        booking_count <- map["booking_count"]
        service_name <- map["service_name"]
        fullname <- map["fullname"]
        total_price <- map["total_price"]
    }
}
