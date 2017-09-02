//
//  CustomAnnotation.swift
//  Map
//
//  Created by Pulkit's Mac on 31/07/17.
//  Copyright © 2017 Pulkit's Mac. All rights reserved.
//

import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
     let title : String?
     let locationName: String?
     let discipline: String?
     let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    


}
