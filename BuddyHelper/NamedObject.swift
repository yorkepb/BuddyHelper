//
//  NamedObject.swift
//  BuddyHelper
//
//  Created by iYrke on 5/17/17.
//  Copyright © 2017 iYrke. All rights reserved.
//

protocol NamedObject {
    var name: String { get }
}

extension Array where Element: NamedObject {
    func app(from name: String) -> NamedObject? {
        return first { $0.name == name }
    }
}
