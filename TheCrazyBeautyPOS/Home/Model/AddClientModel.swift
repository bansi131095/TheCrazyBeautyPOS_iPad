//
//  AddClientModel.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 02/07/25.
//

import Foundation
import ObjectMapper

// MARK: - AddClientModel
class AddClientModel: Mappable {
    var data: DataModel?
    var error: String = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        data    <- map["data"]
        error   <- map["error"]
    }
}

// MARK: - DataModel
class DataModel: Mappable {
    var message: String?
    var clientDetails: ClientDetails?

    required init?(map: Map) {}

    func mapping(map: Map) {
        message        <- map["message"]
        clientDetails  <- map["client_details"]
    }
}

// MARK: - ClientDetails
class ClientDetails: Mappable {
    var id: Int?
    var firstName: String?
    var lastName: String?
    var email: String?
    var phone: String?
    var gender: String?
    var dob: String?
    var clientType: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        id         <- map["id"]
        firstName  <- map["first_name"]
        lastName   <- map["last_name"]
        email      <- map["email"]
        phone      <- map["phone"]
        gender     <- map["gender"]
        dob        <- map["dob"]
        clientType <- map["client_type"]
    }
}
