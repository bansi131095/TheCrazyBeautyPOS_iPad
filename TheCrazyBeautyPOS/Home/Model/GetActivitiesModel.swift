//
//  GetActivitiesModel.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 10/07/25.
//

import Foundation
import ObjectMapper

class GetActivitiesModel: Mappable {
    var totalPages: Int = 0
    var total: Int = 0
    var data: [MessageData] = []
    var error: String = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        total       <- map["total"]
        totalPages  <- map["totalpages"]
        data        <- map["data"]
        error       <- map["error"]
    }
}


class MessageData: Mappable {
    var message: String = ""
    var viewed: Int = 0
    var createdAt: String = ""
    var updatedAt: String = ""
    var description: String = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        message     <- map["message"]
        viewed      <- map["viewed"]
        createdAt   <- map["created_at"]
        updatedAt   <- map["updated_at"]
        description <- map["description"]
    }
}
