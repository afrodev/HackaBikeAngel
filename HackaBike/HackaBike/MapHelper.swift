//
//  MapHelper.swift
//  HackaBike
//
//  Created by Paulo Henrique Leite on 16/04/16.
//  Copyright © 2016 Paulo Henrique Leite. All rights reserved.
//

import UIKit
import CoreLocation

class MapHelper: NSObject, CLLocationManagerDelegate {
    var locationManager:CLLocationManager!
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func retornaLocal() {
        
    }
    
    
}
