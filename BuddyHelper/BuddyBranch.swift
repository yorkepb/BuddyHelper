//
//  BuddyBranch.swift
//  BuddyHelper
//
//  Created by iYrke on 5/17/17.
//  Copyright © 2017 iYrke. All rights reserved.
//

struct BuddyBranch: NamedObject {
    let name: String
}

extension BuddyBranch {
    enum Keys: String {
        case name
    }

    static func from(_ json: [AnyHashable: AnyObject]) -> BuddyBranch? {
        return (json[Keys.name.rawValue] as? String).map { BuddyBranch(name: $0) }
    }
}

extension BuddyBranch: Equatable {}

func == (lhs: BuddyBranch, rhs: BuddyBranch) -> Bool {
    return lhs.name == rhs.name
}

extension BuddyBranch: Hashable {
    var hashValue: Int {
        return name.hashValue
    }
}
