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
