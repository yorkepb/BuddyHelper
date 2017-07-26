//
//  RemoteServiceCoordinator.swift
//  BuddyHelper
//
//  Created by iYrke on 5/17/17.
//  Copyright © 2017 iYrke. All rights reserved.
//

import Foundation

final class RemoteServiceCoordinator {
    var apps: [BuddyApp] = []

    func setUp() {
        RequestSerializer.appsRequest().map {
            let session = URLSession(configuration: .default)
            session.dataTask(with: $0) { (data, response, error) in
                let json = data.map {
                    try? JSONSerialization.jsonObject(with: $0, options: [])
                }

                (json as? [[AnyHashable: AnyObject]])?.forEach {
                    BuddyApp.from($0).map { self.apps.append($0) }
                }
            }.resume()
        }
    }

    func branches(for appName: String, completion: @escaping ([BuddyBranch]) -> Void) {
        (apps.app(from: appName) as? BuddyApp).map {
            RequestSerializer.branchesRequest(for: $0).map {
                let session = URLSession(configuration: .default)
                session.dataTask(with: $0) { (data, urlResponse, error) in
                    let json = data.map {
                        try? JSONSerialization.jsonObject(with: $0, options: [])
                    }

                    var branches: [BuddyBranch] = []
                    (json as? [[AnyHashable: AnyObject]])?.forEach {
                        BuddyBranch.from($0).map { branches.append($0) }
                    }

                    completion(branches)
                }.resume()
            }
        }
    }

    func build(app: BuddyApp, branch: String) {
        RequestSerializer.buildRequest(for: app, branch: branch).map {
            let session = URLSession(configuration: .default)
            session.dataTask(with: $0) { (data, urlRequest, error) in
                print("the data received: \(String(describing: data))")
            }.resume()
        }
    }
}
