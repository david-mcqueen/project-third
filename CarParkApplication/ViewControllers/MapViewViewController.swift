//
//  MapViewViewController.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 13/01/2015.
//  Copyright (c) 2015 DavidMcQueen. All rights reserved.
//


import Foundation
import MapKit

class MapViewViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var btnSearch: UIButton!
    @IBOutlet var txtSearchLocation: UITextField!
    @IBOutlet var map: MKMapView!
    var locationManager = CLLocationManager();
    var firstLoad = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self;
        
        //TODO:- Do we need "Always" authorisation?
        locationManager.requestWhenInUseAuthorization();
        

        
//        let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.01 , 0.01)
//        let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 45.612125, longitude: 22.948280)
//        let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(location, theSpan)
//        
//        map.setRegion(theRegion, animated: true)
//        
//        var anotation = MKPointAnnotation()
//        anotation.coordinate = location
//        anotation.title = "Your Location"
//        anotation.subtitle = "Current location"
//        map.addAnnotation(anotation)
        
//        let longPress = UILongPressGestureRecognizer(target: self, action: "action:")
//        longPress.minimumPressDuration = 1.0
//        map.addGestureRecognizer(longPress)
        
        
    }
    
    
    @IBAction func searchPressed(sender: AnyObject) {

        var address =  txtSearchLocation.text;
        println("Searching in location \(address)")
        
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            
            if error != nil {
                println(error.description)
            }
            
            if let placemark = placemarks?[0] as? CLPlacemark {
                
                //Set the view to be that of the searched area
                let latitude = placemark.location.coordinate.latitude;
                let longitude = placemark.location.coordinate.longitude;
                let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                
                //We can set the altitude of the map view
                var mapCamera = MKMapCamera(lookingAtCenterCoordinate: location, fromEyeCoordinate: location, eyeAltitude: 1000)
                self.map.setCamera(mapCamera, animated: true)

                //TODO:- Populate the map with markers indicating each of the parking locations
                //First need to send to the server to get the map locations
                println("Lat: \(latitude)")
                println("Long: \(longitude)");
                
                var anotation = MKPointAnnotation()
                anotation.coordinate = location
                anotation.title = "Car Park Location"
                anotation.subtitle = "Some car park information goes here"
                self.map.addAnnotation(anotation)
            }
        });
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (status == .AuthorizedWhenInUse) {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        //Set the view to be of the users current location
        if let location = locations.first as? CLLocation {
            let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.01 , 0.01)
            let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(location.coordinate, theSpan)
            if (firstLoad){
                self.map.setRegion(theRegion, animated: true);
                firstLoad = false;
            }
        }
    }
    
//    func action(gestureRecognizer:UIGestureRecognizer) {
//        var touchPoint = gestureRecognizer.locationInView(self.map)
//        var newCoord:CLLocationCoordinate2D = map.convertPoint(touchPoint, toCoordinateFromView: self.map)
//        
//        var newAnotation = MKPointAnnotation()
//        newAnotation.coordinate = newCoord
//        newAnotation.title = "New Location"
//        newAnotation.subtitle = "New Subtitle"
//        map.addAnnotation(newAnotation)
//        
//    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}