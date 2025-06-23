//
//  ServicesModel.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 13/06/25.
//

import Foundation
import ObjectMapper


class ServicesModel: Mappable {
    var data: [ServiceDatas] = []
    var error: String = ""

    init() {}

    required init?(map: Map) {}

    func mapping(map: Map) {
        data  <- map["data"]
        error <- map["error"]
    }
}


class ServiceDatas: Mappable {
    var id: Int = 0
    var service_name: String = ""
    var icon: String = ""
    var color: String = ""

    init() {}

    required init?(map: Map) {}

    func mapping(map: Map) {
        id            <- map["id"]
        service_name  <- map["service_name"]
        icon          <- map["icon"]
        color         <- map["color"]
    }
}
