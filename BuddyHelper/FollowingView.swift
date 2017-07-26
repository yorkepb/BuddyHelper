//
//  FollowingView.swift
//  BuddyHelper
//
//  Created by iYrke on 5/26/17.
//  Copyright © 2017 iYrke. All rights reserved.
//

import Cocoa

final class FollowingView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        NSColor.white.setFill()
        NSRectFill(dirtyRect)
        super.draw(dirtyRect)
    }
}
