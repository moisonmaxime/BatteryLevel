//
//  PowerInfo.swift
//  BatteryLevel
//
//  Created by Maxime Moison on 10/27/17.
//  Copyright © 2017 Maxime Moison. All rights reserved.
//

import Cocoa
import IOKit.ps

class PowerInfoProvider: NSObject {
    var powerSrcString = ""
    var currentPowerDict = Dictionary<String, String>()
    
    func getInfos() -> Dictionary<String, String> {
        let blob = IOPSCopyPowerSourcesInfo()
        let list = IOPSCopyPowerSourcesList(blob?.takeRetainedValue())
        let s = String(describing: list!.takeRetainedValue())
        
        if (s != powerSrcString) {
            var substrings = s.split(separator: "\n")
            
            for i in substrings {
                if (!i.contains("=")) {
                    substrings.remove(at: substrings.index(of: i)!)
                } else {
                    let okayChars : Set<Character> =
                        Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=".characters)
                    substrings[substrings.index(of: i)!] = i.filter({ c in
                        return okayChars.contains(c)
                    })
                }
            }
            
            var dict = Dictionary<String, String>()
            for i in substrings {
                let end = i.split(separator: "=")
                dict[String(end[0])] = String(end[1])
            }
            
            currentPowerDict = dict
            powerSrcString = s
            
            return dict
        } else {
            return currentPowerDict
        }
    }
    
}
