//
//  BookingResponse.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 02/07/25.
//

import Foundation
import ObjectMapper


// Root Response
class BookingResponse: Mappable {
    var total: Int?
    var totalpages: Int?
    var data: [BookingData]?
    var error: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        total        <- map["total"]
        totalpages   <- map["totalpages"]
        data         <- map["data"]
        error        <- map["error"]
    }
}


// Booking Item
class BookingData: Mappable {
    var id: Int?
    var bookingNumber: String?
    var bookingDate: String?
    var bookingTime: String?
    var description: String?
    var totalPrice: String?
    var bookedBy: String?
    var duration: String?
    var isVisit: String?
    var subTotal: String?
    var paidAmount: String?
    var discountAmount: String?
    var miscellaneousNotes: String?
    var miscellaneousPrice: String?
    var name: String?
    var customerType: String?
    var phone: String?
    var services: String?
    var grandTotal: String?
    var bookingStatus: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        id                   <- map["id"]
        bookingNumber        <- map["booking_number"]
        bookingDate          <- map["booking_date"]
        bookingTime          <- map["booking_time"]
        description          <- map["description"]
        totalPrice           <- map["total_price"]
        bookedBy             <- map["booked_by"]
        duration             <- map["duration"]
        isVisit              <- map["is_visit"]
        subTotal             <- map["sub_total"]
        paidAmount           <- map["paid_amount"]
        discountAmount       <- map["discount_amount"]
        miscellaneousNotes   <- map["miscellaneous_notes"]
        miscellaneousPrice   <- map["miscellaneous_price"]
        name                 <- map["name"]
        customerType         <- map["customer_type"]
        phone                <- map["phone"]
        services             <- map["services"]
        grandTotal           <- map["grand_total"]
        bookingStatus        <- map["booking_status"]
    }
}

