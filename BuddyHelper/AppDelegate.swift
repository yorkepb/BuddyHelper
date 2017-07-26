//
//  AppDelegate.swift
//  BuddyHelper
//
//  Created by iYrke on 5/16/17.
//  Copyright © 2017 iYrke. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let popover = NSPopover()
    let remoteServiceCoordinator = RemoteServiceCoordinator()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named: "icon")
            button.action = #selector(togglePopover(sender:))
        }

        let helperVC = HelperViewController(nibName: "HelperViewController", bundle: nil)
        popover.contentViewController = helperVC
        helperVC?.remoteServiceCoordinator = remoteServiceCoordinator
        remoteServiceCoordinator.setUp()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func togglePopover(sender: AnyObject?) {
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

