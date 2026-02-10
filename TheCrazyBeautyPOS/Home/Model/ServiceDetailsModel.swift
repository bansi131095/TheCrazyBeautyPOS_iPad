//
//  ServiceDetailsModel.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 13/06/25.
//

import Foundation
import ObjectMapper

class ServiceDetailsModel: Mappable {
    var total: Int = 0
    var totalpages: Int = 0
    var data: [ServiceData] = []
    var total_sales: String = ""
    var error: String = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        total       <- map["total"]
        totalpages  <- map["totalpages"]
        data        <- map["data"]
        total_sales <- map["total_sales"]
        error       <- map["error"]
    }
}

class ServiceData: Mappable {
    var cellindex: Int = 0
    var cartCount: Int = 0
    var id: Int = 0
    var duration: Int = 0
    var price: String = ""
//    var sale_price: Double?
    var sale_price: String = ""
    var category_id: Int = 0
    var category: String = ""
    var service: String = ""
    var service_for: String = ""
    var service_name: String = ""
    var description: String = ""
    var price_type: String = ""
    var selectedTeamId: Int = 0
    var selectedTeamName: String = ""
    var selectedTeamPhoto: String = ""
    var staff_id: String = ""
    var isVendorOnly: Int = 0
    var patchTest: Int = 0
    var conatctSalon: Int = 0
    var numberOfGuests: Int = 0
    var isFav: Int = 0
    var amount: Int = 0
    var total_saleprice: Int = 0
    var has_sub_service: Int = 0
    var is_sub_service: Int = 0
    var resource_id: String = ""
    var guests: [Guest] = []

    required init?(map: Map) {}

    func mapping(map: Map) {
        cellindex          <- map["cellIndex"]
        cartCount          <- map["cartCount"]
        id                 <- map["id"]
        duration           <- map["duration"]
        price              <- map["price"]
        sale_price         <- map["sale_price"]
        category_id        <- map["category_id"]
        category           <- map["category"]
        service            <- map["service"]
        service_for        <- map["service_for"]
        service_name       <- map["service_name"]
        description        <- map["description"]
        price_type         <- map["price_type"]
        selectedTeamId     <- map["selectedTeamId"]
        selectedTeamName   <- map["selectedTeamName"]
        selectedTeamPhoto  <- map["selectedTeamPhoto"]
        staff_id           <- map["staff_id"]
        isVendorOnly       <- map["is_vendor_only"]
        patchTest          <- map["test_required"]
        conatctSalon       <- map["contact_salon"]
        numberOfGuests     <- map["numberOfGuests"]
        isFav              <- map["isFav"]
        amount             <- map["amount"]
        total_saleprice    <- map["total_saleprice"]
        has_sub_service    <- map["has_sub_service"]
        is_sub_service    <- map["is_sub_service"]
        resource_id    <- map["resource_id"]
        guests             <- map["guests"]
    }
}

class Guest: Mappable {
    var name: String = ""
    var age: Int = 0
    var gender: String = ""

    // Modify properties above to match your real guest structure

    required init?(map: Map) {}

    func mapping(map: Map) {
        name    <- map["name"]
        age     <- map["age"]
        gender  <- map["gender"]
    }
}

class GiftModel: Mappable {
    var total: Int = 0
    var totalpages: Int = 0
    var data: [GiftDateModel] = []
    var totalSales: String = ""
    var error: String = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        total       <- map["total"]
        totalpages  <- map["totalpages"]
        data        <- map["data"]
        totalSales <- map["totalSales"]
        error       <- map["error"]
    }
}

class GiftDateModel: Mappable {
    
    var id: Int = 0
    var gift_id: Int = 0
    var off_vendor_id: Int = 0
    var customer_id: Int = 0
    var from_mail: String = ""
    var to_mail: String = ""
    var gift_name: String = ""
    var gift_code: String = ""
    var used_date: String = ""
    var amount: Int = 0
    var offline_vendor: Int = 0
    var message: String = ""
    var expiry_date: String = ""
    var created_at: String = ""
    var updated_at: String = ""
    

    required init?(map: Map) {}

    func mapping(map: Map) {
        id                   <- map["id"]
        gift_id              <- map["gift_id"]
        off_vendor_id        <- map["off_vendor_id"]
        customer_id          <- map["customer_id"]
        from_mail            <- map["from_mail"]
        to_mail              <- map["to_mail"]
        gift_name            <- map["gift_name"]
        gift_code            <- map["gift_code"]
        used_date            <- map["used_date"]
        amount               <- map["amount"]
        offline_vendor       <- map["offline_vendor"]
        message              <- map["message"]
        expiry_date          <- map["expiry_date"]
        created_at           <- map["created_at"]
        updated_at           <- map["updated_at"]
        
    }
}

class SalesHistoryModel: Mappable {
    var total: Int = 0
    var totalpages: Int = 0
    var passcode_status: Int = 0
    var totalAmount: String = ""
    var data: [SalesHistoryDateModel] = []
    var error: String = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        total       <- map["total"]
        totalpages  <- map["totalpages"]
        data        <- map["data"]
        totalAmount <- map["totalAmount"]
        error       <- map["error"]
    }
}

class SalesHistoryDateModel: Mappable {
    
