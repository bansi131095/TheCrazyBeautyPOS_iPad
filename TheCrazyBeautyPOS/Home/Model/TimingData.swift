//
//  TimingModel.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 04/07/25.
//

import Foundation
import ObjectMapper

class TimingModel: Mappable {
    var data: [TimingData] = []
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        data  <- map["data"]
        error <- map["error"]
    }
}


class TimingData: Mappable {
    var id: Int?
    var working_hours: String?
    var updated_at: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        id            <- map["id"]
        working_hours <- map["working_hours"]
        updated_at    <- map["updated_at"]
    }
}

