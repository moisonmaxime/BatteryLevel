//
//  AppDelegate.swift
//  ToolBar
//
//  Created by Maxime Moison on 9/17/17.
//  Copyright © 2017 Maxime Moison. All rights reserved.
//

import Cocoa
import NetworkExtension
import CFNetwork

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var statusMenu: NSMenu!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var popover = NSPopover()
    
    @IBAction func quitHit(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        popover.contentViewController = ToolBar.freshController(barItem: statusItem)
        statusItem.button?.action = #selector(togglePopover(_:))
        networkThings()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            // print("Open")
        }
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
        // print("Close")
    }
    
    func networkThings() {
        
    }
    
    
}

