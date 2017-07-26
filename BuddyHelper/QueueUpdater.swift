//
//  QueueUpdater.swift
//  BuddyHelper
//
//  Created by iYrke on 5/29/17.
//  Copyright © 2017 iYrke. All rights reserved.
//

import Foundation

typealias QueueUpdateCompletion = ([BuddyBuild]) -> Void

final class QueueUpdater {

    init() {

    }

    let updateQueue = DispatchQueue(label: "com.buddyhelper.update.queue")
    let completionQueue = DispatchQueue(label: "com.buddyhelper.update.completion.queue")

    var shouldAutoUpdate: Bool {
        get { return completionQueue.sync { self._shouldAutoUpdate } }
        set { completionQueue.sync { self._shouldAutoUpdate = newValue } }
    }

    var _shouldAutoUpdate: Bool = false

    var updating: Bool {
        get { return completionQueue.sync { self._updating } }
        set { completionQueue.sync { self._updating = newValue } }
    }

    var _updating: Bool = false

    var completions: [QueueUpdateCompletion] {
        get { return completionQueue.sync { self._completions } }
        set { completionQueue.sync { self._completions = newValue } }
    }

    private var _completions: [QueueUpdateCompletion] = []

    var builds: [BuddyBuild] {
        get { return completionQueue.sync { self._builds } }
        set { completionQueue.sync { self._builds = newValue } }
    }

    private var _builds: [BuddyBuild] = []

    func start(for buddyApps: [BuddyApp]) {
        updating = true


        /// TODO: How do we know when it is done?!?!? Need to figure that out so thzt the completion can be called
        updateQueue.async {
            buddyApps.forEach {
                self.requestBuilds(for: $0)
            }
        }
    }

    func requestBuilds(for buddyApp: BuddyApp) {
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

extension QueueUpdater {
    func updateQueue(completion: @escaping QueueUpdateCompletion) {
        completions += [completion]
        guard updating else { return start(for: []) }
    }
}



/**
 Updater has a queue
 updateW/Completion -> is queue empty? Yes -> start(); No -> Add completion to array of completions -> Bail
 start -> download all builds for all apps and merge together -> Call Completions (on completions queue) -> isAutoBuild? Yes -> dispatch_after: Start; No -> Bail


 **/
