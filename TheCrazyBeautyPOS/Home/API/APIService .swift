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
        
        let params: [String: Any] = [
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
    
    
    func getclientDetails(page: String, limit: String, vendorId: String, search: String, completion: @escaping (CustomerListResponse?) -> Void) {
        let url = global.shared.URL_CLIENT_DETAILS
        
        let params: [String: Any] = [
                "page": page,
                "limit": limit,
                "vendor_id": vendorId,
                "search": search,
            ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CustomerListResponse, AFError>) in

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
    
    
    func getInventoryDetails(page: String, limit: String, vendorId: String, search: String, completion: @escaping (InventoryListResponse?) -> Void) {
        let url = global.shared.URL_INVENTORY_DETAILS
        
        let params: [String: Any] = [
                "page": page,
                "limit": limit,
                "vendor_id": vendorId,
                "search": search,
            ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<InventoryListResponse, AFError>) in

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
    
    
    func getGiftCardDetails(page: String, limit: String, vendorId: String, search: String, completion: @escaping (GiftCardListResponse?) -> Void) {
        let url = global.shared.URL_GIFTCARD_DETAILS
        
        let params: [String: Any] = [
                "page": page,
                "limit": limit,
                "vendor_id": vendorId,
                "search": search,
            ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<GiftCardListResponse, AFError>) in

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
    
    
    func getcouponDetails(page: String, limit: String, vendorId: String, search: String, completion: @escaping (CouponListResponse?) -> Void) {
        let url = global.shared.URL_COUPON_DETAILS
        
        let params: [String: Any] = [
                "page": page,
                "limit": limit,
                "vendor_id": vendorId,
                "search": search,
            ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CouponListResponse, AFError>) in

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
    
    
    func getofflineGiftCardDetails(page: String, limit: String, vendorId: String, search: String, completion: @escaping (OfflineGiftCardListResponse?) -> Void) {
        let url = global.shared.URL_GIFT_CARDS
        
        let params: [String: Any] = [
                "page": page,
                "limit": limit,
                "vendor_id": vendorId,
                "search": search,
            ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<OfflineGiftCardListResponse, AFError>) in

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
    
    
    func getbookingHistory(page: String, limit: String, vendorId: String, search: String, days: String, completion: @escaping (BookingResponse?) -> Void) {
        let url = global.shared.URL_BOOKINGS_HISTORY
        
        let params: [String: Any] = [
                "page": page,
                "limit": limit,
                "id": vendorId,
                "search": search,
                "days": days
            ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<BookingResponse, AFError>) in

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
    
    func getCurrency(completion: @escaping (CurrencyResponse?) -> Void) {
        let id = LocalData.userId
        let url = "\(global.shared.URL_GET_CURRENCY)\(id)"
        
        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CurrencyResponse, AFError>) in
                
            // 🌐 Log Request Info
            print("🌐 URL: \(url)")
            print("📤 Headers: \(self.headers)")

            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            switch response.result {
            case .success(let result):
                if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(raw)")
                }
                print("✅ Parsed Response: \(result)")
                completion(result)
            case .failure(let error):
                print("❌ API Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    
    func addClientData(firstName: String, lastName: String, vendorId: String, email: String, clientType: String, gender: String, dob: String, phone: String, completion: @escaping (AddClientModel?) -> Void) {
        let url = global.shared.URL_ADD_CLIENT
        
        let params: [String: Any] = [
                "first_name": firstName,
                "last_name": lastName,
                "vendor_id": vendorId,
                "email": email,
                "client_type": clientType,
                "gender": gender,
                "dob": dob,
                "phone": phone,
            ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<AddClientModel, AFError>) in

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
    
    func updateClientData(firstName: String, lastName: String, vendorId: String, email: String, clientType: String, gender: String, dob: String, phone: String, clientId: Int, completion: @escaping (CommonResponse?) -> Void) {
        let urlString = "\(global.shared.URL_UPDATE_CLIENT)\(clientId)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT" // ✅ OR "PUT" if your backend expects it
        request.headers = HTTPHeaders(headers)
       
        // ✅ JSON Body
        let params: [String: Any] = [
            "first_name": firstName,
            "last_name": lastName,
            "vendor_id": vendorId,
            "email": email,
            "client_type": clientType,
            "gender": gender,
            "dob": dob,
            "phone": phone,
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
            request.httpBody = jsonData
        } catch {
            print("❌ Failed to encode JSON: \(error)")
            completion(nil)
            return
        }
        
        // ✅ Execute Request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Request error: \(error)")
                completion(nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid response")
                completion(nil)
                return
            }
            
            print("📬 Status Code: \(httpResponse.statusCode)")
            
            guard let data = data else {
                print("❌ No data returned")
                completion(nil)
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(CommonResponse.self, from: data)
                print("✅ Decoded Response: \(decoded)")
                completion(decoded)
            } catch {
                print("❌ JSON Decoding failed: \(error)")
                if let rawString = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(rawString)")
                }
                completion(nil)
            }
        }.resume()
    }

    
    func deleteClientData(clientId: Int, completion: @escaping (CommonResponse?) -> Void) {
        let urlString = "\(global.shared.URL_DELETE_CLIENT)\(clientId)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE" // ✅ OR "PUT" if your backend expects it
        request.headers = HTTPHeaders(headers)
       
        // ✅ JSON Body
        let params: [String: Any] = [:]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
            request.httpBody = jsonData
        } catch {
            print("❌ Failed to encode JSON: \(error)")
            completion(nil)
            return
        }
        
        // ✅ Execute Request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Request error: \(error)")
                completion(nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid response")
                completion(nil)
                return
            }
            
            print("📬 Status Code: \(httpResponse.statusCode)")
            
            guard let data = data else {
                print("❌ No data returned")
                completion(nil)
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(CommonResponse.self, from: data)
                print("✅ Decoded Response: \(decoded)")
                completion(decoded)
            } catch {
                print("❌ JSON Decoding failed: \(error)")
                if let rawString = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(rawString)")
                }
                completion(nil)
            }
        }.resume()
    }
    
    
    func getDurationDetails(completion: @escaping (DurationResponse?) -> Void) {
        let url = "\(global.shared.URL_DURATION_DETAILS)"
        
        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<DurationResponse, AFError>) in
                
            // 🌐 Log Request Info
            print("🌐 URL: \(url)")
            print("📤 Headers: \(self.headers)")

            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            switch response.result {
            case .success(let result):
                if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(raw)")
                }
                print("✅ Parsed Response: \(result)")
                completion(result)
            case .failure(let error):
                print("❌ API Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    func getselectMainCategory(completion: @escaping (ServicesModel?) -> Void) {
        let id = LocalData.userId
        let url = "\(global.shared.URL_SELECT_MAINCATEGORY)\(id)"
        
        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<ServicesModel, AFError>) in
                
            // 🌐 Log Request Info
            print("🌐 URL: \(url)")
            print("📤 Headers: \(self.headers)")

            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            switch response.result {
            case .success(let result):
                if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(raw)")
                }
                print("✅ Parsed Response: \(result)")
                completion(result)
            case .failure(let error):
                print("❌ API Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }


}

