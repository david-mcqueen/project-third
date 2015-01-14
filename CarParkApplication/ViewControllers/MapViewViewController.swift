//
//  MapViewViewController.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 13/01/2015.
//  Copyright (c) 2015 DavidMcQueen. All rights reserved.
//


import Foundation
import MapKit

class MapViewViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet var btnRememberLocation: UIBarButtonItem!
    @IBOutlet var btnSearch: UIButton!
    @IBOutlet var txtSearchLocation: UITextField!
    @IBOutlet var map: MKMapView!
    var locationManager = CLLocationManager();
    var savedLocation: CLLocationCoordinate2D?;
    var allAnnotations: [MKAnnotation] = []
    var firstTimeLoad = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self;
        
        //TODO:- Do we need "Always" authorisation?
        //Request permission to access beacons - Whilst the app is in Foreground
        if(CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse){
            println("Requesting")
            locationManager.requestWhenInUseAuthorization();
        }else{
             viewCurrentLocation(self);
        }
        txtSearchLocation.delegate = self;
       
        getSavedCoordinates();
        
//        let longPress = UILongPressGestureRecognizer(target: self, action: "action:")
//        longPress.minimumPressDuration = 1.0
//        map.addGestureRecognizer(longPress)
        
        if (savedLocation != nil){
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Retrieve Location", style: .Bordered, target: self, action: "retrieveLocation:")
        }else{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remember Location", style: .Bordered, target: self, action: "rememberLocation:")
        }
    }
    
    func getSavedCoordinates(){
        var savedLatitude: CLLocationDegrees?;
        var savedLongitude: CLLocationDegrees?;
        
        //Get the coordinates of the saved location
        if let latitude: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("savedParkingLocation-Lat") {
            println(latitude.description)
            
            savedLatitude = latitude as? CLLocationDegrees;
            
        }
        if let longitude: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("savedParkingLocation-Long") {
            println(longitude.description)
            savedLongitude = longitude as? CLLocationDegrees;
        }
        if (savedLatitude != nil && savedLongitude != nil) {
            savedLocation = CLLocationCoordinate2D(latitude: savedLatitude!, longitude: savedLongitude!)
        }
    }
    
    //Save the location in which the user has parked
    func rememberLocation(_: UIBarButtonItem!){
        println("remember")
        let latitude = locationManager.location.coordinate.latitude;
        let longitude = locationManager.location.coordinate.longitude;
        println(latitude);
        println(longitude);
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        //Drop a pin onto the saved location
        self.addMapAnnotation(location, title: "Your car", subtitle: "Your vehicle is here!");
        
        //Saved the location into the UserDefaults - so that it persists after the app is closed
        NSUserDefaults.standardUserDefaults().setObject(latitude, forKey: "savedParkingLocation-Lat");
        NSUserDefaults.standardUserDefaults().setObject(longitude, forKey: "savedParkingLocation-Long");
        NSUserDefaults.standardUserDefaults().synchronize();
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Retrieve Location", style: .Bordered, target: self, action: "retrieveLocation:")
    }
    
    //Display the saved location where the user has parked
    func retrieveLocation(_: UIBarButtonItem!){
        getSavedCoordinates();
        println("Find")
        let annotationTitle = "Your car";
        let annotationSubtitle = "Your vehicle is here!";
        var annotationCounter = 0;
        
        //Remove the old annotation
        for annotation in allAnnotations {
            if annotation.title == annotationTitle && annotation.subtitle == annotationSubtitle{
                self.map.removeAnnotation(annotation);
                allAnnotations.removeAtIndex(annotationCounter)
            }
            annotationCounter++;
        }
        
        if let newLocation = savedLocation {
            self.addMapAnnotation(newLocation, title: annotationTitle, subtitle: annotationSubtitle);
        }
        
        if let vehicleLocation = savedLocation {
            self.focusMap(vehicleLocation);
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Forget Location", style: .Bordered, target: self, action: "forgetLocation:")
    }
    
    func forgetLocation(_: UIBarButtonItem!){
        println("forget")
        let annotationTitle = "Your car";
        let annotationSubtitle = "Your vehicle is here!";
        var annotationCounter = 0;
        
        //Remove the old annotation
        for annotation in allAnnotations {
            if annotation.title == annotationTitle && annotation.subtitle == annotationSubtitle{
                self.map.removeAnnotation(annotation);
                allAnnotations.removeAtIndex(annotationCounter)
            }
            annotationCounter++;
        }
        
        //Forget the location into the UserDefaults
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "savedParkingLocation-Lat");
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "savedParkingLocation-Long");
        NSUserDefaults.standardUserDefaults().synchronize();
        
        savedLocation = nil;
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remember Location", style: .Bordered, target: self, action: "rememberLocation:")
        
        
    }
    
    
    @IBAction func viewCurrentLocation(sender: AnyObject) {
        let latitude = locationManager.location.coordinate.latitude;
        let longitude = locationManager.location.coordinate.longitude;
        let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        focusMap(location);
    }
    
    @IBAction func searchPressed(sender: AnyObject) {

        self.view.endEditing(true)
        self.map.removeAnnotations(allAnnotations);
        allAnnotations.removeAll(keepCapacity: false);
        
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
                
                self.focusMap(location);

                //TODO:- Populate the map with markers indicating each of the parking locations
                //First need to send to the server to get the map locations
                println("Lat: \(latitude)");
                println("Long: \(longitude)");
                
                self.addMapAnnotation(location, title: "Car Park Location", subtitle: "Some car park information goes here");
            }
        });
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.AuthorizedWhenInUse) {
            locationManager.startUpdatingLocation()
        }else{
            println("Don't have authorisation")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        //Set the view to be of the users current location
        if let location = locations.first as? CLLocation {
            if (firstTimeLoad){
                let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.01 , 0.01)
                let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(location.coordinate, theSpan)
                
                self.map.setRegion(theRegion, animated: true);
                firstTimeLoad = false;
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
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        txtSearchLocation.resignFirstResponder();
        searchPressed(self);
        return true;
    }
    
    func addMapAnnotation(location: CLLocationCoordinate2D, title: String, subtitle: String){
        println("Add Annotation")
        var annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = title
        annotation.subtitle = subtitle
        self.map.addAnnotation(annotation)
        
        self.allAnnotations.append(annotation);
    }

    func focusMap(location: CLLocationCoordinate2D){
        var mapCamera = MKMapCamera(lookingAtCenterCoordinate: location, fromEyeCoordinate: location, eyeAltitude: 1000)
        self.map.setCamera(mapCamera, animated: true)
    }
    
    
}