//
//  OfflineGiftCardListResponse.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 26/06/25.
//

import Foundation
import ObjectMapper


class OfflineGiftCardListResponse: Mappable {
    var total: Int = 0
    var totalpages: Int = 0
    var data: [OfflineGiftCardData] = []
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        total       <- map["total"]
        totalpages  <- map["totalpages"]
        data        <- map["data"]
        error       <- map["error"]
    }
}


class OfflineGiftCardData: Mappable {
    var id: Int = 0
    var gift_id: Int = 0
    var off_vendor_id: Int = 0
    var customer_id: Int = 0
    var from_mail: String = ""
    var to_mail: String = ""
    var gift_name: String = ""
    var gift_code: String = ""
    var used_date: String?
    var amount: String = ""
    var message: String = ""
    var is_used: Int = 0
    var offline_vendor: Int = 0
    var expiry_date: String = ""
    var created_at: String = ""
    var updated_at: String = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        id              <- map["id"]
        gift_id         <- map["gift_id"]
        off_vendor_id   <- map["off_vendor_id"]
        customer_id     <- map["customer_id"]
        from_mail       <- map["from_mail"]
        to_mail         <- map["to_mail"]
        gift_name       <- map["gift_name"]
        gift_code       <- map["gift_code"]
        used_date       <- map["used_date"]
        amount          <- map["amount"]
        message         <- map["message"]
        is_used         <- map["is_used"]
        offline_vendor  <- map["offline_vendor"]
        expiry_date     <- map["expiry_date"]
        created_at      <- map["created_at"]
        updated_at      <- map["updated_at"]
    }
}
