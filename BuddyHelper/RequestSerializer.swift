//
//  RequestSerializer.swift
//  BuddyHelper
//
//  Created by iYrke on 5/17/17.
//  Copyright © 2017 iYrke. All rights reserved.
//

import Foundation

private let baseURLString = "https://api.buddybuild.com/v1/"

enum RequestSerializer {
    fileprivate enum API {
        case apps
        case branches(appIdentifier: String)
        case executeBuild(appIdentifier: String)
        case listBuilds(appIdentifier: String)

        var url: URL? {
            switch self {
            case .apps:
                return URL(string: "\(baseURLString)apps")
            case .branches(let appIdentifier):
                return URL(string: "\(baseURLString)apps/\(appIdentifier)/branches")
            case .executeBuild(let appIdentifier):
                return URL(string: "\(baseURLString)apps/\(appIdentifier)/build")
            case .listBuilds(let appIdentifier):
                return URL(string: "\(baseURLString)apps/\(appIdentifier)/builds?limit=50")
            }
        }
    }

    fileprivate static func request(for api: API) -> URLRequest? {
        var request = api.url.map {
            URLRequest(url: $0) 
        }

        return request
    }
}

extension RequestSerializer {
    static func appsRequest() -> URLRequest? {
        return request(for: .apps)
    }

    static func branchesRequest(for buddyApp: BuddyApp) -> URLRequest? {
        return request(for: .branches(appIdentifier: buddyApp.identifier))
    }

    static func buildRequest(for buddyApp: BuddyApp, branch: String) -> URLRequest? {
        var buildRequest = request(for: .executeBuild(appIdentifier: buddyApp.identifier))
        buildRequest?.httpBody = "branch=\(branch)".data(using: .utf8)
        buildRequest?.httpMethod = "POST"
        return buildRequest
    }

    static func listBuildsRequest(for buddyApp: BuddyApp) -> URLRequest? {
        return request(for: .listBuilds(appIdentifier: buddyApp.identifier))
    }
}
