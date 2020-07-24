//
//  DatabaseManager.swift
//  Articles_Demo_Vanita
//
//  Created by Vanita Ladkat on 12/07/20.
//  Copyright © 2020 Vanita Ladkat. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import ObjectMapper

protocol DbManager {
    associatedtype DataType
    func getData() -> [DataType]
    func saveData(data: [DataType])
}

class DatabaseManager: DbManager {
    static let sharedInstance = DatabaseManager()
    private init() {}

    private func fetchUserData() -> [UserData]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<UserData> = UserData.fetchRequest()
        let userData = try? context.fetch(request)
        return userData
    }

    private func insertUserData(rawuserModel: RawUserDataModel) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let entityDecription = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: context)
        entityDecription.setValue(rawuserModel.id, forKey: "id")
        entityDecription.setValue(rawuserModel.type, forKey: "type")
        entityDecription.setValue(rawuserModel.data, forKey: "data")
        entityDecription.setValue(rawuserModel.date, forKey: "date")
        do {
            try context.save()
        } catch {
            print("error while insterting data")
        }
        print("record saved")
    }

    private func deleteAllUserData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
        print("all records deleted")
    }

    private func convertToJSONArray(moArray: [NSManagedObject]) -> Any {
        var jsonArray: [[String: Any]] = []
        for item in moArray {
            var dict: [String: Any] = [:]
            for attribute in item.entity.attributesByName {
                //check if value is present, then add key to dictionary so as to avoid the nil value crash
                if let value = item.value(forKey: attribute.key) {
                    dict[attribute.key] = value
                }
            }
            jsonArray.append(dict)
        }
        return jsonArray
    }

    func getData() -> [RawUserDataModel] {
        var jsonArray: [RawUserDataModel] = []
        if let moArray = fetchUserData() {
            let convertedJson = convertToJSONArray(moArray: moArray)
            if let result = Mapper<RawUserDataModel>().mapArray(JSONObject: convertedJson) {
                jsonArray += result
            }
        }
        return jsonArray
    }

    func saveData(data: [RawUserDataModel]) {
        deleteAllUserData() //first clear previous data
        for rawUserData in data {
            insertUserData(rawuserModel: rawUserData)
        }
    }

}
