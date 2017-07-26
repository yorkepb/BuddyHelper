//
//  SeparatorView.swift
//  BuddyHelper
//
//  Created by iYrke on 5/26/17.
//  Copyright © 2017 iYrke. All rights reserved.
//

import Cocoa

final class SeparatorView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        NSColor(calibratedRed: 192/255, green: 194/255, blue: 197/255, alpha: 1.0).setFill()
        NSRectFill(dirtyRect)
        super.draw(dirtyRect)
    }
}
