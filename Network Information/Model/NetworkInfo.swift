//
//  NetworkInfo.swift
//  Radio Tool
//
//  Created by Prasha Bora on 6/25/18.
//  Copyright © 2018 Prasha Bora. All rights reserved.
//

import UIKit
import CoreTelephony
import CoreLocation
import Foundation

protocol LocationUpdateDelegate {
    func didUpdateLocation(_ lat: String, _ long: String)
}

class NetworkInfo: NSObject, CLLocationManagerDelegate{
    var mcc: String?
    var mnc: String?
    var name: String?
    var dataNetworkType: String?


    var latitude: String?
    var longitude: String?
    var locationManager: CLLocationManager?
    
    var locationUpdateDelegate: LocationUpdateDelegate?
    
    init(_ carrier: CTCarrier) {
        super.init()
        mnc = carrier.mobileNetworkCode
        mcc = carrier.mobileCountryCode
        name = carrier.carrierName
        
        locationManager = CLLocationManager()
        setupLocationManager()
    }
    
    func setupLocationManager() {
        if let locationManager = locationManager {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last,
            location.horizontalAccuracy > 0 {
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            latitude = String(location.coordinate.latitude)
            longitude = String(location.coordinate.longitude)
            if let delegate = locationUpdateDelegate,
                let latitude = latitude,
                let longitude =  longitude
            {
                delegate.didUpdateLocation(latitude, longitude)
            }
        }
    }

    enum Property: String {
        case mnc = "MNC"
        case mcc = "MCC"
        case name = "Carrier Name"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case dataNetworkTypes = "Data network Type"
        
        
        static var list: [String] {
            
            return [Property.name.rawValue, Property.dataNetworkTypes.rawValue, Property.mnc.rawValue, Property.mcc.rawValue, Property.latitude.rawValue, Property.longitude.rawValue]
            //return [mnc.rawValue]
        }
    }
    
    override func value(forKey key: String) -> Any? {
        if let property = Property(rawValue: key) {
            switch(property) {
            case .mcc : return self.mcc
            
            case .mnc : return self.mnc
                
            case .name : return self.name
                
            case .latitude : return self.latitude
                
            case .longitude : return self.longitude
                
            case .dataNetworkTypes: return self.dataNetworkType
            
            default: return ""
            }
        } else {
            return ""
        }
    }
}

