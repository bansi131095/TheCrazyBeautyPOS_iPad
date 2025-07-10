//
//  CommonResponse.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 03/07/25.
//

import Foundation
import ObjectMapper


class CommonResponses: Mappable {
    var data: String = ""
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        data  <- map["data"]
        error <- map["error"]
    }
}


struct CommonResponse: Codable {
    let data: String
    let error: String?
}
