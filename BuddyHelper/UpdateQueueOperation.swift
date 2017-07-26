//
//  UpdateQueueOperation.swift
//  BuddyHelper
//
//  Created by iYrke on 5/29/17.
//  Copyright © 2017 iYrke. All rights reserved.
//

import Foundation

final class UpdateQueueOperation: Operation {
    let buddyApp: BuddyApp

    var builds: [BuddyBuild] = []

    init(buddyApp: BuddyApp) {
        self.buddyApp = buddyApp
    }

    override func main() {
        RequestSerializer.listBuildsRequest(for: buddyApp).map {
            let session = URLSession(configuration: .default)
            session.dataTask(with: $0) { (data, urlResponse, error) in
                let json = data.map {
                    try? JSONSerialization.jsonObject(with: $0, options: [])
                }

                (json as? [[AnyHashable: AnyObject]])?.forEach {
                    BuddyBuild.from($0).map {
                        self.builds.append($0)
                    }
                }
            }.resume()
        }
    }
}
