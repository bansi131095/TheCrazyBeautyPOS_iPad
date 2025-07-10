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
    
    func getCurrency(completion: @escaping (CurrencyModel?) -> Void) {
        let url = global.shared.URL_GET_CURRENCY + "/\(LocalData.userId)"

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
    
    func UpdateCurrency(currency: String,symbol: String,vendorId: String, completion: @escaping (CurrencyResponse?) -> Void) {
        let url = global.shared.URL_UPDATE_CURRENCY
        
        let params: [String: Any] = [
                "currency": currency,
                "symbol": symbol,
                "vendor_id": vendorId
            ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CurrencyResponse, AFError>) in

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
    
    
    func UpdateBookingFlow(booking_flow: Int,vendorId: String, completion: @escaping (CurrencyResponse?) -> Void) {
        let url = global.shared.URL_UPDATE_BOOKINGFLOW
        
        let params: [String: Any] = [
                "booking_flow": booking_flow,
                "vendor_id": vendorId
            ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CurrencyResponse, AFError>) in

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
    
    
    func UpdateBankDetails(accountNumber: String,accountHolderName: String,completion: @escaping (CurrencyResponse?) -> Void
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
            .responseObject { (response: DataResponse<CurrencyResponse, AFError>) in

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
    
    func UpdateNotes(vendorId: String, notes: String, completion: @escaping (CurrencyResponse?) -> Void) {
        let url = global.shared.URL_UPDATE_NOTES

        // Prepare parameters
        let params: [String: Any] = [
            "vendor_id": vendorId,
            "notes": notes
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CurrencyResponse, AFError>) in

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
    
    
    
    func UpdateAmount(vendorId: String, amount: String, penaltyFees: String, penaltyDuration: String, cancellationPolicy: String, completion: @escaping (CurrencyResponse?) -> Void) {
        let url = global.shared.URL_UPDATE_Amount

        let params: [String: Any] = [
            "vendor_id": vendorId,
            "amount": amount,
            "penalty_fees": penaltyFees,
            "penalty_duration": penaltyDuration,
            "cancellation_policy": cancellationPolicy
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CurrencyResponse, AFError>) in

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
    
    func updateStaffSequence(staffSequenceList: [[String: String]], vendorid:String, completion: @escaping (CurrencyResponse?) -> Void) {
        
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
        
        // Parameters
        let params: [String: Any] = [
            "staff_sequence": staffSequenceJSONString,
            "vendor_id" : vendorid
        ]
        
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CurrencyResponse, AFError>) in
            
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

 
    
    func updateTimeGap(vendorId: String,time_gap: String, completion: @escaping (CurrencyResponse?) -> Void) {
        let url = global.shared.URL_UPDATE_TIMEGAP

        let params: [String: Any] = [
            "vendor_id": vendorId,
            "time_gap": time_gap,
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CurrencyResponse, AFError>) in

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
 
    func ChangePassword(vendorId: String, new_pass: String,old_pass: String, completion: @escaping (CurrencyResponse?) -> Void) {
        let url = global.shared.URL_CHANGE_PASSWORD

        // Prepare parameters
        let params: [String: Any] = [
            "vendor_id": vendorId,
            "new_pass": new_pass,
            "old_pass": old_pass,
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CurrencyResponse, AFError>) in

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
    
    /*func uploadSalonImages(vendorId: String,
                           photo: UIImage?,
                           photos: [UIImage],
                           otherPhotos: [String],
                           completion: @escaping (CurrencyResponse?) -> Void) {
        
        let url = global.shared.URL_ADD_IMAGE + "/\(LocalData.userId)"
        
        
        AF.upload(multipartFormData: { multipartFormData in
            
            // Add vendor_id
            multipartFormData.append(Data(vendorId.utf8), withName: "vendor_id")
            
            // Add main photo (optional)
            if let mainPhoto = photo {
                if let pngData = mainPhoto.pngData() {
                    multipartFormData.append(pngData, withName: "photo", fileName: "photo.png", mimeType: "image/png")
                } else if let jpegData = mainPhoto.jpegData(compressionQuality: 0.8) {
                    multipartFormData.append(jpegData, withName: "photo", fileName: "photo.jpg", mimeType: "image/jpeg")
                }
            }
            
            // Add multiple new photos
            for (index, image) in photos.enumerated() {
                if let pngData = image.pngData() {
                    multipartFormData.append(pngData, withName: "photos[]", fileName: "photo_\(index).png", mimeType: "image/png")
                } else if let jpegData = image.jpegData(compressionQuality: 0.8) {
                    multipartFormData.append(jpegData, withName: "photos[]", fileName: "photo_\(index).jpg", mimeType: "image/jpeg")
                }
            }
            
            // Add already uploaded image names
            if let jsonData = try? JSONSerialization.data(withJSONObject: otherPhotos, options: []),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                multipartFormData.append(Data(jsonString.utf8), withName: "other_photos")
            }
            
        }, to: url, method: .post, headers: HTTPHeaders(headers))
        .responseObject { (response: DataResponse<CurrencyResponse, AFError>) in
            
            print("🌐 URL: \(url)")
            
            
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
                print("❌ Upload Failed: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }*/

    /*func uploadSalonImages(
        photo: UIImage?,
        otherPhotos: [String],   // filenames to retain
        photos: [UIImage],       // new gallery images
        completion: @escaping (CurrencyResponse?) -> Void
    ) {
        let url = global.shared.URL_ADD_IMAGE + "/\(LocalData.userId)"
        print("📤 Uploading to: \(url)")

        AF.upload(multipartFormData: { multipartFormData in

            // ✅ 1. Main profile image
            if let profileImage = photo,
               let imageData = profileImage.jpegData(compressionQuality: 0.7) {
                multipartFormData.append(imageData, withName: "photo", fileName: "main_photo.jpg", mimeType: "image/jpeg")
                print("✅ photo: main_photo.jpg")
            }

            // ✅ 2. other_photos as JSON string (text field)
            let jsonString = try? JSONSerialization.data(withJSONObject: otherPhotos)
            if let jsonData = jsonString,
               let stringValue = String(data: jsonData, encoding: .utf8) {
                multipartFormData.append(Data(stringValue.utf8), withName: "other_photos")
                print("✅ other_photos: \(stringValue)")
            }

            // ✅ 3. photos (multiple binary files)
            for (index, image) in photos.enumerated() {
                if let imageData = image.jpegData(compressionQuality: 0.7) {
                    let fileName = "gallery_\(index).jpg"
                    multipartFormData.append(imageData, withName: "\(photos)[]", fileName: fileName, mimeType: "image/jpeg")
                    print("✅ photos: \(fileName)")
                }
            }

        }, to: url, method: .post, headers: HTTPHeaders(headers))
        .responseJSON { response in
            switch response.result {
            case .success(let json):
                print("🎉 Upload success: \(json)")
                let mapped = Mapper<CurrencyResponse>().map(JSONObject: json)
                completion(mapped)

            case .failure(let error):
                print("❌ Upload failed: \(error.localizedDescription)")
                if let data = response.data, let text = String(data: data, encoding: .utf8) {
                    print("📦 Server response: \(text)")
                }
                completion(nil)
            }
        }
    }*/

    /*func uploadSalonImages(
        photo: UIImage?,              // main profile image
        otherPhotos: [String],        // filenames of images to retain
        photos: [UIImage],            // actual image files to upload
        completion: @escaping (CurrencyResponse?) -> Void
    ) {
        let url = global.shared.URL_ADD_IMAGE + "/\(LocalData.userId)"
        print("📤 Uploading to: \(url)")

        AF.upload(multipartFormData: { multipartFormData in

            // ✅ 1. Add 'photo' (main image)
            if let profileImage = photo,
               let imageData = profileImage.jpegData(compressionQuality: 0.7) {
                multipartFormData.append(imageData, withName: "photo", fileName: "photo.jpg", mimeType: "image/jpeg")
                print("✅ Sent: photo.jpg")
            }

            // ✅ 2. Add 'photos' (multiple gallery images)
            for (index, image) in photos.enumerated() {
                if let imgData = image.jpegData(compressionQuality: 0.7) {
                    let fileName = "gallery_\(index)_\(Int(Date().timeIntervalSince1970)).jpg"
                    multipartFormData.append(imgData, withName: "photos", fileName: fileName, mimeType: "image/jpeg")
                    print("✅ Sent: photos = \(fileName)")
                }
            }

            // ✅ 3. Add 'other_photos' (JSON string of filenames)
            if let jsonData = try? JSONSerialization.data(withJSONObject: otherPhotos, options: []),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                multipartFormData.append(Data(jsonString.utf8), withName: "other_photos")
                print("✅ Sent: other_photos = \(jsonString)")
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
                print("❌ Upload Error: \(error.localizedDescription)")
                if let data = response.data, let string = String(data: data, encoding: .utf8) {
                    print("📦 Server says: \(string)")
                }
                completion(nil)
            }
        }
    }*/

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
    

    func UpdateReminderMail(reminder_mail: String,vendorId: String, completion: @escaping (CurrencyResponse?) -> Void) {
        let url = global.shared.URL_UPDATE_REMINDERMAIL
        
        let params: [String: Any] = [
                "reminder_mail": reminder_mail,
                "vendor_id": vendorId
            ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CurrencyResponse, AFError>) in

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
        let url = global.shared.URL_SELECT_MAINCATEGORY + "/\(LocalData.userId)"

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
    
    func updateCategoryDescription(category_description: [[String: String]], vendorid:String, completion: @escaping (CurrencyResponse?) -> Void) {
        
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
            .responseObject { (response: DataResponse<CurrencyResponse, AFError>) in
            
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
    
    func UpdateCreateSubvendor(email: String,name: String,password: String,vendorId: String, completion: @escaping (CurrencyResponse?) -> Void) {
        let url = global.shared.URL_UPDATE_SUBVENDOR
        
        let params: [String: Any] = [
                "email": email,
                "name": name,
                "password": password,
                "vendor_id": vendorId
            ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CurrencyResponse, AFError>) in

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
    
    
    func UpdateAddKiosk(email: String,password: String,vendorId: String, completion: @escaping (CurrencyResponse?) -> Void) {
        let url = global.shared.URL_UPDATE_ADD_KIOSK
        
        let params: [String: Any] = [
                "email": email,
                "password": password,
                "vendor_id": vendorId
            ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CurrencyResponse, AFError>) in

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
                let workingHours = self.parseWorkingHours(jsonString)
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
    
    func parseWorkingHours(_ jsonString: String) -> [WorkingHour1] {
        guard let data = jsonString.data(using: .utf8),
              let array = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
            return []
        }
        return Mapper<WorkingHour1>().mapArray(JSONArray: array)
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
    
    /*func UpdateOpenDate(vendor_id: String, opening_date: String, completion: @escaping (CurrencyResponse?) -> Void) {
        let url = global.shared.URL_UPDATE_OPENDATE
        let params: [String: Any] = ["vendor_id": vendor_id, "opening_date": opening_date]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CurrencyResponse, AFError>) in

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
//                    completion(result.data)
                case .failure(let error):
                    print("❌ Error: \(error.localizedDescription)")
                    completion(nil)
                }
            }
    }*/
    
    func UpdateOpenDate(vendor_id: String,opening_date: String,completion: @escaping (CurrencyResponse?) -> Void) {
        let url = global.shared.URL_UPDATE_OPENDATE
        
        let params: [String: Any] = [
                "vendor_id": vendor_id,
                "opening_date": opening_date
            ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CurrencyResponse, AFError>) in

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
 
    func UpdateBusinessInformation(id: String,salon_name: String,salon_type:String,phone:String,salon_phone:String,postcode:String,address:String,city:String,country:String,latitude:String,longitude:String,web_status:String,allow_search:String,time_gap:String,reminder_mail:String,about_us:String, completion: @escaping (CurrencyResponse?) -> Void) {
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
                "about_us": about_us
            ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .responseObject { (response: DataResponse<CurrencyResponse, AFError>) in

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
    
}

