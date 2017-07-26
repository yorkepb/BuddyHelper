//
//  BuddyApp.swift
//  BuddyHelper
//
//  Created by iYrke on 5/17/17.
//  Copyright © 2017 iYrke. All rights reserved.
//

struct BuddyApp: NamedObject {
    let name: String
    let identifier: String
}

extension BuddyApp {
    enum Keys: String {
        case identifier = "_id"
        case name = "app_name"
    }

    static func from(_ json: [AnyHashable: AnyObject]) -> BuddyApp? {
        return (json[Keys.identifier.rawValue] as? String).flatMap { identifier in
            return (json[Keys.name.rawValue] as? String).map {
                return BuddyApp(name: $0, identifier: identifier)
            } ?? nil
        }
    }
}
