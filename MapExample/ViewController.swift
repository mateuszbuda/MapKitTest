//
//  ViewController.swift
//  MapExample
//
//  Created by Mateusz Buda on 07/08/15.
//  Copyright © 2015 inFullMobile. All rights reserved.
//

import UIKit
import MapKit
import Darwin

class ViewController: UIViewController, MKMapViewDelegate {
    
    let coord = CLLocationCoordinate2DMake(51.514342, -0.149560)
    let coord2 = CLLocationCoordinate2DMake(51.516443, -0.130754)

    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.showsTraffic = true
        map.showsScale = true
        map.showsCompass = true
        map.showsPointsOfInterest = true
        map.showsBuildings = true
        
        let point = MKPointAnnotation()
        point.coordinate = coord
        point.title = "hahaha"
        point.subtitle = "blahblah"
        
        map.addAnnotation(point)
        
        getTransitETA()
        
//        openInMapsTransit(CLLocationCoordinate2DMake(51.514342, -0.149560))
        
        map.mapType = MKMapType.HybridFlyover
        
        let camera = MKMapCamera(lookingAtCenterCoordinate: coord,
            fromDistance: CLLocationDistance(100.0),
            pitch: CGFloat(M_PI / 3),
            heading: CLLocationDirection(75))
        
        map.camera = camera
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        annotationView.pinTintColor = UIColor.blueColor()
        annotationView.canShowCallout = true
        annotationView.detailCalloutAccessoryView = UIImageView(image: UIImage(named: "image"))
        annotationView.rightCalloutAccessoryView = UIImageView(image: UIImage(named: "image"))
        annotationView.leftCalloutAccessoryView = UIImageView(image: UIImage(named: "image"))
        return annotationView
    }
    
    func getTransitETA() {
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: coord, addressDictionary: [:]))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coord2, addressDictionary: [:]))
        request.transportType = MKDirectionsTransportType.Transit
        
        let directions = MKDirections(request: request)
        directions.calculateETAWithCompletionHandler { (response: MKETAResponse?, error: NSError?) -> Void in
            
            if let error = error {
                print(error)
                return
            }
            
            print(response!.source)
            print(response!.destination)
            print(response!.expectedTravelTime)
            
        }
    }
    
    func openInMapsTransit(coord: CLLocationCoordinate2D) {
        let placemark = MKPlacemark(coordinate: coord, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeTransit
        ]
        mapItem.openInMapsWithLaunchOptions(launchOptions)
    }
    
}

