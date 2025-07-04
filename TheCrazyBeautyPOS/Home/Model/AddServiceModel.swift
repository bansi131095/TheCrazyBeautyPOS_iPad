//
//  AddServiceModel.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 04/07/25.
//

import Foundation
import ObjectMapper

class AddServiceModel: Mappable {
    var data: AddServiceDatas?
    var error: String?

    required init?(map: Map) {}

    init(data: AddServiceDatas? = AddServiceDatas(), error: String = "") {
        self.data = data
        self.error = error
    }

    func mapping(map: Map) {
        data  <- map["data"]
        error <- map["error"]
    }
}

class AddServiceDatas: Mappable {
    var id: Int = 0
    var message: String = ""

    required init?(map: Map) {}

    init(id: Int = 0, message: String = "") {
        self.id = id
        self.message = message
    }

    func mapping(map: Map) {
        id      <- map["id"]
        message <- map["message"]
    }
}
