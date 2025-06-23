//
//  ServiceDetailsRepo.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 13/06/25.
//

import Foundation
import Alamofire
import ObjectMapper

class ServiceDetailsRepo {

    func getServiceDetailsRepo(
        page: Int,
        limit: Int,
        vendorId: Int,
        search: String,
        booking: String,
        categoryId: String,
        isGroup: Bool,
        completion: @escaping (ServiceDetailsModel?) -> Void
    ) {
        let url = global.shared.URL_SERVICE_DETAILS // Replace with your actual endpoint

        var parameters: [String: Any] = [:]

        if isGroup {
            parameters = [
                "page": page,
                "limit": limit,
                "vendor_id": vendorId,
                "search": search
            ]
        } else {
            if booking.isEmpty {
                parameters = [
                    "page": page,
                    "limit": limit,
                    "vendor_id": vendorId,
                    "search": search,
                    "category_name": categoryId
                ]
            } else {
                parameters = [
                    "booking": booking,
                    "vendor_id": vendorId
                ]
            }
        }

       /* AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any],
                       let model = ServiceDetailsModel(JSON: json) {
                        completion(model)
                    } else {
                        print("Invalid JSON format")
                        completion(nil)
                    }
                case .failure(let error):
                    print("API call failed: \(error)")
                    completion(nil)
                }
            } */
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseString { response in
                print("📨 Raw Response: \(response.value ?? "nil")")

                switch response.result {
                case .success(let raw):
                    // Try converting raw string to JSON if needed
                    if let data = raw.data(using: .utf8),
                       let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let model = ServiceDetailsModel(JSON: json) {
                        completion(model)
                    } else {
                        print("⚠️ Could not parse JSON from response string")
                        completion(nil)
                    }
                case .failure(let error):
                    print("❌ API call failed: \(error)")
                    completion(nil)
                }
            }

    }
    
    
}
