//
//  APIService .swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 05/06/25.
//

/*import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper*/


/*class APIService {
    
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
    
    
    func addServiceData(serviceName: String, parentId: Int, vendorId: String, description: String, serviceFor: String, duration: Int, priceType: String, price: String, salePrice: String, vendorOnly: String, contactSalon: String, testRequired: String, staffId: String,has_sub_service:String,is_sub_service:String,resource_id:String, completion: @escaping (AddServiceModel?) -> Void) {
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
            "staff_id": staffId,
            "has_sub_service":has_sub_service,
            "is_sub_service":is_sub_service,
            "resource_id":resource_id
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
    
    
    func updateServiceData(serviceName: String, parentId: Int, vendorId: String, description: String, serviceFor: String, duration: Int, priceType: String, price: String, salePrice: String, vendorOnly: String, contactSalon: String, testRequired: String, staffId: String, serviceId: String,has_sub_service:String,is_sub_service:String,resource_id:String, completion: @escaping (CommonResponse?) -> Void) {
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
            "has_sub_service":has_sub_service,
            "is_sub_service":is_sub_service,
            "resource_id":resource_id
        ]

        print("Params:- \(params)")
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
    
    func fetchMainServices(completion: @escaping (ServicesModel?) -> Void) {
        let url = "\(global.shared.URL_SELECT_MAINSERVICES)\(LocalData.userId)"

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
    
    
    func addTeamData(firstName: String, lastName: String, vendorId: String, email: String, jobTitle: String, gender: String, dob: String, phone: String, showCustomer: String, showInCalendar: String, serviceIds: String, workingHours: String, shiftTimings: String, image: UIImage?, imageKey: String = "file", completion: @escaping (AddMemberModel?) -> Void) {
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
    
    func updateTeamData(
        firstName: String,
        lastName: String,
        vendorId: String,
        email: String,
        jobTitle: String,
        gender: String,
        dob: String,
        phone: String,
        showCustomer: String,
        showInCalendar: String,
        serviceIds: String,
        workingHours: String,
        shiftTimings: String,
        image: UIImage?,
        imageKey: String = "file",
        teamId: String,
        completion: @escaping (CommonResponse?) -> Void
    ) {
        let urlString = "\(global.shared.URL_UPDATE_TEAM)\(teamId)"
        guard let url = URL(string: urlString) else { return }
        
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
            "shift_timings": shiftTimings
        ]
        
        AF.upload(
            multipartFormData: { multipartFormData in
                // ✅ Attach Image if available
                if let image = image, let imageData = image.jpegData(compressionQuality: 0.8) {
                    multipartFormData.append(
                        imageData,
                        withName: imageKey,
                        fileName: "team.jpg",
                        mimeType: "image/jpeg"
                    )
                }
                
                // ✅ Attach other parameters
                for (key, value) in params {
                    if let stringValue = "\(value)".data(using: .utf8) {
                        multipartFormData.append(stringValue, withName: key)
                    }
                }
            },
            to: url,
            method: .put,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseDecodable(of: CommonResponse.self) { response in
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
    
    /*func getClientDetails(page: String, limit: String,sort: String,vendorId: String,search: String,completion: @escaping (CustomerListResponse?) -> Void) {
        
        let url = global.shared.URL_CLIENT_DETAILS
        
        let params: [String: Any] = [
            "page": page,
            "limit": limit,
            "vendor_id": vendorId,
            "sort": sort,
            "search": search
        ]
        
        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding.default,
                   headers: HTTPHeaders(headers))
        .responseJSON { response in
            
            // ✅ Print status code
            if let httpResponse = response.response {
                print("📬 Status Code: \(httpResponse.statusCode)")
            }
            
            switch response.result {
            case .success(let value):
                print("📦 Raw Response: \(value)")
                
                if let json = value as? [String: Any],
                   let result = CustomerListResponse(JSON: json) {
                    print("✅ Parsed Response Object: \(result)")
                    completion(result)
                } else {
                    print("❌ Failed to map JSON to CustomerListResponse")
                    completion(nil)
                }
                
            case .failure(let error):
                print("❌ Alamofire Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }*/
    
    //MARK: Clients Api
    func getclientDetails(page: String, limit: String,sort:String, vendorId: String, search: String, completion: @escaping (CustomerListResponse?) -> Void) {
        let url = global.shared.URL_CLIENT_DETAILS
        
        let params: [String: Any] = [
                "page": page,
                "limit": limit,
                "vendor_id": vendorId,
                "sort": sort,
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
    func getGiftCardDetails(page: String, limit: String, vendorId: String,filter:String, search: String, completion: @escaping (GiftCardListResponse?) -> Void) {
        let url = global.shared.URL_GIFTCARD_DETAILS
        
        let params: [String: Any] = [
                "page": page,
                "limit": limit,
                "vendor_id": vendorId,
                "filter": filter,
                "search": search,
            ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<GiftCardListResponse, AFError>) in

            // 📦 Print request info
            print("🌐 URL: \(url)")
            print("123:-Parameters:-: \(params)")
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
    func getofflineGiftCardDetails(page: String, limit: String, vendorId: String, search: String,filter:String, completion: @escaping (OfflineGiftCardListResponse?) -> Void) {
        let url = global.shared.URL_GIFT_CARDS
        
        let params: [String: Any] = [
                "page": page,
                "limit": limit,
                "vendor_id": vendorId,
                "search": search,
                "filter": filter,
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
        
        var params: [String: Any] = [:]
        if days != "300" {
            params = [
                "page": page,
                "limit": limit,
                "id": vendorId,
                "search": search,
                "days": days
            ]
        } else {
            params = [
                "id": vendorId,
                "days": days
            ]
        }

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
    func fetchTiming1(completion: @escaping (String) -> Void) {
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
        
        var params: [String: Any] = [
            "vendor_id": LocalData.salonId,
        ]
        
        if LocalData.salonId == "0" {
            params["vendor_id"] = LocalData.userId
        }

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

    //MARK: AJAY
    func fetchSalonCurrency(completion: @escaping (CurrencyModel?) -> Void) {
        
        let url = global.shared.URL_CURRENCY_DETAILS

        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseObject { (response: DataResponse<CurrencyModel, AFError>) in
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
    
    func getCurrencyA(completion: @escaping (CurrencyModel?) -> Void) {
        let url = global.shared.URL_GET_CURRENCY1 + "/\(LocalData.userId)"

        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseObject { (response: DataResponse<CurrencyModel, AFError>) in
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
    
    func UpdateCurrency(currency: String,symbol: String,vendorId: String, completion: @escaping (CurrencyResponseA?) -> Void) {
        let url = global.shared.URL_UPDATE_CURRENCY
        
        let params: [String: Any] = [
                "currency": currency,
                "symbol": symbol,
                "vendor_id": vendorId
            ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CurrencyResponseA, AFError>) in

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
    
    
    func UpdateBookingFlow(booking_flow: Int,vendorId: String, completion: @escaping (CurrencyResponseA?) -> Void) {
        let url = global.shared.URL_UPDATE_BOOKINGFLOW
        
        let params: [String: Any] = [
                "booking_flow": booking_flow,
                "vendor_id": vendorId
            ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CurrencyResponseA, AFError>) in

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
    
    
    func fetchBookingFlow(completion: @escaping (BookingFlow?) -> Void) {
        let url = global.shared.URL_GET_BOOKINGFLOW + "/\(LocalData.userId)"

        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseObject { (response: DataResponse<BookingFlow, AFError>) in
            switch response.result {
            case .success(let model):
                if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }
                print("✅ Received \(String(describing: model.data)) business services")
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
    
    
    func UpdateBankDetails(accountNumber: String,accountHolderName: String,completion: @escaping (CurrencyResponseA?) -> Void
    ) {
        let url = global.shared.URL_UPDATE_BANKDETAILS + "/\(LocalData.userId)"
        
        // Prepare bank details
        let bankDetails: [String: String] = [
            "account number": accountNumber,
            "account holder name": accountHolderName
        ]
        
        var bankDetailsJSONString = ""
        if let data = try? JSONSerialization.data(withJSONObject: bankDetails, options: []),
           let jsonString = String(data: data, encoding: .utf8) {
            bankDetailsJSONString = jsonString
            print("✅ Bank_Parameters: \(jsonString)")
        } else {
            print("❌ Failed to convert bank details to JSON string")
        }

        // Prepare all parameters
        let params: [String: Any] = [
            "bank_details": bankDetailsJSONString
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CurrencyResponseA, AFError>) in

            // 📦 Print request info
            print("🌐 URL: \(url)")
            print("📤 Parameters: \(params)")
            print("📤 Headers: \(self.headers)")

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

    
    func fetchBankDetails(completion: @escaping (BankDetailsResponse?) -> Void) {
        let url = global.shared.URL_GET_BANKDETAILS + "/\(LocalData.userId)"

        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseObject { (response: DataResponse<BankDetailsResponse, AFError>) in
            switch response.result {
            case .success(let model):
                if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }
                print("✅ Received \(String(describing: model.data)) business services")
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
    
    
    func fetchNotes(completion: @escaping (NotesModel?) -> Void) {
        let url = global.shared.URL_GET_NOTES + "/\(LocalData.userId)"

        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseObject { (response: DataResponse<NotesModel, AFError>) in
            switch response.result {
            case .success(let model):
                if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }
                print("✅ Received \(String(describing: model.data)) business services")
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
    
    func UpdateNotes(vendorId: String, notes: String, completion: @escaping (CurrencyResponseA?) -> Void) {
        let url = global.shared.URL_UPDATE_NOTES

        // Prepare parameters
        let params: [String: Any] = [
            "vendor_id": vendorId,
            "notes": notes
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CurrencyResponseA, AFError>) in

            // 🌐 Log request info
            print("🌐 URL: \(url)")
            print("📤 Parameters: \(params)")
            print("📤 Headers: \(self.headers)")

            // 📩 Log response
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

    
 
    func fetchAmount(completion: @escaping (AmountModel?) -> Void) {
        let url = global.shared.URL_GET_Amount + "/\(LocalData.userId)"

        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseObject { (response: DataResponse<AmountModel, AFError>) in
            switch response.result {
            case .success(let model):
                if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }
                print("✅ Received \(String(describing: model.data)) business services")
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
    
    
    
    func UpdateAmount(vendorId: String, amount: String, penaltyFees: String, penaltyDuration: String, cancellationPolicy: String, completion: @escaping (CurrencyResponseA?) -> Void) {
        let url = global.shared.URL_UPDATE_Amount

        let params: [String: Any] = [
            "vendor_id": vendorId,
            "amount": amount,
            "penalty_fees": penaltyFees,
            "penalty_duration": penaltyDuration,
            "cancellation_policy": cancellationPolicy
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CurrencyResponseA, AFError>) in

            // 🌐 Log request info
            print("🌐 URL: \(url)")
            print("📤 Parameters: \(params)")
            print("📤 Headers: \(self.headers)")

            // 📩 Log response
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
    
    
    
    func fetchTeamDetails(vendorId: String, completion: @escaping (TeamModel?) -> Void) {
        let url = global.shared.URL_Team_Details

        let params: [String: Any] = [
            "vendor_id": vendorId,
            "search": "",
            "limit" : "10000"
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<TeamModel, AFError>) in

            // 🌐 Log request info
            print("🌐 URL: \(url)")
            print("📤 Parameters: \(params)")
            print("📤 Headers: \(self.headers)")

            // 📩 Log response
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
    
    func fetchStaffsequence(vendorId: String, completion: @escaping (GetStaffSequenceModel?) -> Void) {
        let url = global.shared.URL_GET_STAFFSEQUENCE

        let params: [String: Any] = [
            "vendor_id": vendorId
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<GetStaffSequenceModel, AFError>) in

            // 🌐 Log request info
            print("🌐 URL: \(url)")
            print("📤 Parameters: \(params)")
            print("📤 Headers: \(self.headers)")

            // 📩 Log response
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
    
    func updateStaffSequence(staffSequenceList: [[String: String]],calendar_sequence: [[String: Any]], vendorid:String, completion: @escaping (CurrencyResponseA?) -> Void) {
        
        let url = global.shared.URL_UPDATE_STAFFSEQUENCE
        
        // Convert to JSON string
        var staffSequenceJSONString = ""
        if let data = try? JSONSerialization.data(withJSONObject: staffSequenceList, options: []),
           let jsonString = String(data: data, encoding: .utf8) {
            staffSequenceJSONString = jsonString
            print("✅ staff_sequence JSON: \(jsonString)")
        } else {
            print("❌ Failed to convert staff sequence to JSON string")
        }
        
        // Convert to JSON string
        var calendarSequenceJSONString = ""
        if let data = try? JSONSerialization.data(withJSONObject: calendar_sequence, options: []),
           let jsonString = String(data: data, encoding: .utf8) {
            calendarSequenceJSONString = jsonString
            print("✅ staff_sequence JSON: \(jsonString)")
        } else {
            print("❌ Failed to convert staff sequence to JSON string")
        }
        
        // Parameters
        let params: [String: Any] = [
            "calendar_sequence":calendarSequenceJSONString,
            "staff_sequence": staffSequenceJSONString,
            "vendor_id" : vendorid
        ]
        
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CurrencyResponseA, AFError>) in
            
            // 📦 Print request info
            print("🌐 URL: \(url)")
            print("📤 Parameters: \(params)")
            print("📤 Headers: \(self.headers)")
            
            // 📩 HTTP status
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

 
    
    func updateTimeGap(vendorId: String,time_gap: String, completion: @escaping (CommonModel?) -> Void) {
        let url = global.shared.URL_UPDATE_TIMEGAP

        let params: [String: Any] = [
            "vendor_id": vendorId,
            "time_gap": time_gap,
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CommonModel, AFError>) in

            // 🌐 Log request info
            print("🌐 URL: \(url)")
            print("📤 Parameters: \(params)")
            print("📤 Headers: \(self.headers)")

            // 📩 Log response
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
 
    func ChangePassword(vendorId: String, new_pass: String,old_pass: String, completion: @escaping (CommonModel?) -> Void) {
        let url = global.shared.URL_CHANGE_PASSWORD

        // Prepare parameters
        let params: [String: Any] = [
            "vendor_id": vendorId,
            "new_pass": new_pass,
            "old_pass": old_pass,
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CommonModel, AFError>) in

            // 🌐 Log request info
            print("🌐 URL: \(url)")
            print("📤 Parameters: \(params)")
            print("📤 Headers: \(self.headers)")

            // 📩 Log response
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
    
    
    func fetchProfileImage(completion: @escaping (ProfileModel?) -> Void) {
        let url = global.shared.URL_GET_IMAGE + "/\(LocalData.userId)"

        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseObject { (response: DataResponse<ProfileModel, AFError>) in
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
    
    func uploadSalonImages(
        photo: UIImage?,              // main profile photo
        otherPhotos: [String],        // filenames of old gallery images to retain
        photos: [UIImage],            // one OR more new gallery images
        completion: @escaping (CurrencyResponse?) -> Void
    ) {
        let url = global.shared.URL_ADD_IMAGE + "/\(LocalData.userId)"
        print("📤 Uploading to: \(url)")

        AF.upload(multipartFormData: { multipartFormData in

            // ✅ 1. Main profile photo
            if let profileImage = photo,
               let imageData = profileImage.jpegData(compressionQuality: 0.7) {
                multipartFormData.append(imageData, withName: "photo", fileName: "main_photo.jpg", mimeType: "image/jpeg")
                print("✅ photo: main_photo.jpg")
            }

            // ✅ 2. One or more photos under same field name "photos"
            if photos.isEmpty {
                print("⚠️ No gallery photos to upload.")
            } else {
                for (index, image) in photos.enumerated() {
                    if let imageData = image.jpegData(compressionQuality: 0.7) {
                        let timestamp = Int(Date().timeIntervalSince1970)
                        let fileName = "gallery_\(index)_\(timestamp).jpg"
                        multipartFormData.append(imageData, withName: "photos", fileName: fileName, mimeType: "image/jpeg")
                        print("✅ photos: \(fileName)")
                    }
                }
            }

            // ✅ 3. other_photos as JSON string (filenames to retain)
            if !otherPhotos.isEmpty,
               let jsonData = try? JSONSerialization.data(withJSONObject: otherPhotos, options: []),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                multipartFormData.append(Data(jsonString.utf8), withName: "other_photos")
                print("✅ other_photos: \(jsonString)")
            }

        }, to: url, method: .post, headers: HTTPHeaders(headers))
        .responseJSON { response in
            if let status = response.response?.statusCode {
                print("📶 Status Code: \(status)")
            }

            switch response.result {
            case .success(let json):
                print("🎉 Upload Success: \(json)")
                let mapped = Mapper<CurrencyResponse>().map(JSONObject: json)
                completion(mapped)
            case .failure(let error):
                print("❌ Upload Failed: \(error.localizedDescription)")
                if let data = response.data, let errorMsg = String(data: data, encoding: .utf8) {
                    print("📦 Server says: \(errorMsg)")
                }
                completion(nil)
            }
        }
    }



    
    
    func OrdersPhotos(apiurl: String, param: inout Parameters, file: [UIImage], method: HTTPMethod, completionHandler : @escaping(Bool,NSDictionary?) -> ()) {
        
        
        
        let parameter = param
        print(param)
        
        if NetworkReachabilityManager()!.isReachable == false{
            completionHandler(false,nil)
        }
        
        AF.upload(multipartFormData: { multipartFormData in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy-HH:MM:ss"
            let convertedDate: String = dateFormatter.string(from: Date())
            for imageData in file {
                let convert = imageData.jpegData(compressionQuality: 1.0)
                multipartFormData.append(convert!, withName: "\("photos")[]", fileName: "\(convertedDate).png", mimeType: "image/jpeg")
            }
            
            for (key, value) in parameter {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, to: apiurl).responseData { res in
            switch res.result {
            case .success(let data) :
                if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]{
                    print(jsonObj)
                    completionHandler(true, jsonObj as NSDictionary)
                }else{
                    completionHandler(false, nil)
                    print("Not UpdateProfile")
                }
            default:
                print("error")
                break
            }
        }
    }
    

    func UpdateReminderMail(reminder_mail: String,vendorId: String, completion: @escaping (CurrencyResponseA?) -> Void) {
        let url = global.shared.URL_UPDATE_REMINDERMAIL
        
        let params: [String: Any] = [
                "reminder_mail": reminder_mail,
                "vendor_id": vendorId
            ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CurrencyResponseA, AFError>) in

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
    
    func UpdateSelectServices(service_id: String,vendorId: String, completion: @escaping (SelectedService?) -> Void) {
        let url = global.shared.URL_SELECT_SERVICES
        
        let params: [String: Any] = [
                "service_id": service_id,
                "vendor_id": vendorId
            ]

        AF.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<SelectedService, AFError>) in

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
    
    func fetchCategory(completion: @escaping (CategoryModel?) -> Void) {
        let url = global.shared.URL_SELECT_MAINCATEGORY1 + "/\(LocalData.userId)"

        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseObject { (response: DataResponse<CategoryModel, AFError>) in
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
    
    func fetchcategory_description(completion: @escaping (CategoryStaffSequenceModel?) -> Void) {
        let url = global.shared.URL_CATEGORY_DESCRIPTION + "/\(LocalData.userId)"

        let params: [String: Any] = [:]
        

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CategoryStaffSequenceModel, AFError>) in

            // 🌐 Log request info
            print("🌐 URL: \(url)")
            print("📤 Parameters: \(params)")
            print("📤 Headers: \(self.headers)")

            // 📩 Log response
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
    
    func updateCategoryDescription(category_description: [[String: String]], vendorid:String, completion: @escaping (CommonModel?) -> Void) {
        
        let url = global.shared.URL_UPDATE_CATEGORY_DESCRIPTION
        
        // Convert to JSON string
        var staffSequenceJSONString = ""
        if let data = try? JSONSerialization.data(withJSONObject: category_description, options: []),
           let jsonString = String(data: data, encoding: .utf8) {
            staffSequenceJSONString = jsonString
            print("✅ staff_sequence JSON: \(jsonString)")
        } else {
            print("❌ Failed to convert staff sequence to JSON string")
        }
        
        // Parameters
        let params: [String: Any] = [
            "category_description": staffSequenceJSONString,
            "vendor_id" : vendorid
        ]
        
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CommonModel, AFError>) in
            
            // 📦 Print request info
            print("🌐 URL: \(url)")
            print("📤 Parameters: \(params)")
            print("📤 Headers: \(self.headers)")
            
            // 📩 HTTP status
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
    
    func fetchKioskUser(completion: @escaping (GetKioskModel?) -> Void) {
        let url = global.shared.URL_GET_KIOSK + "/\(LocalData.userId)"

        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseObject { (response: DataResponse<GetKioskModel, AFError>) in
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
    
    func fetchSubvendor(completion: @escaping (GetKioskModel?) -> Void) {
        let url = global.shared.URL_GET_SUBVENDOR + "/\(LocalData.userId)"

        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseObject { (response: DataResponse<GetKioskModel, AFError>) in
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
    
    func UpdateCreateSubvendor(email: String,name: String,password: String,vendorId: String, completion: @escaping (CurrencyResponseA?) -> Void) {
        let url = global.shared.URL_UPDATE_SUBVENDOR
        
        let params: [String: Any] = [
                "email": email,
                "name": name,
                "password": password,
                "vendor_id": vendorId
            ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CurrencyResponseA, AFError>) in

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
    
    
    func UpdateAddKiosk(email: String,password: String,vendorId: String, completion: @escaping (CurrencyResponseA?) -> Void) {
        let url = global.shared.URL_UPDATE_ADD_KIOSK
        
        let params: [String: Any] = [
                "email": email,
                "password": password,
                "vendor_id": vendorId
            ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CurrencyResponseA, AFError>) in

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
    
    func parseWorkingHours1(_ jsonString: String) -> [WorkingHour1] {
        guard let data = jsonString.data(using: .utf8),
              let array = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
            return []
        }
        return Mapper<WorkingHour1>().mapArray(JSONArray: array)
    }
    
    func fetchTiming(completion: @escaping ([WorkingHour1]) -> Void) {
    let url = global.shared.URL_GET_TIMING + "/\(LocalData.userId)"

    AF.request(url, method: .get, headers: HTTPHeaders(headers))
        .validate()
        .responseObject { (response: DataResponse<GetKioskModel1, AFError>) in
            switch response.result {
            case .success(let model):
                if let rawData = response.data,
                   let rawJSON = String(data: rawData, encoding: .utf8) {
                    print("📦 Raw Response:\n\(rawJSON)")
                }

                // Make sure we have at least one vendor
                guard let firstVendor = model.data.first,
                      let jsonString = firstVendor.working_hours else {
                    completion([])
                    return
                }

                // Parse working_hours string
                let workingHours = self.parseWorkingHours1(jsonString)
                completion(workingHours)

            case .failure(let error):
                print("❌ API Call Failed: \(error)")
                if let data = response.data,
                   let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }
                completion([])
            }
        }
    }
    
    func convertWorkingHoursToJSONString(_ workingHours: [WorkingHour1]) -> String? {
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
    
    func UpdateBusinessHours(workingHours: [WorkingHour1], completion: @escaping (Bool) -> Void) {
        let url = global.shared.URL_UPDATE_BUSINESS_TIMING + "/\(LocalData.userId)"

        // 1. Build JSON manually to ensure correct formatting
        var workingHoursArray: [[String: String]] = []

        for wh in workingHours {
            if let day = wh.day, let from = wh.from, let to = wh.to {
                workingHoursArray.append([
                    "day": day,
                    "from": from,
                    "to": to
                ])
            }
        }

        // 2. Convert to JSON data
        guard let data = try? JSONSerialization.data(withJSONObject: workingHoursArray, options: []),
              let jsonArrayString = String(data: data, encoding: .utf8) else {
            print("❌ Failed to encode working_hours array")
            completion(false)
            return
        }

        // 3. Build final parameters
        let params: [String: Any] = [
            "working_hours": jsonArrayString
        ]

        // Debug print
        print("📤 Payload to Send: \(params)")

        // 5. API Call
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding.default, // Use JSONEncoding for JSON payload
                   headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("✅ API Success: \(value)")
                    completion(true)
                case .failure(let error):
                    print("❌ API Error: \(error)")
                    if let data = response.data {
                        print("📦 Error Body:\n\(String(data: data, encoding: .utf8) ?? "")")
                    }
                    completion(false)
                }
            }
    }


    func fetchBreakTime(completion: @escaping ([BreakTime1]) -> Void) {
        let url = global.shared.URL_GET_BREAK_TIME + "/\(LocalData.userId)"

        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseObject { (response: DataResponse<GetBreakTimeModel, AFError>) in
                switch response.result {
                case .success(let model):
                    if let first = model.data.first, let breakString = first.break_time {
                        let parsedBreakTimes = self.parseBreakTime(from: breakString)
                        completion(parsedBreakTimes)
                    } else {
                        completion([])
                    }

                case .failure(let error):
                    print("❌ API Call Failed: \(error)")
                    completion([])
                }
            }
    }

    func parseBreakTime(from jsonString: String) -> [BreakTime1] {
        if let data = jsonString.data(using: .utf8) {
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    return Mapper<BreakTime1>().mapArray(JSONArray: jsonArray)
                }
            } catch {
                print("❌ BreakTime parsing failed: \(error.localizedDescription)")
            }
        }
        return []
    }

    
    func UpdateBreakTime(breakTimes: [[String: String]], vendorID: String, completion: @escaping (Bool) -> Void) {
        let url = global.shared.URL_UPDATE_BREAK_TIME

        // 1. Convert array to JSON string
        guard let data = try? JSONSerialization.data(withJSONObject: breakTimes, options: []),
              let jsonString = String(data: data, encoding: .utf8) else {
            print("❌ Failed to encode breakTimes array")
            completion(false)
            return
        }

        // 2. Final parameters
        let params: [String: Any] = [
            "vendor_id": vendorID,
            "break_time": jsonString
        ]

        print("📤 Payload to Send: \(params)")

        // 3. Alamofire request
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding.default,
                   headers: HTTPHeaders(headers)) // <-- Add your headers dictionary here
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("✅ BreakTime Update Success: \(value)")
                    completion(true)
                case .failure(let error):
                    print("❌ API Error: \(error)")
                    if let data = response.data {
                        print("📦 Error Body:\n\(String(data: data, encoding: .utf8) ?? "")")
                    }
                    completion(false)
                }
            }
    }

    func fetchSMSDetails(completion: @escaping (SMSDetailsData?) -> Void) {
    let url = global.shared.URL_GET_SMS_DETAILS + "/\(LocalData.userId)"

    AF.request(url, method: .get, headers: HTTPHeaders(headers))
        .validate()
        .responseObject { (response: DataResponse<SMSDetailsModel, AFError>) in
            switch response.result {
            case .success(let model):
                if let first = model.data.first {
                    completion(first)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                print("❌ Failed to fetch SMS Details: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

    func updateNotificationSettings(vendorId: String,reminderTime: String,smsSettings: [[String: Int]],emailSettings: [[String: Int]],emailNotifications: String,completion: @escaping (Bool) -> Void
    ) {
        let url = global.shared.URL_UPDATE_SMS_DETAILS

        // Convert complex arrays to JSON strings
        guard let smsData = try? JSONSerialization.data(withJSONObject: smsSettings, options: []),
              let smsJSONString = String(data: smsData, encoding: .utf8),
              let emailData = try? JSONSerialization.data(withJSONObject: emailSettings, options: []),
              let emailJSONString = String(data: emailData, encoding: .utf8) else {
            print("❌ Failed to encode JSON")
            completion(false)
            return
        }

        // Actual JSON object (not URL-encoded!)
        let parameters: [String: Any] = [
            "vendor_id": vendorId,
            "reminder_time": reminderTime,
            "sms_settings": smsJSONString,
            "email_settings": emailJSONString,
            "email_notifications": emailNotifications
        ]

        // Must send as JSON
       
        print("📤 Final JSON Parameters:\n\(parameters)")

    AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
        .validate()
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                print("✅ Success: \(value)")
                completion(true)
            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                if let data = response.data,
                   let errorMsg = String(data: data, encoding: .utf8) {
                    print("❌ Server Message: \(errorMsg)")
                }
                completion(false)
            }
        }
    }


    func fetchSalonDetails(completion: @escaping (SalonModel?) -> Void) {
        let url = global.shared.URL_GET_SALON_INFORMATION + "/\(LocalData.userId)"

        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseObject { (response: DataResponse<SalonModel, AFError>) in
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
    
    func fetchSalonHolidays(completion: @escaping (HolidayModel?) -> Void) {
        let url = global.shared.URL_GET_HOLIDAYS + "/\(LocalData.userId)"

        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseObject { (response: DataResponse<HolidayModel, AFError>) in
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
    
    func convertHolidayDatesToJSONString(_ holidays: [HolidayDate1]) -> String? {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(holidays) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }


    func updateSalonHolidays(vendorID: String, holidays: [HolidayDate1], completion: @escaping (Bool) -> Void) {
        let url = global.shared.URL_UPDATE_HOLIDAYS

        // Step 1: Convert [HolidayDate1] to JSON string
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(holidays),
           let jsonString = String(data: jsonData, encoding: .utf8) {

            let params: [String: Any] = [
                "vendor_id": vendorID,
                "holiday_dates": jsonString // 👈 string version of array
            ]

            print("📤 Final Parameters:", params)

            AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        print("✅ Success:", value)
                        completion(true)
                    case .failure(let error):
                        print("❌ Error:", error)
                        if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                            print("📦 Raw Response:", raw)
                        }
                        completion(false)
                    }
                }
        } else {
            print("❌ Failed to encode holiday array to JSON string")
            completion(false)
        }
    }


    func fetchGetOpenDate(completion: @escaping (OpeningDateResponse?) -> Void) {
        let url = global.shared.URL_GET_OPENDATE + "/\(LocalData.userId)"

        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseObject { (response: DataResponse<OpeningDateResponse, AFError>) in
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
    
    func UpdateOpenDate(vendor_id: String,opening_date: String,completion: @escaping (CommonModel?) -> Void) {
        let url = global.shared.URL_UPDATE_OPENDATE
        
        let params: [String: Any] = [
                "vendor_id": vendor_id,
                "opening_date": opening_date
            ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CommonModel, AFError>) in

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
 
    func UpdateBusinessInformation(id: String,salon_name: String,salon_type:String,phone:String,salon_phone:String,postcode:String,address:String,city:String,country:String,latitude:String,longitude:String,web_status:String,allow_search:String,time_gap:String,reminder_mail:String,about_us:String,booking_guest:String, completion: @escaping (CommonModel?) -> Void) {
        let url = global.shared.URL_UPDATE_BUSINESS_INFORMATION + "/\(LocalData.userId)"
        
        let params: [String: Any] = [
                "id": id,
                "salon_name": salon_name,
                "salon_type": salon_type,
                "phone": phone,
                "salon_phone": salon_phone,
                "postcode": postcode,
                "address": address,
                "city": city,
                "country": country,
                "latitude": latitude,
                "longitude": longitude,
                "web_status": web_status,
                "allow_search": allow_search,
                "time_gap": time_gap,
                "reminder_mail": reminder_mail,
                "about_us": about_us,
                "booking_guest" : booking_guest
            ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CommonModel, AFError>) in

            // 📦 Print request info
            

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
    
    
    //<<<<<<< Updated upstream:TheCrazyBeautyPOS/Helper/APIService .swift
    //=======
        func uploadBlockCustomers(vendorId: String, blockCustomers: String, completion: @escaping (Bool, String?) -> Void) {
            let url = global.shared.URL_UPDATE_BLOCK_CUSTOMERS  // replace with your actual URL
            
            let params: [String: Any] = [
                "vendor_id": vendorId,
                "block_customers": blockCustomers
            ]

            AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        print("✅ Upload successful")
                        completion(true, nil)
                    case .failure(let error):
                        print("❌ Upload failed: \(error)")
                        if let data = response.data,
                           let responseStr = String(data: data, encoding: .utf8) {
                            print("📦 Raw response:", responseStr)
                            completion(false, responseStr)
                        } else {
                            completion(false, error.localizedDescription)
                        }
                    }
                }
        }
        
        
        func AddVendorData(salon_id: String, completion: @escaping (VendorData?) -> Void) {
            let url = global.shared.URL_ADD_VENDOR_DATA

            let params: [String: Any] = [
                "salon_id": salon_id
            ]

            AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
                .responseObject { (response: DataResponse<VendorData, AFError>) in

                // 📦 Debug Logs
                print("🌐 URL: \(url)")
                print("📤 Parameters: \(params)")
                

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
        
        func BusinessInformation(url:String,address:String,latitude:String,longitude:String,postcode:String,salon_name: String,salon_type:String,web_status:String, completion: @escaping (CommonModel?) -> Void) {
            let url = url
            
            let params: [String: Any] = [
                    "address": address,
                    "latitude": latitude,
                    "longitude": longitude,
                    "postcode": postcode,
                    "salon_name": salon_name,
                    "salon_type": salon_type,
                    "web_status": web_status
                ]

            AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
                .responseObject { (response: DataResponse<CommonModel, AFError>) in

                // 📦 Print request info
                

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
        
        func Add_BusinessHours(url: String, workingHours: [WorkingHour1], completion: @escaping (Bool) -> Void) {
            let url = url

            // 1. Build JSON manually to ensure correct formatting
            var workingHoursArray: [[String: String]] = []

            for wh in workingHours {
                if let day = wh.day, let from = wh.from, let to = wh.to {
                    workingHoursArray.append([
                        "day": day,
                        "from": from,
                        "to": to
                    ])
                }
            }

            // 2. Convert to JSON data
            guard let data = try? JSONSerialization.data(withJSONObject: workingHoursArray, options: []),
                  let jsonArrayString = String(data: data, encoding: .utf8) else {
                print("❌ Failed to encode working_hours array")
                completion(false)
                return
            }

            // 3. Build final parameters
            let params: [String: Any] = [
                "working_hours": jsonArrayString
            ]

            // Debug print
            print("📤 Payload to Send: \(params)")

            // 5. API Call
            AF.request(url,method: .post,parameters: params,encoding: JSONEncoding.default,headers: HTTPHeaders(headers))
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        print("✅ API Success: \(value)")
                        completion(true)
                    case .failure(let error):
                        print("❌ API Error: \(error)")
                        if let data = response.data {
                            print("📦 Error Body:\n\(String(data: data, encoding: .utf8) ?? "")")
                        }
                        completion(false)
                    }
                }
        }
        
        func fetch_MainCategory(completion: @escaping (CategoryModel?) -> Void) {
            let url = global.shared.URL_MAIN_CATAGORIES + "/\(LocalData.userId)"

            AF.request(url, method: .get, headers: HTTPHeaders(headers))
                .validate()
                .responseObject { (response: DataResponse<CategoryModel, AFError>) in
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
        
        func AddTeamData(salon_id: String, completion: @escaping (CurrencyResponseA?) -> Void) {
            let url = global.shared.URL_ADD_TEAM_DATA
            
            let params: [String: Any] = ["salon_id": salon_id]

            AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
                .responseObject { (response: DataResponse<CurrencyResponseA, AFError>) in

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
        
        func ServiceGet(vendor_id: String,start_date: String,end_date: String, completion: @escaping (ServiceDetailsModel?) -> Void) {
            let url = global.shared.URL_SERIVICES_SALES_DATA
            
            let params: [String: Any] = [
                "vendor_id": vendor_id,
                "start_date": start_date,
                "end_date": end_date
            ]

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
        
        func GiftCardGet(vendor_id: String,limt: String, page:String, start_date: String,end_date: String, completion: @escaping (GiftModel?) -> Void) {
            let url = global.shared.URL_GIFT_DETAILS
            
            let params: [String: Any] = [
                "vendor_id": vendor_id,
                "start_date": start_date,
                "end_date": end_date,
                "limit": limt,
                "page": page
            ]

            AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
                .responseObject { (response: DataResponse<GiftModel, AFError>) in

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
     
        
        func SalesPaymentHistory(vendor_id: String,start_date: String,end_date: String,limit: String, page:String,customer_type:String,search:String,staff_id:String, completion: @escaping (SalesHistoryModel?) -> Void) {
            let url = global.shared.URL_PAYMENT_HISTORY
            
            let params: [String: Any] = [
                "vendor_id": vendor_id,
                "start_date": start_date,
                "end_date": end_date,
                "limit": limit,
                "page": page,
                "customer_type" : customer_type,
                "search" : search,
                "staff_id" : staff_id,
            ]

            AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
                .responseObject { (response: DataResponse<SalesHistoryModel, AFError>) in

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
        
        func WalkinHistoryGet(vendor_id: String,limt: String, page:String, start_date: String,end_date: String, completion: @escaping (WalkinModel?) -> Void) {
            let url = global.shared.URL_WALKIN_DETAILS
            
            let params: [String: Any] = [
                "vendor_id": vendor_id,
                "start_date": start_date,
                "end_date": end_date,
                "limit": limt,
                "page": page
            ]

            AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
                .responseObject { (response: DataResponse<WalkinModel, AFError>) in

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
        
        func SalesDataGet(vendor_id: String,staff_id: String,limt: String, page:String, start_date: String,end_date: String, completion: @escaping (SalesModel?) -> Void) {
            let url = global.shared.URL_SALES_DATA
            
            let params: [String: Any] = [
                "vendor_id": vendor_id,
                "start_date": start_date,
                "end_date": end_date,
                "staff_id" : staff_id,
                "limit": limt,
                "page": page
            ]

            AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
                .responseObject { (response: DataResponse<SalesModel, AFError>) in

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
        
    func downloadSalesReport(vendor_id: String, start_date: String, end_date: String, staff_id: String, completion: @escaping (ReportDownloadModel?) -> Void) {

    let url = global.shared.URL_SALES_REPORT

    let params: [String: Any] = [
        "vendor_id": vendor_id,
        "start_date": start_date,
        "end_date": end_date,
        "staff_id": staff_id
    ]

    AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
        .responseObject { (response: DataResponse<ReportDownloadModel, AFError>) in
            
            // Debug Info
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
                print("✅ Download File: \(result.filename)")
                completion(result)
            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    

    func downloadServiceReport(vendor_id: String, start_date: String, end_date: String, completion: @escaping (ReportDownloadModel?) -> Void) {

    let url = global.shared.URL_SARVICE_REPORT

    let params: [String: Any] = [
        "vendor_id": vendor_id,
        "start_date": start_date,
        "end_date": end_date
    ]

    AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
        .responseObject { (response: DataResponse<ReportDownloadModel, AFError>) in
            
            // Debug Info
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
                print("✅ Download File: \(result.filename)")
                completion(result)
            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    func downloadBookingHistoryReport(vendor_id: String, start_date: String, end_date: String,customer_type:String, completion: @escaping (ReportDownloadModel?) -> Void) {

    let url = global.shared.URL_BOOKING_HISTORY_REPORT

    let params: [String: Any] = [
        "vendor_id": vendor_id,
        "start_date": start_date,
        "end_date": end_date,
        "customer_type": customer_type
    ]

    AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
        .responseObject { (response: DataResponse<ReportDownloadModel, AFError>) in
            
            // Debug Info
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
                print("✅ Download File: \(result.filename)")
                completion(result)
            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    func downloadWalkinHistoryReport(vendor_id: String, start_date: String, end_date: String, completion: @escaping (ReportDownloadModel?) -> Void) {

    let url = global.shared.URL_WALKIN_REPORT

    let params: [String: Any] = [
        "vendor_id": vendor_id,
        "start_date": start_date,
        "end_date": end_date
    ]

    AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
        .responseObject { (response: DataResponse<ReportDownloadModel, AFError>) in
            
            // Debug Info
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
                print("✅ Download File: \(result.filename)")
                completion(result)
            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    func downloadGiftReport(vendor_id: String, start_date: String, end_date: String, completion: @escaping (ReportDownloadModel?) -> Void) {

    let url = global.shared.URL_GIFT_REPORT

    let params: [String: Any] = [
        "vendor_id": vendor_id,
        "start_date": start_date,
        "end_date": end_date
    ]

    AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
        .responseObject { (response: DataResponse<ReportDownloadModel, AFError>) in
            
            // Debug Info
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
                print("✅ Download File: \(result.filename)")
                completion(result)
            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    
    func CheckCouponCode(vendor_id: String,code: String,bookingDate: String, completion: @escaping (CheckCouponModel?) -> Void) {
        let url = global.shared.URL_CHECK_COUPON
        
        let params: [String: Any] = [
            "vendor_id": vendor_id,
            "booking_date" : bookingDate,
            "code": code
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CheckCouponModel, AFError>) in

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
    
    
    
    func ApplyCouponCode(vendor_id: String, code: String, completion: @escaping (CouponResponse?) -> Void) {
        let url = global.shared.URL_APPLY_COUPON
        
        let params: [String: Any] = [
            "vendor_id": vendor_id,
            "coupon_code": code
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CouponResponse, AFError>) in

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
    
    
    
    func ApplyGiftCard(vendor_id: String, code: String, total: String, completion: @escaping (GiftCardResponse?) -> Void) {
        let url = global.shared.URL_APPLY_GIFTCARD
        
        let params: [String: Any] = [
            "vendor_id": vendor_id,
            "gift_code": code,
            "sub_total": total,
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<GiftCardResponse, AFError>) in

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
    
    
    
    func addCartDetails(vendorId: String, subTotal: Double, grandTotal: Double, discountAmount: String, serviceIds: String, couponCode: String, discountPercentage: String, transactionId: String, paymentType: String, discountType: String, giftCard: String, miscellaneousNote: String, miscellaneousPrice: Double, tips: Double, completion: @escaping (VendorData?) -> Void) {
        let url = global.shared.URL_ADD_CART_DETAILS
        
        let params: [String: Any] = [
            "vendor_id": vendorId,
            "coupon_code": couponCode,
            "discount_amount": discountAmount,
            "discount_percentage": discountPercentage,
            "discount_type": discountType,
            "gift_card": giftCard,
            "miscellaneous_notes": miscellaneousNote,
            "miscellaneous_price": miscellaneousPrice,
            "payment_type": paymentType,
            "service_ids": serviceIds,
            "sub_total": subTotal,
            "tip": tips,
            "total": grandTotal,
            "transaction_id": transactionId
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<VendorData, AFError>) in

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
    
    
    func WalkinTransaction(vendorId: String, amount: String, miscPrice: String, miscNotes: String, completion: @escaping (CommonModel?) -> Void) {
        let url = global.shared.URL_WALKIN_TRANSACTION
        
        let params: [String: Any] = [
            "vendor_id": vendorId,
            "amount": amount,
            "price": miscPrice,
            "notes": miscNotes
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CommonModel, AFError>) in

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
    
    
    func WalkinPayment(vendorId: String, transactionId: String, completion: @escaping (PosPaymentModel?) -> Void) {
        let url = global.shared.URL_WALKIN_PAYMENT
        
        let params: [String: Any] = [
            "vendor_id": vendorId,
            "transaction_id": transactionId
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<PosPaymentModel, AFError>) in

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
    
    
    
    func getShiftTeam(vendorId: String, endDate: String, isTeamDetails: String, limit: String, page: String, search: String, startDate: String, completion: @escaping (StaffListResponse?) -> Void) {
        let url = global.shared.URL_GET_SHIFTS
        
        let params: [String: Any] = [
            "vendor_id": vendorId,
            "start_date": startDate,
            "end_date": endDate,
            "is_teamdetails": isTeamDetails,
            "limit": limit,
            "page": page,
            "search": search
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<StaffListResponse, AFError>) in

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
    
    
    
    func staffReport(vendorId: String, endDate: String, send_email: String, search: String, startDate: String, completion: @escaping (CommonResponses?) -> Void) {
        let url = global.shared.URL_STAFF_REPORT
        
        let params: [String: Any] = [
            "vendor_id": vendorId,
            "end_date": endDate,
            "send_email": send_email,
            "search": search,
            "start_date": startDate,
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
    
    
    func add_offgift(vendorId: String, gift_name: String, price: String, expiry_date: String, description: String, completion: @escaping (OfflineGift?) -> Void) {
        let url = global.shared.URL_Add_OFFGIFT
        
        let params: [String: Any] = [
            "vendor_id": vendorId,
            "gift_name": gift_name,
            "price": price,
            "expiry_date": expiry_date,
            "description": description
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<OfflineGift, AFError>) in

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
    
    func add_AddCoupon(vendorId: String, status: String, start_date: String, highest_amount: String, end_date: String,discount_type: String,coupon_name:String,coupon_code:String,amount:String, completion: @escaping (OfflineGift?) -> Void) {
        let url = global.shared.URL_Add_Coupon
        
        let params: [String: Any] = [
            "vendor_id": vendorId,
            "status": status,
            "start_date": start_date,
            "highest_amount": highest_amount,
            "end_date": end_date,
            "discount_type": discount_type,
            "coupon_name": coupon_name,
            "coupon_code": coupon_code,
            "amount": amount
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<OfflineGift, AFError>) in

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
    
    func TodayBookings(vendorId: String, date: String, completion: @escaping (TodayBookingModel?) -> Void) {
        let url = global.shared.URL_TODAY_BOOKINGS
        
        let params: [String: Any] = [
            "vendor_id": vendorId,
            "date": date
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<TodayBookingModel, AFError>) in

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
    
    /*func addGiftCard(card_name: String, price: String, expired_in: String, vendor_id: String, status: String, image: UIImage?, imageKey: String = "file", completion: @escaping (AddMemberModel?) -> Void) {
        let url = global.shared.URL_Add_GIFTCARD
        
        let params: [String: Any] = [
                "card_name": card_name,
                "price": price,
                "expired_in": expired_in,
                "vendor_id": vendor_id,
                "status": status
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
    }*/
    func addGiftCard(
        card_name: String,
        price: String,
        expired_in: String,
        vendor_id: String,
        status: String,
        image: UIImage?,
        imageKey: String = "file",
        completion: @escaping (AddMemberModel?) -> Void
    ) {
        let url = global.shared.URL_Add_GIFTCARD
        
        // ✅ Use [String: Any] but only send String values
        let params: [String: Any] = [
            "card_name": card_name,
            "price": price,
            "expired_in": expired_in,
            "vendor_id": vendor_id,
            "status": status
        ]
        
        AF.upload(
            multipartFormData: { multipartFormData in
                // ✅ Add Image Data (if available)
                if let image = image, let imageData = image.jpegData(compressionQuality: 0.8) {
                    multipartFormData.append(
                        imageData,
                        withName: imageKey,
                        fileName: "profile.jpg",
                        mimeType: "image/jpeg"
                    )
                }
                // ✅ Add Other Parameters
                for (key, value) in params {
                    if let stringValue = "\(value)".data(using: .utf8) {
                        multipartFormData.append(stringValue, withName: key)
                    }
                }
            },
            to: url,
            method: .post,
            headers: HTTPHeaders(headers)   // 🔑 Use your existing headers
        )
        .validate() // Accept 200..<300 by default
        .responseObject { (response: DataResponse<AddMemberModel, AFError>) in
            
            // 🌐 Debug Info
            print("🌐 URL: \(url)")
            print("📤 Parameters: \(params)")
            print("📤 Headers: \(self.headers)")
            
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            } else {
                print("⚠️ No HTTP Response (check network)")
            }
            
            switch response.result {
            case .success(let result):
                if let data = response.data,
                   let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }
                print("✅ Parsed Response Object: \(result)")
                completion(result)
                
            case .failure(let error):
                print("❌ Upload Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }


    
    func add_AddInventory(vendorId: String, price: String, product_name: String, qty: String,completion: @escaping (OfflineGift?) -> Void) {
        let url = global.shared.URL_Add_INVENTORY
        
        let params: [String: Any] = [
            "vendor_id": vendorId,
            "price": price,
            "product_name": product_name,
            "qty": qty,
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<OfflineGift, AFError>) in

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
    
    func updateInventory(clientId:Int,price: String, product_name: String, qty: String, vendor_id: String, completion: @escaping (CommonResponse?) -> Void) {
        let urlString = "\(global.shared.URL_UPDATE_INVENTORY)\(clientId)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT" // ✅ OR "PUT" if your backend expects it
        request.headers = HTTPHeaders(headers)
       
        // ✅ JSON Body
        let params: [String: Any] = [
            "price": price,
            "product_name": product_name,
            "qty": qty,
            "vendor_id": vendor_id
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
 
    func deleteInventory(Id: Int, completion: @escaping (CommonResponse?) -> Void) {
        let urlString = "\(global.shared.URL_DELETE_INVENTORY)\(Id)"
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
    
    func updateGiftCoupon(Id:Int,amount: String, coupon_code: String, discount_type: String, vendor_id: String,coupon_name:String,end_date:String,highest_amount:String,start_date:String,status:String, completion: @escaping (CommonResponse?) -> Void) {
        let urlString = "\(global.shared.URL_UPDATE_Coupon)\(Id)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT" // ✅ OR "PUT" if your backend expects it
        request.headers = HTTPHeaders(headers)
       
        // ✅ JSON Body
        let params: [String: Any] = [
            "amount": amount,
            "coupon_code": coupon_code,
            "discount_type": discount_type,
            "coupon_name": coupon_name,
            "end_date": end_date,
            "highest_amount": highest_amount,
            "start_date": start_date,
            "status": status,
            "vendor_id": vendor_id,
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
 
    func deleteCoupon(Id: Int, completion: @escaping (CommonResponse?) -> Void) {
        let urlString = "\(global.shared.URL_DELETE_COUPON)\(Id)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT" // ✅ OR "PUT" if your backend expects it
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
    
    func UpdateGiftCard(Id: Int,card_name: String, price: String, expired_in: String, vendor_id: String, status: String, image: UIImage?, imageKey: String = "photo", completion: @escaping (AddMemberModel?) -> Void) {
//        let url = global.shared.URL_UPDATE_GIFTCARD
        let urlString = "\(global.shared.URL_UPDATE_GIFTCARD)\(Id)"
        guard let url = URL(string: urlString) else { return }
        
        
        let params: [String: Any] = [
                "card_name": card_name,
                "price": price,
                "expired_in": expired_in,
                "vendor_id": vendor_id,
                "status": status
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
            method: .put,
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
    
    func deleteGiftCard(Id: Int, completion: @escaping (CommonResponse?) -> Void) {
        let urlString = "\(global.shared.URL_DELETE_GIFTCARD)\(Id)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT" // ✅ OR "PUT" if your backend expects it
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
    
    func fetchNoShowLimit(completion: @escaping (ShowLimitModel?) -> Void) {
        
        let url = global.shared.URL_GET_NoShowLimit + "/\(LocalData.userId)"

        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseObject { (response: DataResponse<ShowLimitModel, AFError>) in
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
    
    func UpdateNoShowlimit(vendorId: String,allow_noshow:String,noshow_limit: String, completion: @escaping (CommonModel?) -> Void) {
        let url = global.shared.URL_UPDATE_NoShowLimit
        
        let params: [String: Any] = [
            "vendor_id": vendorId,
            "noshow_limit": noshow_limit,
            "allow_noshow": allow_noshow
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CommonModel, AFError>) in

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
    
    //MARK: Clients Api
    func SendInvoice(booking_id: String, email: String, completion: @escaping (CommonResponses?) -> Void) {
        let url = global.shared.URL_SEND_INVOICE
        
        let params: [String: Any] = [
                "booking_id": booking_id,
                "email": email
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
    
    func verifyPasscode(passcode: String, vendorId: String, completion: @escaping (verifyPasscode?) -> Void) {
        let url = global.shared.URL_VERIFY_PASSCODE
        
        let params: [String: Any] = [
                "passcode": passcode,
                "vendor_id": vendorId
            ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<verifyPasscode, AFError>) in

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
    
    func Past_Client_Booking(customer_id: String, is_past: String, search:String, completion: @escaping (ClientBooking?) -> Void) {
        let url = global.shared.URL_CLIENT_BOOKINGS
        
        let params: [String: Any] = [
                "customer_id": customer_id,
                "is_past": is_past,
                "search" : search
            ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<ClientBooking, AFError>) in

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
    
    func ClientBookingData(customer_id: String, completion: @escaping (TodayBookingModel?) -> Void) {
        let url = global.shared.URL_CLIENT_BOOKINGS_DATA
        
        let params: [String: Any] = [
                "customer_id": customer_id
            ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<TodayBookingModel, AFError>) in

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
    
    func fetchStaffList(service_id: String, completion: @escaping (StaffListModel?) -> Void) {
        let url = global.shared.URL_GET_STAFF + "\(LocalData.userId)"

        let params: [String: Any] = [
            "service_id": service_id
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<StaffListModel, AFError>) in

            // 🌐 Log request info
            print("🌐 URL: \(url)")
            print("📤 Parameters: \(params)")
            print("📤 Headers: \(self.headers)")

            // 📩 Log response
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
    
    func fetchTestDetails(customer_id: String, completion: @escaping (TeamListModel?) -> Void) {
        let url = global.shared.URL_TEST_DETAILS

        let params: [String: Any] = [
            "customer_id": customer_id
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<TeamListModel, AFError>) in

            // 🌐 Log request info
            print("🌐 URL: \(url)")
            print("📤 Parameters: \(params)")
            print("📤 Headers: \(self.headers)")

            // 📩 Log response
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
    
    func UpdateNewTest(customer_id: String, description: String,status: String,tested_by:String,tested_date:String,title:String, completion: @escaping (CurrencyResponseA?) -> Void) {
        let url = global.shared.URL_ADD_TEST

        // Prepare parameters
        let params: [String: Any] = [
            "customer_id": customer_id,
            "description": description,
            "status": status,
            "tested_by": tested_by,
            "tested_date": tested_date,
            "title": title,
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CurrencyResponseA, AFError>) in

            // 🌐 Log request info
            print("🌐 URL: \(url)")
            print("📤 Parameters: \(params)")
            print("📤 Headers: \(self.headers)")

            // 📩 Log response
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
    
    
    func TimeSlot(duration: String, full_date: String,staff_id: String, completion: @escaping (TimeSlotResponse?) -> Void) {
        let url = global.shared.URL_SELECT_SLOT + "/v1"
//        let url = global.shared.URL_SELECT_SLOT

        // Prepare parameters
        let params: [String: Any] = [
            "duration": duration,
            "full_date": full_date,
            "staff_id": staff_id,
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<TimeSlotResponse, AFError>) in

            // 🌐 Log request info
            print("🌐 URL: \(url)")
            print("📤 Parameters: \(params)")
            print("📤 Headers: \(self.headers)")

            // 📩 Log response
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
    
    func PastBooking(booking_date: String,booking_id: String,startTime: String,endTime: String,staffBookingArray: [[String: Any]],staff_id: String,completion: @escaping (CurrencyResponseA?) -> Void) {
        let url = global.shared.URL_PAST_REBOOKING
        
        // Convert booking_time dictionary to JSON string
        let bookingTimeDict: [String: Any] = [
            "startTime": startTime,
            "endTime": endTime
        ]
        let bookingTimeData = try? JSONSerialization.data(withJSONObject: bookingTimeDict, options: [])
        let bookingTimeString = String(data: bookingTimeData ?? Data(), encoding: .utf8) ?? ""
        
        // Convert staff_booking array to JSON string
        let staffBookingData = try? JSONSerialization.data(withJSONObject: staffBookingArray, options: [])
        let staffBookingString = String(data: staffBookingData ?? Data(), encoding: .utf8) ?? ""
        
        // Prepare parameters
        let params: [String: Any] = [
            "booking_date": booking_date,
            "booking_id": booking_id,
            "booking_time": bookingTimeString,
            "is_fav": "0",
            "staff_booking": staffBookingString,
            "staff_id": staff_id
        ]
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CurrencyResponseA, AFError>) in
                
                print("🌐 URL: \(url)")
                print("📤 Parameters: \(params)")
                print("📤 Headers: \(self.headers)")
                
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }
                
                switch response.result {
                case .success(let result):
                    if let data = response.data,
                       let responseStr = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(responseStr)")
                    }
                    completion(result)
                case .failure(let error):
                    print("❌ Error: \(error.localizedDescription)")
                    completion(nil)
                }
            }
    }

    
    func deleteWalkin(WalkinId: Int, completion: @escaping (CommonResponse?) -> Void) {
        let urlString = "\(global.shared.URL_DELETE_WALKIN)\(WalkinId)"
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
    
    func DeleteBooking(vendor_id: String, booking_id: String, completion: @escaping (CommonResponses?) -> Void) {
        let url = global.shared.URL_DELETE_BOOKING
        
        let params: [String: Any] = [
            "vendor_id": vendor_id,
            "booking_id": booking_id
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
    
    func ResourceDetails(vendorId: String, completion: @escaping (InventoryListResponse?) -> Void) {
        let url = global.shared.URL_RESOURCE_DETAILS
        
        let params: [String: Any] = [
                "vendor_id": vendorId,
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
    
    func addResource(description: String, name: String, qty: String, vendor_id:String, completion: @escaping (AddResource?) -> Void) {
        let url = global.shared.URL_ADD_RESOURCE
        
        let params: [String: Any] = [
            "vendor_id": vendor_id,
            "description": description,
            "name": name,
            "qty": qty,
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<AddResource, AFError>) in

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
    
    func UpdateResource(description: String, name: String, qty: String, resource_id: String, vendor_id:String, completion: @escaping (CommonResponses?) -> Void) {
        let url = global.shared.URL_UPDATE_RESOURCE
        
        let params: [String: Any] = [
            "vendor_id": vendor_id,
            "description": description,
            "name": name,
            "qty": qty,
            "resource_id": resource_id
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
    
    func deleteResource(id: Int, completion: @escaping (CommonResponse?) -> Void) {
        let urlString = "\(global.shared.URL_DELETE_RESOURCE)\(id)"
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
    
    func subvendorLogin(email: String, password: String, completion: @escaping (subVendor?) -> Void) {
        let url = global.shared.URL_LOGIN_SUBVENDOR
        let params: [String: Any] = ["email": email, "password": password]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<subVendor, AFError>) in

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
                    completion(result)
                case .failure(let error):
                    print("❌ Error: \(error.localizedDescription)")
                    completion(nil)
                }
            }
    }
    
    func downloadClientReport(vendor_id: String,search:String, completion: @escaping (ReportDownloadModel?) -> Void) {

    let url = global.shared.URL_CLIENT_REPORT

    let params: [String: Any] = [
        "vendor_id": vendor_id,
        "search" : search
    ]

    AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
        .responseObject { (response: DataResponse<ReportDownloadModel, AFError>) in
            
            // Debug Info
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
                print("✅ Download File: \(result.filename)")
                completion(result)
            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    
    // not use this code
    /*
    func updateTeamData(firstName: String, lastName: String, vendorId: String, email: String, jobTitle: String, gender: String, dob: String, phone: String, showCustomer: String, showInCalendar: String, serviceIds: String, workingHours: String, shiftTimings: String, image: UIImage?, imageKey: String = "file", teamId: String, completion: @escaping (CommonResponse?) -> Void) {
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
    */
    
    //MARK: After ObjectMapper Add Api Call Change Login Api
/*
    func login(email: String, password: String, completion: @escaping (LoginData?) -> Void) {
        let url = global.shared.URL_LOGIN
        let params: [String: Any] = ["email": email, "password": password]

    AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
        .responseJSON { response in

            print("🔵 Request: \(String(describing: response.request))")
            print("🌐 URL: \(url)")
            print("📤 Parameters: \(params)")

            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            if let data = response.data,
               let rawJSON = String(data: data, encoding: .utf8) {
                print("📥 Raw Response: \(rawJSON)")
            }

            switch response.result {
            case .success(let value):
                // 🔁 Map manually using ObjectMapper
                if let json = value as? [String: Any],
                   let result = Mapper<LoginResponse>().map(JSON: json) {
                    print("✅ Parsed Response Object: \(result)")
                    completion(result.data)
                } else {
                    print("⚠️ Failed to parse JSON into LoginResponse")
                    completion(nil)
                }

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
        // ⬇️ CHANGED: replaced `.responseObject` with `.responseJSON`
        .responseJSON { response in    // ➡️ CHANGED

            print("🌐 URL: \(url)")
            print("📤 Parameters: \(params)")
            print("📤 Headers: \(self.headers)")

            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            switch response.result {
            case .success(let value):   // ➡️ CHANGED
                if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }

                // ⬇️ CHANGED: Manual ObjectMapper mapping
                if let json = value as? [String: Any],
                   let result = Mapper<ServiceDetailsModel>().map(JSON: json) {  // ➡️ CHANGED
                    print("✅ Parsed Response Object: \(result)")
                    completion(result)
                } else {  // ➡️ CHANGED
                    print("⚠️ Failed to parse JSON into ServiceDetailsModel") // ➡️ CHANGED
                    completion(nil)
                }

            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    func addServiceData(serviceName: String, parentId: Int, vendorId: String, description: String, serviceFor: String, duration: Int, priceType: String, price: String, salePrice: String, vendorOnly: String, contactSalon: String, testRequired: String, staffId: String, has_sub_service: String, is_sub_service: String, resource_id: String, completion: @escaping (AddServiceModel?) -> Void) {
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
            "staff_id": staffId,
            "has_sub_service": has_sub_service,
            "is_sub_service": is_sub_service,
            "resource_id": resource_id
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            // ⬇️ CHANGED: replaced `.responseObject` with `.responseJSON`
            .responseJSON { response in   // ➡️ CHANGED

                print("🌐 URL: \(url)")
                print("📤 Parameters: \(params)")
                print("📤 Headers: \(self.headers)")

                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }
                
                switch response.result {
                case .success(let value):   // ➡️ CHANGED
                    if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(responseStr)")
                    }

                    // ⬇️ CHANGED: Manual mapping using ObjectMapper
                    if let json = value as? [String: Any],
                       let result = Mapper<AddServiceModel>().map(JSON: json) {  // ➡️ CHANGED
                        print("✅ Parsed Response Object: \(result)")
                        completion(result)
                    } else {  // ➡️ CHANGED
                        print("⚠️ Failed to parse JSON into AddServiceModel") // ➡️ CHANGED
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ Error: \(error.localizedDescription)")
                    completion(nil)
                }
            }
    }

    func updateServiceData(serviceName: String,parentId: Int,vendorId: String,description: String,serviceFor: String,duration: Int,priceType: String,price: String,salePrice: String,vendorOnly: String,contactSalon: String,testRequired: String,staffId: String,serviceId: String,has_sub_service: String,is_sub_service: String,resource_id: String,completion: @escaping (CommonResponse?) -> Void) {
        
        let urlString = "\(global.shared.URL_UPDATE_SERVICE)\(serviceId)"
        let url = urlString

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
            "has_sub_service": has_sub_service,
            "is_sub_service": is_sub_service,
            "resource_id": resource_id
        ]

        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(self.headers)")

        // ✅ Using Alamofire with PUT request
        AF.request(url,method: .put,parameters: params,encoding: JSONEncoding.default,headers: HTTPHeaders(headers))
        .responseJSON { response in

            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            switch response.result {
            case .success(let value):
                if let data = response.data,
                   let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }

                // ✅ Parse using ObjectMapper
                if let json = value as? [String: Any],
                   let result = Mapper<CommonResponse>().map(JSON: json) {
                    print("✅ Parsed Response Object: \(result)")
                    completion(result)
                } else {
                    print("⚠️ Failed to parse JSON into CommonResponse")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    func deleteServiceData(serviceId: Int, completion: @escaping (CommonResponse?) -> Void) {
        let urlString = "\(global.shared.URL_DELETE_SERVICE)\(serviceId)"
        let url = urlString

        let params: [String: Any] = [:] // No params needed for delete
        
        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(self.headers)")

        // ⬇️ CHANGED: Using Alamofire instead of URLSession
        AF.request(url, method: .delete, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers)) // ➡️ CHANGED
            .responseJSON { response in // ➡️ CHANGED

                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                switch response.result {
                case .success(let value): // ➡️ CHANGED
                    if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(responseStr)")
                    }

                    // ⬇️ CHANGED: Manual ObjectMapper parsing
                    if let json = value as? [String: Any],
                       let result = Mapper<CommonResponse>().map(JSON: json) { // ➡️ CHANGED
                        print("✅ Parsed Response Object: \(result)")
                        completion(result)
                    } else {
                        print("⚠️ Failed to parse JSON into CommonResponse") // ➡️ CHANGED
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ Error: \(error.localizedDescription)")
                    completion(nil)
                }
            }
    }

    func fetchBusinessServices(completion: @escaping (ServicesModel?) -> Void) {
        let url = global.shared.URL_BUSINESS_SERVICES
        
        print("🌐 URL: \(url)")
        print("📤 Headers: \(self.headers)")

        AF.request(url,method: .get,parameters: nil,encoding: URLEncoding.default,headers: HTTPHeaders(headers))
        .validate()
        .responseData { response in  // ✅ Use responseData instead of responseJSON (no warning)
            
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            switch response.result {
            case .success(let data):
                if let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }

                // ✅ Convert Data → JSON → ObjectMapper
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let model = Mapper<ServicesModel>().map(JSON: json) {
                        print("✅ Parsed ServicesModel Successfully")
                        completion(model)
                    } else {
                        print("⚠️ Failed to parse JSON into ServicesModel")
                        completion(nil)
                    }
                } catch {
                    print("❌ JSON Parsing Error: \(error.localizedDescription)")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ API Call Failed: \(error.localizedDescription)")
                if let data = response.data,
                   let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }
                completion(nil)
            }
        }
    }

    func fetchMainServices(completion: @escaping (ServicesModel?) -> Void) {
        let url = "\(global.shared.URL_SELECT_MAINSERVICES)\(LocalData.userId)"
        
        print("🌐 URL: \(url)")
        print("📤 Headers: \(self.headers)")
        
        AF.request(url,method: .get,parameters: nil,encoding: URLEncoding.default,headers: HTTPHeaders(headers))
        .validate()
        .responseData { response in  // ✅ Updated to responseData
            
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }
            
            switch response.result {
            case .success(let data):
                if let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }
                
                // ✅ Manual JSON → ObjectMapper parsing
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let model = Mapper<ServicesModel>().map(JSON: json) {
                        print("✅ Parsed ServicesModel Successfully")
                        completion(model)
                    } else {
                        print("⚠️ Failed to parse JSON into ServicesModel")
                        completion(nil)
                    }
                } catch {
                    print("❌ JSON Parsing Error: \(error.localizedDescription)")
                    completion(nil)
                }
                
            case .failure(let error):
                print("❌ API Call Failed: \(error.localizedDescription)")
                if let data = response.data,
                   let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }
                completion(nil)
            }
        }
    }
    
    func getteamDetails(page: String,limit: String,vendorId: String,search: String,date: String = "",staffId: String = "",isTeamDetails: Int = 0,completion: @escaping (StaffResponse?) -> Void) {
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
        
        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(self.headers)")
        
        AF.request(
            url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseData { response in  // ✅ replaced .responseObject → .responseData
            
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }
            
            switch response.result {
            case .success(let data):
                if let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }
                
                // ✅ Manual JSON → ObjectMapper conversion
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let result = Mapper<StaffResponse>().map(JSON: json) {
                        print("✅ Parsed Response Object: \(result)")
                        completion(result)
                    } else {
                        print("⚠️ Failed to map JSON to StaffResponse")
                        completion(nil)
                    }
                } catch {
                    print("❌ JSON Parsing Error: \(error.localizedDescription)")
                    completion(nil)
                }
                
            case .failure(let error):
                print("❌ API Call Failed: \(error.localizedDescription)")
                if let data = response.data,
                   let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }
                completion(nil)
            }
        }
    }
    
    func addTeamData(firstName: String,lastName: String,vendorId: String,email: String,jobTitle: String,gender: String,dob: String,phone: String,showCustomer: String,showInCalendar: String,serviceIds: String,workingHours: String,shiftTimings: String,image: UIImage?,imageKey: String = "file",completion: @escaping (AddMemberModel?) -> Void) {
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
                // Attach image if available
                if let image = image, let imageData = image.jpegData(compressionQuality: 0.8) {
                    multipartFormData.append(
                        imageData,
                        withName: imageKey,
                        fileName: "profile.jpg",
                        mimeType: "image/jpeg"
                    )
                }

                // Add text parameters
                for (key, value) in params {
                    if let data = "\(value)".data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            },
            to: url,
            method: .post,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseData { response in
            // 🌍 Log request info
            print("🌍 URL: \(url)")
            print("📤 Parameters: \(params)")
            print("📤 Headers: \(self.headers)")

            if let httpResponse = response.response {
                print("📡 Status Code: \(httpResponse.statusCode)")
            }

            switch response.result {
            case .success(let data):
                if let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }

                // 🟩 Try mapping manually using ObjectMapper
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let model = AddMemberModel(JSON: json) {
                    print("✅ Parsed Response Object Successfully")
                    completion(model)
                } else {
                    print("⚠️ Failed to parse JSON to AddMemberModel")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ Upload Failed: \(error.localizedDescription)")
                if let data = response.data,
                   let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Error Response: \(responseStr)")
                }
                completion(nil)
            }
        }
    }

    func updateTeamData(firstName: String,lastName: String,vendorId: String,email: String,jobTitle: String,gender: String,dob: String,phone: String,showCustomer: String,showInCalendar: String,serviceIds: String,workingHours: String,shiftTimings: String,image: UIImage?,imageKey: String = "file",teamId: String,
        completion: @escaping (CommonResponse?) -> Void) {
        
        let urlString = "\(global.shared.URL_UPDATE_TEAM)\(teamId)"
        guard let url = URL(string: urlString) else { return }

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
            "shift_timings": shiftTimings
        ]

        AF.upload(
            multipartFormData: { multipartFormData in
                // ✅ Attach image
                if let image = image, let imageData = image.jpegData(compressionQuality: 0.8) {
                    multipartFormData.append(
                        imageData,
                        withName: imageKey,
                        fileName: "team.jpg",
                        mimeType: "image/jpeg"
                    )
                }

                // ✅ Attach other parameters
                for (key, value) in params {
                    if let stringValue = "\(value)".data(using: .utf8) {
                        multipartFormData.append(stringValue, withName: key)
                    }
                }
            },
            to: url,
            method: .put,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in
            print("🌐 URL: \(url)")
            print("📤 Parameters: \(params)")
            print("📤 Headers: \(self.headers)")

            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            switch response.result {
            case .success(let json):
                print("📦 Raw Response: \(json)")

                // ✅ Parse with ObjectMapper
                if let dict = json as? [String: Any],
                   let model = CommonResponse(JSON: dict) {
                    print("✅ Parsed Response Object: \(model)")
                    completion(model)
                } else {
                    print("⚠️ Failed to map response to CommonResponse")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ Upload Failed: \(error.localizedDescription)")

                if let data = response.data,
                   let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Error Response: \(responseStr)")
                }

                completion(nil)
            }
        }
    }

    func deleteTeamData(teamId: Int, completion: @escaping (CommonResponse?) -> Void) {
        let urlString = "\(global.shared.URL_DELETE_TEAM)\(teamId)"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.headers = HTTPHeaders(headers)
        
        // ✅ Optional: JSON body (if API expects any parameters)
        let params: [String: Any] = [:]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
            request.httpBody = jsonData
        } catch {
            print("❌ Failed to encode JSON: \(error)")
            completion(nil)
            return
        }

        print("🌐 URL: \(urlString)")
        print("📤 Headers: \(self.headers)")
        print("📤 Params: \(params)")

        // ✅ Execute Request
        AF.request(request)
            .validate()
            .responseData { response in
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                switch response.result {
                case .success(let value):
                    print("📦 Raw Response: \(value)")

                    // ✅ Parse JSON to CommonResponse using ObjectMapper
                    if let json = value as? [String: Any],
                       let model = CommonResponse(JSON: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("⚠️ Failed to parse JSON into CommonResponse")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ Request Failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let responseStr = String(data: data, encoding: .utf8) {
                        print("📦 Raw Error Response: \(responseStr)")
                    }
                    completion(nil)
                }
            }
    }*/

}*/

import Foundation
import Alamofire
import ObjectMapper
//import AlamofireObjectMapper


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
    
    // MARK: - Helper mapper
    private func mapResponseObject<T: Mappable>(json: Any?) -> T? {
        guard let dict = json as? [String: Any] else { return nil }
        return Mapper<T>().map(JSON: dict)
    }

    private func mapResponseArray<T: Mappable>(json: Any?) -> [T]? {
        guard let arr = json as? [[String: Any]] else { return nil }
        return Mapper<T>().mapArray(JSONArray: arr)
    }


    // MARK: - Login Api
        func login(email: String, password: String, completion: @escaping (LoginData?) -> Void) {
            let url = global.shared.URL_LOGIN
            let params: [String: Any] = ["email": email, "password": password]

            AF.request(url,
                       method: .post,
                       parameters: params,
                       encoding: JSONEncoding.default,
                       headers: HTTPHeaders(headers))
                .validate()
                .responseJSON { response in

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
                    case .success(let json):
                        if let result: LoginResponse = self.mapResponseObject(json: json) {
                            print("✅ Parsed Response Object: \(result)")
                            completion(result.data)
                        } else {
                            print("❌ JSON structure does not match LoginResponse")
                            completion(nil)
                        }
                    case .failure(let error):
                        print("❌ Error: \(error.localizedDescription)")
                        completion(nil)
                    }
                }
        }
    
    func soicalLogin(social_id: String, social_type: String,email: String, completion: @escaping (LoginData?) -> Void) {
        let url = global.shared.URL_SOCIAL_LOGIN
        let params: [String: Any] = ["social_id": social_id, "social_type": social_type,"email":email]

        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding.default,
                   headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in

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
                case .success(let json):
                    if let result: LoginResponse = self.mapResponseObject(json: json) {
                        print("✅ Parsed Response Object: \(result)")
                        completion(result.data)
                    } else {
                        print("❌ JSON structure does not match LoginResponse")
                        completion(nil)
                    }
                case .failure(let error):
                    print("❌ Error: \(error.localizedDescription)")
                    completion(nil)
                }
            }
    }
    
    // MARK: - Service List Api
        func getServiceDetails(
            page: String,
            limit: String,
            vendorId: String,
            search: String,
            booking: String,
            categoryId: String,
            isGroup: Bool,
            completion: @escaping (ServiceDetailsModel?) -> Void
        ) {
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

            AF.request(url,
                       method: .post,
                       parameters: params,
                       encoding: JSONEncoding.default,
                       headers: HTTPHeaders(headers))
                .validate()
                .responseJSON { response in

                    // 📦 Print request info
                    print("🌐 URL: \(url)")
                    print("📤 Parameters: \(params)")
                    print("📤 Headers: \(self.headers)")

                    // 📩 Print HTTP response status code
                    if let httpResponse = response.response {
                        print("✅ Status Code: \(httpResponse.statusCode)")
                    }

                    // 🧾 Print raw response body
                    if let data = response.data,
                       let raw = String(data: data, encoding: .utf8) {
                        print("📥 Raw Response: \(raw)")
                    }

                    switch response.result {
                    case .success(let json):
                        if let model: ServiceDetailsModel = self.mapResponseObject(json: json) {
                            print("✅ Parsed Response Object: \(model)")
                            completion(model)
                        } else {
                            print("❌ Mapping failed — unexpected JSON structure.")
                            completion(nil)
                        }

                    case .failure(let error):
                        print("❌ Error: \(error.localizedDescription)")
                        completion(nil)
                    }
                }
        }

    // MARK: - Add Service
        func addServiceData(
            serviceName: String,
            parentId: Int,
            vendorId: String,
            description: String,
            serviceFor: String,
            duration: Int,
            priceType: String,
            price: String,
            salePrice: String,
            vendorOnly: String,
            contactSalon: String,
            testRequired: String,
            staffId: String,
            has_sub_service: String,
            is_sub_service: String,
            resource_id: String,
            completion: @escaping (AddServiceModel?) -> Void
        ) {
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
                "staff_id": staffId,
                "has_sub_service": has_sub_service,
                "is_sub_service": is_sub_service,
                "resource_id": resource_id
            ]

            AF.request(url,
                       method: .post,
                       parameters: params,
                       encoding: JSONEncoding.default,
                       headers: HTTPHeaders(headers))
                .validate()
                .responseJSON { response in
                    // 📦 Print request info
                    print("🌐 URL: \(url)")
                    print("📤 Parameters: \(params)")
                    print("📤 Headers: \(self.headers)")

                    // 📩 Print HTTP response status code
                    if let httpResponse = response.response {
                        print("✅ Status Code: \(httpResponse.statusCode)")
                    }

                    // raw response
                    if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(responseStr)")
                    }

                    switch response.result {
                    case .success(let json):
                        if let model: AddServiceModel = self.mapResponseObject(json: json) {
                            print("✅ Parsed Response Object: \(model)")
                            completion(model)
                        } else {
                            print("❌ Mapping failed — unexpected JSON structure.")
                            completion(nil)
                        }
                    case .failure(let error):
                        print("❌ Error: \(error.localizedDescription)")
                        completion(nil)
                    }
                }
        }
    
    // MARK: - Update Service API
    func updateServiceData(
        serviceName: String,
        parentId: Int,
        vendorId: String,
        description: String,
        serviceFor: String,
        duration: Int,
        priceType: String,
        price: String,
        salePrice: String,
        vendorOnly: String,
        contactSalon: String,
        testRequired: String,
        staffId: String,
        serviceId: String,
        has_sub_service: String,
        is_sub_service: String,
        resource_id: String,
        completion: @escaping (CommonResponse?) -> Void
    ) {
        let url = "\(global.shared.URL_UPDATE_SERVICE)\(serviceId)"

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
            "has_sub_service": has_sub_service,
            "is_sub_service": is_sub_service,
            "resource_id": resource_id
        ]

        // 📦 Log Request
        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")

        AF.request(
            url,
            method: .put,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in

            // 📩 Print HTTP response status code
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            // 🧾 Print raw response body
            if let data = response.data,
               let rawJSON = String(data: data, encoding: .utf8) {
                print("📥 Raw Response: \(rawJSON)")
            }

            // 🧠 Map JSON to CommonResponse
            switch response.result {
            case .success(let json):
                if let model: CommonResponse = Mapper<CommonResponse>().map(JSONObject: json) {
                    print("✅ Parsed Response Object: \(model)")
                    completion(model)
                } else {
                    print("❌ Mapping failed — unexpected JSON structure.")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }


    // MARK: - Delete Service API
    func deleteServiceData(serviceId: Int, completion: @escaping (CommonResponse?) -> Void) {
        let url = "\(global.shared.URL_DELETE_SERVICE)\(serviceId)"
        let params: [String: Any] = [:] // Optional for DELETE

        print("🌐 URL: \(url)")
        print("📤 Headers: \(headers)")

        AF.request(
            url,
            method: .delete,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in
            // 📩 Print HTTP response status code
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            // 🧾 Print raw response body
            if let data = response.data,
               let rawJSON = String(data: data, encoding: .utf8) {
                print("📥 Raw Response: \(rawJSON)")
            }

            // 🧠 Map JSON → CommonResponse
            switch response.result {
            case .success(let json):
                if let model: CommonResponse = Mapper<CommonResponse>().map(JSONObject: json) {
                    print("✅ Parsed Response Object: \(model)")
                    completion(model)
                } else {
                    print("❌ Mapping failed — unexpected JSON structure.")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

    
    
    // MARK: - Business Service Api
        func fetchBusinessServices(completion: @escaping (ServicesModel?) -> Void) {
            let url = global.shared.URL_BUSINESS_SERVICES

            AF.request(url,
                       method: .get,
                       headers: HTTPHeaders(headers))
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let json):
                        if let model: ServicesModel = self.mapResponseObject(json: json) {
                            if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                                print("📦 Raw Response: \(responseStr)")
                            }
                            print("✅ Received \(model.data.count) business services")
                            completion(model)
                        } else {
                            print("❌ Mapping failed")
                            completion(nil)
                        }
                    case .failure(let error):
                        print("❌ API Call Failed: \(error)")
                        if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                            print("📦 Raw Response: \(responseStr)")
                        }
                        completion(nil)
                    }
                }
        }
    
    // MARK: - fetchMainServices
        func fetchMainServices(completion: @escaping (ServicesModel?) -> Void) {
            let url = "\(global.shared.URL_SELECT_MAINSERVICES)\(LocalData.userId)"

            AF.request(url,
                       method: .get,
                       headers: HTTPHeaders(headers))
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let json):
                        if let model: ServicesModel = self.mapResponseObject(json: json) {
                            if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                                print("📦 Raw Response: \(responseStr)")
                            }
                            print("✅ Received \(model.data.count) business services")
                            completion(model)
                        } else {
                            print("❌ Mapping failed")
                            completion(nil)
                        }
                    case .failure(let error):
                        print("❌ API Call Failed: \(error)")
                        if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                            print("📦 Raw Response: \(responseStr)")
                        }
                        completion(nil)
                    }
                }
        }
    
    
    // MARK: - Team Api
       func getteamDetails(
           page: String,
           limit: String,
           vendorId: String,
           search: String,
           date: String = "",
           staffId: String = "",
           isTeamDetails: Int = 0,
           completion: @escaping (StaffResponse?) -> Void
       ) {
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

           AF.request(url,
                      method: .post,
                      parameters: params,
                      encoding: JSONEncoding.default,
                      headers: HTTPHeaders(headers))
               .validate()
               .responseJSON { response in

                   // 📦 Print request info
                   print("🌐 URL: \(url)")
                   print("📤 Parameters: \(params)")
                   print("📤 Headers: \(self.headers)")

                   // 📩 Print HTTP response status code
                   if let httpResponse = response.response {
                       print("✅ Status Code: \(httpResponse.statusCode)")
                   }

                   switch response.result {
                   case .success(let json):
                       if let model: StaffResponse = self.mapResponseObject(json: json) {
                           if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                               print("📦 Raw Response: \(responseStr)")
                           }
                           print("✅ Parsed Response Object: \(model)")
                           completion(model)
                       } else {
                           print("❌ Mapping failed")
                           completion(nil)
                       }
                   case .failure(let error):
                       print("❌ Error: \(error.localizedDescription)")
                       completion(nil)
                   }
               }
       }

       // MARK: - addTeamData (multipart)
       func addTeamData(
           firstName: String,
           lastName: String,
           vendorId: String,
           email: String,
           jobTitle: String,
           gender: String,
           dob: String,
           phone: String,
           showCustomer: String,
           showInCalendar: String,
           serviceIds: String,
           workingHours: String,
           shiftTimings: String,
           image: UIImage?,
           imageKey: String = "file",
           completion: @escaping (AddMemberModel?) -> Void
       ) {
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
                   if let image = image, let imageData = image.jpegData(compressionQuality: 0.8) {
                       multipartFormData.append(imageData, withName: imageKey, fileName: "profile.jpg", mimeType: "image/jpeg")
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
           .responseJSON { response in
               print("🌐 URL: \(url)")
               print("📤 Parameters: \(params)")
               print("📤 Headers: \(self.headers)")

               if let httpResponse = response.response {
                   print("✅ Status Code: \(httpResponse.statusCode)")
               }

               switch response.result {
               case .success(let json):
                   if let model: AddMemberModel = self.mapResponseObject(json: json) {
                       if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                           print("📦 Raw Response: \(responseStr)")
                       }
                       print("✅ Parsed Response Object: \(model)")
                       completion(model)
                   } else {
                       print("❌ Mapping failed")
                       completion(nil)
                   }
               case .failure(let error):
                   print("❌ Error: \(error.localizedDescription)")
                   completion(nil)
               }
           }
       }

       // MARK: - updateTeamData (multipart with PUT)
       func updateTeamData(
           firstName: String,
           lastName: String,
           vendorId: String,
           email: String,
           jobTitle: String,
           gender: String,
           dob: String,
           phone: String,
           showCustomer: String,
           showInCalendar: String,
           serviceIds: String,
           workingHours: String,
           shiftTimings: String,
           image: UIImage?,
           imageKey: String = "file",
           teamId: String,
           completion: @escaping (CommonResponse?) -> Void
       ) {
           let urlString = "\(global.shared.URL_UPDATE_TEAM)\(teamId)"
           guard let url = URL(string: urlString) else { return }

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
               "shift_timings": shiftTimings
           ]

           AF.upload(
               multipartFormData: { multipartFormData in
                   // Attach Image if available
                   if let image = image, let imageData = image.jpegData(compressionQuality: 0.8) {
                       multipartFormData.append(imageData, withName: imageKey, fileName: "team.jpg", mimeType: "image/jpeg")
                   }

                   // Attach other parameters
                   for (key, value) in params {
                       if let stringValue = "\(value)".data(using: .utf8) {
                           multipartFormData.append(stringValue, withName: key)
                       }
                   }
               },
               to: url,
               method: .put,
               headers: HTTPHeaders(headers)
           )
           .validate()
           .responseJSON { response in
               print("🌐 URL: \(url)")
               print("📤 Parameters: \(params)")
               print("📤 Headers: \(self.headers)")

               if let httpResponse = response.response {
                   print("✅ Status Code: \(httpResponse.statusCode)")
               }

               switch response.result {
               case .success(let json):
                   if let model: CommonResponse = self.mapResponseObject(json: json) {
                       if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                           print("📦 Raw Response: \(responseStr)")
                       }
                       print("✅ Parsed Response Object: \(model)")
                       completion(model)
                   } else {
                       print("❌ Mapping failed")
                       completion(nil)
                   }
               case .failure(let error):
                   print("❌ Error: \(error.localizedDescription)")
                   completion(nil)
               }
           }
       }

       // MARK: - deleteTeamData (uses URLSession)
    // MARK: - Delete Team API
    func deleteTeamData(teamId: Int, completion: @escaping (CommonResponse?) -> Void) {
        let url = "\(global.shared.URL_DELETE_TEAM)\(teamId)"
        let params: [String: Any] = [:] // Optional for DELETE

        // 📦 Log Request
        print("🌐 URL: \(url)")
        print("📤 Headers: \(headers)")

        AF.request(
            url,
            method: .delete,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in

            // 📩 Print HTTP response status code
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            // 🧾 Print raw response body
            if let data = response.data,
               let rawJSON = String(data: data, encoding: .utf8) {
                print("📥 Raw Response: \(rawJSON)")
            }

            // 🧠 Parse JSON → CommonResponse using ObjectMapper
            switch response.result {
            case .success(let json):
                if let model: CommonResponse = Mapper<CommonResponse>().map(JSONObject: json) {
                    print("✅ Parsed Response Object: \(model)")
                    completion(model)
                } else {
                    print("❌ Mapping failed — unexpected JSON structure.")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

    
    // MARK: - Client APIs (examples converted similarly)
        func getclientDetails(
            page: String,
            limit: String,
            sort: String,
            vendorId: String,
            search: String,
            completion: @escaping (CustomerListResponse?) -> Void
        ) {
            let url = global.shared.URL_CLIENT_DETAILS

            let params: [String: Any] = [
                "page": page,
                "limit": limit,
                "vendor_id": vendorId,
                "sort": sort,
                "search": search,
            ]

            AF.request(url,
                       method: .post,
                       parameters: params,
                       encoding: JSONEncoding.default,
                       headers: HTTPHeaders(headers))
                .validate()
                .responseJSON { response in
                    print("🌐 URL: \(url)")
                    print("📤 Parameters: \(params)")
                    print("📤 Headers: \(self.headers)")

                    if let httpResponse = response.response {
                        print("✅ Status Code: \(httpResponse.statusCode)")
                    }

                    switch response.result {
                    case .success(let json):
                        if let model: CustomerListResponse = self.mapResponseObject(json: json) {
                            if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                                print("📦 Raw Response: \(responseStr)")
                            }
                            print("✅ Parsed Response Object: \(model)")
                            completion(model)
                        } else {
                            print("❌ Mapping failed")
                            completion(nil)
                        }
                    case .failure(let error):
                        print("❌ Error: \(error.localizedDescription)")
                        completion(nil)
                    }
                }
        }

        func addClientData(
            firstName: String,
            lastName: String,
            vendorId: String,
            email: String,
            clientType: String,
            gender: String,
            dob: String,
            phone: String,
            completion: @escaping (AddClientModel?) -> Void
        ) {
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

            AF.request(url,
                       method: .post,
                       parameters: params,
                       encoding: JSONEncoding.default,
                       headers: HTTPHeaders(headers))
                .validate()
                .responseJSON { response in
                    print("🌐 URL: \(url)")
                    print("📤 Parameters: \(params)")
                    print("📤 Headers: \(self.headers)")

                    if let httpResponse = response.response {
                        print("✅ Status Code: \(httpResponse.statusCode)")
                    }

                    switch response.result {
                    case .success(let json):
                        if let model: AddClientModel = self.mapResponseObject(json: json) {
                            if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                                print("📦 Raw Response: \(responseStr)")
                            }
                            print("✅ Parsed Response Object: \(model)")
                            completion(model)
                        } else {
                            print("❌ Mapping failed")
                            completion(nil)
                        }
                    case .failure(let error):
                        print("❌ Error: \(error.localizedDescription)")
                        completion(nil)
                    }
                }
        }
    
    func updateClientData(
        firstName: String,
        lastName: String,
        vendorId: String,
        email: String,
        clientType: String,
        gender: String,
        dob: String,
        phone: String,
        clientId: Int,
        completion: @escaping (CommonResponse?) -> Void
    ) {
        let urlString = "\(global.shared.URL_UPDATE_CLIENT)\(clientId)"
        let url = urlString

        let params: [String: Any] = [
            "first_name": firstName,
            "last_name": lastName,
            "vendor_id": vendorId,
            "email": email,
            "client_type": clientType,
            "gender": gender,
            "dob": dob,
            "phone": phone
        ]

        // 📦 Log Request
        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")

        AF.request(url,
                   method: .put,
                   parameters: params,
                   encoding: JSONEncoding.default,
                   headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in

                // 📩 Print HTTP response status code
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 🧾 Print raw response body
                if let data = response.data,
                   let raw = String(data: data, encoding: .utf8) {
                    print("📥 Raw Response: \(raw)")
                }

                switch response.result {
                case .success(let json):
                    if let model: CommonResponse = Mapper<CommonResponse>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Mapping failed — unexpected JSON structure.")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ Error: \(error.localizedDescription)")
                    completion(nil)
                }
            }
    }

    func deleteClientData(clientId: Int, completion: @escaping (CommonResponse?) -> Void) {
        let url = "\(global.shared.URL_DELETE_CLIENT)\(clientId)"
        let params: [String: Any] = [:] // Usually not needed for DELETE but included if your backend requires it

        print("🌐 URL: \(url)")
        print("📤 Headers: \(headers)")

        AF.request(url,
                   method: .delete,
                   parameters: params,
                   encoding: JSONEncoding.default,
                   headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in

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
                case .success(let json):
                    if let model: CommonResponse = Mapper<CommonResponse>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Mapping failed — unexpected JSON structure.")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ Error: \(error.localizedDescription)")
                    completion(nil)
                }
            }
    }

    func getShiftV1_Details(vendorId: String,
        completion: @escaping (StaffResponse?) -> Void) {
        let url = global.shared.URL_GET_SHIFTS_V1

        let params: [String: Any] = [
            "vendor_id": vendorId,
        ]

        AF.request(url,method: .post,parameters: params,encoding: JSONEncoding.default,headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in

                // 📦 Print request info
                print("🌐 URL: \(url)")
                print("📤 Parameters: \(params)")
                print("📤 Headers: \(self.headers)")

                // 📩 Print HTTP response status code
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                switch response.result {
                case .success(let json):
                    if let model: StaffResponse = self.mapResponseObject(json: json) {
                        if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                            print("📦 Raw Response: \(responseStr)")
                        }
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Mapping failed")
                        completion(nil)
                    }
                case .failure(let error):
                    print("❌ Error: \(error.localizedDescription)")
                    completion(nil)
                }
            }
    }
    
    // MARK: - Inventory API
    func getInventoryDetails(
        page: String,
        limit: String,
        vendorId: String,
        search: String,
        completion: @escaping (InventoryListResponse?) -> Void
    ) {
        let url = global.shared.URL_INVENTORY_DETAILS

        let params: [String: Any] = [
            "page": page,
            "limit": limit,
            "vendor_id": vendorId,
            "search": search
        ]

        AF.request(
            url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in
            // 📦 Request info
            print("🌐 URL: \(url)")
            print("📤 Parameters: \(params)")
            print("📤 Headers: \(self.headers)")

            // 📩 Status
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            // 🧾 Raw JSON
            if let data = response.data,
               let raw = String(data: data, encoding: .utf8) {
                print("📥 Raw Response: \(raw)")
            }

            switch response.result {
            case .success(let json):
                if let model: InventoryListResponse = Mapper<InventoryListResponse>().map(JSONObject: json) {
                    print("✅ Parsed Response Object: \(model)")
                    completion(model)
                } else {
                    print("❌ Mapping failed — unexpected JSON structure.")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

    
    
    //MARK: GiftCard Api
    func getGiftCardDetails(
        page: String,
        limit: String,
        vendorId: String,
        filter: String,
        search: String,
        completion: @escaping (GiftCardListResponse?) -> Void
    ) {
        let url = global.shared.URL_GIFTCARD_DETAILS

        let params: [String: Any] = [
            "page": page,
            "limit": limit,
            "vendor_id": vendorId,
            "filter": filter,
            "search": search
        ]

        // 📦 Log Request Info
        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")

        AF.request(
            url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in

            // 📩 HTTP Status
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            // 🧾 Raw Response
            if let data = response.data,
               let raw = String(data: data, encoding: .utf8) {
                print("📥 Raw Response: \(raw)")
            }

            // 🧠 Map JSON → GiftCardListResponse
            switch response.result {
            case .success(let json):
                if let model: GiftCardListResponse = Mapper<GiftCardListResponse>().map(JSONObject: json) {
                    print("✅ Parsed Response Object: \(model)")
                    completion(model)
                } else {
                    print("❌ Mapping failed — unexpected JSON structure.")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

    // MARK: - Coupon API
    func getCouponDetails(
        page: String,
        limit: String,
        vendorId: String,
        search: String,
        completion: @escaping (CouponListResponse?) -> Void
    ) {
        let url = global.shared.URL_COUPON_DETAILS

        let params: [String: Any] = [
            "page": page,
            "limit": limit,
            "vendor_id": vendorId,
            "search": search
        ]

        // 📦 Log Request
        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")

        AF.request(
            url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in

            // 📩 HTTP Status
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            // 🧾 Raw Response
            if let data = response.data,
               let raw = String(data: data, encoding: .utf8) {
                print("📥 Raw Response: \(raw)")
            }

            // 🧠 Parse JSON → CouponListResponse
            switch response.result {
            case .success(let json):
                if let model: CouponListResponse = Mapper<CouponListResponse>().map(JSONObject: json) {
                    print("✅ Parsed Response Object: \(model)")
                    completion(model)
                } else {
                    print("❌ Mapping failed — unexpected JSON structure.")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

    // MARK: - Offline Gift Card API
    func getOfflineGiftCardDetails(
        page: String,
        limit: String,
        vendorId: String,
        search: String,
        filter: String,
        completion: @escaping (OfflineGiftCardListResponse?) -> Void
    ) {
        let url = global.shared.URL_GIFT_CARDS

        let params: [String: Any] = [
            "page": page,
            "limit": limit,
            "vendor_id": vendorId,
            "search": search,
            "filter": filter
        ]

        // 📦 Log Request
        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")

        AF.request(
            url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in

            // 📩 Print HTTP Response Status Code
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            // 🧾 Print Raw Response
            if let data = response.data,
               let raw = String(data: data, encoding: .utf8) {
                print("📥 Raw Response: \(raw)")
            }

            // 🧠 Parse JSON → OfflineGiftCardListResponse using ObjectMapper
            switch response.result {
            case .success(let json):
                if let model: OfflineGiftCardListResponse = Mapper<OfflineGiftCardListResponse>().map(JSONObject: json) {
                    print("✅ Parsed Response Object: \(model)")
                    completion(model)
                } else {
                    print("❌ Mapping failed — unexpected JSON structure.")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

    
    // MARK: - Dashboard Booking API
    func getBookingHistory(
        page: String,
        limit: String,
        vendorId: String,
        search: String,
        days: String,
        completion: @escaping (BookingResponse?) -> Void
    ) {
        let url = global.shared.URL_BOOKINGS_HISTORY

        // 🧾 Build Parameters
        var params: [String: Any] = [:]
        if days != "300" {
            params = [
                "page": page,
                "limit": limit,
                "id": vendorId,
                "search": search,
                "days": days
            ]
        } else {
            params = [
                "id": vendorId,
                "days": days
            ]
        }

        // 📦 Log Request
        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")

        AF.request(
            url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in

            // 📩 Print HTTP response status code
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            // 🧾 Print raw response
            if let data = response.data,
               let raw = String(data: data, encoding: .utf8) {
                print("📥 Raw Response: \(raw)")
            }

            // 🧠 Parse JSON → BookingResponse
            switch response.result {
            case .success(let json):
                if let model: BookingResponse = Mapper<BookingResponse>().map(JSONObject: json) {
                    print("✅ Parsed Response Object: \(model)")
                    completion(model)
                } else {
                    print("❌ Mapping failed — unexpected JSON structure.")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

    // MARK: - Get Currency API
    func getCurrency(completion: @escaping (CurrencyResponse?) -> Void) {
        let id = LocalData.userId
        let url = "\(global.shared.URL_GET_CURRENCY)\(id)"

        // 🌐 Log Request Info
        print("🌐 URL: \(url)")
        print("📤 Headers: \(headers)")

        AF.request(
            url,
            method: .get,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in

            // 📩 Print HTTP response status code
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            // 🧾 Print raw response
            if let data = response.data,
               let raw = String(data: data, encoding: .utf8) {
                print("📥 Raw Response: \(raw)")
            }

            // 🧠 Parse JSON → CurrencyResponse using ObjectMapper
            switch response.result {
            case .success(let json):
                if let model: CurrencyResponse = Mapper<CurrencyResponse>().map(JSONObject: json) {
                    print("✅ Parsed Response Object: \(model)")
                    completion(model)
                } else {
                    print("❌ Mapping failed — unexpected JSON structure.")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

    // MARK: - Duration List API
    func getDurationDetails(completion: @escaping (DurationResponse?) -> Void) {
        let url = global.shared.URL_DURATION_DETAILS

        // 🌐 Log Request Info
        print("🌐 URL: \(url)")
        print("📤 Headers: \(headers)")

        AF.request(
            url,
            method: .get,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in

            // 📩 Print HTTP response status code
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            // 🧾 Print raw response for debugging
            if let data = response.data,
               let raw = String(data: data, encoding: .utf8) {
                print("📥 Raw Response: \(raw)")
            }

            // 🧠 Parse JSON → DurationResponse using ObjectMapper
            switch response.result {
            case .success(let json):
                if let model: DurationResponse = Mapper<DurationResponse>().map(JSONObject: json) {
                    print("✅ Parsed Response Object: \(model)")
                    completion(model)
                } else {
                    print("❌ Mapping failed — unexpected JSON structure.")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

    // MARK: - Main Category Get API
    func getSelectMainCategory(completion: @escaping (ServicesModel?) -> Void) {
        let id = LocalData.userId
        let url = "\(global.shared.URL_SELECT_MAINCATEGORY)\(id)"

        // 🌐 Log Request Info
        print("🌐 URL: \(url)")
        print("📤 Headers: \(headers)")

        AF.request(
            url,
            method: .get,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in

            // 📩 Print HTTP response status code
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            // 🧾 Print raw response for debugging
            if let data = response.data,
               let raw = String(data: data, encoding: .utf8) {
                print("📥 Raw Response: \(raw)")
            }

            // 🧠 Parse JSON → ServicesModel using ObjectMapper
            switch response.result {
            case .success(let json):
                if let model: ServicesModel = Mapper<ServicesModel>().map(JSONObject: json) {
                    print("✅ Parsed Response Object: \(model)")
                    completion(model)
                } else {
                    print("❌ Mapping failed — unexpected JSON structure.")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

    // MARK: - Get Salon Time
    func fetchTiming1(completion: @escaping (String) -> Void) {
        let url = "\(global.shared.URL_GET_TIMING)/\(LocalData.userId)"

        print("🌐 URL: \(url)")
        print("📤 Headers: \(headers)")

        AF.request(
            url,
            method: .get,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in
            // 📩 Print HTTP response status code
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            // 🧾 Print raw response
            if let data = response.data,
               let rawJSON = String(data: data, encoding: .utf8) {
                print("📥 Raw Response:\n\(rawJSON)")
            }

            switch response.result {
            case .success(let json):
                // 🧠 Parse JSON → TimingModel using ObjectMapper
                if let model: TimingModel = Mapper<TimingModel>().map(JSONObject: json) {
                    if let firstVendor = model.data.first,
                       let workingHours = firstVendor.working_hours {
                        completion(workingHours)
                    } else {
                        print("⚠️ No working hours found in response.")
                        completion("")
                    }
                } else {
                    print("❌ Mapping failed — unexpected JSON structure.")
                    completion("")
                }

            case .failure(let error):
                print("❌ API Call Failed: \(error.localizedDescription)")
                if let data = response.data,
                   let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }
                completion("")
            }
        }
    }

    // MARK: - Get Holidays
    func getHolidays(completion: @escaping (String) -> Void) {
        let url = "\(global.shared.URL_GET_HOLIDAYS)/\(LocalData.userId)"

        print("🌐 URL: \(url)")
        print("📤 Headers: \(headers)")

        AF.request(
            url,
            method: .get,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in
            // 📩 Print HTTP response status code
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            // 🧾 Print raw response
            if let data = response.data,
               let rawJSON = String(data: data, encoding: .utf8) {
                print("📥 Raw Response:\n\(rawJSON)")
            }

            switch response.result {
            case .success(let json):
                // 🧠 Parse JSON → GetSalonHolidaysModel using ObjectMapper
                if let model: GetSalonHolidaysModel = Mapper<GetSalonHolidaysModel>().map(JSONObject: json) {
                    if let firstVendor = model.data.first {
                        completion(firstVendor.holidayDates)
                    } else {
                        print("⚠️ No holiday data found.")
                        completion("")
                    }
                } else {
                    print("❌ Mapping failed — unexpected JSON structure.")
                    completion("")
                }

            case .failure(let error):
                print("❌ API Call Failed: \(error.localizedDescription)")
                if let data = response.data,
                   let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }
                completion("")
            }
        }
    }

    // MARK: - Get Staff Holidays
    func getStaffHoliday(staffId: String, completion: @escaping (String?) -> Void) {
        let url = global.shared.URL_STAFF_HOLIDAYS

        let params: [String: Any] = [
            "staff_id": staffId
        ]

        // 🌐 Log Request Info
        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")

        AF.request(
            url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in

            // 📩 Print HTTP response status code
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            // 🧾 Print raw response for debugging
            if let data = response.data,
               let raw = String(data: data, encoding: .utf8) {
                print("📥 Raw Response: \(raw)")
            }

            switch response.result {
            case .success(let json):
                // 🧠 Parse JSON → GetSalonHolidaysModel using ObjectMapper
                if let model: GetSalonHolidaysModel = Mapper<GetSalonHolidaysModel>().map(JSONObject: json) {
                    if let firstVendor = model.data.first {
                        completion(firstVendor.holidayDates)
                    } else {
                        print("⚠️ No holiday data found for this staff.")
                        completion("")
                    }
                } else {
                    print("❌ Mapping failed — unexpected JSON structure.")
                    completion("")
                }

            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                if let data = response.data,
                   let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }
                completion(nil)
            }
        }
    }

    
    // MARK: - Update Staff Holiday
    func updateStaffHoliday(
        holidayDates: String,
        staffId: String,
        completion: @escaping (CommonResponse?) -> Void
    ) {
        let url = global.shared.URL_UPDATE_STAFFHOLIDAYS

        let params: [String: Any] = [
            "holiday_dates": holidayDates,
            "staff_id": staffId
        ]

        // 🌐 Log Request Info
        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")

        AF.request(
            url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in

            // 📩 Print HTTP response status code
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            // 🧾 Print raw response
            if let data = response.data,
               let raw = String(data: data, encoding: .utf8) {
                print("📥 Raw Response: \(raw)")
            }

            // 🧠 Parse JSON → CommonResponses using ObjectMapper
            switch response.result {
            case .success(let json):
                if let model: CommonResponse = Mapper<CommonResponse>().map(JSONObject: json) {
                    print("✅ Parsed Response Object: \(model)")
                    completion(model)
                } else {
                    print("❌ Mapping failed — unexpected JSON structure.")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                if let data = response.data,
                   let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }
                completion(nil)
            }
        }
    }

    
    // MARK: - Get Staff Shift
    func getStaffShift(staffId: String = "", completion: @escaping (StaffScheduleResponse?) -> Void) {
        let url = global.shared.URL_STAFF_SHIFTS

        let params: [String: Any] = [
            "staff_id": staffId
        ]

        // 🌐 Log Request Info
        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")

        AF.request(
            url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in

            // 📩 HTTP Status Code
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            // 🧾 Raw Response
            if let data = response.data,
               let raw = String(data: data, encoding: .utf8) {
                print("📥 Raw Response: \(raw)")
            }

            // 🧠 Parse JSON → StaffScheduleResponse using ObjectMapper
            switch response.result {
            case .success(let json):
                if let model: StaffScheduleResponse = Mapper<StaffScheduleResponse>().map(JSONObject: json) {
                    print("✅ Parsed Response Object: \(model)")
                    completion(model)
                } else {
                    print("❌ Mapping failed — unexpected JSON structure.")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                if let data = response.data,
                   let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }
                completion(nil)
            }
        }
    }

    
    // MARK: - Update Staff Shift
    func updateStaffShift(
        staffShift: String,
        deleteShift: String,
        completion: @escaping (CommonResponse?) -> Void
    ) {
        let url = global.shared.URL_UPDATE_SHIFTS

        let params: [String: Any] = [
            "staff_shift": staffShift,
            "delete_shifts": deleteShift
        ]

        // 🌐 Log Request Info
        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")

        AF.request(
            url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in

            // 📩 Print HTTP response status code
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            // 🧾 Print raw JSON response
            if let data = response.data,
               let raw = String(data: data, encoding: .utf8) {
                print("📥 Raw Response: \(raw)")
            }

            // 🧠 Parse JSON → CommonResponses using ObjectMapper
            switch response.result {
            case .success(let json):
                if let model: CommonResponse = Mapper<CommonResponse>().map(JSONObject: json) {
                    print("✅ Parsed Response Object: \(model)")
                    completion(model)
                } else {
                    print("❌ Mapping failed — unexpected JSON structure.")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                if let data = response.data,
                   let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }
                completion(nil)
            }
        }
    }

    // MARK: - Update Service Sequence
    func updateServiceSequence(serviceSequence: String, completion: @escaping (CommonResponse?) -> Void) {
        let url = global.shared.URL_UPDATE_SERVICE_SEQUENCE
        
        let params: [String: Any] = [
            "service_sequence": serviceSequence
        ]
        
        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                // ✅ Log status code
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }
                
                // 🧾 Log raw response body
                if let data = response.data,
                   let raw = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(raw)")
                }
                
                switch response.result {
                case .success(let json):
                    // 🧠 Parse response using ObjectMapper
                    if let model = Mapper<CommonResponse>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Mapping failed — unexpected JSON structure.")
                        completion(nil)
                    }
                    
                case .failure(let error):
                    print("❌ API Call Failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let responseStr = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(responseStr)")
                    }
                    completion(nil)
                }
            }
    }

    
    // MARK: - Salon Data
    func getAllSalonData(completion: @escaping (GetAllSalonModel?) -> Void) {
        let url = global.shared.URL_GET_ALL_SALONS
        
        var params: [String: Any] = [
            "vendor_id": LocalData.salonId,
        ]
        
        if LocalData.salonId == "0" {
            params["vendor_id"] = LocalData.userId
        }
        
        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                // 📩 Print HTTP status
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }
                
                // 🧾 Log Raw JSON Response
                if let data = response.data,
                   let raw = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(raw)")
                }
                
                switch response.result {
                case .success(let json):
                    // 🧠 Map using ObjectMapper
                    if let model = Mapper<GetAllSalonModel>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Mapping failed — unexpected JSON structure.")
                        completion(nil)
                    }
                    
                case .failure(let error):
                    print("❌ API Call Failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let rawResponse = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(rawResponse)")
                    }
                    completion(nil)
                }
            }
    }

    
    func updateSalonData(salonId: String, completion: @escaping (SalonDataModel?) -> Void) {
        let url = global.shared.URL_SALON_DATA + "\(salonId)"

        print("🌐 URL: \(url)")
        print("📤 Headers: \(headers)")

        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                // 📩 Log HTTP status
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 🧾 Log raw response body
                if let data = response.data,
                   let raw = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(raw)")
                }

                switch response.result {
                case .success(let json):
                    // 🧠 Decode using ObjectMapper
                    if let model = Mapper<SalonDataModel>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Mapping failed — unexpected JSON structure.")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Call Failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let rawResponse = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(rawResponse)")
                    }
                    completion(nil)
                }
            }
    }

    
    // MARK: - Notification Data
    func getNotificationList(page: String, limit: String, completion: @escaping (GetActivitiesModel?) -> Void) {
        let url = global.shared.URL_GET_ACTIVITIES

        let params: [String: Any] = [
            "vendor_id": LocalData.userId,
            "limit": limit,
            "page": page
        ]

        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                // Log HTTP response info
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // Log raw response
                if let data = response.data,
                   let rawString = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(rawString)")
                }

                switch response.result {
                case .success(let json):
                    // Decode using ObjectMapper
                    if let model = Mapper<GetActivitiesModel>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Mapping failed — unexpected JSON format")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    if let data = response.data,
                       let responseStr = String(data: data, encoding: .utf8) {
                        print("📦 Error Response: \(responseStr)")
                    }
                    completion(nil)
                }
            }
    }

    
    func updateActivity(completion: @escaping (CommonResponse?) -> Void) {
        let url = global.shared.URL_UPDATE_ACTIVITIES

        let params: [String: Any] = [
            "vendor_id": LocalData.userId
        ]

        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                // 📩 Print HTTP response status code
        
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 📦 Raw JSON
                if let data = response.data, let rawJSON = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(rawJSON)")
                }

                // 5️⃣ Handle Result
                switch response.result {
                case .success(let json):
                    if let model = Mapper<CommonResponse>().map(JSONObject: json) {
                        print("✅ Parsed Response: \(model)")
                        completion(model)
                    } else {
                        print("❌ Failed to map response JSON to CommonResponse")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    if let data = response.data,
                       let raw = String(data: data, encoding: .utf8) {
                        print("📦 Error Body: \(raw)")
                    }
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

    // MARK: - AJAY
    func fetchSalonCurrency(completion: @escaping (CurrencyModel?) -> Void) {
        let url = global.shared.URL_CURRENCY_DETAILS

        print("🌐 URL: \(url)")
        print("📤 Headers: \(headers)")

        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                // 📩 Print status code
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 📦 Print raw JSON for debugging
                if let data = response.data,
                   let rawResponse = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(rawResponse)")
                }

                switch response.result {
                case .success(let json):
                    if let model = Mapper<CurrencyModel>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Failed to map JSON → CurrencyModel")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Call Failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let errMsg = String(data: data, encoding: .utf8) {
                        print("📦 Error Response: \(errMsg)")
                    }
                    completion(nil)
                }
            }
    }

    
    func getCurrencyA(completion: @escaping (CurrencyModel?) -> Void) {
        let url = global.shared.URL_GET_CURRENCY1 + "/\(LocalData.userId)"
        
        print("🌐 URL: \(url)")
        print("📤 Headers: \(headers)")
        
        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                // 📩 Status code log
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }
                
                // 🧾 Raw JSON response
                if let data = response.data,
                   let rawResponse = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(rawResponse)")
                }
                
                switch response.result {
                case .success(let json):
                    if let model = Mapper<CurrencyModel>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Failed to map JSON → CurrencyModel")
                        completion(nil)
                    }
                    
                case .failure(let error):
                    print("❌ API Call Failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let errMsg = String(data: data, encoding: .utf8) {
                        print("📦 Error Response: \(errMsg)")
                    }
                    completion(nil)
                }
            }
    }

    
    func UpdateCurrency(currency: String, symbol: String, vendorId: String, completion: @escaping (CurrencyResponseA?) -> Void) {
        let url = global.shared.URL_UPDATE_CURRENCY
        
        let params: [String: Any] = [
            "currency": currency,
            "symbol": symbol,
            "vendor_id": vendorId
        ]
        
        // 🌐 Log request details
        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(self.headers)")
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                // 📩 Log status code
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }
                
                // 🧾 Log raw response
                if let data = response.data,
                   let rawResponse = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(rawResponse)")
                }
                
                // 🧠 Handle JSON parsing
                switch response.result {
                case .success(let json):
                    if let model = Mapper<CurrencyResponseA>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Failed to map JSON → CurrencyResponseA")
                        completion(nil)
                    }
                    
                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    if let data = response.data,
                       let errMsg = String(data: data, encoding: .utf8) {
                        print("📦 Error Response: \(errMsg)")
                    }
                    completion(nil)
                }
            }
    }

    
    func UpdateBookingFlow(booking_flow: Int, vendorId: String, completion: @escaping (CurrencyResponseA?) -> Void) {
        let url = global.shared.URL_UPDATE_BOOKINGFLOW
        
        let params: [String: Any] = [
            "booking_flow": booking_flow,
            "vendor_id": vendorId
        ]

        // 🌐 Log request info
        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(self.headers)")

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                // 📩 Log HTTP response
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 🧾 Raw response
                if let data = response.data,
                   let rawResponse = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(rawResponse)")
                }

                // 🧠 Handle response
                switch response.result {
                case .success(let json):
                    if let model = Mapper<CurrencyResponseA>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Failed to map JSON → CurrencyResponseA")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    if let data = response.data,
                       let errMsg = String(data: data, encoding: .utf8) {
                        print("📦 Error Response: \(errMsg)")
                    }
                    completion(nil)
                }
            }
    }

    
    func fetchBookingFlow(completion: @escaping (BookingFlow?) -> Void) {
        let url = global.shared.URL_GET_BOOKINGFLOW + "/\(LocalData.userId)"

        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                // 🌐 Log request info
                print("🌐 URL: \(url)")
                print("📤 Headers: \(self.headers)")
                
                // 📩 Log HTTP status code
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 🧾 Log raw JSON response
                if let data = response.data,
                   let rawJSON = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(rawJSON)")
                }

                // 🧠 Handle result
                switch response.result {
                case .success(let json):
                    if let model = Mapper<BookingFlow>().map(JSONObject: json) {
                        print("✅ Parsed BookingFlow Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Mapping failed — unexpected JSON structure.")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Call Failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let errorMsg = String(data: data, encoding: .utf8) {
                        print("📦 Error Response: \(errorMsg)")
                    }
                    completion(nil)
                }
            }
    }

    
    func UpdateBankDetails(
        accountNumber: String,
        accountHolderName: String,
        completion: @escaping (CurrencyResponseA?) -> Void
    ) {
        let url = global.shared.URL_UPDATE_BANKDETAILS + "/\(LocalData.userId)"
        
        // 🏦 Prepare bank details dictionary
        let bankDetails: [String: String] = [
            "account number": accountNumber,
            "account holder name": accountHolderName
        ]
        
        // 🧾 Convert to JSON string
        var bankDetailsJSONString = ""
        if let data = try? JSONSerialization.data(withJSONObject: bankDetails, options: []),
           let jsonString = String(data: data, encoding: .utf8) {
            bankDetailsJSONString = jsonString
            print("✅ Bank_Parameters JSON: \(jsonString)")
        } else {
            print("❌ Failed to encode bank details to JSON string")
        }

        // 📦 Final parameters
        let params: [String: Any] = [
            "bank_details": bankDetailsJSONString
        ]

        // 🌐 API Request
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                // 📬 Log request info
                print("🌐 URL: \(url)")
                print("📤 Parameters: \(params)")
                print("📤 Headers: \(self.headers)")
                
                // 📩 HTTP Status
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }
                
                // 🧾 Raw Response
                if let data = response.data,
                   let rawResponse = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(rawResponse)")
                }

                // 🧠 Handle Response
                switch response.result {
                case .success(let json):
                    if let model = Mapper<CurrencyResponseA>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ JSON Mapping Failed — Unexpected structure.")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    if let data = response.data,
                       let errorStr = String(data: data, encoding: .utf8) {
                        print("📦 Error Body: \(errorStr)")
                    }
                    completion(nil)
                }
            }
    }


    func fetchBankDetails(completion: @escaping (BankDetailsResponse?) -> Void) {
        let url = global.shared.URL_GET_BANKDETAILS + "/\(LocalData.userId)"
        
        print("🌐 URL: \(url)")
        print("📤 Headers: \(headers)")

        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                // 📩 Log HTTP Status
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 🧾 Log Raw JSON Response
                if let data = response.data,
                   let rawResponse = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(rawResponse)")
                }

                // 🧠 Handle Result
                switch response.result {
                case .success(let json):
                    if let model = Mapper<BankDetailsResponse>().map(JSONObject: json) {
                        print("✅ Parsed BankDetailsResponse: \(model)")
                        completion(model)
                    } else {
                        print("❌ JSON Mapping Failed — Unexpected structure.")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Call Failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let raw = String(data: data, encoding: .utf8) {
                        print("📦 Error Response: \(raw)")
                    }
                    completion(nil)
                }
            }
    }

    
    func fetchNotes(completion: @escaping (NotesModel?) -> Void) {
        let url = global.shared.URL_GET_NOTES + "/\(LocalData.userId)"

        print("🌐 URL: \(url)")
        print("📤 Headers: \(headers)")

        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                // 📩 Log HTTP Status
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 🧾 Log Raw JSON Response
                if let data = response.data,
                   let rawResponse = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(rawResponse)")
                }

                switch response.result {
                case .success(let json):
                    // 🧠 Parse JSON using ObjectMapper
                    if let model = Mapper<NotesModel>().map(JSONObject: json) {
                        print("✅ Parsed NotesModel: \(model)")
                        completion(model)
                    } else {
                        print("❌ JSON Mapping Failed — Unexpected structure.")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Request Failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let raw = String(data: data, encoding: .utf8) {
                        print("📦 Error Response: \(raw)")
                    }
                    completion(nil)
                }
            }
    }

    
    func UpdateNotes(vendorId: String, notes: String, completion: @escaping (CurrencyResponseA?) -> Void) {
        let url = global.shared.URL_UPDATE_NOTES

        let params: [String: Any] = [
            "vendor_id": vendorId,
            "notes": notes
        ]

        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                // 📩 HTTP Status Code
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 🧾 Raw Response
                if let data = response.data,
                   let raw = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(raw)")
                }

                switch response.result {
                case .success(let json):
                    // 🧠 Map JSON to Model
                    if let model = Mapper<CurrencyResponseA>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ JSON Mapping Failed — Invalid structure.")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ Request Failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let raw = String(data: data, encoding: .utf8) {
                        print("📦 Error Response: \(raw)")
                    }
                    completion(nil)
                }
            }
    }


    func fetchAmount(completion: @escaping (AmountModel?) -> Void) {
        let url = global.shared.URL_GET_Amount + "/\(LocalData.userId)"

        print("🌐 URL: \(url)")
        print("📤 Headers: \(headers)")

        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                // 📩 Log HTTP response
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 🧾 Log raw JSON string
                if let data = response.data,
                   let raw = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(raw)")
                }

                // 🔍 Handle result
                switch response.result {
                case .success(let json):
                    // Map using ObjectMapper
                    if let model = Mapper<AmountModel>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ JSON Mapping Failed — Invalid structure.")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Call Failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let raw = String(data: data, encoding: .utf8) {
                        print("📦 Error Response: \(raw)")
                    }
                    completion(nil)
                }
            }
    }

    
    func UpdateAmount(
        vendorId: String,
        amount: String,
        penaltyFees: String,
        penaltyDuration: String,
        cancellationPolicy: String,
        completion: @escaping (CurrencyResponseA?) -> Void
    ) {
        let url = global.shared.URL_UPDATE_Amount

        let params: [String: Any] = [
            "vendor_id": vendorId,
            "amount": amount,
            "penalty_fees": penaltyFees,
            "penalty_duration": penaltyDuration,
            "cancellation_policy": cancellationPolicy
        ]

        // 🌐 Log request info
        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                // 📩 Status code
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 🧾 Raw response body
                if let data = response.data,
                   let raw = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(raw)")
                }

                switch response.result {
                case .success(let json):
                    // 🧠 Map JSON manually using ObjectMapper
                    if let model = Mapper<CurrencyResponseA>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ JSON mapping failed for CurrencyResponseA")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ Request Failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let raw = String(data: data, encoding: .utf8) {
                        print("📦 Error Response: \(raw)")
                    }
                    completion(nil)
                }
            }
    }

    
    func fetchTeamDetails(vendorId: String, completion: @escaping (TeamModel?) -> Void) {
        let url = global.shared.URL_Team_Details

        let params: [String: Any] = [
            "vendor_id": vendorId,
            "search": "",
            "limit": "10000"
        ]

        // 🌐 Log request info
        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                // 📩 HTTP status code
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 🧾 Raw response data
                if let data = response.data,
                   let rawResponse = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(rawResponse)")
                }

                switch response.result {
                case .success(let json):
                    // 🧠 Parse JSON manually with ObjectMapper
                    if let model = Mapper<TeamModel>().map(JSONObject: json) {
                        print("✅ Parsed TeamModel: \(model)")
                        completion(model)
                    } else {
                        print("❌ JSON Mapping failed for TeamModel")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Request Failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let raw = String(data: data, encoding: .utf8) {
                        print("📦 Error Response: \(raw)")
                    }
                    completion(nil)
                }
            }
    }

    
    func fetchStaffsequence(vendorId: String, completion: @escaping (GetStaffSequenceModel?) -> Void) {
        let url = global.shared.URL_GET_STAFFSEQUENCE

        let params: [String: Any] = [
            "vendor_id": vendorId
        ]

        // 🌐 Request log
        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                // 📩 HTTP Status
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 🧾 Raw JSON
                if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(raw)")
                }

                switch response.result {
                case .success(let json):
                    // 🧠 Manual ObjectMapper mapping
                    if let model = Mapper<GetStaffSequenceModel>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Failed to map JSON to GetStaffSequenceModel")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    if let data = response.data,
                       let errorMsg = String(data: data, encoding: .utf8) {
                        print("📦 Error Body: \(errorMsg)")
                    }
                    completion(nil)
                }
            }
    }

    
    func updateStaffSequence(
        staffSequenceList: [[String: String]],
        calendar_sequence: [[String: Any]],
        vendorid: String,
        completion: @escaping (CurrencyResponseA?) -> Void
    ) {
        let url = global.shared.URL_UPDATE_STAFFSEQUENCE

        // Convert to JSON string - staff sequence
        var staffSequenceJSONString = ""
        if let data = try? JSONSerialization.data(withJSONObject: staffSequenceList, options: []),
           let jsonString = String(data: data, encoding: .utf8) {
            staffSequenceJSONString = jsonString
            print("✅ staff_sequence JSON: \(jsonString)")
        } else {
            print("❌ Failed to convert staff sequence to JSON string")
        }

        // Convert to JSON string - calendar sequence
        var calendarSequenceJSONString = ""
        if let data = try? JSONSerialization.data(withJSONObject: calendar_sequence, options: []),
           let jsonString = String(data: data, encoding: .utf8) {
            calendarSequenceJSONString = jsonString
            print("✅ calendar_sequence JSON: \(jsonString)")
        } else {
            print("❌ Failed to convert calendar sequence to JSON string")
        }

        // Final parameters
        let params: [String: Any] = [
            "calendar_sequence": calendarSequenceJSONString,
            "staff_sequence": staffSequenceJSONString,
            "vendor_id": vendorid
        ]

        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")

        // API Call using responseJSON
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                // 📩 HTTP status
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 🧾 Raw response
                if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(raw)")
                }

                switch response.result {
                case .success(let json):
                    // 🧠 Map JSON manually with ObjectMapper
                    if let model = Mapper<CurrencyResponseA>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Failed to map JSON to CurrencyResponseA")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    if let data = response.data, let rawError = String(data: data, encoding: .utf8) {
                        print("📦 Error Body: \(rawError)")
                    }
                    completion(nil)
                }
            }
    }


    func updateTimeGap(vendorId: String, time_gap: String, completion: @escaping (CommonModel?) -> Void) {
        let url = global.shared.URL_UPDATE_TIMEGAP

        let params: [String: Any] = [
            "vendor_id": vendorId,
            "time_gap": time_gap
        ]

        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                // 📩 Log status code
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 🧾 Print raw response
                if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(raw)")
                }

                switch response.result {
                case .success(let json):
                    // 🧠 Map JSON → CommonModel
                    if let model = Mapper<CommonModel>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ JSON mapping failed")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ Error: \(error.localizedDescription)")
                    if let data = response.data, let errorStr = String(data: data, encoding: .utf8) {
                        print("📦 Error Body: \(errorStr)")
                    }
                    completion(nil)
                }
            }
    }

 
    func ChangePassword(vendorId: String, new_pass: String, old_pass: String, completion: @escaping (CommonModel?) -> Void) {
        let url = global.shared.URL_CHANGE_PASSWORD

        // Prepare parameters
        let params: [String: Any] = [
            "vendor_id": vendorId,
            "new_pass": new_pass,
            "old_pass": old_pass
        ]

        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                // 📩 Log HTTP status
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 🧾 Print raw JSON for debugging
                if let data = response.data,
                   let raw = String(data: data, encoding: .utf8) {
                    print("📥 Raw Response: \(raw)")
                }

                switch response.result {
                case .success(let json):
                    // 🧠 Parse JSON → CommonModel
                    if let model = Mapper<CommonModel>().map(JSONObject: json) {
                        print("✅ Password change success response parsed")
                        completion(model)
                    } else {
                        print("❌ JSON parsing to CommonModel failed")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    if let data = response.data,
                       let errorStr = String(data: data, encoding: .utf8) {
                        print("📦 Error Response: \(errorStr)")
                    }
                    completion(nil)
                }
            }
    }

    
    func fetchProfileImage(completion: @escaping (ProfileModel?) -> Void) {
        let url = global.shared.URL_GET_IMAGE + "/\(LocalData.userId)"
        
        print("🌐 URL: \(url)")
        print("📤 Headers: \(headers)")
        
        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                // 📩 Log HTTP status
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 🧾 Log raw JSON response
                if let data = response.data,
                   let raw = String(data: data, encoding: .utf8) {
                    print("📥 Raw Response:\n\(raw)")
                }

                switch response.result {
                case .success(let json):
                    // 🧠 Try to map JSON → ProfileModel
                    if let model = Mapper<ProfileModel>().map(JSONObject: json) {
                        print("✅ Parsed Profile Model Successfully")
                        completion(model)
                    } else {
                        print("❌ Failed to map JSON to ProfileModel")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Call Failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let errorResponse = String(data: data, encoding: .utf8) {
                        print("📦 Error Response: \(errorResponse)")
                    }
                    completion(nil)
                }
            }
    }

    
    func uploadSalonImages(
        photo: UIImage?,              // main profile photo
        otherPhotos: [String],        // filenames of old gallery images to retain
        photos: [UIImage],            // one OR more new gallery images
        completion: @escaping (CurrencyResponse?) -> Void
    ) {
        let url = global.shared.URL_ADD_IMAGE + "/\(LocalData.userId)"
        print("📤 Uploading to: \(url)")

        AF.upload(multipartFormData: { multipartFormData in

            // ✅ 1. Main profile photo
            if let profileImage = photo,
               let imageData = profileImage.jpegData(compressionQuality: 0.7) {
                multipartFormData.append(imageData, withName: "photo", fileName: "main_photo.jpg", mimeType: "image/jpeg")
                print("✅ photo: main_photo.jpg")
            }

            // ✅ 2. One or more photos under same field name "photos"
            if photos.isEmpty {
                print("⚠️ No gallery photos to upload.")
            } else {
                for (index, image) in photos.enumerated() {
                    if let imageData = image.jpegData(compressionQuality: 0.7) {
                        let timestamp = Int(Date().timeIntervalSince1970)
                        let fileName = "gallery_\(index)_\(timestamp).jpg"
                        multipartFormData.append(imageData, withName: "photos", fileName: fileName, mimeType: "image/jpeg")
                        print("✅ photos: \(fileName)")
                    }
                }
            }

            // ✅ 3. other_photos as JSON string (filenames to retain)
            if !otherPhotos.isEmpty,
               let jsonData = try? JSONSerialization.data(withJSONObject: otherPhotos, options: []),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                multipartFormData.append(Data(jsonString.utf8), withName: "other_photos")
                print("✅ other_photos: \(jsonString)")
            }

        }, to: url, method: .post, headers: HTTPHeaders(headers))
        .responseJSON { response in
            if let status = response.response?.statusCode {
                print("📶 Status Code: \(status)")
            }

            switch response.result {
            case .success(let json):
                print("🎉 Upload Success: \(json)")
                let mapped = Mapper<CurrencyResponse>().map(JSONObject: json)
                completion(mapped)
            case .failure(let error):
                print("❌ Upload Failed: \(error.localizedDescription)")
                if let data = response.data, let errorMsg = String(data: data, encoding: .utf8) {
                    print("📦 Server says: \(errorMsg)")
                }
                completion(nil)
            }
        }
    }

    func OrdersPhotos(
        apiurl: String,
        param: [String: Any],
        file: [UIImage],
        method: HTTPMethod = .post,
        completionHandler: @escaping (Bool, NSDictionary?) -> Void
    ) {
        // 🌐 Log API call
        print("📤 API URL:", apiurl)
        print("📦 Parameters:", param)
        
        // 🌐 Check Network Reachability
        guard NetworkReachabilityManager()?.isReachable == true else {
            print("❌ No Internet Connection")
            completionHandler(false, nil)
            return
        }
        
        // 🧩 Start Upload
        AF.upload(
            multipartFormData: { multipartFormData in
                // Append images
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
                
                for (index, image) in file.enumerated() {
                    if let imageData = image.jpegData(compressionQuality: 0.8) {
                        let timestamp = dateFormatter.string(from: Date())
                        let fileName = "photo_\(timestamp)_\(index).jpg"
                        multipartFormData.append(
                            imageData,
                            withName: "photos[]",
                            fileName: fileName,
                            mimeType: "image/jpeg"
                        )
                    }
                }
                
                // Append text parameters
                for (key, value) in param {
                    let stringValue = "\(value)"
                    if let data = stringValue.data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            },
            to: apiurl,
            method: method,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    if let jsonObj = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                        print("✅ Upload Success:", jsonObj)
                        completionHandler(true, jsonObj as NSDictionary)
                    } else {
                        print("⚠️ Unable to parse JSON")
                        completionHandler(false, nil)
                    }
                } catch {
                    print("❌ JSON Parsing Error:", error.localizedDescription)
                    completionHandler(false, nil)
                }
                
            case .failure(let error):
                print("❌ Upload Failed:", error.localizedDescription)
                if let data = response.data,
                   let errorStr = String(data: data, encoding: .utf8) {
                    print("📦 Server Error Response:", errorStr)
                }
                completionHandler(false, nil)
            }
        }
    }

    
    func UpdateReminderMail(reminder_mail: String, vendorId: String, completion: @escaping (CurrencyResponseA?) -> Void) {
        let url = global.shared.URL_UPDATE_REMINDERMAIL

        let params: [String: Any] = [
            "reminder_mail": reminder_mail,
            "vendor_id": vendorId
        ]

        // 🌐 Log request info
        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                // 📩 HTTP Status
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 📦 Raw Response
                if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }

                switch response.result {
                case .success(let json):
                    // 🧠 Map JSON → CurrencyResponseA
                    if let model = Mapper<CurrencyResponseA>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Mapping failed — unexpected JSON structure.")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ Error: \(error.localizedDescription)")
                    if let data = response.data,
                       let errorBody = String(data: data, encoding: .utf8) {
                        print("📦 Error Body: \(errorBody)")
                    }
                    completion(nil)
                }
            }
    }

    
    func UpdateSelectServices(service_id: String, vendorId: String, completion: @escaping (SelectedService?) -> Void) {
        let url = global.shared.URL_SELECT_SERVICES

        let params: [String: Any] = [
            "service_id": service_id,
            "vendor_id": vendorId
        ]

        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")

        AF.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                // 📩 Print status code
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 📦 Print raw response
                if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }

                switch response.result {
                case .success(let json):
                    if let model = Mapper<SelectedService>().map(JSONObject: json) {
                        print("✅ Parsed SelectedService: \(model)")
                        completion(model)
                    } else {
                        print("❌ Failed to map JSON to SelectedService")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    if let data = response.data,
                       let errorBody = String(data: data, encoding: .utf8) {
                        print("📦 Error Body: \(errorBody)")
                    }
                    completion(nil)
                }
            }
    }

    
    func fetchCategory(completion: @escaping (CategoryModel?) -> Void) {
        let url = global.shared.URL_SELECT_MAINCATEGORY1 + "/\(LocalData.userId)"

        print("🌐 URL: \(url)")
        print("📤 Headers: \(headers)")

        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                // 🧾 Log status
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 🧩 Log raw response
                if let data = response.data,
                   let raw = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response:\n\(raw)")
                }

                switch response.result {
                case .success(let json):
                    // 🧠 Parse JSON → CategoryModel using ObjectMapper
                    if let model = Mapper<CategoryModel>().map(JSONObject: json) {
                        print("✅ Parsed CategoryModel Successfully")
                        completion(model)
                    } else {
                        print("❌ Failed to map JSON → CategoryModel")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Call Failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let raw = String(data: data, encoding: .utf8) {
                        print("📦 Error Response:\n\(raw)")
                    }
                    completion(nil)
                }
            }
    }

    
    // MARK: - Fetch Category Description
    func fetchCategoryDescription(completion: @escaping (CategoryStaffSequenceModel?) -> Void) {
        let url = "\(global.shared.URL_CATEGORY_DESCRIPTION)/\(LocalData.userId)"

        // 🌐 Debug info
        print("🌐 URL: \(url)")
        print("📤 Headers: \(headers)")

        AF.request(
            url,
            method: .post,
            parameters: [:],
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in
            // ✅ Log status
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            // 📥 Log raw response
            if let data = response.data,
               let rawResponse = String(data: data, encoding: .utf8) {
                print("📦 Raw Response:\n\(rawResponse)")
            }

            switch response.result {
            case .success(let json):
                if let model = Mapper<CategoryStaffSequenceModel>().map(JSONObject: json) {
                    print("✅ Parsed CategoryStaffSequenceModel: \(model)")
                    completion(model)
                } else {
                    print("❌ JSON mapping failed — unexpected response format.")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ API Request Failed: \(error.localizedDescription)")
                if let data = response.data,
                   let errorBody = String(data: data, encoding: .utf8) {
                    print("📦 Error Response: \(errorBody)")
                }
                completion(nil)
            }
        }
    }


    func updateCategoryDescription(
        category_description: [[String: String]],
        vendorid: String,
        completion: @escaping (CommonModel?) -> Void
    ) {
        let url = global.shared.URL_UPDATE_CATEGORY_DESCRIPTION

        // Convert array to JSON string
        guard let data = try? JSONSerialization.data(withJSONObject: category_description, options: []),
              let jsonString = String(data: data, encoding: .utf8) else {
            print("❌ Failed to encode category_description array")
            completion(nil)
            return
        }

        print("✅ Encoded category_description JSON: \(jsonString)")

        // Parameters
        let params: [String: Any] = [
            "category_description": jsonString,
            "vendor_id": vendorid
        ]

        // 🌐 Debug info
        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(self.headers)")

        // Perform request
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                switch response.result {
                case .success(let json):
                    if let data = response.data,
                       let rawResponse = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response:\n\(rawResponse)")
                    }

                    // Parse to CommonModel using ObjectMapper
                    if let dict = json as? [String: Any],
                       let model = CommonModel(JSON: dict) {
                        print("✅ Parsed CommonModel: \(model)")
                        completion(model)
                    } else {
                        print("⚠️ JSON mapping failed")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    if let data = response.data,
                       let raw = String(data: data, encoding: .utf8) {
                        print("📦 Raw Error Response:\n\(raw)")
                    }
                    completion(nil)
                }
            }
    }

    
    func fetchKioskUser(completion: @escaping (GetKioskModel?) -> Void) {
        let url = global.shared.URL_GET_KIOSK + "/\(LocalData.userId)"

        print("🌐 URL: \(url)")
        print("📤 Headers: \(self.headers)")

        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                switch response.result {
                case .success(let json):
                    if let data = response.data,
                       let rawResponse = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response:\n\(rawResponse)")
                    }

                    // 🧩 Convert JSON → Model using ObjectMapper
                    if let dict = json as? [String: Any],
                       let model = GetKioskModel(JSON: dict) {
                        print("✅ Parsed Kiosk Data: \(model)")
                        print("✅ Total Records: \(model.data.count)")
                        completion(model)
                    } else {
                        print("⚠️ JSON Parsing Failed — unexpected format")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Call Failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let responseStr = String(data: data, encoding: .utf8) {
                        print("📦 Raw Error Response:\n\(responseStr)")
                    }
                    completion(nil)
                }
            }
    }

    
    func fetchSubvendor(completion: @escaping (GetKioskModel?) -> Void) {
        let url = global.shared.URL_GET_SUBVENDOR + "/\(LocalData.userId)"

        print("🌐 URL: \(url)")
        print("📤 Headers: \(self.headers)")

        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                switch response.result {
                case .success(let json):
                    if let data = response.data,
                       let rawResponse = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(rawResponse)")
                    }

                    // 🧩 Convert JSON → GetKioskModel using ObjectMapper
                    if let dict = json as? [String: Any],
                       let model = GetKioskModel(JSON: dict) {
                        print("✅ Parsed Response Object: \(model)")
                        print("✅ Subvendors Count: \(model.data.count)")
                        completion(model)
                    } else {
                        print("⚠️ JSON Parsing Failed: Unexpected format")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Call Failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let raw = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(raw)")
                    }
                    completion(nil)
                }
            }
    }

    
    func UpdateCreateSubvendor(
        email: String,
        name: String,
        password: String,
        vendorId: String,
        completion: @escaping (CurrencyResponseA?) -> Void
    ) {
        let url = global.shared.URL_UPDATE_SUBVENDOR

        let params: [String: Any] = [
            "email": email,
            "name": name,
            "password": password,
            "vendor_id": vendorId
        ]

        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(self.headers)")

        AF.request(
            url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in
            
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            switch response.result {
            case .success(let json):
                if let data = response.data,
                   let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }

                // 🧩 Convert JSON → ObjectMapper model
                if let dict = json as? [String: Any],
                   let model = CurrencyResponseA(JSON: dict) {
                    print("✅ Parsed Response Object: \(model)")
                    completion(model)
                } else {
                    print("⚠️ JSON Parsing Failed (unexpected structure)")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ API Error: \(error.localizedDescription)")
                if let data = response.data,
                   let raw = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(raw)")
                }
                completion(nil)
            }
        }
    }

    
    func UpdateAddKiosk(email: String, password: String, vendorId: String, completion: @escaping (CurrencyResponseA?) -> Void) {
        let url = global.shared.URL_UPDATE_ADD_KIOSK

        let params: [String: Any] = [
            "email": email,
            "password": password,
            "vendor_id": vendorId
        ]

        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(self.headers)")

        AF.request(
            url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            switch response.result {
            case .success(let json):
                if let data = response.data,
                   let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }

                // 🧩 Parse JSON manually into your model
                if let dict = json as? [String: Any] {
                    let model = CurrencyResponseA(JSON: dict)
                    print("✅ Parsed Response Object: \(String(describing: model))")
                    completion(model)
                } else {
                    print("⚠️ Unexpected JSON format")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ API Error: \(error.localizedDescription)")
                if let data = response.data,
                   let raw = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(raw)")
                }
                completion(nil)
            }
        }
    }

    
    func parseWorkingHours1(_ jsonString: String) -> [WorkingHour1] {
        guard let data = jsonString.data(using: .utf8),
              let array = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
            return []
        }
        return Mapper<WorkingHour1>().mapArray(JSONArray: array)
    }
    
    func fetchTiming(completion: @escaping ([WorkingHour1]) -> Void) {
        let url = "\(global.shared.URL_GET_TIMING)/\(LocalData.userId)"

        print("🌐 URL: \(url)")
        print("📤 Headers: \(headers)")

        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 🧾 Raw Response
                if let data = response.data,
                   let raw = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(raw)")
                }

                switch response.result {
                case .success(let json):
                    // 🧩 Use ObjectMapper to map JSON manually
                    if let mappedModel = Mapper<GetKioskModel1>().map(JSONObject: json) {
                        if let first = mappedModel.data.first {
                            print("✅ Parsed SMS Details: \(first)")
                            if let breakString = first.working_hours {
                                let parsedBreakTimes = self.parseWorkingHours1(breakString)
                                completion(parsedBreakTimes)
                            } else {
                                print("⚠️ No data found in response")
                                completion([])
                            }
                        } else {
                            print("⚠️ No data found in response")
                            completion([])
                        }
                    } else {
                        print("❌ Mapping Failed: Invalid JSON format")
                        completion([])
                    }

                case .failure(let error):
                    print("❌ Failed to fetch SMS Details: \(error.localizedDescription)")
                    if let data = response.data,
                       let responseStr = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(responseStr)")
                    }
                    completion([])
                }
                
            }
    }

    
    func convertWorkingHoursToJSONString(_ workingHours: [WorkingHour1]) -> String? {
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
    
    func UpdateBusinessHours(workingHours: [WorkingHour1], completion: @escaping (Bool) -> Void) {
        let url = global.shared.URL_UPDATE_BUSINESS_TIMING + "/\(LocalData.userId)"

        // 1. Build JSON manually to ensure correct formatting
        var workingHoursArray: [[String: String]] = []

        for wh in workingHours {
            if let day = wh.day, let from = wh.from, let to = wh.to {
                workingHoursArray.append([
                    "day": day,
                    "from": from,
                    "to": to
                ])
            }
        }

        // 2. Convert to JSON data
        guard let data = try? JSONSerialization.data(withJSONObject: workingHoursArray, options: []),
              let jsonArrayString = String(data: data, encoding: .utf8) else {
            print("❌ Failed to encode working_hours array")
            completion(false)
            return
        }

        // 3. Build final parameters
        let params: [String: Any] = [
            "working_hours": jsonArrayString
        ]

        // Debug print
        print("📤 Payload to Send: \(params)")

        // 5. API Call
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding.default, // Use JSONEncoding for JSON payload
                   headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("✅ API Success: \(value)")
                    completion(true)
                case .failure(let error):
                    print("❌ API Error: \(error)")
                    if let data = response.data {
                        print("📦 Error Body:\n\(String(data: data, encoding: .utf8) ?? "")")
                    }
                    completion(false)
                }
            }
    }

    func fetchBreakTime(completion: @escaping ([BreakTime1]) -> Void) {
        let url = "\(global.shared.URL_GET_BREAK_TIME)/\(LocalData.userId)"

        print("🌐 URL: \(url)")
        print("📤 Headers: \(headers)")

        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 🧾 Raw Response
                if let data = response.data,
                   let raw = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(raw)")
                }

                switch response.result {
                case .success(let json):
                    // 🧩 Use ObjectMapper to map JSON manually
                    if let mappedModel = Mapper<GetBreakTimeModel>().map(JSONObject: json) {
                        if let first = mappedModel.data.first {
                            print("✅ Parsed SMS Details: \(first)")
                            if let breakString = first.break_time {
                                let parsedBreakTimes = self.parseBreakTime(from: breakString)
                                completion(parsedBreakTimes)
                            } else {
                                print("⚠️ No data found in response")
                                completion([])
                            }
                        } else {
                            print("⚠️ No data found in response")
                            completion([])
                        }
                    } else {
                        print("❌ Mapping Failed: Invalid JSON format")
                        completion([])
                    }

                case .failure(let error):
                    print("❌ Failed to fetch SMS Details: \(error.localizedDescription)")
                    if let data = response.data,
                       let responseStr = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(responseStr)")
                    }
                    completion([])
                }
            
            }
    }


    func parseBreakTime(from jsonString: String) -> [BreakTime1] {
        if let data = jsonString.data(using: .utf8) {
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    return Mapper<BreakTime1>().mapArray(JSONArray: jsonArray)
                }
            } catch {
                print("❌ BreakTime parsing failed: \(error.localizedDescription)")
            }
        }
        return []
    }

    
    func UpdateBreakTime(breakTimes: [[String: String]], vendorID: String, completion: @escaping (Bool) -> Void) {
        let url = global.shared.URL_UPDATE_BREAK_TIME

        // 1. Convert array to JSON string
        guard let data = try? JSONSerialization.data(withJSONObject: breakTimes, options: []),
              let jsonString = String(data: data, encoding: .utf8) else {
            print("❌ Failed to encode breakTimes array")
            completion(false)
            return
        }

        // 2. Final parameters
        let params: [String: Any] = [
            "vendor_id": vendorID,
            "break_time": jsonString
        ]

        print("📤 Payload to Send: \(params)")

        // 3. Alamofire request
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding.default,
                   headers: HTTPHeaders(headers)) // <-- Add your headers dictionary here
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("✅ BreakTime Update Success: \(value)")
                    completion(true)
                case .failure(let error):
                    print("❌ API Error: \(error)")
                    if let data = response.data {
                        print("📦 Error Body:\n\(String(data: data, encoding: .utf8) ?? "")")
                    }
                    completion(false)
                }
            }
    }

    func fetchSMSDetails(completion: @escaping (SMSDetailsData?) -> Void) {
        let url = "\(global.shared.URL_GET_SMS_DETAILS)/\(LocalData.userId)"

        // 🌐 Log request info
        print("🌐 URL: \(url)")
        print("📤 Headers: \(headers)")

        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 🧾 Raw Response
                if let data = response.data,
                   let raw = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(raw)")
                }

                switch response.result {
                case .success(let json):
                    // 🧩 Use ObjectMapper to map JSON manually
                    if let mappedModel = Mapper<SMSDetailsModel>().map(JSONObject: json) {
                        if let first = mappedModel.data.first {
                            print("✅ Parsed SMS Details: \(first)")
                            completion(first)
                        } else {
                            print("⚠️ No data found in response")
                            completion(nil)
                        }
                    } else {
                        print("❌ Mapping Failed: Invalid JSON format")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ Failed to fetch SMS Details: \(error.localizedDescription)")
                    if let data = response.data,
                       let responseStr = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(responseStr)")
                    }
                    completion(nil)
                }
            }
    }

    
    func updateNotificationSettings(
        vendorId: String,
        reminderTime: String,
        smsSettings: [[String: Int]],
        emailSettings: [[String: Int]],
        emailNotifications: String,
        completion: @escaping (Bool) -> Void
    ) {
        let url = global.shared.URL_UPDATE_SMS_DETAILS

        // ✅ Convert complex arrays to JSON strings
        guard
            let smsData = try? JSONSerialization.data(withJSONObject: smsSettings, options: []),
            let smsJSONString = String(data: smsData, encoding: .utf8),
            let emailData = try? JSONSerialization.data(withJSONObject: emailSettings, options: []),
            let emailJSONString = String(data: emailData, encoding: .utf8)
        else {
            print("❌ Failed to encode SMS/Email JSON arrays")
            completion(false)
            return
        }

        // ✅ Final request parameters
        let params: [String: Any] = [
            "vendor_id": vendorId,
            "reminder_time": reminderTime,
            "sms_settings": smsJSONString,
            "email_settings": emailJSONString,
            "email_notifications": emailNotifications
        ]

        // 🌐 Debug Log
        print("🌐 URL: \(url)")
        print("📤 Method: POST")
        print("📤 Headers: \(headers)")
        print("📤 JSON Parameters: \(params)")

        // ✅ Perform network call
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in

                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                switch response.result {
                case .success(let json):
                    print("✅ Success Response: \(json)")
                    completion(true)

                case .failure(let error):
                    print("❌ Request Failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let raw = String(data: data, encoding: .utf8) {
                        print("📦 Raw Error Response: \(raw)")
                    }
                    completion(false)
                }
            }
    }


    func fetchSalonDetails(completion: @escaping (SalonModel?) -> Void) {
        let url = global.shared.URL_GET_SALON_INFORMATION + "/\(LocalData.userId)"
        
        print("🌐 URL: \(url)")
        print("📤 Headers: \(headers)")
        
        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                // 📩 Log HTTP status
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 🧾 Log raw JSON
                if let data = response.data,
                   let raw = String(data: data, encoding: .utf8) {
                    print("📥 Raw Response: \(raw)")
                }

                switch response.result {
                case .success(let json):
                    // ✅ Map manually with ObjectMapper
                    if let model = Mapper<SalonModel>().map(JSONObject: json) {
                        print("✅ Parsed SalonModel Successfully")
                        print("✅ Total Entries: \(model.data.count)")
                        completion(model)
                    } else {
                        print("❌ Failed to map JSON to SalonModel")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Call Failed: \(error.localizedDescription)")
                    completion(nil)
                }
            }
    }

   
    func fetchSalonHolidays(completion: @escaping (HolidayModel?) -> Void) {
        let url = global.shared.URL_GET_HOLIDAYS + "/\(LocalData.userId)"
        
        print("🌐 URL: \(url)")
        print("📤 Headers: \(headers)")
        
        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                // 📩 Log HTTP status
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 🧾 Log raw JSON response
                if let data = response.data,
                   let rawJSON = String(data: data, encoding: .utf8) {
                    print("📥 Raw Response: \(rawJSON)")
                }

                switch response.result {
                case .success(let json):
                    // ✅ Parse JSON using ObjectMapper
                    if let model = Mapper<HolidayModel>().map(JSONObject: json) {
                        print("✅ Parsed HolidayModel: \(model)")
                        print("✅ Total Holidays: \(model.data.count)")
                        completion(model)
                    } else {
                        print("❌ Failed to map JSON to HolidayModel")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Call Failed: \(error.localizedDescription)")
                    completion(nil)
                }
            }
    }

    
    func convertHolidayDatesToJSONString(_ holidays: [HolidayDate1]) -> String? {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(holidays) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    func updateSalonHolidays(vendorID: String, holidays: [HolidayDate1], completion: @escaping (Bool) -> Void) {
        let url = global.shared.URL_UPDATE_HOLIDAYS

        // Step 1: Encode [HolidayDate1] → JSON string
        let encoder = JSONEncoder()
        guard let jsonData = try? encoder.encode(holidays),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            print("❌ Failed to encode holiday array to JSON string")
            completion(false)
            return
        }

        // Step 2: Build parameters
        let params: [String: Any] = [
            "vendor_id": vendorID,
            "holiday_dates": jsonString
        ]

        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")

        // Step 3: Perform request
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                // 📩 Print HTTP status code
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 🧾 Print raw JSON response
                if let data = response.data,
                   let raw = String(data: data, encoding: .utf8) {
                    print("📥 Raw Response: \(raw)")
                }

                switch response.result {
                case .success(let json):
                    print("✅ Success Response JSON:", json)
                    // (Optional) parse with ObjectMapper if API returns CommonModel
                    if let common = Mapper<CommonModel>().map(JSONObject: json) {
                        print("✅ Parsed CommonModel:", common)
                    }
                    completion(true)

                case .failure(let error):
                    print("❌ Error:", error.localizedDescription)
                    completion(false)
                }
            }
    }


    func fetchGetOpenDate(completion: @escaping (OpeningDateResponse?) -> Void) {
        let url = global.shared.URL_GET_OPENDATE + "/\(LocalData.userId)"

        print("🌐 URL: \(url)")
        print("📤 Headers: \(headers)")

        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in

                // 📩 Print HTTP status code
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 🧾 Print raw response
                if let data = response.data,
                   let rawJSON = String(data: data, encoding: .utf8) {
                    print("📥 Raw Response: \(rawJSON)")
                }

                switch response.result {
                case .success(let json):
                    // 🧠 Parse JSON with ObjectMapper
                    if let model = Mapper<OpeningDateResponse>().map(JSONObject: json) {
                        print("✅ Parsed OpeningDateResponse successfully")
                        completion(model)
                    } else {
                        print("❌ Mapping failed — unexpected JSON structure.")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Call Failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let responseStr = String(data: data, encoding: .utf8) {
                        print("📦 Raw Error Response: \(responseStr)")
                    }
                    completion(nil)
                }
            }
    }

   
    func UpdateOpenDate(
        vendor_id: String,
        opening_date: String,
        completion: @escaping (CommonModel?) -> Void
    ) {
        let url = global.shared.URL_UPDATE_OPENDATE

        let params: [String: Any] = [
            "vendor_id": vendor_id,
            "opening_date": opening_date
        ]

        // 🌐 Debug Info
        print("🌐 URL: \(url)")
        print("📤 Method: POST")
        print("📤 Headers: \(headers)")
        print("📤 Parameters: \(params)")

        AF.request(
            url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in
            
            // 📩 Print HTTP status
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }
            
            // 🧾 Print raw response
            if let data = response.data,
               let responseStr = String(data: data, encoding: .utf8) {
                print("📦 Raw Response: \(responseStr)")
            }

            switch response.result {
            case .success(let json):
                print("✅ API Success")

                // 🧠 Map JSON using ObjectMapper
                if let model = Mapper<CommonModel>().map(JSONObject: json) {
                    print("✅ Parsed CommonModel: \(model)")
                    completion(model)
                } else {
                    print("❌ Mapping failed — unexpected JSON structure.")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ API Request Failed: \(error.localizedDescription)")
                if let data = response.data,
                   let errorStr = String(data: data, encoding: .utf8) {
                    print("📦 Error Body: \(errorStr)")
                }
                completion(nil)
            }
        }
    }

 
    func UpdateBusinessInformation(
        id: String,
        salon_name: String,
        salon_type: String,
        phone: String,
        salon_phone: String,
        postcode: String,
        address: String,
        city: String,
        country: String,
        latitude: String,
        longitude: String,
        web_status: String,
        allow_search: String,
        time_gap: String,
        reminder_mail: String,
        about_us: String,
        booking_guest: String,
        completion: @escaping (CommonModel?) -> Void
    ) {
        let url = "\(global.shared.URL_UPDATE_BUSINESS_INFORMATION)/\(LocalData.userId)"
        
        let params: [String: Any] = [
            "id": id,
            "salon_name": salon_name,
            "salon_type": salon_type,
            "phone": phone,
            "salon_phone": salon_phone,
            "postcode": postcode,
            "address": address,
            "city": city,
            "country": country,
            "latitude": latitude,
            "longitude": longitude,
            "web_status": web_status,
            "allow_search": allow_search,
            "time_gap": time_gap,
            "reminder_mail": reminder_mail,
            "about_us": about_us,
            "booking_guest": booking_guest
        ]
        
        // 🌐 Debug Logs
        print("🌐 URL: \(url)")
        print("📤 Method: POST")
        print("📤 Headers: \(headers)")
        print("📤 Parameters: \(params)")
        
        AF.request(
            url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in
            
            // 📩 Log HTTP status
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }
            
            // 📦
            if let data = response.data,
               let rawResponse = String(data: data, encoding: .utf8) {
                print("📦 Raw Response: \(rawResponse)")
            }
            
            switch response.result {
            case .success(let json):
                print("✅ API Success: \(json)")
                
                // Optional: Parse into CommonModel if backend returns a message
                if let commonModel = Mapper<CommonModel>().map(JSONObject: json) {
                    print("✅ Parsed CommonModel: \(commonModel)")
                    completion(commonModel)
                } else {
                    completion(nil)
                }

            case .failure(let error):
                print("❌ API Error: \(error.localizedDescription)")
                if let data = response.data,
                   let raw = String(data: data, encoding: .utf8) {
                    print("📦 Raw Error Response: \(raw)")
                    completion(nil)
                } 
            }
            
        }
    }
    
    //<<<<<<< Updated upstream:TheCrazyBeautyPOS/Helper/APIService .swift
    //=======
   
    func uploadBlockCustomers(vendorId: String, blockCustomers: String, completion: @escaping (Bool, String?) -> Void) {
        let url = global.shared.URL_UPDATE_BLOCK_CUSTOMERS

        let params: [String: Any] = [
            "vendor_id": vendorId,
            "block_customers": blockCustomers
        ]

        // 🌐 Debug info
        print("🌐 URL: \(url)")
        print("📤 Method: POST")
        print("📤 Headers: \(headers)")
        print("📤 Parameters: \(params)")

        AF.request(
            url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in

            // 📩 Status Code
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            // 📦 Raw Response
            if let data = response.data,
               let rawResponse = String(data: data, encoding: .utf8) {
                print("📦 Raw Response: \(rawResponse)")
            }

            switch response.result {
            case .success(let json):
                print("✅ API Success: \(json)")
                
                // Optional: Parse into CommonModel if backend returns a message
                if let commonModel = Mapper<CommonModel>().map(JSONObject: json) {
                    print("✅ Parsed CommonModel: \(commonModel)")
                    completion(true, commonModel.error)
                } else {
                    completion(true, nil)
                }

            case .failure(let error):
                print("❌ API Error: \(error.localizedDescription)")
                if let data = response.data,
                   let raw = String(data: data, encoding: .utf8) {
                    print("📦 Raw Error Response: \(raw)")
                    completion(false, raw)
                } else {
                    completion(false, error.localizedDescription)
                }
            }
        }
    }

   
    func AddVendorData(salon_id: String, completion: @escaping (VendorData?) -> Void) {
        let url = global.shared.URL_ADD_VENDOR_DATA

        let params: [String: Any] = [
            "salon_id": salon_id
        ]

        // 🌐 Debug Logs
        print("🌐 URL: \(url)")
        print("📤 Method: POST")
        print("📤 Headers: \(headers)")
        print("📤 Parameters: \(params)")

        AF.request(
            url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in
            
            // 📩 Status Code
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            // 📦 Raw Response
            if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                print("📦 Raw Response: \(raw)")
            }

            // 🧠 Handle Result
            switch response.result {
            case .success(let json):
                if let model = Mapper<VendorData>().map(JSONObject: json) {
                    print("✅ Parsed VendorData: \(model)")
                    completion(model)
                } else {
                    print("❌ Failed to map VendorData")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ API Error: \(error.localizedDescription)")
                if let data = response.data,
                   let rawError = String(data: data, encoding: .utf8) {
                    print("📦 Error Response: \(rawError)")
                }
                completion(nil)
            }
        }
    }

 
    func BusinessInformation(
        url: String,
        address: String,
        latitude: String,
        longitude: String,
        postcode: String,
        salon_name: String,
        salon_type: String,
        web_status: String,
        completion: @escaping (CommonModel?) -> Void
    ) {
        let params: [String: Any] = [
            "address": address,
            "latitude": latitude,
            "longitude": longitude,
            "postcode": postcode,
            "salon_name": salon_name,
            "salon_type": salon_type,
            "web_status": web_status
        ]

        // 🌐 Debug Info
        print("🌐 URL: \(url)")
        print("📤 Method: POST")
        print("📤 Headers: \(headers)")
        print("📤 Parameters: \(params)")

        // 🚀 Make API Request
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                // 📩 HTTP Status
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 🧾 Raw Response
                if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }

                // 🧠 Handle API Result
                switch response.result {
                case .success(let json):
                    if let model = Mapper<CommonModel>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Failed to map response to CommonModel")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    if let data = response.data,
                       let rawJSON = String(data: data, encoding: .utf8) {
                        print("📦 Error Response: \(rawJSON)")
                    }
                    completion(nil)
                }
            }
    }

    func Add_BusinessHours(
        url: String,
        workingHours: [WorkingHour1],
        completion: @escaping (CommonResponse?) -> Void
    ) {
        // 1️⃣ Prepare JSON Array for working_hours
        let workingHoursArray: [[String: String]] = workingHours.compactMap { wh in
            if let day = wh.day, let from = wh.from, let to = wh.to {
                return ["day": day, "from": from, "to": to]
            }
            return nil
        }

        // 2️⃣ Encode as JSON String
        guard let data = try? JSONSerialization.data(withJSONObject: workingHoursArray, options: []),
              let jsonArrayString = String(data: data, encoding: .utf8) else {
            print("❌ Failed to encode working_hours array")
            completion(nil)
            return
        }

        // 3️⃣ Prepare Final Parameters
        let params: [String: Any] = ["working_hours": jsonArrayString]

        // 🌐 Debug Info
        print("🌐 URL: \(url)")
        print("📤 Method: POST")
        print("📤 Headers: \(headers)")
        print("📤 Parameters: \(params)")

        // 4️⃣ Make Request
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                // 📬 Log Status Code
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 📦 Raw JSON
                if let data = response.data, let rawJSON = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(rawJSON)")
                }

                // 5️⃣ Handle Result
                switch response.result {
                case .success(let json):
                    if let model = Mapper<CommonResponse>().map(JSONObject: json) {
                        print("✅ Parsed Response: \(model)")
                        completion(model)
                    } else {
                        print("❌ Failed to map response JSON to CommonResponse")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    if let data = response.data,
                       let raw = String(data: data, encoding: .utf8) {
                        print("📦 Error Body: \(raw)")
                    }
                    completion(nil)
                }
            }
    }
    
    func fetch_MainCategory(completion: @escaping (CategoryModel?) -> Void) {
        let url = global.shared.URL_MAIN_CATAGORIES + "/\(LocalData.userId)"
        
        print("🌐 URL: \(url)")
        print("📤 Headers: \(headers)")
        
        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                // 📩 Log HTTP Status Code
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }
                
                // 🧾 Print Raw Response
                if let data = response.data,
                   let rawJSON = String(data: data, encoding: .utf8) {
                    print("📥 Raw Response: \(rawJSON)")
                }
                
                switch response.result {
                case .success(let json):
                    // 🧠 Parse JSON using ObjectMapper
                    if let model: CategoryModel = Mapper<CategoryModel>().map(JSONObject: json) {
                        print("✅ Parsed Category Model Successfully")
                        print("✅ Total Categories: \(model.data.count)")
                        completion(model)
                    } else {
                        print("❌ Mapping failed — unexpected JSON structure.")
                        completion(nil)
                    }
                    
                case .failure(let error):
                    print("❌ API Call Failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let responseStr = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(responseStr)")
                    }
                    completion(nil)
                }
            }
    }


    
    // MARK: - Add Team Data
    func AddTeamData(
        salon_id: String,
        completion: @escaping (CurrencyResponseA?) -> Void
    ) {
        let url = global.shared.URL_ADD_TEAM_DATA
        
        let params: [String: Any] = [
            "salon_id": salon_id
        ]
        
        // 🌐 Debug Info
        print("🌐 URL: \(url)")
        print("📤 Method: POST")
        print("📤 Headers: \(self.headers)")
        print("📤 Parameters: \(params)")
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }
                
                switch response.result {
                case .success(let value):
                    // 📦 Raw Response
                    if let data = response.data,
                       let responseStr = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(responseStr)")
                    }
                    
                    // 🧩 Convert JSON to Model (ObjectMapper)
                    if let json = value as? [String: Any],
                       let model = Mapper<CurrencyResponseA>().map(JSON: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("⚠️ Mapping Failed for CurrencyResponseA")
                        completion(nil)
                    }
                    
                case .failure(let error):
                    print("❌ Request Failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let raw = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(raw)")
                    }
                    completion(nil)
                }
            }
    }

    
    // MARK: - Service Get
    func ServiceGet(
        vendor_id: String,
        start_date: String,
        end_date: String,
        completion: @escaping (ServiceDetailsModel?) -> Void
    ) {
        let url = global.shared.URL_SERIVICES_SALES_DATA
        
        let params: [String: Any] = [
            "vendor_id": vendor_id,
            "start_date": start_date,
            "end_date": end_date
        ]
        
        // 🌐 Request Info
        print("🌐 URL: \(url)")
        print("📤 Method: POST")
        print("📤 Headers: \(self.headers)")
        print("📤 Parameters: \(params)")
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }
                
                switch response.result {
                case .success(let value):
                    // 📦 Raw Response
                    if let data = response.data,
                       let responseStr = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(responseStr)")
                    }
                    
                    // 🧩 Map JSON using ObjectMapper
                    if let json = value as? [String: Any],
                       let model = Mapper<ServiceDetailsModel>().map(JSON: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("⚠️ Failed to map JSON into ServiceDetailsModel")
                        completion(nil)
                    }
                    
                case .failure(let error):
                    print("❌ Request Failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let raw = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(raw)")
                    }
                    completion(nil)
                }
            }
    }

   
    // MARK: - Gift Card Get
    func GiftCardGet(
        vendor_id: String,
        limt: String,
        page: String,
        start_date: String,
        end_date: String,
        completion: @escaping (GiftModel?) -> Void
    ) {
        let url = global.shared.URL_GIFT_DETAILS
        
        let params: [String: Any] = [
            "vendor_id": vendor_id,
            "start_date": start_date,
            "end_date": end_date,
            "limit": limt,
            "page": page
        ]
        
        // 🌐 Request Info
        print("🌐 URL: \(url)")
        print("📤 Method: POST")
        print("📤 Headers: \(self.headers)")
        print("📤 Parameters: \(params)")
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }
                
                switch response.result {
                case .success(let value):
                    // 📦 Log raw JSON
                    if let data = response.data,
                       let responseStr = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(responseStr)")
                    }
                    
                    // 🧩 Parse with ObjectMapper
                    if let json = value as? [String: Any],
                       let model = Mapper<GiftModel>().map(JSON: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("⚠️ Failed to map JSON into GiftModel")
                        completion(nil)
                    }
                    
                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    if let data = response.data,
                       let raw = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(raw)")
                    }
                    completion(nil)
                }
            }
    }

   
    // MARK: - Sales Payment History
    func SalesPaymentHistory(
        vendor_id: String,
        start_date: String,
        end_date: String,
        limit: String,
        page: String,
        customer_type: String,
        search: String,
        staff_id: String,
        completion: @escaping (SalesHistoryModel?) -> Void
    ) {
        let url = global.shared.URL_PAYMENT_HISTORY
        
        let params: [String: Any] = [
            "vendor_id": vendor_id,
            "start_date": start_date,
            "end_date": end_date,
            "limit": limit,
            "page": page,
            "customer_type": customer_type,
            "search": search,
            "staff_id": staff_id
        ]
        
        // 🌐 Request info logs
        print("🌐 URL: \(url)")
        print("📤 Method: POST")
        print("📤 Headers: \(self.headers)")
        print("📤 Parameters: \(params)")
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }
                
                switch response.result {
                case .success(let value):
                    // 📦 Raw JSON print
                    if let data = response.data,
                       let responseStr = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(responseStr)")
                    }
                    
                    // 🧩 Parse using ObjectMapper
                    if let json = value as? [String: Any],
                       let model = Mapper<SalesHistoryModel>().map(JSON: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("⚠️ Mapping failed — invalid JSON structure")
                        completion(nil)
                    }
                    
                case .failure(let error):
                    print("❌ Request Failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let raw = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(raw)")
                    }
                    completion(nil)
                }
            }
    }

        
    // MARK: - Walkin History Get
    func WalkinHistoryGet(
        vendor_id: String,
        limt: String,
        page: String,
        start_date: String,
        end_date: String,
        completion: @escaping (WalkinModel?) -> Void
    ) {
        let url = global.shared.URL_WALKIN_DETAILS
        
        let params: [String: Any] = [
            "vendor_id": vendor_id,
            "start_date": start_date,
            "end_date": end_date,
            "limit": limt,
            "page": page
        ]
        
        // 🌐 Log request info
        print("🌐 URL: \(url)")
        print("📤 Method: POST")
        print("📤 Headers: \(self.headers)")
        print("📤 Parameters: \(params)")
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }
                
                switch response.result {
                case .success(let value):
                    if let data = response.data,
                       let responseStr = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(responseStr)")
                    }
                    
                    // 🧩 Parse using ObjectMapper
                    if let json = value as? [String: Any],
                       let model = Mapper<WalkinModel>().map(JSON: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("⚠️ Mapping Failed – Invalid JSON structure")
                        completion(nil)
                    }
                    
                case .failure(let error):
                    print("❌ Error: \(error.localizedDescription)")
                    if let data = response.data,
                       let raw = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(raw)")
                    }
                    completion(nil)
                }
            }
    }

        

    // MARK: - Sales Data Get
    func SalesDataGet(
        vendor_id: String,
        staff_id: String,
        limt: String,
        page: String,
        start_date: String,
        end_date: String,
        completion: @escaping (SalesModel?) -> Void
    ) {
        let url = global.shared.URL_SALES_DATA
        
        let params: [String: Any] = [
            "vendor_id": vendor_id,
            "start_date": start_date,
            "end_date": end_date,
            "staff_id": staff_id,
            "limit": limt,
            "page": page
        ]
        
        // 🌐 Debug Info
        print("🌐 URL: \(url)")
        print("📤 Method: POST")
        print("📤 Headers: \(self.headers)")
        print("📤 Parameters: \(params)")
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }
                
                switch response.result {
                case .success(let value):
                    if let data = response.data,
                       let responseStr = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(responseStr)")
                    }
                    
                    // 🧩 Parse JSON into Model using ObjectMapper
                    if let json = value as? [String: Any],
                       let model = Mapper<SalesModel>().map(JSON: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("⚠️ Mapping Failed — Unexpected JSON structure")
                        completion(nil)
                    }
                    
                case .failure(let error):
                    print("❌ Error: \(error.localizedDescription)")
                    if let data = response.data,
                       let raw = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(raw)")
                    }
                    completion(nil)
                }
            }
    }

        

    // MARK: - Download Sales Report
    func downloadSalesReport(
        vendor_id: String,
        start_date: String,
        end_date: String,
        staff_id: String,
        completion: @escaping (ReportDownloadModel?) -> Void
    ) {
        let url = global.shared.URL_SALES_REPORT

        let params: [String: Any] = [
            "vendor_id": vendor_id,
            "start_date": start_date,
            "end_date": end_date,
            "staff_id": staff_id
        ]

        // 🌐 Debug Info
        print("🌐 URL: \(url)")
        print("📤 Method: POST")
        print("📤 Headers: \(self.headers)")
        print("📤 Parameters: \(params)")

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                switch response.result {
                case .success(let value):
                    if let data = response.data,
                       let responseStr = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(responseStr)")
                    }

                    // 🧩 Parse JSON using ObjectMapper
                    if let json = value as? [String: Any],
                       let model = Mapper<ReportDownloadModel>().map(JSON: json) {
                        print("✅ Download File: \(model.filename)")
                        completion(model)
                    } else {
                        print("⚠️ Mapping Failed — Unexpected JSON Structure")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ Request Failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let raw = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(raw)")
                    }
                    completion(nil)
                }
            }
    }

  
    // MARK: - Download Service Report
    func downloadServiceReport(
        vendor_id: String,
        start_date: String,
        end_date: String,
        completion: @escaping (ReportDownloadModel?) -> Void
    ) {
        let url = global.shared.URL_SARVICE_REPORT

        let params: [String: Any] = [
            "vendor_id": vendor_id,
            "start_date": start_date,
            "end_date": end_date
        ]

        // 🌐 Debug Info
        print("🌐 URL: \(url)")
        print("📤 Method: POST")
        print("📤 Headers: \(self.headers)")
        print("📤 Parameters: \(params)")

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                switch response.result {
                case .success(let value):
                    if let data = response.data,
                       let responseStr = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(responseStr)")
                    }

                    // 🧩 Parse JSON using ObjectMapper
                    if let json = value as? [String: Any],
                       let model = Mapper<ReportDownloadModel>().map(JSON: json) {
                        print("✅ Download File: \(model.filename)")
                        completion(model)
                    } else {
                        print("⚠️ Mapping Failed — Unexpected JSON Structure")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Request Failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let raw = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(raw)")
                    }
                    completion(nil)
                }
            }
    }

   
    // MARK: - Download Booking History Report
    func downloadBookingHistoryReport(
        vendor_id: String,
        start_date: String,
        end_date: String,
        customer_type: String,
        completion: @escaping (ReportDownloadModel?) -> Void
    ) {
        let url = global.shared.URL_BOOKING_HISTORY_REPORT

        let params: [String: Any] = [
            "vendor_id": vendor_id,
            "start_date": start_date,
            "end_date": end_date,
            "customer_type": customer_type
        ]

        // 🌐 Debug Info
        print("🌐 URL: \(url)")
        print("📤 Method: POST")
        print("📤 Headers: \(self.headers)")
        print("📤 Parameters: \(params)")

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in

                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                switch response.result {
                case .success(let value):
                    if let data = response.data,
                       let rawResponse = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(rawResponse)")
                    }

                    // 🧩 Map JSON to Model using ObjectMapper
                    if let json = value as? [String: Any],
                       let model = Mapper<ReportDownloadModel>().map(JSON: json) {
                        print("✅ Parsed ReportDownloadModel: \(model)")
                        completion(model)
                    } else {
                        print("⚠️ Mapping Failed — Unexpected JSON Structure")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Request Failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let rawResponse = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(rawResponse)")
                    }
                    completion(nil)
                }
            }
    }

 
    // MARK: - Download Walk-in History Report
    func downloadWalkinHistoryReport(
        vendor_id: String,
        start_date: String,
        end_date: String,
        completion: @escaping (ReportDownloadModel?) -> Void
    ) {
        let url = global.shared.URL_WALKIN_REPORT

        let params: [String: Any] = [
            "vendor_id": vendor_id,
            "start_date": start_date,
            "end_date": end_date
        ]

        // 🌐 Debug Info
        print("🌐 URL: \(url)")
        print("📤 Method: POST")
        print("📤 Headers: \(self.headers)")
        print("📤 Parameters: \(params)")

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in

                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                switch response.result {
                case .success(let value):
                    if let data = response.data,
                       let rawResponse = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(rawResponse)")
                    }

                    // 🧩 Map JSON to Model using ObjectMapper
                    if let json = value as? [String: Any],
                       let model = Mapper<ReportDownloadModel>().map(JSON: json) {
                        print("✅ Parsed ReportDownloadModel: \(model)")
                        completion(model)
                    } else {
                        print("⚠️ Mapping Failed — Unexpected JSON Structure")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Request Failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let rawResponse = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(rawResponse)")
                    }
                    completion(nil)
                }
            }
    }

  
    // MARK: - Download Gift Report
    func downloadGiftReport(
        vendor_id: String,
        start_date: String,
        end_date: String,
        completion: @escaping (ReportDownloadModel?) -> Void
    ) {
        let url = global.shared.URL_GIFT_REPORT

        let params: [String: Any] = [
            "vendor_id": vendor_id,
            "start_date": start_date,
            "end_date": end_date
        ]

        // 🌐 Debug Info
        print("🌐 URL: \(url)")
        print("📤 Method: POST")
        print("📤 Headers: \(self.headers)")
        print("📤 Parameters: \(params)")

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                switch response.result {
                case .success(let value):
                    if let data = response.data,
                       let responseStr = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(responseStr)")
                    }

                    // 🧩 Convert JSON to Model via ObjectMapper
                    if let json = value as? [String: Any],
                       let model = Mapper<ReportDownloadModel>().map(JSON: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("⚠️ Mapping Failed: Unexpected JSON Structure")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    if let data = response.data,
                       let raw = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(raw)")
                    }
                    completion(nil)
                }
            }
    }

    
   
    // MARK: - Check Coupon Code
    func CheckCouponCode(
        vendor_id: String,
        code: String,
        bookingDate: String,
        completion: @escaping (CheckCouponModel?) -> Void
    ) {
        let url = global.shared.URL_CHECK_COUPON
        
        let params: [String: Any] = [
            "vendor_id": vendor_id,
            "booking_date": bookingDate,
            "code": code
        ]
        
        // 🌐 Debug Request Info
        print("🌐 URL: \(url)")
        print("📤 Method: POST")
        print("📤 Headers: \(self.headers)")
        print("📤 Parameters: \(params)")
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                // 📩 Print HTTP Response
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }
                
                switch response.result {
                case .success(let value):
                    // 📦 Raw Response
                    if let data = response.data,
                       let responseStr = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(responseStr)")
                    }
                    
                    // 🧩 Map JSON to Model
                    if let json = value as? [String: Any],
                       let model = Mapper<CheckCouponModel>().map(JSON: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("⚠️ Mapping Failed — Unexpected JSON Structure")
                        completion(nil)
                    }
                    
                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    if let data = response.data,
                       let raw = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(raw)")
                    }
                    completion(nil)
                }
            }
    }

  
    // MARK: - Apply Coupon Code
    func ApplyCouponCode(
        vendor_id: String,
        code: String,
        completion: @escaping (CouponResponse?) -> Void
    ) {
        let url = global.shared.URL_APPLY_COUPON
        
        let params: [String: Any] = [
            "vendor_id": vendor_id,
            "coupon_code": code
        ]
        
        // 🌐 Log Request
        print("🌐 URL: \(url)")
        print("📤 Method: POST")
        print("📤 Headers: \(self.headers)")
        print("📤 Parameters: \(params)")
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }
                
                switch response.result {
                case .success(let value):
                    // 📦 Print raw JSON
                    if let data = response.data,
                       let rawJSON = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(rawJSON)")
                    }
                    
                    // 🧩 Map JSON to Model
                    if let json = value as? [String: Any],
                       let model = Mapper<CouponResponse>().map(JSON: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("⚠️ Mapping Failed — Invalid JSON Structure")
                        completion(nil)
                    }
                    
                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    if let data = response.data,
                       let raw = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(raw)")
                    }
                    completion(nil)
                }
            }
    }

    
    // MARK: - Apply Gift Card
    func ApplyGiftCard(
        vendor_id: String,
        code: String,
        total: String,
        completion: @escaping (GiftCardResponse?) -> Void
    ) {
        let url = global.shared.URL_APPLY_GIFTCARD
        
        let params: [String: Any] = [
            "vendor_id": vendor_id,
            "gift_code": code,
            "sub_total": total
        ]
        
        // 🌐 Log Request
        print("🌐 URL: \(url)")
        print("📤 Method: POST")
        print("📤 Headers: \(self.headers)")
        print("📤 Parameters: \(params)")
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                // 📩 Log HTTP response
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }
                
                switch response.result {
                case .success(let value):
                    // 📦 Raw response
                    if let data = response.data,
                       let rawString = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(rawString)")
                    }
                    
                    // 🧩 Map JSON → GiftCardResponse
                    if let json = value as? [String: Any],
                       let model = Mapper<GiftCardResponse>().map(JSON: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("⚠️ Mapping Failed — Unexpected JSON Format")
                        completion(nil)
                    }
                    
                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    if let data = response.data,
                       let raw = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(raw)")
                    }
                    completion(nil)
                }
            }
    }

  
    // MARK: - Add Cart Details
    func addCartDetails(
        vendorId: String,
        subTotal: Double,
        grandTotal: Double,
        discountAmount: String,
        serviceIds: String,
        couponCode: String,
        discountPercentage: String,
        transactionId: String,
        paymentType: String,
        discountType: String,
        giftCard: String,
        miscellaneousNote: String,
        miscellaneousPrice: Double,
        tips: Double,
        completion: @escaping (VendorData?) -> Void
    ) {
        let url = global.shared.URL_ADD_CART_DETAILS
        
        let params: [String: Any] = [
            "vendor_id": vendorId,
            "coupon_code": couponCode,
            "discount_amount": discountAmount,
            "discount_percentage": discountPercentage,
            "discount_type": discountType,
            "gift_card": giftCard,
            "miscellaneous_notes": miscellaneousNote,
            "miscellaneous_price": miscellaneousPrice,
            "payment_type": paymentType,
            "service_ids": serviceIds,
            "sub_total": subTotal,
            "tip": tips,
            "total": grandTotal,
            "transaction_id": transactionId
        ]
        
        // 🌐 Print request info
        print("🌐 URL: \(url)")
        print("📤 Method: POST")
        print("📤 Headers: \(self.headers)")
        print("📤 Parameters: \(params)")
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                // 📩 Log HTTP status
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }
                
                switch response.result {
                case .success(let value):
                    // 📦 Raw Response
                    if let data = response.data, let rawString = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(rawString)")
                    }
                    
                    // 🧩 Map JSON → VendorData
                    if let json = value as? [String: Any],
                       let model = Mapper<VendorData>().map(JSON: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("⚠️ Mapping Failed — Unexpected JSON format")
                        completion(nil)
                    }
                    
                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    if let data = response.data,
                       let raw = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(raw)")
                    }
                    completion(nil)
                }
            }
    }

   
    // MARK: - Walkin Transaction
    func WalkinTransaction(
        vendorId: String,
        amount: String,
        miscPrice: String,
        miscNotes: String,
        completion: @escaping (CommonModel?) -> Void
    ) {
        let url = global.shared.URL_WALKIN_TRANSACTION
        
        let params: [String: Any] = [
            "vendor_id": vendorId,
            "amount": amount,
            "price": miscPrice,
            "notes": miscNotes
        ]
        
        // 🌐 Debug Info
        print("🌐 URL: \(url)")
        print("📤 Method: POST")
        print("📤 Headers: \(self.headers)")
        print("📤 Parameters: \(params)")
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                // 📩 Print HTTP Status
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }
                
                switch response.result {
                case .success(let value):
                    // 🧾 Raw JSON Response
                    if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(raw)")
                    }
                    
                    // 🧩 Map JSON → CommonModel
                    if let json = value as? [String: Any],
                       let model = Mapper<CommonModel>().map(JSON: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("⚠️ Mapping Failed: Response not matching CommonModel")
                        completion(nil)
                    }
                    
                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    if let data = response.data,
                       let raw = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(raw)")
                    }
                    completion(nil)
                }
            }
    }

    

    // MARK: - Walkin Payment
    func WalkinPayment(
        vendorId: String,
        transactionId: String,
        completion: @escaping (PosPaymentModel?) -> Void
    ) {
        let url = global.shared.URL_WALKIN_PAYMENT
        
        let params: [String: Any] = [
            "vendor_id": vendorId,
            "transaction_id": transactionId
        ]
        
        // 🌐 Log Request Info
        print("🌐 URL: \(url)")
        print("📤 Method: POST")
        print("📤 Headers: \(self.headers)")
        print("📤 Parameters: \(params)")
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                // 📩 Log Status
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }
                
                switch response.result {
                case .success(let value):
                    // 📦 Log Raw Response
                    if let data = response.data, let rawResponse = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(rawResponse)")
                    }
                    
                    // 🧩 Map JSON -> ObjectMapper Model
                    if let json = value as? [String: Any],
                       let mappedModel = Mapper<PosPaymentModel>().map(JSON: json) {
                        print("✅ Parsed Response Object: \(mappedModel)")
                        completion(mappedModel)
                    } else {
                        print("⚠️ Failed to map response to PosPaymentModel")
                        completion(nil)
                    }
                    
                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    if let data = response.data,
                       let rawResponse = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(rawResponse)")
                    }
                    completion(nil)
                }
            }
    }

   
    
    // MARK: - Get Shift Team
    func getShiftTeam(
        vendorId: String,
        endDate: String,
        isTeamDetails: String,
        limit: String,
        page: String,
        search: String,
        startDate: String,
        completion: @escaping (StaffListResponse?) -> Void
    ) {
        let url = global.shared.URL_GET_SHIFTS

        // ✅ Parameters
        let params: [String: Any] = [
            "vendor_id": vendorId,
            "start_date": startDate,
            "end_date": endDate,
            "is_teamdetails": isTeamDetails,
            "limit": limit,
            "page": page,
            "search": search
        ]

        // 🌐 Request Logs
        print("🌐 URL: \(url)")
        print("📤 Method: POST")
        print("📤 Headers: \(self.headers)")
        print("📤 Parameters: \(params)")

        // ✅ Perform Request
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in

                // 📩 Status Log
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                switch response.result {
                case .success(let value):
                    // 🧾 Raw JSON
                    if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(raw)")
                    }

                    // 🧩 Parse Response Using ObjectMapper
                    if let json = value as? [String: Any],
                       let mappedObject = Mapper<StaffListResponse>().map(JSON: json) {
                        print("✅ Parsed Response Object: \(mappedObject)")
                        completion(mappedObject)
                    } else {
                        print("⚠️ Failed to map response into StaffListResponse")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(raw)")
                    }
                    completion(nil)
                }
            }
    }

    
    // MARK: - Staff Report
    func staffReport(
        vendorId: String,
        endDate: String,
        send_email: String,
        search: String,
        startDate: String,
        completion: @escaping (CommonResponse?) -> Void
    ) {
        let url = global.shared.URL_STAFF_REPORT

        // ✅ Parameters
        let params: [String: Any] = [
            "vendor_id": vendorId,
            "end_date": endDate,
            "send_email": send_email,
            "search": search,
            "start_date": startDate
        ]

        // 🌐 Log Request
        print("🌐 URL: \(url)")
        print("📤 Method: POST")
        print("📤 Headers: \(self.headers)")
        print("📤 Parameters: \(params)")

        // ✅ Perform Request
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                // 📩 Log HTTP Response
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                switch response.result {
                case .success(let value):
                    // 📦 Raw Response Logging
                    if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(raw)")
                    }

                    // 🧩 Parse JSON into Model using ObjectMapper
                    if let json = value as? [String: Any],
                       let mappedObject = Mapper<CommonResponse>().map(JSON: json) {
                        print("✅ Parsed Response Object: \(mappedObject)")
                        completion(mappedObject)
                    } else {
                        print("⚠️ Failed to map response into CommonResponses model")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(raw)")
                    }
                    completion(nil)
                }
            }
    }

  
    // MARK: - Add Offline Gift
    func add_offgift(
        vendorId: String,
        gift_name: String,
        price: String,
        expiry_date: String,
        description: String,
        completion: @escaping (OfflineGift?) -> Void
    ) {
        let url = global.shared.URL_Add_OFFGIFT

        // ✅ Parameters
        let params: [String: Any] = [
            "vendor_id": vendorId,
            "gift_name": gift_name,
            "price": price,
            "expiry_date": expiry_date,
            "description": description
        ]

        // 🌐 Log Request Info
        print("🌐 URL: \(url)")
        print("📤 Method: POST")
        print("📤 Headers: \(self.headers)")
        print("📤 Parameters: \(params)")

        // ✅ Perform Request
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in

                // 📩 Log HTTP Status Code
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                switch response.result {
                case .success(let value):
                    // 🧾 Raw Response Log
                    if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(raw)")
                    }

                    // 🧩 Parse JSON into Model
                    if let json = value as? [String: Any],
                       let mappedObject = Mapper<OfflineGift>().map(JSON: json) {
                        print("✅ Parsed Response Object: \(mappedObject)")
                        completion(mappedObject)
                    } else {
                        print("⚠️ Failed to map response into OfflineGift model")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ Request Failed: \(error.localizedDescription)")
                    if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(raw)")
                    }
                    completion(nil)
                }
            }
    }

    
    // MARK: - Add Coupon (Alamofire + ObjectMapper)
    func add_AddCoupon(
        vendorId: String,
        status: String,
        start_date: String,
        highest_amount: String,
        end_date: String,
        discount_type: String,
        coupon_name: String,
        coupon_code: String,
        amount: String,
        completion: @escaping (OfflineGift?) -> Void
    ) {
        let url = global.shared.URL_Add_Coupon

        let params: [String: Any] = [
            "vendor_id": vendorId,
            "status": status,
            "start_date": start_date,
            "highest_amount": highest_amount,
            "end_date": end_date,
            "discount_type": discount_type,
            "coupon_name": coupon_name,
            "coupon_code": coupon_code,
            "amount": amount
        ]

        // 🌐 Debug Request Info
        print("🌐 URL: \(url)")
        print("📤 Method: POST")
        print("📤 Headers: \(self.headers)")
        print("📤 Parameters: \(params)")

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                switch response.result {
                case .success(let value):
                    // 🧾 Print Raw Response
                    if let data = response.data,
                       let rawString = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(rawString)")
                    }

                    // 🧩 Map JSON to Model
                    if let json = value as? [String: Any],
                       let mappedModel = Mapper<OfflineGift>().map(JSON: json) {
                        print("✅ Parsed Response Object: \(mappedModel)")
                        completion(mappedModel)
                    } else {
                        print("⚠️ Failed to map response to OfflineGift model")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ Request Failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let rawString = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(rawString)")
                    }
                    completion(nil)
                }
            }
    }
    
    /*func addGiftCard(card_name: String, price: String, expired_in: String, vendor_id: String, status: String, image: UIImage?, imageKey: String = "file", completion: @escaping (AddMemberModel?) -> Void) {
        let url = global.shared.URL_Add_GIFTCARD
        
        let params: [String: Any] = [
                "card_name": card_name,
                "price": price,
                "expired_in": expired_in,
                "vendor_id": vendor_id,
                "status": status
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
    }*/
   
    // MARK: - Add Gift Card (Alamofire + ObjectMapper)
    func addGiftCard(
        card_name: String,
        price: String,
        expired_in: String,
        vendor_id: String,
        status: String,
        image: UIImage?,
        imageKey: String = "file",
        completion: @escaping (AddMemberModel?) -> Void
    ) {
        let url = global.shared.URL_Add_GIFTCARD
        
        let params: [String: Any] = [
            "card_name": card_name,
            "price": price,
            "expired_in": expired_in,
            "vendor_id": vendor_id,
            "status": status
        ]
        
        // 🌐 Debug Request Info
        print("🌐 URL: \(url)")
        print("📤 Method: POST")
        print("📤 Headers: \(self.headers)")
        print("📤 Parameters: \(params)")
        
        AF.upload(
            multipartFormData: { multipartFormData in
                // 🖼️ Add image if available
                if let image = image, let imageData = image.jpegData(compressionQuality: 0.8) {
                    multipartFormData.append(
                        imageData,
                        withName: imageKey,
                        fileName: "giftcard.jpg",
                        mimeType: "image/jpeg"
                    )
                }
                
                // 🧾 Add text fields
                for (key, value) in params {
                    if let data = "\(value)".data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            },
            to: url,
            method: .post,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in
            
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            switch response.result {
            case .success(let value):
                // 🧾 Print Raw Response
                if let data = response.data,
                   let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }
                
                // 🧩 Map to AddMemberModel
                if let json = value as? [String: Any],
                   let mapped = Mapper<AddMemberModel>().map(JSON: json) {
                    print("✅ Parsed Response Object: \(mapped)")
                    completion(mapped)
                } else {
                    print("⚠️ Failed to map response to AddMemberModel")
                    completion(nil)
                }
                
            case .failure(let error):
                print("❌ Upload Error: \(error.localizedDescription)")
                if let data = response.data,
                   let raw = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(raw)")
                }
                completion(nil)
            }
        }
    }


    
    // MARK: - Add Inventory (Alamofire + ObjectMapper)
    func add_AddInventory(
        vendorId: String,
        price: String,
        product_name: String,
        qty: String,
        completion: @escaping (OfflineGift?) -> Void
    ) {
        let url = global.shared.URL_Add_INVENTORY

        let params: [String: Any] = [
            "vendor_id": vendorId,
            "price": price,
            "product_name": product_name,
            "qty": qty
        ]

        // 🌐 Log Request
        print("🌐 URL: \(url)")
        print("📤 Method: POST")
        print("📤 Headers: \(self.headers)")
        print("📤 Parameters: \(params)")

        AF.request(
            url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in
            
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            switch response.result {
            case .success(let value):
                // 🧾 Print Raw JSON
                if let data = response.data,
                   let rawJSON = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(rawJSON)")
                }

                // 🧩 Map JSON into OfflineGift
                if let json = value as? [String: Any],
                   let mapped = Mapper<OfflineGift>().map(JSON: json) {
                    print("✅ Parsed Response Object: \(mapped)")
                    completion(mapped)
                } else {
                    print("⚠️ Failed to map response to OfflineGift")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ Request Failed: \(error.localizedDescription)")
                if let data = response.data,
                   let raw = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(raw)")
                }
                completion(nil)
            }
        }
    }


   
    // MARK: - Update Inventory (Alamofire + ObjectMapper)
    func updateInventory(
        clientId: Int,
        price: String,
        product_name: String,
        qty: String,
        vendor_id: String,
        completion: @escaping (CommonResponse?) -> Void
    ) {
        let url = "\(global.shared.URL_UPDATE_INVENTORY)\(clientId)"
        
        let params: [String: Any] = [
            "price": price,
            "product_name": product_name,
            "qty": qty,
            "vendor_id": vendor_id
        ]
        
        // 🌐 Log Request
        print("🌐 URL: \(url)")
        print("📤 Method: PUT")
        print("📤 Headers: \(self.headers)")
        print("📤 Parameters: \(params)")
        
        // ✅ Alamofire Request
        AF.request(
            url,
            method: .put,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in
            
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }
            
            switch response.result {
            case .success(let value):
                // 🧾 Print raw JSON for debugging
                if let data = response.data,
                   let rawJSON = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(rawJSON)")
                }
                
                // 🧩 Map JSON to CommonResponse
                if let json = value as? [String: Any],
                   let mapped = Mapper<CommonResponse>().map(JSON: json) {
                    print("✅ Parsed Response Object: \(mapped)")
                    completion(mapped)
                } else {
                    print("⚠️ Failed to map JSON to CommonResponse")
                    completion(nil)
                }
                
            case .failure(let error):
                print("❌ API Error: \(error.localizedDescription)")
                if let data = response.data,
                   let rawJSON = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(rawJSON)")
                }
                completion(nil)
            }
        }
    }


    
    // MARK: - Delete Inventory (Alamofire + ObjectMapper)
    func deleteInventory(Id: Int, completion: @escaping (CommonResponse?) -> Void) {
        let url = "\(global.shared.URL_DELETE_INVENTORY)\(Id)"
        let params: [String: Any] = [:] // Optional body
        
        print("🌐 URL: \(url)")
        print("📤 Method: DELETE")
        print("📤 Headers: \(self.headers)")
        print("📤 Parameters: \(params)")

        AF.request(
            url,
            method: .delete,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in
            
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            switch response.result {
            case .success(let value):
                if let data = response.data,
                   let rawJSON = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(rawJSON)")
                }

                if let json = value as? [String: Any],
                   let mapped = Mapper<CommonResponse>().map(JSON: json) {
                    print("✅ Parsed Response Object: \(mapped)")
                    completion(mapped)
                } else {
                    print("⚠️ Failed to map JSON to CommonResponse")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ API Error: \(error.localizedDescription)")
                if let data = response.data,
                   let rawJSON = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(rawJSON)")
                }
                completion(nil)
            }
        }
    }


    // MARK: - Update Gift Coupon (Alamofire + ObjectMapper)
    func updateGiftCoupon(
        Id: Int,
        amount: String,
        coupon_code: String,
        discount_type: String,
        vendor_id: String,
        coupon_name: String,
        end_date: String,
        highest_amount: String,
        start_date: String,
        status: String,
        completion: @escaping (CommonResponse?) -> Void
    ) {
        let url = "\(global.shared.URL_UPDATE_Coupon)\(Id)"
        
        let params: [String: Any] = [
            "amount": amount,
            "coupon_code": coupon_code,
            "discount_type": discount_type,
            "coupon_name": coupon_name,
            "end_date": end_date,
            "highest_amount": highest_amount,
            "start_date": start_date,
            "status": status,
            "vendor_id": vendor_id
        ]
        
        print("🌐 URL: \(url)")
        print("📤 Method: PUT")
        print("📤 Headers: \(self.headers)")
        print("📤 Parameters: \(params)")

        AF.request(
            url,
            method: .put,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in
            
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }
            
            switch response.result {
            case .success(let value):
                if let data = response.data,
                   let rawJSON = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(rawJSON)")
                }
                
                if let json = value as? [String: Any],
                   let mapped = Mapper<CommonResponse>().map(JSON: json) {
                    print("✅ Parsed Response Object: \(mapped)")
                    completion(mapped)
                } else {
                    print("⚠️ Failed to map JSON to CommonResponse")
                    completion(nil)
                }
                
            case .failure(let error):
                print("❌ API Error: \(error.localizedDescription)")
                if let data = response.data,
                   let rawJSON = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(rawJSON)")
                }
                completion(nil)
            }
        }
    }


    // MARK: - Delete Coupon (Alamofire + ObjectMapper, no AlamofireObjectMapper)
    func deleteCoupon(Id: Int, completion: @escaping (CommonResponse?) -> Void) {
        let url = "\(global.shared.URL_DELETE_COUPON)\(Id)"
        let params: [String: Any] = [:] // Empty body if backend expects

        print("🌐 URL: \(url)")
        print("📤 Method: PUT")
        print("📤 Headers: \(self.headers)")
        print("📤 Parameters: \(params)")

        AF.request(
            url,
            method: .put,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in
            
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            switch response.result {
            case .success(let value):
                if let data = response.data,
                   let rawJSON = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(rawJSON)")
                }

                if let json = value as? [String: Any],
                   let mapped = Mapper<CommonResponse>().map(JSON: json) {
                    print("✅ Parsed Response Object: \(mapped)")
                    completion(mapped)
                } else {
                    print("⚠️ Failed to map response to CommonResponse")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ API Error: \(error.localizedDescription)")
                if let data = response.data,
                   let rawJSON = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(rawJSON)")
                }
                completion(nil)
            }
        }
    }

    
    // MARK: - Update Gift Card API
    func UpdateGiftCard(
        Id: Int,
        card_name: String,
        price: String,
        expired_in: String,
        vendor_id: String,
        status: String,
        image: UIImage?,
        imageKey: String = "photo",
        completion: @escaping (AddMemberModel?) -> Void
    ) {
        let urlString = "\(global.shared.URL_UPDATE_GIFTCARD)\(Id)"
        guard let url = URL(string: urlString) else { return }

        // 📦 Prepare Parameters
        let params: [String: Any] = [
            "card_name": card_name,
            "price": price,
            "expired_in": expired_in,
            "vendor_id": vendor_id,
            "status": status
        ]

        // 🌐 Multipart Upload Request
        AF.upload(
            multipartFormData: { multipartFormData in
                // 🖼️ Add image if available
                if let image = image,
                   let imageData = image.jpegData(compressionQuality: 0.8) {
                    multipartFormData.append(
                        imageData,
                        withName: imageKey,
                        fileName: "giftcard.jpg",
                        mimeType: "image/jpeg"
                    )
                }

                // 🧾 Add all other parameters
                for (key, value) in params {
                    if let stringValue = "\(value)".data(using: .utf8) {
                        multipartFormData.append(stringValue, withName: key)
                    }
                }
            },
            to: url,
            method: .put,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in

            // 🧾 Debug Logging
            print("🌐 URL: \(url)")
            print("📤 Parameters: \(params)")
            print("📤 Headers: \(self.headers)")

            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            // 📥 Raw JSON for inspection
            if let data = response.data,
               let responseStr = String(data: data, encoding: .utf8) {
                print("📦 Raw Response: \(responseStr)")
            }

            // 🎯 Handle Response
            switch response.result {
            case .success(let json):
                // ✅ Map JSON manually using ObjectMapper
                if let model = Mapper<AddMemberModel>().map(JSONObject: json) {
                    print("✅ Parsed Response Object: \(model)")
                    completion(model)
                } else {
                    print("❌ Mapping Failed: Could not map JSON to AddMemberModel")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ Upload Failed: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

    
    // MARK: - Delete Gift Card API
    func deleteGiftCard(Id: Int, completion: @escaping (CommonResponse?) -> Void) {
        let urlString = "\(global.shared.URL_DELETE_GIFTCARD)\(Id)"
        guard let url = URL(string: urlString) else { return }

        // 🌐 Create URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "PUT" // or "DELETE" based on backend
        request.headers = HTTPHeaders(headers)

        // ✅ Empty JSON body
        let params: [String: Any] = [:]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
            request.httpBody = jsonData
        } catch {
            print("❌ Failed to encode JSON: \(error.localizedDescription)")
            completion(nil)
            return
        }

        // 🌐 Execute the request manually
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Request error: \(error.localizedDescription)")
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

            // 🧾 Log raw JSON for debugging
            if let rawString = String(data: data, encoding: .utf8) {
                print("📦 Raw Response: \(rawString)")
            }

            // ✅ Parse manually using ObjectMapper
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let model = Mapper<CommonResponse>().map(JSON: json) {
                    print("✅ Parsed Response Object: \(model)")
                    completion(model)
                } else {
                    print("❌ Mapping Failed: Could not map JSON to CommonResponse")
                    completion(nil)
                }
            } catch {
                print("❌ JSON Parsing Error: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }

    
    // MARK: - Fetch No-Show Limit API
    func fetchNoShowLimit(completion: @escaping (ShowLimitModel?) -> Void) {
        let url = global.shared.URL_GET_NoShowLimit + "/\(LocalData.userId)"

        // 🌐 Send GET Request
        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in

                // 🧾 Log Request Info
                print("🌐 URL: \(url)")
                print("📤 Headers: \(self.headers)")

                // ✅ Log HTTP Status
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 📥 Log Raw Response
                if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }

                // 🎯 Handle Result
                switch response.result {
                case .success(let json):
                    // ✅ Map JSON using ObjectMapper
                    if let model = Mapper<ShowLimitModel>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Mapping Failed: Could not map JSON to ShowLimitModel")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Call Failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let responseStr = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(responseStr)")
                    }
                    completion(nil)
                }
            }
    }

    
    // MARK: - Update No-Show Limit API
    func UpdateNoShowlimit(
        vendorId: String,
        allow_noshow: String,
        noshow_limit: String,
        completion: @escaping (CommonModel?) -> Void
    ) {
        let url = global.shared.URL_UPDATE_NoShowLimit

        // 📦 Prepare Parameters
        let params: [String: Any] = [
            "vendor_id": vendorId,
            "noshow_limit": noshow_limit,
            "allow_noshow": allow_noshow
        ]

        // 🌐 Send Request
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in

                // 🧾 Log Request Info
                print("🌐 URL: \(url)")
                print("📤 Parameters: \(params)")
                print("📤 Headers: \(self.headers)")

                // ✅ Log HTTP Status
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 📥 Log Raw Response
                if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }

                // 🎯 Handle Response
                switch response.result {
                case .success(let json):
                    // ✅ Parse manually using ObjectMapper
                    if let model = Mapper<CommonModel>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Mapping Failed: Could not map JSON to CommonModel")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    completion(nil)
                }
            }
    }

    
    // MARK: - Send Invoice API
    func SendInvoice(
        booking_id: String,
        email: String,
        completion: @escaping (CommonResponse?) -> Void
    ) {
        let url = global.shared.URL_SEND_INVOICE

        // 📦 Prepare Parameters
        let params: [String: Any] = [
            "booking_id": booking_id,
            "email": email
        ]

        // 🌐 Send Request
        AF.request(
            url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in

            // 🧾 Log Request Info
            print("🌐 URL: \(url)")
            print("📤 Parameters: \(params)")
            print("📤 Headers: \(self.headers)")

            // ✅ Log HTTP Status
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            // 📥 Log Raw Response
            if let data = response.data,
               let responseStr = String(data: data, encoding: .utf8) {
                print("📦 Raw Response: \(responseStr)")
            }

            // 🎯 Handle Result
            switch response.result {
            case .success(let json):
                // ✅ Parse using ObjectMapper
                if let model = Mapper<CommonResponse>().map(JSONObject: json) {
                    print("✅ Parsed Response Object: \(model)")
                    completion(model)
                } else {
                    print("❌ Mapping Failed: Could not map JSON to CommonResponses")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ API Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

    
    // MARK: - Verify Passcode API
    func verifyPasscode(
        passcode: String,
        vendorId: String,
        completion: @escaping (verifyPasscode?) -> Void
    ) {
        let url = global.shared.URL_VERIFY_PASSCODE

        // 📦 Prepare Parameters
        let params: [String: Any] = [
            "passcode": passcode,
            "vendor_id": vendorId
        ]

        // 🌐 Send Request
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in

                // 🧾 Log Request Info
                print("🌐 URL: \(url)")
                print("📤 Parameters: \(params)")
                print("📤 Headers: \(self.headers)")

                // ✅ Log HTTP Status
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 📥 Log Raw Response
                if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }

                // 🎯 Handle Response
                switch response.result {
                case .success(let json):
                    // ✅ Parse manually using ObjectMapper
                    if let model = Mapper<verifyPasscode>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Mapping Failed: Could not map JSON to verifyPasscode")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    completion(nil)
                }
            }
    }

    
    // MARK: - Past Client Booking API
    func Past_Client_Booking(
        customer_id: String,
        is_past: String,
        search: String,
        completion: @escaping (ClientBooking?) -> Void
    ) {
        let url = global.shared.URL_CLIENT_BOOKINGS

        // 📦 Prepare Parameters
        let params: [String: Any] = [
            "customer_id": customer_id,
            "is_past": is_past,
            "search": search
        ]

        // 🌐 Send Request
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in

                // 🧾 Log Request Info
                print("🌐 URL: \(url)")
                print("📤 Parameters: \(params)")
                print("📤 Headers: \(self.headers)")

                // ✅ Log HTTP Status
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 📥 Log Raw Response
                if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }

                // 🎯 Handle Result
                switch response.result {
                case .success(let json):
                    // ✅ Map using ObjectMapper
                    if let model = Mapper<ClientBooking>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Mapping Failed: Could not map JSON to ClientBooking")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    completion(nil)
                }
            }
    }

    
    // MARK: - Fetch Staff List API
    func fetchStaffList(service_id: String, completion: @escaping (StaffListModel?) -> Void) {
        let url = global.shared.URL_GET_STAFF + "\(LocalData.userId)"

        // 📦 Prepare Parameters
        let params: [String: Any] = [
            "service_id": service_id
        ]

        // 🌐 Send Request
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in

                // 🧾 Log Request Info
                print("🌐 URL: \(url)")
                print("📤 Parameters: \(params)")
                print("📤 Headers: \(self.headers)")

                // ✅ Log HTTP Status
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 📥 Log Raw Response
                if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }

                // 🎯 Handle Response
                switch response.result {
                case .success(let json):
                    // ✅ Manual ObjectMapper Mapping
                    if let model = Mapper<StaffListModel>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Mapping Failed: Could not map JSON to StaffListModel")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    completion(nil)
                }
            }
    }

    
    // MARK: - Fetch Test Details API
    func fetchTestDetails(customer_id: String, completion: @escaping (TeamListModel?) -> Void) {
        let url = global.shared.URL_TEST_DETAILS

        // 📦 Prepare Parameters
        let params: [String: Any] = [
            "customer_id": customer_id
        ]

        // 🌐 Send Request
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in

                // 🧾 Log Request Info
                print("🌐 URL: \(url)")
                print("📤 Parameters: \(params)")
                print("📤 Headers: \(self.headers)")

                // ✅ Log HTTP Status
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 📥 Log Raw Response
                if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }

                // 🎯 Handle Response
                switch response.result {
                case .success(let json):
                    // ✅ Manual mapping with ObjectMapper
                    if let model = Mapper<TeamListModel>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Mapping Failed: Could not map JSON to TeamListModel")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    completion(nil)
                }
            }
    }

    
    // MARK: - Add / Update Test API
    func UpdateNewTest(
        customer_id: String,
        description: String,
        status: String,
        tested_by: String,
        tested_date: String,
        title: String,
        completion: @escaping (CurrencyResponseA?) -> Void
    ) {
        let url = global.shared.URL_ADD_TEST

        // 📦 Prepare Parameters
        let params: [String: Any] = [
            "customer_id": customer_id,
            "description": description,
            "status": status,
            "tested_by": tested_by,
            "tested_date": tested_date,
            "title": title
        ]

        // 🌐 Send Request
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in

                // 🧾 Log Request Info
                print("🌐 URL: \(url)")
                print("📤 Parameters: \(params)")
                print("📤 Headers: \(self.headers)")

                // ✅ Log HTTP Status
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 📥 Log Raw Response
                if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }

                // 🎯 Handle Response
                switch response.result {
                case .success(let json):
                    // ✅ Manual mapping using ObjectMapper
                    if let model = Mapper<CurrencyResponseA>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Mapping Failed: Could not map JSON to CurrencyResponseA")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    completion(nil)
                }
            }
    }

    
    // MARK: - Time Slot API
    func TimeSlot(
        duration: String,
        full_date: String,
        staff_id: String,
        completion: @escaping (TimeSlotResponse?) -> Void
    ) {
        let url = global.shared.URL_SELECT_SLOT + "/v1"

        // 📦 Prepare Parameters
        let params: [String: Any] = [
            "duration": duration,
            "full_date": full_date,
            "staff_id": staff_id
        ]

        // 🌐 Send Request
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in

                // 🧾 Debug Logging
                print("🌐 URL: \(url)")
                print("📤 Parameters: \(params)")
                print("📤 Headers: \(self.headers)")

                // ✅ Log HTTP Status
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 📥 Log Raw Response
                if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }

                switch response.result {
                case .success(let json):
                    // ✅ Parse using ObjectMapper
                    if let model = Mapper<TimeSlotResponse>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Mapping Failed: Could not map JSON to TimeSlotResponse")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    completion(nil)
                }
            }
    }

    
    // MARK: - Past Booking API
    func PastBooking(
        booking_date: String,
        booking_id: String,
        startTime: String,
        endTime: String,
        staffBookingArray: [[String: Any]],
        staff_id: String,
        completion: @escaping (CurrencyResponseA?) -> Void
    ) {
        let url = global.shared.URL_PAST_REBOOKING

        // 🕒 Booking time as JSON string
        let bookingTimeDict: [String: Any] = [
            "startTime": startTime,
            "endTime": endTime
        ]
        let bookingTimeData = try? JSONSerialization.data(withJSONObject: bookingTimeDict, options: [])
        let bookingTimeString = String(data: bookingTimeData ?? Data(), encoding: .utf8) ?? ""

        // 👥 Staff booking array as JSON string
        let staffBookingData = try? JSONSerialization.data(withJSONObject: staffBookingArray, options: [])
        let staffBookingString = String(data: staffBookingData ?? Data(), encoding: .utf8) ?? ""

        // 📦 Parameters
        let params: [String: Any] = [
            "booking_date": booking_date,
            "booking_id": booking_id,
            "booking_time": bookingTimeString,
            "is_fav": "0",
            "staff_booking": staffBookingString,
            "staff_id": staff_id
        ]

        // 🌐 API Request
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in

                // 📋 Log Request Info
                print("🌐 URL: \(url)")
                print("📤 Parameters: \(params)")
                print("📤 Headers: \(self.headers)")

                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 🧾 Raw Response
                if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }

                switch response.result {
                case .success(let json):
                    if let model = Mapper<CurrencyResponseA>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Mapping Failed: Could not map JSON to CurrencyResponseA")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    completion(nil)
                }
            }
    }


    // MARK: - Delete Walk-in API
    func deleteWalkin(WalkinId: Int, completion: @escaping (CommonResponse?) -> Void) {
        let urlString = "\(global.shared.URL_DELETE_WALKIN)\(WalkinId)"
        
        print("🌐 URL: \(urlString)")
        print("📤 Headers: \(headers)")

        AF.request(urlString, method: .delete, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                // 📩 Log status
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 📦 Log raw response
                if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(raw)")
                }

                switch response.result {
                case .success(let json):
                    if let model = Mapper<CommonResponse>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Mapping failed — invalid JSON structure")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(raw)")
                    }
                    completion(nil)
                }
            }
    }

    
    // MARK: - Delete Booking API
    func DeleteBooking(vendor_id: String, booking_id: String, completion: @escaping (CommonResponse?) -> Void) {
        let url = global.shared.URL_DELETE_BOOKING
        
        let params: [String: Any] = [
            "vendor_id": vendor_id,
            "booking_id": booking_id
        ]
        
        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                
                // 📩 Log status code
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }
                
                // 📦 Log raw response
                if let data = response.data, let rawResponse = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(rawResponse)")
                }
                
                switch response.result {
                case .success(let json):
                    if let model = Mapper<CommonResponse>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Mapping failed — invalid JSON structure")
                        completion(nil)
                    }
                    
                case .failure(let error):
                    print("❌ Error: \(error.localizedDescription)")
                    if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(raw)")
                    }
                    completion(nil)
                }
            }
    }

    
    // MARK: - Resource Details API
    func ResourceDetails(vendorId: String, completion: @escaping (InventoryListResponse?) -> Void) {
        let url = global.shared.URL_RESOURCE_DETAILS

        let params: [String: Any] = [
            "vendor_id": vendorId
        ]

        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in

                // 📩 Print HTTP status
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 📦 Print raw JSON for debugging
                if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }

                switch response.result {
                case .success(let json):
                    if let model: InventoryListResponse = Mapper<InventoryListResponse>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Mapping failed — unexpected JSON structure")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ Error: \(error.localizedDescription)")
                    if let data = response.data,
                       let responseStr = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(responseStr)")
                    }
                    completion(nil)
                }
            }
    }

    
    // MARK: - Add Resource
    func addResource(
        description: String,
        name: String,
        qty: String,
        vendor_id: String,
        completion: @escaping (AddResource?) -> Void
    ) {
        let url = global.shared.URL_ADD_RESOURCE

        let params: [String: Any] = [
            "vendor_id": vendor_id,
            "description": description,
            "name": name,
            "qty": qty
        ]

        // 🌐 Log Request Info
        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")

        AF.request(
            url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in
            // 📩 Log HTTP response status
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            // 🧾 Log raw response
            if let data = response.data,
               let rawResponse = String(data: data, encoding: .utf8) {
                print("📥 Raw Response: \(rawResponse)")
            }

            // 🧠 Parse JSON → AddResource using ObjectMapper
            switch response.result {
            case .success(let json):
                if let model: AddResource = Mapper<AddResource>().map(JSONObject: json) {
                    print("✅ Parsed AddResource Model: \(model)")
                    completion(model)
                } else {
                    print("❌ Mapping failed — unexpected JSON structure.")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                if let data = response.data,
                   let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }
                completion(nil)
            }
        }
    }

    
    // MARK: - Update Resource
    func updateResource(
        description: String,
        name: String,
        qty: String,
        resource_id: String,
        vendor_id: String,
        completion: @escaping (CommonResponse?) -> Void
    ) {
        let url = global.shared.URL_UPDATE_RESOURCE

        let params: [String: Any] = [
            "vendor_id": vendor_id,
            "description": description,
            "name": name,
            "qty": qty,
            "resource_id": resource_id
        ]

        // 🌐 Log Request Info
        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")

        AF.request(
            url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in
            // 📩 Log HTTP response status
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            // 🧾 Log raw JSON response
            if let data = response.data,
               let rawResponse = String(data: data, encoding: .utf8) {
                print("📥 Raw Response: \(rawResponse)")
            }

            // 🧠 Parse JSON → CommonResponses using ObjectMapper
            switch response.result {
            case .success(let json):
                if let model: CommonResponse = Mapper<CommonResponse>().map(JSONObject: json) {
                    print("✅ Parsed Response Object: \(model)")
                    completion(model)
                } else {
                    print("❌ Mapping failed — unexpected JSON structure.")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                if let data = response.data,
                   let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }
                completion(nil)
            }
        }
    }

    
    // MARK: - Delete Resource (ObjectMapper Version)
    func deleteResource(id: Int, completion: @escaping (CommonResponse?) -> Void) {
        let urlString = "\(global.shared.URL_DELETE_RESOURCE)\(id)"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.headers = HTTPHeaders(headers)

        let params: [String: Any] = [:]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
            request.httpBody = jsonData
        } catch {
            print("❌ Failed to encode JSON: \(error)")
            completion(nil)
            return
        }

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

            // 🧠 Parse JSON using ObjectMapper
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                if let model: CommonResponse = Mapper<CommonResponse>().map(JSONObject: jsonObject) {
                    print("✅ Parsed Response: \(model)")
                    completion(model)
                } else {
                    print("❌ Mapping failed — unexpected JSON structure.")
                    completion(nil)
                }
            } catch {
                print("❌ JSON Parsing failed: \(error)")
                if let raw = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(raw)")
                }
                completion(nil)
            }
        }.resume()
    }

    
    // MARK: - Subvendor Login
    func subvendorLogin(email: String, password: String, completion: @escaping (subVendor?) -> Void) {
        let url = global.shared.URL_LOGIN_SUBVENDOR
        let params: [String: Any] = [
            "email": email,
            "password": password
        ]

        // 🌐 Log Request Info
        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")

        AF.request(
            url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in
            // 📩 HTTP Status Code
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            // 🧾 Raw JSON Response
            if let data = response.data,
               let rawJSON = String(data: data, encoding: .utf8) {
                print("📥 Raw Response: \(rawJSON)")
            }

            // 🧠 Parse JSON → subVendor using ObjectMapper
            switch response.result {
            case .success(let json):
                if let model: subVendor = Mapper<subVendor>().map(JSONObject: json) {
                    print("✅ Parsed Subvendor Response: \(model)")
                    completion(model)
                } else {
                    print("❌ Mapping failed — unexpected JSON structure.")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                if let data = response.data,
                   let raw = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(raw)")
                }
                completion(nil)
            }
        }
    }

    
    // MARK: - Download Client Report
    func downloadClientReport(vendor_id: String, search: String, completion: @escaping (ReportDownloadModel?) -> Void) {
        let url = global.shared.URL_CLIENT_REPORT

        let params: [String: Any] = [
            "vendor_id": vendor_id,
            "search": search
        ]

        // 🌐 Log Request Info
        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(headers)")

        AF.request(
            url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in
            // 📩 Log HTTP Status Code
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            // 🧾 Log Raw Response
            if let data = response.data,
               let rawResponse = String(data: data, encoding: .utf8) {
                print("📥 Raw Response: \(rawResponse)")
            }

            // 🧠 Parse JSON → ReportDownloadModel using ObjectMapper
            switch response.result {
            case .success(let json):
                if let model: ReportDownloadModel = Mapper<ReportDownloadModel>().map(JSONObject: json) {
                    print("✅ Parsed Report Model: \(model)")
                    print("📁 Download File Name: \(model.filename ?? "N/A")")
                    completion(model)
                } else {
                    print("❌ Mapping failed — unexpected JSON structure.")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                if let data = response.data,
                   let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }
                completion(nil)
            }
        }
    }

    func ClientBookingData(customer_id: String, completion: @escaping (TodayBookingModel?) -> Void) {
        let url = global.shared.URL_CLIENT_BOOKINGS_DATA
     
        let params: [String: Any] = [
            "customer_id": customer_id
        ]
     
        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(self.headers)")
     
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                // 📩 Print HTTP response status code
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }
     
                switch response.result {
                case .success(let json):
                    // 📦 Print full response
                    if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(raw)")
                    }
     
                    // 🧠 Map JSON manually using ObjectMapper
                    if let model = Mapper<TodayBookingModel>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Mapping failed — unexpected JSON structure.")
                        completion(nil)
                    }
     
                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(raw)")
                    }
                    completion(nil)
                }
            }
    }
    
    func TodayBookings(vendorId: String, date: String, completion: @escaping (TodayBookingModel?) -> Void) {
        let url = global.shared.URL_TODAY_BOOKINGS
     
        let params: [String: Any] = [
            "vendor_id": vendorId,
            "date": date
        ]
     
        // 📦 Print request info
        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(self.headers)")
     
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
     
                // 📩 Print HTTP response status code
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }
     
                switch response.result {
                case .success(let json):
                    // 🧾 Log full response
                    if let data = response.data, let rawResponse = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(rawResponse)")
                    }
     
                    // 🧠 Parse JSON manually using ObjectMapper
                    if let model = Mapper<TodayBookingModel>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Mapping failed — unexpected JSON structure.")
                        completion(nil)
                    }
     
                case .failure(let error):
                    print("❌ API Call Failed: \(error.localizedDescription)")
                    if let data = response.data, let rawError = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(rawError)")
                    }
                    completion(nil)
                }
            }
    }
    
    func getCheckVendor(completion: @escaping (subVendor?) -> Void) {
        let url = global.shared.URL_CHECK_VENDOR

        // 🌐 Log Request Info
        print("🌐 URL: \(url)")
        print("📤 Headers: \(headers)")

        AF.request(
            url,
            method: .get,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in

            // 📩 Print HTTP response status code
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            // 🧾 Print raw response for debugging
            if let data = response.data,
               let raw = String(data: data, encoding: .utf8) {
                print("📥 Raw Response: \(raw)")
            }

            // 🧠 Parse JSON → DurationResponse using ObjectMapper
            switch response.result {
            case .success(let json):
                if let model: subVendor = Mapper<subVendor>().map(JSONObject: json) {
                    print("✅ Parsed Response Object: \(model)")
                    completion(model)
                } else {
                    print("❌ Mapping failed — unexpected JSON structure.")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    func BlockNumber(id: String,is_block:String,is_guest:String, completion: @escaping (CommonResponse?) -> Void) {
        let url = global.shared.URL_BLOCK_NUMBER
     
        let params: [String: Any] = [
            "id": id,
            "is_block": is_block,
            "is_guest": is_guest
        ]
     
        print("🌐 URL: \(url)")
        print("📤 Parameters: \(params)")
        print("📤 Headers: \(self.headers)")
     
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                // 📩 Print HTTP response status code
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }
     
                switch response.result {
                case .success(let json):
                    // 📦 Print full response
                    if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(raw)")
                    }
     
                    // 🧠 Map JSON manually using ObjectMapper
                    if let model = Mapper<CommonResponse>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Mapping failed — unexpected JSON structure.")
                        completion(nil)
                    }
     
                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(raw)")
                    }
                    completion(nil)
                }
            }
    }
    
    func getSalonTimings(completion: @escaping (SalonTimingResponse?) -> Void) {
        let url = global.shared.URL_GET_SALONTIMINGS_V1 + "/\(LocalData.userId)"

        // 🌐 Send GET Request
        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in

                // 🧾 Log Request Info
                print("🌐 URL: \(url)")
                print("📤 Headers: \(self.headers)")

                // ✅ Log HTTP Status
                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 📥 Log Raw Response
                if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }

                // 🎯 Handle Result
                switch response.result {
                case .success(let json):
                    // ✅ Map JSON using ObjectMapper
                    if let model = Mapper<SalonTimingResponse>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Mapping Failed: Could not map JSON to ShowLimitModel")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Call Failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let responseStr = String(data: data, encoding: .utf8) {
                        print("📦 Raw Response: \(responseStr)")
                    }
                    completion(nil)
                }
            }
    }
    
    func UpdateSalonTimings(salonTimingArray: String,delete_timing:String,completion: @escaping (CurrencyResponseA?) -> Void) {
        let url = global.shared.URL_UPDATE_SALONTIMINGS_V1 + "/\(LocalData.userId)"

        let jsonData = try? JSONSerialization.jsonObject(with: salonTimingArray.data(using: .utf8)!, options: [])
        
        // 📦 Parameters
        let params: [String: Any] = [
            "salon_timing": jsonData ?? [],
            "delete_timing": delete_timing,
        ]

        // 🌐 API Request
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in

                // 📋 Log Request Info
                print("🌐 URL: \(url)")
                print("📤 Parameters: \(params)")
                print("📤 Headers: \(self.headers)")

                if let httpResponse = response.response {
                    print("✅ Status Code: \(httpResponse.statusCode)")
                }

                // 🧾 Raw Response
                if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                    print("📦 Raw Response: \(responseStr)")
                }

                switch response.result {
                case .success(let json):
                    if let model = Mapper<CurrencyResponseA>().map(JSONObject: json) {
                        print("✅ Parsed Response Object: \(model)")
                        completion(model)
                    } else {
                        print("❌ Mapping Failed: Could not map JSON to CurrencyResponseA")
                        completion(nil)
                    }

                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    completion(nil)
                }
            }
    }
    
    // MARK: - Get Currency API
    func getRemindermail(completion: @escaping (Reminder?) -> Void) {
        let id = LocalData.userId
        let url = "\(global.shared.URL_GET_REMINDERMAIL)\(id)"

        // 🌐 Log Request Info
        print("🌐 URL: \(url)")
        print("📤 Headers: \(headers)")

        AF.request(
            url,
            method: .post,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in

            // 📩 Print HTTP response status code
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            // 🧾 Print raw response
            if let data = response.data,
               let raw = String(data: data, encoding: .utf8) {
                print("📥 Raw Response: \(raw)")
            }

            // 🧠 Parse JSON → CurrencyResponse using ObjectMapper
            switch response.result {
            case .success(let json):
                if let model: Reminder = Mapper<Reminder>().map(JSONObject: json) {
                    print("✅ Parsed Response Object: \(model)")
                    completion(model)
                } else {
                    print("❌ Mapping failed — unexpected JSON structure.")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    
    func getTimeGap(completion: @escaping (Reminder?) -> Void) {
        let id = LocalData.userId
        let url = "\(global.shared.URL_GET_TIMEGAP)\(id)"

        // 🌐 Log Request Info
        print("🌐 URL: \(url)")
        print("📤 Headers: \(headers)")

        AF.request(
            url,
            method: .get,
            headers: HTTPHeaders(headers)
        )
        .validate()
        .responseJSON { response in

            // 📩 Print HTTP response status code
            if let httpResponse = response.response {
                print("✅ Status Code: \(httpResponse.statusCode)")
            }

            // 🧾 Print raw response
            if let data = response.data,
               let raw = String(data: data, encoding: .utf8) {
                print("📥 Raw Response: \(raw)")
            }

            // 🧠 Parse JSON → CurrencyResponse using ObjectMapper
            switch response.result {
            case .success(let json):
                if let model: Reminder = Mapper<Reminder>().map(JSONObject: json) {
                    print("✅ Parsed Response Object: \(model)")
                    completion(model)
                } else {
                    print("❌ Mapping failed — unexpected JSON structure.")
                    completion(nil)
                }

            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    
}

