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

    required init?(map: Map) {}

    func mapping(map: Map) {
        currency <- map["currency"]
        symbol   <- map["symbol"]
    }
}
