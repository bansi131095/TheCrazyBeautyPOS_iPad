//
//  GetAllSalonModel.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 10/07/25.
//

import Foundation
import ObjectMapper


class GetAllSalonModel: Mappable {
    var data: [Salon] = []
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        data  <- map["data"]
        error <- map["error"]
    }
}


class Salon: Mappable {
    
    var id: Int = 0
    var salonId: Int = 0
    var salonName: String = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        id        <- map["id"]
        salonId   <- map["salon_id"]
        salonName <- map["salon_name"]
    }
    
}

