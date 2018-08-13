//
//  CTNetworkInfoFactory.swift
//  Radio Tool
//
//  Created by Prasha Bora on 6/25/18.
//  Copyright © 2018 Prasha Bora. All rights reserved.
//

import UIKit
import CoreTelephony
import CoreLocation
import Foundation
import CoreBluetooth
import SystemConfiguration


class CTNetworkInfoFactory: NSObject{

    static let shared = CTNetworkInfoFactory()
    
    var networkInfo: NetworkInfo?
    var manager:CBCentralManager!

    
    // @@ func fetchNetworkInfo() -> NetworkInfo {
    
    private enum Status: String {
        case signalStrength = "UIStatusBarSignalStrengthItemView"
        case wifiNetwork = "UIStatusBarDataNetworkItemView"
        case bluetooth = "UIStatusBarBluetoothItemView"
        case batteryState = "UIStatusBarBatteryItemView"

        case location = "UIStatusBarLocationItemView"
    }
    
    
    
//    enum dataTypes: String {
//        case wifiNetwork
////    }
//    override func value(forKey key: String) -> Any? {
//        if let status = Status(rawValue: key) {
//            switch(status) {
//            case .wifiNetwork : return .currentRadioAccessTechnology
//
//
//            case .signalStrength:
//                <#code#>
//            case .bluetooth:
//                <#code#>
//            case .batteryState:
//                <#code#>
//            }
//        } else {
//            return ""
//        }
    
    func fetchNetworkInfo() -> NetworkInfo? {
        
        let netinfo = CTTelephonyNetworkInfo()
        let carrier: CTCarrier? = netinfo.subscriberCellularProvider
        guard let carrierObj = carrier else { return nil }
        networkInfo = NetworkInfo(carrierObj)
        
        let dataNetworkTypeString =   netinfo.currentRadioAccessTechnology
        var dataTypeValue = "NA"
        switch dataNetworkTypeString {
        case CTRadioAccessTechnologyLTE:
            dataTypeValue = "LTE"
        case CTRadioAccessTechnologyGPRS:
            dataTypeValue = "GPRS"
        case CTRadioAccessTechnologyEdge:
            dataTypeValue = "Edge"
        case CTRadioAccessTechnologyHSDPA, CTRadioAccessTechnologyHSUPA:
            dataTypeValue = "3G"
        default: break
        }
        networkInfo?.dataNetworkType = dataTypeValue
        return networkInfo
    }

    
    func fetchBatteryPercentage() -> Float {
        if !(UIDevice.current.isBatteryMonitoringEnabled){
            UIDevice.current.isBatteryMonitoringEnabled = true
        }
        return UIDevice.current.batteryLevel
    }
    
   
    
    func fetchStatusBarInfo() -> StatusBarInfo {
        
        var statusBarInfo = StatusBarInfo()
        statusBarInfo.batteryPercentage = fetchBatteryPercentage()
        
        if let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView,
            let foregroundView = statusBarView.value(forKey: "foregroundView") as? UIView
        {
            let statusSubviews = foregroundView.subviews
            for statusView in statusSubviews {
                if let classname = NSClassFromString(Status.signalStrength.rawValue),
                    statusView.isKind(of: classname)
                {
                        let signalStrength = statusView.value(forKey: "signalStrengthBars") as? Int ?? 0
                        statusBarInfo.netwrokSignalStrengthBars = signalStrength
                        print("signal Strenth: \(signalStrength)")


//                        let dataNetwork = statusView.value(forKey: "dataNetworkType"); setValue
//                        print(dataNetwork)
//                        let signal = statusView.value(forKey: "wifiStrengthRaw") ?? 0
//                        print(signal)
                } else if let classname = NSClassFromString(Status.wifiNetwork.rawValue),
                    statusView.isKind(of: classname)
                {
                        let wifiNetwork = statusView.value(forKey: "wifiStrengthBars") as? Int ?? 0
                        statusBarInfo.wifiStrengthBars = wifiNetwork
                        print("wifi Network: \(wifiNetwork)")
                }
                else if let classname = NSClassFromString(Status.wifiNetwork.rawValue),
                    statusView.isKind(of: classname)
                {
                        let wifiNetwork = statusView.value(forKey: "wifiStrengthRaw") ?? 0
                        print("wifiStrengthRaw: \(wifiNetwork)")
                    }
                
                else if let classname = NSClassFromString(Status.bluetooth.rawValue), statusView.isKind(of: classname)
                {
                        let bluetooth = statusView.value(forKey: "connected") as? Bool ?? false
                        statusBarInfo.isBluetoothEnabled = bluetooth
                        print("Bluetooth connectivity: \(bluetooth)")
                    
                }
                else if let classname = NSClassFromString(Status.batteryState.rawValue), statusView.isKind(of: classname){
                        let batteryState = statusView.value(forKey: "state") as? Int
                        switch batteryState{
                        case 0 :
                            print("Battery is below 20%")
                            statusBarInfo.batteryState = batteryState
                        case 1 :
                            print("Battery is above 20%")
                            statusBarInfo.batteryState = batteryState
                        case .none:
                            print("")
                        case .some(_):
                            print("")
                        }
                     //   print("Battery state: \(String(describing: batteryState))"
    
                        let batterySaverMode = statusView.value(forKey: "batterySaverModeActive") as? Int
                        switch batterySaverMode {
                        case 1 :
                            print("The battery saver mode is ON")
                            statusBarInfo.isBatterySaverModeOn = true
                        case 0 :
                            print("The battery saver mode is OFF")
                            statusBarInfo.isBatterySaverModeOn = false
                        case .none:
                            print("Something went wrong")
                        case .some(_):
                            print("Something went wrong")
                        }
                       // print("Battery Saver Mode Status: \(batterySaverMode)")
                    
                }
                else if let classname = NSClassFromString(Status.location.rawValue) , statusView.isKind(of: classname){
                        let location = statusView.value(forKey: "iconType") as? Int
                        switch location {
                        case 1 :
                            print("The location feature is OFF")
                            statusBarInfo.isLocationSharingEnabled = false
                        case 0 :
                            print("The location feature is ON")
                            statusBarInfo.isLocationSharingEnabled = true
                        case .none:
                            print("Something went wrong")
                        case .some(_):
                            print("Something went wrong")
                        
                       // print("Location on: \(location)")
                    }
                }
//                else if let classname = NSClassFromString(Status.batteryState.rawValue) , statusView.isKind(of: classname){
//                    let batterPercentage = statusView.value(forKey: "batterPercentage") as? Int ?? 0
//                    statusBarInfo.batteryPercentage = batterPercentage
//                    print("Battery Percentage: \(batterPercentage)")
//                }
                
            }
        }
        return statusBarInfo
    }

}
