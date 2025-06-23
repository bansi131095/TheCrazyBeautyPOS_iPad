//
//  APIService .swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 05/06/25.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper


class APIService {
    
    static let shared = APIService()

    // Computed property for headers:
    var headers: [String: String] {
        var baseHeaders = [
            "Accept": "application/json",
            "apikey": global.apikey,
            "Content-Type": "application/json",
        ]
        
        if !LocalData.loginToken.isEmpty {
            baseHeaders["Authorization"] = "Bearer \(LocalData.loginToken)"
        }
        
        return baseHeaders
    }

    func login(email: String, password: String, completion: @escaping (LoginData?) -> Void) {
        let url = global.shared.URL_LOGIN
        let params: [String: Any] = ["email": email, "password": password]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<LoginResponse, AFError>) in

                // 📦 Print request info
                print("🔵 Request: \(String(describing: response.request))")
                print("🌐 URL: \(url)")
                print("📤 Parameters: \(params)")

                // 📩 Print HTTP response status code
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 🧾 Print raw response body
                if let data = response.data,
                   let rawJSON = String(data: data, encoding: .utf8) {
                    print("📥 Raw Response: \(rawJSON)")
                }

                switch response.result {
                case .success(let result):
                    print("✅ Parsed Response Object: \(result)")
                    completion(result.data)
                case .failure(let error):
                    print("❌ Error: \(error.localizedDescription)")
                    completion(nil)
                }
            }
    }
    
    
    func getServiceDetails(page: String, limit: String, vendorId: String, search: String, booking: String, categoryId: String, isGroup: Bool, completion: @escaping (ServiceDetailsModel?) -> Void) {
        let url = global.shared.URL_SERVICE_DETAILS
        
        var params: [String: Any] = [:]

        if isGroup {
            params = [
                "page": page,
                "limit": limit,
                "vendor_id": vendorId,
                "search": search
            ]
        } else {
            if booking.isEmpty {
                params = [
                    "page": page,
                    "limit": limit,
                    "vendor_id": vendorId,
                    "search": search,
                    "category_name": categoryId
                ]
            } else {
                params = [
                    "booking": booking,
                    "vendor_id": vendorId
                ]
            }
        }

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<ServiceDetailsModel, AFError>) in

            // 📦 Print request info
            print("🌐 URL: \(url)")
            print("📤 Parameters: \(params)")
            print("📤 Headere: \(self.headers)")

            // 📩 Print HTTP response status code
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }
            
            switch response.result {
            case .success(let result):
                if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }
                print("✅ Parsed Response Object: \(result)")
                completion(result)
            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    

    func fetchBusinessServices(completion: @escaping (ServicesModel?) -> Void) {
        let url = global.shared.URL_BUSINESS_SERVICES

        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseObject { (response: DataResponse<ServicesModel, AFError>) in
            switch response.result {
            case .success(let model):
                if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }
                print("✅ Received \(model.data.count) business services")
                completion(model)
            case .failure(let error):
                print("❌ API Call Failed: \(error)")
                if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }
                completion(nil)
            }
        }
    }
    
    
    
    func getteamDetails(page: String, limit: String, vendorId: String, search: String, date: String = "", staffId: String = "", isTeamDetails: Int = 0, completion: @escaping (StaffResponse?) -> Void) {
        let url = global.shared.URL_TEAM_DETAILS
        
        var params: [String: Any] = [
                "page": page,
                "limit": limit,
                "vendor_id": vendorId,
                "search": search,
                "date": date,
                "is_teamdetails": isTeamDetails,
                "staff_id": staffId
            ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<StaffResponse, AFError>) in

            // 📦 Print request info
            print("🌐 URL: \(url)")
            print("📤 Parameters: \(params)")
            print("📤 Headere: \(self.headers)")

            // 📩 Print HTTP response status code
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }
            
            switch response.result {
            case .success(let result):
                if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }
                print("✅ Parsed Response Object: \(result)")
                completion(result)
            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    

}

