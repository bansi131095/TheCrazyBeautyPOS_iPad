//
//  ServiceCategory.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 13/06/25.
//

import Foundation
import ObjectMapper

class ServiceCategory: Mappable {
    var categoryName: String = ""
    var icon: String = ""
    var services: [ServiceItem] = []
    var totalCount: Int = 0

    required init?(map: Map) {}
    init() {}
    
    init(categoryName: String, icon: String, services: [ServiceItem], totalCount: Int) {
        self.categoryName = categoryName
        self.icon         = icon
        self.services     = services
        self.totalCount   = totalCount
    }

    func mapping(map: Map) {
        categoryName <- map["categoryName"]
        icon         <- map["icon"]
        services     <- map["services"]
        totalCount   <- map["TotalCount"]
    }
}


class ServiceItem: Mappable {
    var id: Int = 0
    var category_id: Int = 0
    var has_sub_service: Int = 0
    var sub_service: [ServiceItem] = []
    var name: String = ""
    var price: Double = 0.0
    var count: Int = 0

    required init?(map: Map) {}
//    init() {}
    
    init(id: Int,category_id:Int,has_sub_service:Int,sub_service:[ServiceItem] = [], name: String, price: Double, count: Int = 0) {
        self.id = id
        self.category_id = category_id
        self.has_sub_service = has_sub_service
        self.sub_service = sub_service
        self.name = name
        self.price = price
        self.count = count
    }

    func mapping(map: Map) {
        id    <- map["id"]
        category_id    <- map["category_id"]
        has_sub_service    <- map["has_sub_service"]
        sub_service    <- map["sub_service"]
        name  <- map["name"]
        price <- map["price"]
        count <- map["count"]
    }
}
