//
//  NetworkManager.swift
//  Articles_Demo_Vanita
//
//  Created by Vanita Ladkat on 11/07/20.
//  Copyright © 2020 Vanita Ladkat. All rights reserved.
//

import Foundation
import Alamofire

typealias NetworkCompletionHander = (_ success: Bool, _ response: Any?, _ error: Error?) -> Void
typealias DataParsedCompletion = (_ success: Bool, _ error: Error?) -> Void

enum NetworkError: Error {
    case paramMissing
    case invalidUrl
}

struct WebAPI {
    static let randomPersonData = "https://raw.githubusercontent.com/AxxessTech/Mobile-Projects/master/challenge.json"
}

class NetworkManager {
    static let sharedInstance = NetworkManager()
    private init() {}
    
    func sendNetworkRequest(urlStr: String, httpMethod: HTTPMethod, parameters: [String: Any]?, completionHanlder: @escaping NetworkCompletionHander) {
        guard let url = URL(string: urlStr) else {
            completionHanlder(false, nil, NetworkError.invalidUrl)
            return
        }
        
        AF.request(url, method: httpMethod, parameters: parameters,  headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(let json):
                completionHanlder(true, json, nil)
            case .failure(let error):
                completionHanlder(false, nil, error)
            }
        }
    }
}