    var id: Int = 0
    var booking_number: String = ""
    var booking_id: Int = 0
    var booking_date: String = ""
    var booking_time: String = ""
    var name: String = ""
    var phone: String = ""
    var customer_type: String = ""
    var salon_name: String = ""
    var staff_names: String = ""
    var services: String = ""
    var duration: String = ""
    var payment_type: String = ""
    var sub_total: Int = 0
    var discount_amount: String = ""
    var grand_total: String = ""
    var booking_status: String = ""
    var miscellaneous_notes: String = ""
    var miscellaneous_price: String = ""
    var tip: Int = 0
    var penalty_amount: Int = 0
    var card_amount: Int = 0
    var cash_amount: Int = 0
    var paid_amount: Int = 0
    var coupon_code: String = ""
    

    required init?(map: Map) {}

    func mapping(map: Map) {
        id                   <- map["id"]
        booking_number       <- map["booking_number"]
        booking_id           <- map["booking_id"]
        booking_date                 <- map["booking_date"]
        booking_time          <- map["booking_time"]
        name            <- map["name"]
        phone              <- map["phone"]
        customer_type            <- map["customer_type"]
        salon_name            <- map["salon_name"]
        staff_names            <- map["staff_names"]
        services               <- map["services"]
        duration       <- map["duration"]
        payment_type              <- map["payment_type"]
        sub_total          <- map["sub_total"]
        discount_amount           <- map["discount_amount"]
        grand_total           <- map["grand_total"]
        booking_status           <- map["booking_status"]
        miscellaneous_notes           <- map["miscellaneous_notes"]
        miscellaneous_price           <- map["miscellaneous_price"]
        tip           <- map["tip"]
        penalty_amount           <- map["penalty_amount"]
        card_amount           <- map["card_amount"]
        cash_amount           <- map["cash_amount"]
        paid_amount           <- map["paid_amount"]
        coupon_code           <- map["coupon_code"]
        
    }
}


class WalkinModel: Mappable {
    var total: Int = 0
    var totalpages: Int = 0
    var total_sales: String = ""
    var data: [WalkinHistoryDateModel] = []
    var error: String = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        total       <- map["total"]
        totalpages  <- map["totalpages"]
        total_sales <- map["total_sales"]
        data        <- map["data"]
        error       <- map["error"]
    }
}


class WalkinHistoryDateModel: Mappable {
    
    var id: Int = 0
    var vendor_id: Int = 0
    var service_ids: String = ""
    var gift_card: String = ""
    var booking_number: String = ""
    var coupon_code: String = ""
    var discount_percentage: String = ""
    var discount_type: String = ""
    var discount_amount: Int = 0
    var sub_total: String = ""
    var miscellaneous_notes: String = ""
    var miscellaneous_price: String = ""
    var tip: Double = 0.0
    var payment_type: String = ""
    var total: String = ""
    var transaction_id: String = ""
    var transaction_status: String = ""
    var created_at: String = ""
    var updated_at: String = ""
    var service_names: String = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        id                      <- map["id"]
        vendor_id               <- map["vendor_id"]
        service_ids             <- map["service_ids"]
        gift_card               <- map["gift_card"]
        booking_number          <- map["booking_number"]
        coupon_code             <- map["coupon_code"]
        discount_percentage     <- map["discount_percentage"]
        discount_type           <- map["discount_type"]
        discount_amount         <- map["discount_amount"]
        sub_total               <- map["sub_total"]
        miscellaneous_notes     <- map["miscellaneous_notes"]
        miscellaneous_price     <- map["miscellaneous_price"]
        tip                     <- map["tip"]
        payment_type            <- map["payment_type"]
        total                   <- map["total"]
        transaction_id          <- map["transaction_id"]
        transaction_status      <- map["transaction_status"]
        created_at              <- map["created_at"]
        updated_at           	<- map["updated_at"]
        service_names           <- map["service_names"]
    }
    
    var giftCardDisplayString: String {
        guard let data = gift_card.data(using: .utf8) else { return "" }
        do {
            let giftCards = try JSONDecoder().decode([GiftCardModel].self, from: data)
//            return giftCards.map { "\($0.qty) × ₹\($0.price)" }.joined(separator: ", ")
            return giftCards.map { "\(SharedPrefs.getSymbol())\($0.price) × \($0.qty)  " }.joined(separator: ", ")
        } catch {
            print("GiftCard parsing error: \(error)")
            return ""
        }
    }
    
}

struct GiftCardModel: Codable {
    let price: Int
    let qty: Int
}

class SalesModel: Mappable {
    var total: Int = 0
    var totalpages: Int = 0
    var totalsales: Int = 0
    var data: [SalesDateModel] = []
    var error: String = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        total       <- map["total"]
        totalpages  <- map["totalpages"]
        totalsales <- map["totalsales"]
        data        <- map["data"]
        error       <- map["error"]
    }
}


class SalesDateModel: Mappable {
    
    var id: Int = 0
    var customer_id: Int = 0
    var customer_name: String = ""
    var booking_number: String = ""
    var staff_id: String = ""
    var staff_name: String = ""
    var service_id: Int = 0
    var service_name: String = ""
    var price: Int = 0
    

    required init?(map: Map) {}

    func mapping(map: Map) {
        id                      <- map["id"]
        customer_id             <- map["customer_id"]
        customer_name           <- map["customer_name"]
        booking_number          <- map["booking_number"]
        staff_id                <- map["staff_id"]
        staff_name              <- map["staff_name"]
        service_id              <- map["service_id"]
        service_name            <- map["service_name"]
        price                   <- map["price"]
    }
}


class ReportDownloadModel: Mappable {
    var filename: String = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        filename <- map["filename"]
    }
}

