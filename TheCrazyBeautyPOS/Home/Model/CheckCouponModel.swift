//
//  CheckCouponModel.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 23/07/25.
//

import Foundation
import ObjectMapper


class CheckCouponModel: Mappable {
    var data: checkCouponData?
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        data  <- map["data"]
        error <- map["error"]
    }
}


class checkCouponData: Mappable {
    var is_coupon: Int = 0
    var is_gift: Int = 0

    required init?(map: Map) {}

    func mapping(map: Map) {
        is_coupon <- map["is_coupon"]
        is_gift   <- map["is_gift"]
    }
}
