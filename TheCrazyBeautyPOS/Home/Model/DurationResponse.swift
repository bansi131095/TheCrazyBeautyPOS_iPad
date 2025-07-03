//
//  DurationResponse.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 03/07/25.
//

import Foundation
import ObjectMapper

// MARK: - Root Model
class DurationResponse: Mappable {
    var data: [DurationItem] = []
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        data    <- map["data"]
        error   <- map["error"]
    }
}

// MARK: - Duration Item
class DurationItem: Mappable {
    var label: String = ""
    var duration: String = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        label     <- map["label"]
        duration  <- map["duration"]
    }
}
