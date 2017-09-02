//
//  MapViewManager.swift
//  Map
//
//  Created by Pulkit's Mac on 31/07/17.
//  Copyright © 2017 Pulkit's Mac. All rights reserved.
//

import UIKit
import MapKit

class MapViewManager: NSObject {
    
    fileprivate let regionRadius: CLLocationDistance = 1000
    var mapView : MKMapView?

    class var Shared: MapViewManager {
        struct Static {
            static var onceToken: Int = 0
            static var instance = MapViewManager()
        }
        return Static.instance
    }
    
    //MARK:
    //MARK: UI
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView?.setRegion(coordinateRegion, animated: true)
    }

    
    //MARK:
    //MARK: Memory
    func prepareMap(frane : CGRect,type : MKMapType){
        self.removeMap()
        mapView = MKMapView(frame: frane)
        mapView?.mapType = type
    }
    
   fileprivate func removeMap(){
        if mapView?.mapType == MKMapType.standard {
            mapView?.mapType = MKMapType.satellite
        }else{
            mapView?.mapType = MKMapType.standard
        }
        mapView?.removeAnnotation(mapView?.annotations as! MKAnnotation)
        mapView?.delegate = nil;
        mapView?.removeFromSuperview()
        mapView = nil;
    }

}

