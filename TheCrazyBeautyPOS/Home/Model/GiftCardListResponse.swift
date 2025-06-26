//
//  GiftCardListResponse.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 26/06/25.
//

import Foundation
import ObjectMapper


class GiftCardListResponse: Mappable {
    var total: Int = 0
    var totalpages: Int = 0
    var data: [GiftCardData] = []
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        total       <- map["total"]
        totalpages  <- map["totalpages"]
        data        <- map["data"]
        error       <- map["error"]
    }
}


class GiftCardData: Mappable {
    var id: Int = 0
    var image: String = ""
    var vendor_id: Int = 0
    var card_name: String = ""
    var price: String = ""
    var expired_in: Int = 0
    var status: String = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        id          <- map["id"]
        image       <- map["image"]
        vendor_id   <- map["vendor_id"]
        card_name   <- map["card_name"]
        price       <- map["price"]
        expired_in  <- map["expired_in"]
        status      <- map["status"]
    }
}

