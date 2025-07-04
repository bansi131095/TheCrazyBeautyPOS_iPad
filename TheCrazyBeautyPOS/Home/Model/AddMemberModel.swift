//
//  AddMemberModel.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 04/07/25.
//

import Foundation
import ObjectMapper


class AddMemberModel: Mappable {
    var data: MemberData?
    var error: String = ""

    required init?(map: Map) {}

    init(data: MemberData? = MemberData(), error: String = "") {
        self.data = data
        self.error = error
    }

    func mapping(map: Map) {
        data  <- map["data"]
        error <- map["error"]
    }
}

class MemberData: Mappable {
    var id: Int = 0

    required init?(map: Map) {}

    init(id: Int = 0) {
        self.id = id
    }

    func mapping(map: Map) {
        id <- map["id"]
    }
}
