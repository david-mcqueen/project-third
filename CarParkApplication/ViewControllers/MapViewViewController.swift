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
    
    //MARK:- UI Outlets
    @IBOutlet weak var btnCurrentLocation: UIBarButtonItem!
    @IBOutlet var btnRememberLocation: UIBarButtonItem!
    @IBOutlet var btnSearch: UIButton!
    @IBOutlet var txtSearchLocation: UITextField!
    @IBOutlet var map: MKMapView!
    
    //MARK:- Variables
    var locationManager = CLLocationManager();
    var savedLocation: CLLocationCoordinate2D?;
    var allAnnotations: [MKAnnotation] = []
    var firstTimeLoad = true;
    
    var searchIndicator : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 100, 100)) as UIActivityIndicatorView
    
    //MARK:- Default functions
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self;
        
        self.map.delegate = self;
        
        
        //Request permission to access beacons - Whilst the app is in Foreground
        if(CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse){
            println("Requesting")
            self.locationAuthorised(false);
            locationManager.requestWhenInUseAuthorization();
            
        }else{
            locationAuthorised(true);
            viewCurrentLocation(self);
            
        }
        txtSearchLocation.delegate = self;
        
        searchIndicator.center = self.view.center
        searchIndicator.hidesWhenStopped = true
        searchIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     override func viewWillAppear(animated: Bool) {
        getSavedCoordinates();
        println(savedLocation);
        if (savedLocation != nil){
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Retrieve Location", style: .Bordered, target: self, action: "retrieveLocation:")
        }else{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remember Location", style: .Bordered, target: self, action: "rememberLocation:")
        }
    }
    
    
    //MARK:- Remember location functions
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
        self.addMapAnnotationBasic(location, title: "Your car", subtitle: "Your vehicle is here!");
        
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
            self.addMapAnnotationBasic(newLocation, title: annotationTitle, subtitle: annotationSubtitle);
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
    
    
    //MARK:- Map functions
    @IBAction func viewCurrentLocation(sender: AnyObject) {
        view.addSubview(searchIndicator)
        searchIndicator.startAnimating()
        let latitude = locationManager.location.coordinate.latitude;
        let longitude = locationManager.location.coordinate.longitude;
        
        self.searchLocation(latitude, longitude: longitude)
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        focusMap(location);
        searchIndicator.stopAnimating();
        
        if(savedLocation != nil){
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Retrieve Location", style: .Bordered, target: self, action: "retrieveLocation:")

        }
        
    }
    
    func removeAnnotations(){
        self.view.endEditing(true)
        self.map.removeAnnotations(allAnnotations);
        allAnnotations.removeAll(keepCapacity: false);
    }
    
    @IBAction func searchPressed(sender: AnyObject) {
        var address =  txtSearchLocation.text;
        view.addSubview(searchIndicator)
        searchIndicator.startAnimating()
        
        if address == "" || address == nil {
            displayAlert("Error", "Please enter a search location", "OK");
        }
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            
            if error != nil {
                println(error.description)
                self.searchIndicator.stopAnimating()
            }
            
            if let placemark = placemarks?[0] as? CLPlacemark {
                
                //Set the view to be that of the searched area
                let latitude = placemark.location.coordinate.latitude;
                let longitude = placemark.location.coordinate.longitude;
                let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                
                self.searchLocation(latitude, longitude: longitude);
                self.focusMap(location);
                self.searchIndicator.stopAnimating()
            }
        });
    }
    
    func searchLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        self.removeAnnotations();
        println("searching")
        searchCarParks(User.sharedInstance.token!, latitude.description, longitude.description, { (success, returnedCarParks, error) -> () in
            if success {
                for carPark in returnedCarParks{
                    let latitude: CLLocationDegrees = (carPark.Latitude as NSString).doubleValue;
                    let longitude: CLLocationDegrees = (carPark.Longitude as NSString).doubleValue;
                    let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude);
                    var openingTimes: String?;
                    if (carPark.Open == nil) {
                        carPark.Open = "CLOSED";
                    }
                    if (carPark.Close == nil){
                        carPark.Close = "CLOSED";
                    }
                    self.addMapAnnotation(location, openingTime: carPark.Open!, closingTime: carPark.Close!, maxSpaces: carPark.Spaces, spacesUsed: carPark.CurrentlyParked, name: carPark.Name, id: carPark.ID);
                }
            }else{
                NSLog("Something went wrong")
            }
        });
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        var annotation = view.annotation as! CustomAnnotation;
        var carParkInformation = ""
        if (annotation.OpeningTime != "CLOSED"){
            carParkInformation = "Opens: \(annotation.OpeningTime)";
            carParkInformation += "\nCloses: \(annotation.ClosingTime)";
            carParkInformation += "\nEst. available: \(annotation.MaxSpaces - annotation.UsedSpaces)";
            carParkInformation += "\nCapacity: \(annotation.MaxSpaces)";
            
        }else{
            carParkInformation = "Carpark is Currently Closed";
        }
        
        displayAlert("\(annotation.Name) (\(annotation.ID))", carParkInformation, "Ok");
        
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
            
            if annotation is MKUserLocation {
                //return nil so map view draws "blue dot" for standard user location
                return nil
            }
        if annotation is CustomAnnotation{
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.animatesDrop = true
                var ann = annotation as! CustomAnnotation;
                println(ann);
                if(ann.OpeningTime != "CLOSED"){
                    pinView!.pinColor = .Green
                }else{
                    pinView!.pinColor = .Purple
                }
                
                pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.InfoDark) as! UIView;
            }
            else {
                pinView!.annotation = annotation
            }
            
            return pinView
        }else{
            return nil;
        }
        
    }
    
    func addMapAnnotation(location: CLLocationCoordinate2D, openingTime: String, closingTime: String, maxSpaces: Int, spacesUsed: Int, name: String, id: Int){
        var annotation = CustomAnnotation()
        annotation.coordinate = location
        annotation.title = "\(name) (\(id))"
        annotation.OpeningTime = openingTime;
        annotation.ClosingTime = closingTime;
        annotation.UsedSpaces = spacesUsed;
        annotation.MaxSpaces = maxSpaces;
        annotation.ID = id;
        annotation.Name = name;
        
        self.map.addAnnotation(annotation)
        
        self.allAnnotations.append(annotation);
    }
    
    func addMapAnnotationBasic(location: CLLocationCoordinate2D, title: String, subtitle: String){
        var annotation = MKPointAnnotation();
        annotation.coordinate = location
        annotation.title = title
        annotation.subtitle = subtitle
        
        self.map.addAnnotation(annotation)
        self.allAnnotations.append(annotation);
    }

    
    func focusMap(location: CLLocationCoordinate2D){
        var mapCamera = MKMapCamera(lookingAtCenterCoordinate: location, fromEyeCoordinate: location, eyeAltitude: 1500);
        self.map.setCamera(mapCamera, animated: true);
    }
    
    
    //MARK:- LocationManager delegate
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status{
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            self.locationAuthorised(true)
            break;
        case .Denied, .NotDetermined, .Restricted:
            self.locationAuthorised(false);
            break;
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
    
    
    //MARK:- TextField delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        txtSearchLocation.resignFirstResponder();
        searchPressed(self);
        return true;
    }
    
    
    //MARK:- Custom functions
    func locationAuthorised(authorised: Bool){
        
        self.navigationItem.leftBarButtonItem?.enabled = authorised
        self.navigationItem.rightBarButtonItem?.enabled = authorised
        
        if(!authorised){
            displayAlert("Permission Error", "Certain map features are disabled due to lack of permission, please enable location services in your iPhone settings to use all features", "Ok")
        }
    }
}