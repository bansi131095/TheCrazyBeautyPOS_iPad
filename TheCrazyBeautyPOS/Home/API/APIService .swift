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

    
    //MARK: Login Api
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
    
    
    //MARK: Service List Api
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
    
    
    func addServiceData(serviceName: String, parentId: Int, vendorId: String, description: String, serviceFor: String, duration: Int, priceType: String, price: Int, salePrice: Int, vendorOnly: String, contactSalon: String, testRequired: String, staffId: String, completion: @escaping (AddServiceModel?) -> Void) {
        let url = global.shared.URL_ADD_SERVICE
        
        let params: [String: Any] = [
            "vendor_id": vendorId,
            "service_name": serviceName,
            "parent_id": parentId,
            "description": description,
            "service_for": serviceFor,
            "duration": duration,
            "price_type": priceType,
            "price": price,
            "sale_price": salePrice,
            "is_vendor_only": vendorOnly,
            "contact_salon": contactSalon,
            "test_required": testRequired,
            "staff_id": staffId
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<AddServiceModel, AFError>) in

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
    
    
    func updateServiceData(serviceName: String, parentId: Int, vendorId: String, description: String, serviceFor: String, duration: Int, priceType: String, price: Int, salePrice: Int, vendorOnly: String, contactSalon: String, testRequired: String, staffId: String, serviceId: String, completion: @escaping (CommonResponse?) -> Void) {
        let urlString = "\(global.shared.URL_UPDATE_SERVICE)\(serviceId)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT" // ✅ OR "PUT" if your backend expects it
        request.headers = HTTPHeaders(headers)
       
        // ✅ JSON Body
        let params: [String: Any] = [
            "vendor_id": vendorId,
            "service_name": serviceName,
            "parent_id": parentId,
            "description": description,
            "service_for": serviceFor,
            "duration": duration,
            "price_type": priceType,
            "price": price,
            "sale_price": salePrice,
            "is_vendor_only": vendorOnly,
            "contact_salon": contactSalon,
            "test_required": testRequired,
            "staff_id": staffId,
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
    
    
    func deleteServiceData(serviceId: Int, completion: @escaping (CommonResponse?) -> Void) {
        let urlString = "\(global.shared.URL_DELETE_SERVICE)\(serviceId)"
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
    

    //MARK: Business Service Api
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
    
    
    //MARK: Team  Api
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
    
    
    func addTeamData(firstName: String, lastName: String, vendorId: String, email: String, jobTitle: String, gender: String, dob: String, phone: String, showCustomer: String, showInCalendar: String, serviceIds: String, workingHours: String, shiftTimings: String, image: UIImage?, imageKey: String = "photo", completion: @escaping (AddMemberModel?) -> Void) {
        let url = global.shared.URL_ADD_TEAM
        
        let params: [String: Any] = [
                "first_name": firstName,
                "last_name": lastName,
                "vendor_id": vendorId,
                "email": email,
                "job_title": jobTitle,
                "gender": gender,
                "dob": dob,
                "phone": phone,
                "show_customer": showCustomer,
                "show_in_calandar": showInCalendar,
                "service_ids": serviceIds,
                "working_hours": workingHours,
                "shift_timings": shiftTimings,
            ]
        
        AF.upload(
            multipartFormData: { multipartFormData in
                // Add image data
                if image != nil {
                    if let imageData = image!.jpegData(compressionQuality: 0.8) {
                        multipartFormData.append(
                            imageData,
                            withName: imageKey,
                            fileName: "profile.jpg",
                            mimeType: "image/jpeg"
                        )
                    }
                }
                // Add other parameters
                for (key, value) in params {
                    if let stringValue = "\(value)".data(using: .utf8) {
                        multipartFormData.append(stringValue, withName: key)
                    }
                }
            },
            to: url,
            method: .post,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseObject { (response: DataResponse<AddMemberModel, AFError>) in
            
            // 🌐 Debug Info
            print("🌐 URL: \(url)")
            print("📤 Parameters: \(params)")
            print("📤 Headers: \(self.headers)")

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
    
    func updateTeamData(firstName: String, lastName: String, vendorId: String, email: String, jobTitle: String, gender: String, dob: String, phone: String, showCustomer: String, showInCalendar: String, serviceIds: String, workingHours: String, shiftTimings: String, image: UIImage?, imageKey: String = "photo", teamId: String, completion: @escaping (CommonResponse?) -> Void) {
        let urlString = "\(global.shared.URL_UPDATE_TEAM)\(teamId)"
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
            "job_title": jobTitle,
            "gender": gender,
            "dob": dob,
            "phone": phone,
            "show_customer": showCustomer,
            "show_in_calandar": showInCalendar,
            "service_ids": serviceIds,
            "working_hours": workingHours,
            "shift_timings": shiftTimings,
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
    
    
    func deleteTeamData(teamId: Int, completion: @escaping (CommonResponse?) -> Void) {
        let urlString = "\(global.shared.URL_DELETE_TEAM)\(teamId)"
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
    
    //MARK: Clients Api
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
    
    
    
    //MARK: Inventory Api
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
    
    
    //MARK: GiftCard Api
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
    
    
    //MARK: Coupon Api
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
    
    
    //MARK: Offline Gift Card Api
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
    
    
    //MARK: Dashboard Booking Api
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
    
    //MARK: Currency get Api
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
    
    //MARK: Duration list get api
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
    
    
    //MARK: MainCategory get api
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
    
    //MARK: get salon time
    func fetchTiming(completion: @escaping (String) -> Void) {
      let url = global.shared.URL_GET_TIMING + "/\(LocalData.userId)"

      AF.request(url, method: .get, headers: HTTPHeaders(headers))
          .validate()
          .responseObject { (response: DataResponse<TimingModel, AFError>) in
              switch response.result {
              case .success(let model):
                  if let rawData = response.data,
                     let rawJSON = String(data: rawData, encoding: .utf8) {
                      print("📦 Raw Response:\n\(rawJSON)")
                  }

                  // Make sure we have at least one vendor
                  guard let firstVendor = model.data.first,
                        let jsonString = firstVendor.working_hours else {
                      completion("")
                      return
                  }

                  completion(jsonString)

              case .failure(let error):
                  print("❌ API Call Failed: \(error)")
                  if let data = response.data,
                     let responseStr = String(data: data, encoding: .utf8) {
                      print("📦 Raw Response: \(responseStr)")
                  }
                  completion("")
              }
          }
      }
    
    //MARK: get Holidays
    func getHolidays(completion: @escaping (String) -> Void) {
      let url = global.shared.URL_GET_HOLIDAYS + "/\(LocalData.userId)"

      AF.request(url, method: .get, headers: HTTPHeaders(headers))
          .validate()
          .responseObject { (response: DataResponse<GetSalonHolidaysModel, AFError>) in
              switch response.result {
              case .success(let model):
                  if let rawData = response.data,
                     let rawJSON = String(data: rawData, encoding: .utf8) {
                      print("📦 Raw Response:\n\(rawJSON)")
                  }

                  // Make sure we have at least one vendor
                  guard let firstVendor = model.data.first else {
                      completion("")
                      return
                  }

                  let jsonString = firstVendor.holidayDates
                  completion(jsonString)

              case .failure(let error):
                  print("❌ API Call Failed: \(error)")
                  if let data = response.data,
                     let responseStr = String(data: data, encoding: .utf8) {
                      print("📦 Raw Response: \(responseStr)")
                  }
                  completion("")
              }
          }
      }
    
    //MARK: get Staff Holidays
    func getStaffHoliday(staffId: String, completion: @escaping (String?) -> Void) {
        let url = global.shared.URL_STAFF_HOLIDAYS
        
        let params: [String: Any] = [
                "staff_id": staffId
            ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<GetSalonHolidaysModel, AFError>) in

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
                guard let firstVendor = result.data.first else {
                    completion("")
                    return
                }

                let jsonString = firstVendor.holidayDates
                completion(jsonString)
            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    
    func updateStaffHoliday(holidayDates: String, staffId: String, completion: @escaping (CommonResponses?) -> Void) {
        let url = global.shared.URL_UPDATE_STAFFHOLIDAYS
        
        let params: [String: Any] = [
            "holiday_dates": holidayDates,
            "staff_id": staffId
        ]


        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CommonResponses, AFError>) in

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
    
    
    //MARK: staff shift
    func getstaffShift(staffId: String = "", completion: @escaping (StaffScheduleResponse?) -> Void) {
        let url = global.shared.URL_STAFF_SHIFTS
        
        let params: [String: Any] = [
            "staff_id": staffId
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<StaffScheduleResponse, AFError>) in

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
    
    
    func updateStaffShift(staffShift: String, deleteShift: String, completion: @escaping (CommonResponses?) -> Void) {
        let url = global.shared.URL_UPDATE_SHIFTS
        
        let params: [String: Any] = [
            "staff_shift": staffShift,
            "delete_shifts": deleteShift
        ]


        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CommonResponses, AFError>) in

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
    
    //MARK: Update
    func updateServiceSequence(serviceSequence: String, completion: @escaping (CommonResponses?) -> Void) {
        let url = global.shared.URL_UPDATE_SERVICE_SEQUENCE
        
        let params: [String: Any] = [
            "service_sequence": serviceSequence
        ]


        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CommonResponses, AFError>) in

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
    
    
    //MARK: Salon Data
    func getAllSalonData(completion: @escaping (GetAllSalonModel?) -> Void) {
        let url = global.shared.URL_GET_ALL_SALONS
        
        let params: [String: Any] = [
            "vendor_id": LocalData.salonId,
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<GetAllSalonModel, AFError>) in

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
    
    
    func updateSalonData(salonId: String, completion: @escaping (SalonDataModel?) -> Void) {
      let url = global.shared.URL_SALON_DATA + "\(salonId)"

      AF.request(url, method: .get, headers: HTTPHeaders(headers))
          .validate()
          .responseObject { (response: DataResponse<SalonDataModel, AFError>) in
              switch response.result {
              case .success(let model):
                  if let rawData = response.data,
                     let rawJSON = String(data: rawData, encoding: .utf8) {
                      print("📦 Raw Response:\n\(rawJSON)")
                  }

                  completion(model)

              case .failure(let error):
                  print("❌ API Call Failed: \(error)")
                  if let data = response.data,
                     let responseStr = String(data: data, encoding: .utf8) {
                      print("📦 Raw Response: \(responseStr)")
                  }
                  completion(nil)
              }
          }
      }
    
    
    //MARK: Notification Data
    func getNotificationList(page: String, limit: String, completion: @escaping (GetActivitiesModel?) -> Void) {
        let url = global.shared.URL_GET_ACTIVITIES
        
        let params: [String: Any] = [
            "vendor_id": LocalData.userId,
            "limit": limit,
            "page": page
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<GetActivitiesModel, AFError>) in

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
    
    
    func updateActivity(completion: @escaping (CommonResponses?) -> Void) {
        let url = global.shared.URL_UPDATE_ACTIVITIES
        
        let params: [String: Any] = [
            "vendor_id": LocalData.userId,
        ]


        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CommonResponses, AFError>) in

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
    
    func parseWorkingHours(_ jsonString: String) -> [WorkingHour] {
        guard let data = jsonString.data(using: .utf8),
              let array = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
            return []
        }
        return Mapper<WorkingHour>().mapArray(JSONArray: array)
    }


    func convertWorkingHoursToJSONString(_ workingHours: [WorkingHour]) -> String? {
        let array = workingHours.compactMap { wh -> [String: String]? in
            guard let day = wh.day, let from = wh.from, let to = wh.to else { return nil }
            return ["day": day, "from": from, "to": to]
        }
          
        if let data = try? JSONSerialization.data(withJSONObject: array, options: []),
            let jsonString = String(data: data, encoding: .utf8) {
            return jsonString
        }
          
        return nil
    }


}

