//
//  Line.swift
//  BatteryLevel
//
//  Created by Maxime Moison on 10/3/17.
//  Copyright © 2017 Maxime Moison. All rights reserved.
//

import Cocoa

class Line: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        let path = NSBezierPath()
        path.move(to: NSPoint(x: dirtyRect.minX, y: dirtyRect.midY))
        path.line(to: NSPoint(x: dirtyRect.maxX, y: dirtyRect.midY))
        path.lineWidth = 1
        NSColor.white.setStroke()
        path.stroke()
    }
    
}
