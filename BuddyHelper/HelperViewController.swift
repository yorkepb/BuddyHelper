//
//  HelperViewController.swift
//  BuddyHelper
//
//  Created by iYrke on 5/17/17.
//  Copyright © 2017 iYrke. All rights reserved.
//

import Cocoa

class HelperViewController: NSViewController {

    @IBOutlet private var appList: NSPopUpButton!
    @IBOutlet private var branchList: NSComboBox!
    @IBOutlet private var followViewConstraint: NSLayoutConstraint!
    @IBOutlet private var followArrow: NSButton!
    @IBOutlet private var queueViewConstraint: NSLayoutConstraint!
    @IBOutlet private var queueArrow: NSButton!

    let preferenceMenu = NSMenu()

    var remoteServiceCoordinator: RemoteServiceCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        appList.addItems(withTitles: remoteServiceCoordinator?.apps.map { $0.name } ?? [])
        appList.select(appList.menu?.item(withTitle: "NYTimes"))
        fetchBranchListAndSetup(for: "NYTimes")

        toggleViewAndRotateArrow(viewConstraint: queueViewConstraint, arrow: queueArrow)
        setupSettings()
    }

    override func viewWillAppear() {
        super.viewWillAppear()

        (appList.selectedItem?.title).map {
            fetchBranchListAndSetup(for: $0)
        }
    }

    func setupSettings() {
        let preferencesMenuItem = NSMenuItem(title: "Preferences...", action: #selector(doSomething), keyEquivalent: "")
        let aboutMenuItem = NSMenuItem(title: "About", action: #selector(doSomething), keyEquivalent: "")
        let quitAppMenuItem = NSMenuItem(title: "Quit", action: #selector(quit(_:)), keyEquivalent: "")

        preferenceMenu.addItem(preferencesMenuItem)
        preferenceMenu.addItem(aboutMenuItem)
        preferenceMenu.addItem(quitAppMenuItem)
    }

    func setupBranchList(with branches: [BuddyBranch]) {
        branchList.removeAllItems()
        branches.forEach {
            branchList.addItem(withObjectValue: $0.name)
        }

        branchList.selectItem(at: 0)
    }

    func doSomething() {

    }

    @IBAction func showPreferencesMenu(sender: NSButton) {
        let p = NSPoint(x: sender.frame.origin.x, y: sender.frame.origin.y - (sender.frame.height / 2))
        preferenceMenu.popUp(positioning: nil, at: p, in: sender.superview)
    }

    @IBAction func appDidChange(sender: NSPopUpButton?) {
        (sender?.selectedItem?.title).map {
            fetchBranchListAndSetup(for: $0)
        }
    }

    func quit(_ sender: Any?) {
        NSApplication.shared().terminate(sender)
    }

    @IBAction func build(sender: Any?) {
        (appList.selectedItem?.title).map {
            (remoteServiceCoordinator?.apps.app(from: $0) as? BuddyApp).map {
                if let branch = branchList.objectValueOfSelectedItem as? String {
                    remoteServiceCoordinator?.build(app: $0, branch: branch)
                }
            }
        }
    }

    func fetchBranchListAndSetup(for appName: String) {
        remoteServiceCoordinator?.branches(for: appName) { [weak self] branches in
            DispatchQueue.main.async {
                self?.setupBranchList(with: branches)
            }
        }
    }

    @IBAction func toggleFollowView(sender: Any?) {
        toggleViewAndRotateArrow(viewConstraint: followViewConstraint, arrow: followArrow)
    }

    @IBAction func toggleQueueView(sender: Any?) {
        toggleViewAndRotateArrow(viewConstraint: queueViewConstraint, arrow: queueArrow)
    }

    func toggleViewAndRotateArrow(viewConstraint: NSLayoutConstraint, arrow: NSButton) {
        if viewConstraint.constant > 0 {
            viewConstraint.constant = 0
            arrow.rotate(byDegrees: -90)
        } else {
            viewConstraint.constant = 50
            arrow.rotate(byDegrees: 90)
        }
    }
}
