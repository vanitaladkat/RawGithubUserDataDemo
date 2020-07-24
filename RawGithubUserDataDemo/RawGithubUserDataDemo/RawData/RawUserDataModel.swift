//
//  RawUserDataModel.swift
//  RawGithubUserDataDemo
//
//  Created by Vanita Ladkat on 21/07/20.
//  Copyright © 2020 Vanita Ladkat. All rights reserved.
//

import Foundation
import ObjectMapper

enum ContentType: String {
    case image
    case text
    case other
    case none
}

struct RawUserDataModel: Mappable {
    var id: String?
    var type: String?
    var date: String?
    var data: String?

    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        type <- map["type"]
        date <- map["date"]
        data <- map["data"]
    }

    func contentType() -> ContentType {
        guard let type = self.type else {
            return .none
        }
        return ContentType(rawValue: type) ?? .none
    }
}
