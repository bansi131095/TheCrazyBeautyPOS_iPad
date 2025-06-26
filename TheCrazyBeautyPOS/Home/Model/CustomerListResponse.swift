//
//  CustomerListResponse.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 26/06/25.
//

import Foundation
import ObjectMapper


class CustomerListResponse: Mappable {
    var total: Int = 0
    var totalpages: Int = 0
    var data: [CustomerData] = []
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        total       <- map["total"]
        totalpages  <- map["totalpages"]
        data        <- map["data"]
        error       <- map["error"]
    }
}


class CustomerData: Mappable {
    var id: Int = 0
    var vendor_id: String = ""
    var parent_customer: Int = 0
    var user_name: String?
    var first_name: String = ""
    var last_name: String = ""
    var email: String = ""
    var phone: String = ""
    var password: String?
    var otp: String?
    var gender: String = ""
    var dob: String = ""
    var photo: String = ""
    var address1: String?
    var address2: String?
    var city: String?
    var postcode: String?
    var social_id: String?
    var social_type: String?
    var verification_token: String?
    var is_verified: Bool?
    var reset_token: String?
    var device_token: String?
    var fcm_token: String?
    var last_visit: String?
    var referal_link: String?
    var paypal_email: String?
    var card_details: String?
    var comment: String?
    var client_type: String = ""
    var type: String = ""
    var kind: String = ""
    var is_deleted: Int = 0
    var last_booked_date: String?
    var created_at: String = ""
    var updated_at: String?
    var status: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        id                  <- map["id"]
        vendor_id           <- map["vendor_id"]
        parent_customer     <- map["parent_customer"]
        user_name           <- map["user_name"]
        first_name          <- map["first_name"]
        last_name           <- map["last_name"]
        email               <- map["email"]
        phone               <- map["phone"]
        password            <- map["password"]
        otp                 <- map["otp"]
        gender              <- map["gender"]
        dob                 <- map["dob"]
        photo               <- map["photo"]
        address1            <- map["address1"]
        address2            <- map["address2"]
        city                <- map["city"]
        postcode            <- map["postcode"]
        social_id           <- map["social_id"]
        social_type         <- map["social_type"]
        verification_token  <- map["verification_token"]
        is_verified         <- map["is_verified"]
        reset_token         <- map["reset_token"]
        device_token        <- map["device_token"]
        fcm_token           <- map["fcm_token"]
        last_visit          <- map["last_visit"]
        referal_link        <- map["referal_link"]
        paypal_email        <- map["paypal_email"]
        card_details        <- map["card_details"]
        comment             <- map["comment"]
        client_type         <- map["client_type"]
        type                <- map["type"]
        kind                <- map["kind"]
        is_deleted          <- map["is_deleted"]
        last_booked_date    <- map["last_booked_date"]
        created_at          <- map["created_at"]
        updated_at          <- map["updated_at"]
        status              <- map["status"]
    }
}
