//
//  RawUserDataViewModel.swift
//  RawGithubUserDataDemo
//
//  Created by Vanita Ladkat on 21/07/20.
//  Copyright © 2020 Vanita Ladkat. All rights reserved.
//

import Foundation
import ObjectMapper

class RawUserDataViewModel {
    var userData: [RawUserDataModel]?

    func numberOfUsers() -> Int {
        return userData?.count ?? 0
    }

    func type(at index: Int) -> ContentType {
        guard index < (userData?.count ?? 0), let type = userData?[index].type else {
            return ContentType.none
        }
        return ContentType(rawValue: type) ?? ContentType.none
    }

    func data(at index: Int) -> String? {
        guard let count = userData?.count, index < count else {
            return nil
        }
        return userData?[index].data
    }

    func date(at index: Int) -> String? {
        guard let count = userData?.count, index < count else {
            return nil
        }
        return userData?[index].date
    }

    func rawUserDataModel(at index: Int) -> RawUserDataModel? {
        guard let count = userData?.count, index < count else {
            return nil
        }
        return userData?[index]
    }
    
    private func sortData(rawUserData: [RawUserDataModel]) -> [RawUserDataModel] {
        return rawUserData.sorted { (r1, r2) -> Bool in
            return r1.type ?? "" > r2.type ?? ""
        }
    }

    func getRawGithubUserData(completion: @escaping DataParsedCompletion) {
        if InternetConnectionManager.isConnectedToNetwork() {
            NetworkManager.sharedInstance.sendNetworkRequest(urlStr: WebAPI.randomPersonData, httpMethod: .get, parameters: nil) { [weak self] (success, json, error) in
                guard success == true,
                      json != nil,
                      error == nil else {
                    completion(false, error)
                    return
                }
                if let rawUserData = Mapper<RawUserDataModel>().mapArray(JSONObject: json) {
                    self?.userData = self?.sortData(rawUserData: rawUserData)
                    //save to local for next time usage in case of offline handling
                    DatabaseManager.sharedInstance.saveData(data: rawUserData)
                }
                completion(true, error)
            }
        } else {
            //get from local db:
            let userDataFromDB = DatabaseManager.sharedInstance.getData()
            self.userData = sortData(rawUserData: userDataFromDB)
            completion(true, nil)
        }
    }
}
