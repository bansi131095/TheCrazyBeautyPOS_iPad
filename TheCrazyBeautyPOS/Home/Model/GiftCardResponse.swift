//
//  GiftCardResponse.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 24/07/25.
//

//

import Foundation
import ObjectMapper


class GiftCardResponse: Mappable {
    var data: ApplyGiftCardData?
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        data  <- map["data"]
        error <- map["error"]
    }
}


class ApplyGiftCardData: Mappable {
    var message: String = ""
    var results: [GiftCardResult] = []

    required init?(map: Map) {}

    func mapping(map: Map) {
        message <- map["message"]
        results <- map["results"]
    }
}


class GiftCardResult: Mappable {
    var id: Int = 0
    var vendor_id: Int = 0
    var image: String = ""
    var price: Int = 0
    var expired_in: Int = 0
    var card_name: String = ""
    var description: String = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        id      <- map["vendor_id"]
        vendor_id  <- map["vendor_id"]
        image         <- map["image"]
        price <- map["price"]
        expired_in    <- map["expired_in"]
        card_name    <- map["card_name"]
        description <- map["description"]
    }
}
