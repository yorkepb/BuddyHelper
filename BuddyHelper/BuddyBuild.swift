//
//  BuddyBuild.swift
//  BuddyHelper
//
//  Created by iYrke on 5/29/17.
//  Copyright © 2017 iYrke. All rights reserved.
//

import Foundation

struct BuddyBuild {
    enum Status: String {
        case queued
        case running
        case success
        case cancelled
        case failed
    }

    let identifier: String
    let appIdentifier: String
    let status: Status
    let branch: BuddyBranch
    let testsCount: Int
    let testsPassed: Int

    var buildURL: URL? {
        return URL(string: "https://dashboard.buddybuild.com/apps/\(appIdentifier)/\(identifier)")
    }
}

extension BuddyBuild {
    enum Keys: String {
        case identifier = "_id"
        case appIdentifier = "app_id"
        case status = "build_status"
        case commit = "commit_info"
        case branch
        case tests = "test_summary"
        case testsCount = "tests_count"
        case testsPassed = "tests_passed"
    }

    static func from(_ json: [AnyHashable: AnyObject]) -> BuddyBuild? {
        guard let identifier = json[Keys.identifier.rawValue] as? String,
            let appIdentifier = json[Keys.appIdentifier.rawValue] as? String,
            let status = Status(rawValue: String(describing: json[Keys.status.rawValue])),
            let commit = json[Keys.commit.rawValue] as? [String: AnyObject],
            let branch = commit[Keys.branch.rawValue] as? String,
            let tests = json[Keys.tests.rawValue] as? [String: AnyObject],
            let testsCount = tests[Keys.testsCount.rawValue] as? Int,
            let testsPassed = tests[Keys.testsPassed.rawValue] as? Int

        else { return nil }

        return BuddyBuild(identifier: identifier, appIdentifier: appIdentifier, status: status, branch: BuddyBranch(name: branch), testsCount: testsCount, testsPassed: testsPassed)
    }
}

extension BuddyBuild: Equatable {}

func == (lhs: BuddyBuild, rhs: BuddyBuild) -> Bool {
    return lhs.identifier == rhs.identifier
    && lhs.appIdentifier == rhs.appIdentifier
    && lhs.status == rhs.status
    && lhs.branch == rhs.branch
    && lhs.testsCount == rhs.testsCount
    && lhs.testsPassed == rhs.testsPassed
}

extension BuddyBuild: Hashable {
    var hashValue: Int {
        return identifier.hashValue ^ appIdentifier.hashValue ^ status.hashValue ^ branch.hashValue ^ testsCount.hashValue ^ testsPassed.hashValue
    }
}

extension BuddyBuild.Status: Comparable {
    static func < (lhs: BuddyBuild.Status, rhs: BuddyBuild.Status) -> Bool {
        switch (lhs, rhs) {
        case (.queued, .queued): return false
        case (.queued, _): return true

        case (.running, .running): return false
        case (.running, .queued): return false
        case (.running, _): return true

        case (.success, .success): return false
        case (.success, .queued): return false
        case (.success, .running): return false
        case (.success, _): return true

        case (.cancelled, .cancelled): return false
        case (.cancelled, .failed): return true
        case (.cancelled, _): return false

        case (.failed, _): return false
        }
    }

    static func <= (lhs: BuddyBuild.Status, rhs: BuddyBuild.Status) -> Bool {
        return lhs < rhs || lhs == rhs
    }

    static func > (lhs: BuddyBuild.Status, rhs: BuddyBuild.Status) -> Bool {
        switch (lhs, rhs) {
        case (.queued, _): return false

        case (.running, .running): return false
        case (.running, .queued): return true
        case (.running, _): return false

        case (.success, .success): return false
        case (.success, .queued): return true
        case (.success, .running): return true
        case (.success, _): return false

        case (.cancelled, .cancelled): return false
        case (.cancelled, .failed): return false
        case (.cancelled, _): return true

        case (.failed, .failed): return false
        case (.failed, _): return true
        }
    }

    static func >= (lhs: BuddyBuild.Status, rhs: BuddyBuild.Status) -> Bool {
        return lhs > rhs || lhs == rhs
    }
}
