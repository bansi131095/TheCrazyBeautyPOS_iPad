//
//  CouponListResponse.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 26/06/25.
//

import Foundation
import ObjectMapper


class CouponListResponse: Mappable {
    var total: Int = 0
    var totalpages: Int = 0
    var data: [CouponData] = []
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        total       <- map["total"]
        totalpages  <- map["totalpages"]
        data        <- map["data"]
        error       <- map["error"]
    }
}


class CouponData: Mappable {
    var id: Int = 0
    var vendor_id: Int = 0
    var discount_type: String = ""
    var amount: Int = 0
    var highest_amount: Int = 0
    var coupon_name: String = ""
    var coupon_code: String = ""
    var coupon_status: String?
    var description: String?
    var start_date: String = ""
    var end_date: String = ""
    var status: String = ""
    var is_deleted: Int = 0
    var created_at: String = ""
    var updated_at: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        id              <- map["id"]
        vendor_id       <- map["vendor_id"]
        discount_type   <- map["discount_type"]
        amount          <- map["amount"]
        highest_amount  <- map["highest_amount"]
        coupon_name     <- map["coupon_name"]
        coupon_code     <- map["coupon_code"]
        coupon_status   <- map["coupon_status"]
        description     <- map["description"]
        start_date      <- map["start_date"]
        end_date        <- map["end_date"]
        status          <- map["status"]
        is_deleted      <- map["is_deleted"]
        created_at      <- map["created_at"]
        updated_at      <- map["updated_at"]
    }
}
