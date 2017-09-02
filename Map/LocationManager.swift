//
//  MapViewManager.swift
//  Map
//
//  Created by Pulkit's Mac on 31/07/17.
//  Copyright © 2017 Pulkit's Mac. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject,CLLocationManagerDelegate {
    let APPDELEGATE = (UIApplication.shared.delegate as! AppDelegate)
    
    fileprivate let userLocation = CLLocationManager()
    fileprivate var location : CLLocation?
    class var Shared: LocationManager {
        struct Static {
            static var onceToken: Int = 0
            static var instance = LocationManager()
        }
        return Static.instance
    }
    //MARK:
    //MARK: Request Location Access
    
    func requestLocation(){
        
        userLocation.delegate = self;
        userLocation.desiredAccuracy = kCLLocationAccuracyBest
        userLocation.requestAlwaysAuthorization()
        userLocation.startUpdatingLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
                dispAlert()
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                
            }
        } else {
            print("Location services are not enabled")
            dispAlert()

        }
    }
    

    
    //MARK:
    //MARK: Location Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        location = locations.last! as CLLocation
    }
    
    //MARK:
    //MARK: Helper Methods
    func getLocation()->CLLocation{
        return ((location != nil) ? location! : CLLocation(latitude: 00.000000, longitude: 00.000000));
    }
    
    fileprivate func dispAlert(){
        let alertVC = UIAlertController(title: "Geolocation is not enabled", message: "For using geolocation you need to enable it in Settings", preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "Open Settings", style: .default) { value in
            
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        })
        
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        APPDELEGATE.window?.rootViewController?.presentedViewController?.present(alertVC, animated: true, completion: nil)
        
    }
    
}

