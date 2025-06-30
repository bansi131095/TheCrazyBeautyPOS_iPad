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
    let is_selected = Bool()
    
    init() {}

    required init?(map: Map) {}
    
    func mapping(map: Map) {
        symbol  <- map["symbol"]
        currency_code <- map["currency_code"]
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

