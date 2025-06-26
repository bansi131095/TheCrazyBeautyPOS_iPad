//
//  InventoryListResponse.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 26/06/25.
//

import Foundation
import ObjectMapper


class InventoryListResponse: Mappable {
    var total: Int = 0
    var totalpages: Int = 0
    var data: [InventoryData] = []
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        total       <- map["total"]
        totalpages  <- map["totalpages"]
        data        <- map["data"]
        error       <- map["error"]
    }
}


class InventoryData: Mappable {
    var id: Int = 0
    var vendor_id: Int = 0
    var product_name: String = ""
    var price: Int = 0
    var qty: Int = 0

    required init?(map: Map) {}

    func mapping(map: Map) {
        id            <- map["id"]
        vendor_id     <- map["vendor_id"]
        product_name  <- map["product_name"]
        price         <- map["price"]
        qty           <- map["qty"]
    }
}
