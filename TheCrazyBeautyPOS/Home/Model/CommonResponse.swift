//
//  CommonResponse.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 03/07/25.
//

import Foundation
import ObjectMapper


class CommonResponse: Mappable {
    var data: String = ""
    var dataObject: TransactionData?
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        data  <- map["data"]
        dataObject  <- map["data"]
        error <- map["error"]
    }
}


class TransactionData: Mappable {
    var transaction_status: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        transaction_status <- map["transaction_status"]
    }
}

class RefundDataModel : Mappable{
    
    var data: RefundData?
    var error: String?

    required init?(map: Map) {}
    
    func mapping(map: Map) {
        data  <- map["data"]
        error <- map["error"]
    }
}

class RefundData: Mappable {
    var message: String?
    var refund_id: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        message   <- map["message"]
        refund_id <- map["refund_id"]
    }
}

/*struct CommonResponse: Codable {
    let data: String
    let error: String?
}*/

/*class CommonResponse: Mappable {
    var data: String?
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        data    <- map["data"]
        error   <- map["error"]
    }
}
*/
