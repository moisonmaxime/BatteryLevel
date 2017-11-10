//
//  BatteryView.swift
//  ToolBar
//
//  Created by Maxime Moison on 10/3/17.
//  Copyright © 2017 Maxime Moison. All rights reserved.
//

import Cocoa

class BatteryView: NSView {

    var capacity:Double = 0
    var isPlugged = false
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        var primaryColor:NSColor = .white
        var secondaryColor:NSColor = .white
        
        if (capacity == 1.0) {
            primaryColor = NSColor.green.withAlphaComponent(0.9)
        } else if (capacity < 0.2){
            primaryColor = NSColor.red.withAlphaComponent(0.9)
            secondaryColor = NSColor.red.withAlphaComponent(0.9)
        }
        
        if (isPlugged) {
            primaryColor = NSColor.green.withAlphaComponent(0.9)
            secondaryColor = NSColor.green.withAlphaComponent(0.9)
        }
        
        secondaryColor.setFill()
        secondaryColor.setStroke()
        
        var p = NSBezierPath()
        let f = dirtyRect.insetBy(dx: 5, dy: 5)
        
        p.appendArc(withCenter: NSPoint(x: f.maxX, y: f.midY), radius: 3, startAngle: 270, endAngle: 90)
        p.close()
        p.fill()
        
        primaryColor.setFill()
        
        p = NSBezierPath(roundedRect: f, xRadius: 2, yRadius: 2)
        p.lineWidth = 1
        p.stroke()
        p = NSBezierPath()
        
        var clipRect = f.insetBy(dx: 1.5, dy: 1.5)
        let context = NSGraphicsContext.current?.cgContext
        clipRect.size.width = clipRect.size.width * CGFloat(capacity)
        context?.saveGState()
        context?.clip(to: clipRect)
        
        p = NSBezierPath(roundedRect: f, xRadius: 1, yRadius: 1)
        p.fill()
        p.stroke()
        
        context?.restoreGState()
        clipRect.origin.x = clipRect.maxX
        
    }
    
    func drawCapacity(_ percentage: Int, _ plug: Bool) {
        capacity = Double(percentage)/100
        isPlugged = plug
        self.setNeedsDisplay(self.frame)
    }
    
}
