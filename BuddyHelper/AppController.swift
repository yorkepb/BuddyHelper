//
//  AppController.swift
//  BuddyHelper
//
//  Created by iYrke on 5/17/17.
//  Copyright © 2017 iYrke. All rights reserved.
//

import Cocoa

final class AppController {

    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let popover = NSPopover()

    let remoteServiceCoordinator = RemoteServiceCoordinator()

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        if let button = statusItem.button {
            button.image = NSImage(named: "icon")
            button.action = #selector(togglePopover(sender:))
        }

        //let helperVC = HelperViewController(nibName: "HelperViewController", bundle: nil)
        //helperVC?.remoteServiceCoordinator = remoteServiceCoordinator
        popover.contentViewController = HelperViewController(nibName: "HelperViewController", bundle: nil)

        remoteServiceCoordinator.setUp()
    }

    @objc func togglePopover(sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }

    func showPopover(_ sender: AnyObject?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }

    func closePopover(_ sender: AnyObject?) {
        popover.performClose(sender)
    }
}
