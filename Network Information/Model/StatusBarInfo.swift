//
//  StatusBarInfo.swift
//  Radio Tool
//
//  Created by Prasha Bora on 7/23/18.
//  Copyright © 2018 Prasha Bora. All rights reserved.
//

import Foundation
import UIKit

class StatusBarInfo: NSObject {
    
    // MARK: Battery Info
    var batteryPercentage: Float?
    var batteryState: Int?
    var isBatterySaverModeOn: Bool?
    
    // MARK: Network/Wifi Signal Strength
    var isWifiEnabled: Bool?
    var netwrokSignalStrengthBars: Int?
    var wifiStrengthBars: Int?
    var wifiStrengthRaw: Int?
    
    // MARK: Bluetooth and Location enabled info
    var isBluetoothEnabled: Bool?
    var isLocationSharingEnabled: Bool?
    
    enum Property: String {
        case batteryPercentage = "Battery Percentage"
        case batterySaverMode = "Battery Saver Mode"
        case batteryState = "Battery state"
        case bluetoothEnabled = "Bluetooth Enabled"
        case locationSharing = "Location Sharing"
        case networkSignalStrength = "Network Signal Strength"
        case wifiStrengthBars = "Wifi Strength"
        
        static var list: [String] {
            let statusBarList: [Property] = [.batteryPercentage, .batterySaverMode, .batteryState, .bluetoothEnabled, .locationSharing, .networkSignalStrength,.wifiStrengthBars]
            return statusBarList.compactMap{$0.rawValue}
        }
    }
    
    override func value(forKey key: String) -> Any? {
        var value: Any?
        if let property = Property(rawValue: key) {
            switch(property) {
            case .batteryPercentage : value = "\((self.batteryPercentage ?? 0)*100)%"
            case .batterySaverMode: value = self.isBatterySaverModeOn != nil
                ? self.isBatterySaverModeOn == true ? "ON" : "OFF"
                : "NA"
            case .batteryState: value = self.batteryState != nil
                ? self.batteryState == 0 ? "Bellow 20%" : "Above 20%"
                : "NA"
            case .bluetoothEnabled : value = self.isBluetoothEnabled != nil
                ? self.isBluetoothEnabled == true ? "ON" : "OFF"
                : "NA"
            case .locationSharing: value = self.isLocationSharingEnabled != nil
                ? self.isLocationSharingEnabled == true ? "ON" : "OFF"
                : "NA"
            case .networkSignalStrength : value = "\(self.netwrokSignalStrengthBars ?? 0) Bars"
            case .wifiStrengthBars : value = "\(self.wifiStrengthBars ?? 0) Bars"
           
            default: break
            }
        }
        return value
    }
    
   override init() {
        // Battery
        batteryPercentage = UIDevice.current.batteryLevel*100
       
        
        super.init()
    }
    
    
}

