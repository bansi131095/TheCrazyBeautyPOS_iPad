//
//  ServiceDetailsModel.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 13/06/25.
//

import Foundation
import ObjectMapper

class ServiceDetailsModel: Mappable {
    var total: Int = 0
    var totalpages: Int = 0
    var data: [ServiceData] = []
    var error: String = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        total       <- map["total"]
        totalpages  <- map["totalpages"]
        data        <- map["data"]
        error       <- map["error"]
    }
}

class ServiceData: Mappable {
    var cellindex: Int = 0
    var cartCount: Int = 0
    var id: Int = 0
    var duration: Int = 0
    var price: String = ""
    var sale_price: String = ""
    var category_id: Int = 0
    var category: String = ""
    var service: String = ""
    var service_for: String = ""
    var description: String = ""
    var price_type: String = ""
    var selectedTeamId: Int = 0
    var selectedTeamName: String = ""
    var selectedTeamPhoto: String = ""
    var staff_id: String = ""
    var isVendorOnly: Int = 0
    var patchTest: Int = 0
    var conatctSalon: Int = 0
    var numberOfGuests: Int = 0
    var isFav: Int = 0
    var guests: [Guest] = []

    required init?(map: Map) {}

    func mapping(map: Map) {
        cellindex          <- map["cellIndex"]
        cartCount          <- map["cartCount"]
        id                 <- map["id"]
        duration           <- map["duration"]
        price              <- map["price"]
        sale_price         <- map["sale_price"]
        category_id        <- map["category_id"]
        category           <- map["category"]
        service            <- map["service"]
        service_for        <- map["service_for"]
        description        <- map["description"]
        price_type         <- map["price_type"]
        selectedTeamId     <- map["selectedTeamId"]
        selectedTeamName   <- map["selectedTeamName"]
        selectedTeamPhoto  <- map["selectedTeamPhoto"]
        staff_id           <- map["staff_id"]
        isVendorOnly       <- map["is_vendor_only"]
        patchTest          <- map["test_required"]
        conatctSalon       <- map["contact_salon"]
        numberOfGuests     <- map["numberOfGuests"]
        isFav              <- map["isFav"]
        guests             <- map["guests"]
    }
}

class Guest: Mappable {
    var name: String = ""
    var age: Int = 0
    var gender: String = ""

    // Modify properties above to match your real guest structure

    required init?(map: Map) {}

    func mapping(map: Map) {
        name    <- map["name"]
        age     <- map["age"]
        gender  <- map["gender"]
    }
}

