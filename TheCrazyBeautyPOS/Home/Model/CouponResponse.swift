//
//  CouponData.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 23/07/25.
//

import Foundation
import ObjectMapper


class CouponResponse: Mappable {
    var data: ApplyCouponData?
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        data  <- map["data"]
        error <- map["error"]
    }
}


class ApplyCouponData: Mappable {
    var message: String = ""
    var results: [CouponResult] = []

    required init?(map: Map) {}

    func mapping(map: Map) {
        message <- map["message"]
        results <- map["results"]
    }
}


class CouponResult: Mappable {
    var vendor_id: Int = 0
    var discount_type: String = ""
    var amount: Int = 0
    var highest_amount: Int = 0
    var coupon_name: String = ""
    var coupon_code: String = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        vendor_id      <- map["vendor_id"]
        discount_type  <- map["discount_type"]
        amount         <- map["amount"]
        highest_amount <- map["highest_amount"]
        coupon_name    <- map["coupon_name"]
        coupon_code    <- map["coupon_code"]
    }
}
