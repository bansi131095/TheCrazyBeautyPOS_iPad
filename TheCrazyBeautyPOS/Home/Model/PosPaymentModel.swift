//
//  PosPaymentModel.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 24/07/25.
//

import Foundation
import ObjectMapper


class PosPaymentModel: Mappable {
    var data: PosPaymentData?
    var error: String = ""

    init() {}

    required init?(map: Map) {}

    func mapping(map: Map) {
        data  <- map["data"]
        error <- map["error"]
    }
}


class PosPaymentData: Mappable {
    var transactionStatus: String = ""
    var cardType: String = ""

    init() {}

    required init?(map: Map) {}

    func mapping(map: Map) {
        transactionStatus  <- map["transaction_status"]
        cardType          <- map["card_type"]
    }
}
