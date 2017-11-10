//
//  ToolBar.swift
//  ToolBar
//
//  Created by Maxime Moison on 9/17/17.
//  Copyright © 2017 Maxime Moison. All rights reserved.
//

import Cocoa
import AVFoundation

class ToolBar: NSViewController {
    
    @IBOutlet weak var timeEstimate: NSTextField!
    @IBOutlet weak var label: NSTextField!
    
    var timer = Timer()
    var statusItem = NSStatusItem()
    var batteryIcon = NSView()
    var isLocked = false
    let sound = NSSound(named: NSSound.Name(rawValue: "Purr"))
    let powerInfoProvider = PowerInfoProvider()
    
    static func freshController(barItem: NSStatusItem) -> ToolBar {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "ToolBar")) as? ToolBar else {
            fatalError("Couldn't load")
        }
        viewcontroller.statusItem = barItem
        viewcontroller.statusItem.button?.title = "     "
        viewcontroller.batteryIcon = BatteryView(frame: (viewcontroller.statusItem.button?.frame)!)
        viewcontroller.statusItem.button?.addSubview(viewcontroller.batteryIcon)
        viewcontroller.setTimer()
        viewcontroller.setBatteryView()
        return viewcontroller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        setBatteryView()
        sound?.loops = true
        sound?.volume = 1
        // print(getInfos())
    }
    
    func setTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(refresh)), userInfo: nil, repeats: true)
    }
    
    func startAlarm() {
        if !(sound?.isPlaying)! {
            sound?.play()
        }
    }
    
    func stopAlarm() {
        if (sound?.isPlaying)! {
            sound?.stop()
        }
    }
    
    func setBatteryView() {
        let timeRemaining: CFTimeInterval = IOPSGetTimeRemainingEstimate()
        
        let infos = powerInfoProvider.getInfos() as [String:String]
        
        if (timeRemaining == -2.0) {
            // Plugged
            if (isLocked) {
                stopAlarm()
            }
            
            (batteryIcon as! BatteryView).drawCapacity(Int(infos["CurrentCapacity"]!)!, true)
            estimateTime(Int(infos["TimetoFullCharge"]!)!, false)
        } else {
            // Unplugged
            if (isLocked) {
                startAlarm()
            }
            
            (batteryIcon as! BatteryView).drawCapacity(Int(infos["CurrentCapacity"]!)!, false)
            estimateTime(Int(infos["TimetoEmpty"]!)!, true)
        }
        
        guard let l = label else { return }
        l.stringValue = "\(infos["CurrentCapacity"]!) %"
    }
    
    func estimateTime(_ minutes: Int, _ needsEstimate: Bool) {
        guard let tl = timeEstimate else { return }
        if (minutes > 0) {
            let hours = Int(minutes/60)
            tl.stringValue = "\(hours)h\(Int(minutes - hours*60)) to full"
        } else {
            tl.stringValue = (needsEstimate ? "Estimating remaining time..." : "")
        }
    }
    
    @objc func refresh() {
        setBatteryView()
    }
    
    @IBAction func lockPress(_ sender: NSButton) {
        if (sender.title == "Lock") {
            sender.title = "Unlock"
            isLocked = true
        } else if (sender.title == "Unlock") {
            sender.title = "Lock"
            isLocked = false
            stopAlarm()
        }
    }
    
    @IBAction func quitPress(_ sender: NSButton) {
        NSApplication.shared.terminate(self)
    }
}
