//
//  ViewController.swift
//  Map
//
//  Created by Pulkit's Mac on 31/07/17.
//  Copyright © 2017 Pulkit's Mac. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class ViewController: UIViewController {
    
    let MapManager = MapViewManager.Shared
    var route : MKRoute? = nil
    let initialLocation = CLLocation(latitude: 40.759011, longitude: -73.984472)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        LocationManager.Shared.requestLocation()
        
        MapManager.prepareMap(frane: CGRect(x: 0, y:0, width: UIScreen.main.bounds.size.width, height:  UIScreen.main.bounds.size.height), type: .standard)
        MapManager.mapView?.delegate = self;
        self.view.addSubview(MapManager.mapView!)
        
        MapManager.centerMapOnLocation(location: initialLocation)
        
        
        
        let annotaion = CustomAnnotation(title: "california",
                              locationName: "california",
                              discipline: "california",
                              coordinate: CLLocationCoordinate2D(latitude: 40.759011, longitude: -73.984472))
        
        MapManager.mapView?.addAnnotation(annotaion)
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let sourceLocation = CLLocationCoordinate2D(latitude: 40.759011, longitude: -73.984472)
        let destinationLocation = CLLocationCoordinate2D(latitude: 40.748441, longitude: -73.985564)
        
        showRouteOnMap(firstCordinates: sourceLocation, secondCordinate: destinationLocation)
        showCircle(cordinates: sourceLocation)
       
    }
    //MARK:
    //MARK: Circle
    func showCircle(cordinates : CLLocationCoordinate2D){
        let circle = MKCircle(center: cordinates, radius: 500)
        MapManager.mapView?.add(circle)
    }
    
    //MARK:
    //MARK: Route
    func showRouteOnMap(firstCordinates : CLLocationCoordinate2D, secondCordinate : CLLocationCoordinate2D) {
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: firstCordinates, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate:secondCordinate, addressDictionary: nil))
        request.requestsAlternateRoutes = false
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            
            print(response)
            print(error)
            
            guard let unwrappedResponse = response else { return }
            
            if (unwrappedResponse.routes.count > 0) {
                self.route = unwrappedResponse.routes[0]
                self.MapManager.mapView?.add(unwrappedResponse.routes[0].polyline)
               // self.MapManager.mapView?.setVisibleMapRect(unwrappedResponse.routes[0].polyline.boundingMapRect, animated: true)
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? CustomAnnotation {
            let identifier = "AID"
            var view: SVPulsingAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? SVPulsingAnnotationView { // 2
                dequeuedView.annotation = annotation as MKAnnotation
                view = dequeuedView
            } else {
                // 3
                view = SVPulsingAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
               // view.rightCalloutAccessoryView = UIButton.buttonWithType(.detailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
    //MARK: 
    //MARK: Render Route..Circle
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) ->MKOverlayRenderer {
        
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.green
            circle.fillColor = UIColor.green.withAlphaComponent(0.1)
            circle.lineWidth = 1
            return circle
        }
        else if overlay is MKPolyline{
            let myLineRenderer = MKPolylineRenderer(polyline: (route?.polyline)!)
            
            myLineRenderer.strokeColor = UIColor.red
            
            myLineRenderer.lineWidth = 1
            
            return myLineRenderer
        }else {
            return MKPolylineRenderer()
        }
        

    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Annotaion Selected")
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        print("Annotaion De-Selected")

    }

}

