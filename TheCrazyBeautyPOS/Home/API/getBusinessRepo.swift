//
//  getBusinessRepo.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 13/06/25.
//

import Foundation
import Alamofire
import ObjectMapper

func getBusinessRepo(completion: @escaping (ServicesModel?) -> Void) {
    let url = global.shared.URL_BUSINESS_SERVICES // Replace with `Services.business_services`

    AF.request(url, method: .get).responseJSON { response in
        switch response.result {
        case .success(let value):
            if let json = value as? [String: Any] {
                let model = ServicesModel(JSON: json)
                completion(model)
            } else {
                print("Invalid JSON structure")
                completion(nil)
            }
        case .failure(let error):
            print("API call failed: \(error)")
            completion(nil)
        }
    }
}
