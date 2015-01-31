//
//  ParkViewController.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 05/10/2014.
//  Copyright (c) 2014 DavidMcQueen. All rights reserved.
//

/*
//  TableViewController, Displaying all the information the user needs to park a vehicle.
//  Integrates CoreLocation in order to use the iBeacons and determine the users location
*/
import UIKit
import CoreLocation

class ViewController: UITableViewController, UITableViewDelegate, CLLocationManagerDelegate, SelectUserVehicleDelegate, CreateVehicleDelegate, TimeBandSelectedDelegate {
    
    //MARK:- Variables & Constants
    let locationManager = CLLocationManager();
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "EBEFD083-70A2-47C8-9837-E7B5634DF524"), identifier: "CarPark");
    var beaconActivityIndicator : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 100, 100)) as UIActivityIndicatorView
    var editLocationButton = false;
    var selectedVehicle:Vehicle?;
    var selectedTimeBand: PricingBand?;
    var selectedCarParkID: Int?;
    
    //MARK:- UI Outlets
    @IBOutlet var determineLocationButton: UIButton!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var timeBandLabel: UILabel!
    @IBOutlet var vehicleLabel: UILabel!
    @IBOutlet var toggleMethod: UISwitch!
    
    
    //MARK:- Default functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var firstVehicle = User.sharedInstance.getFirstVehicle();
        selectedVehicle = firstVehicle;
        
        locationManager.delegate = self;
        vehicleLabel.text = selectedVehicle?.displayVehicle();
        if ((selectedTimeBand) != nil){
            timeBandLabel.text = selectedTimeBand!.displayBand();
        }else{
            timeBandLabel.text = "Select Time";
        }
        
        
        //Request permission to access beacons - Whilst the app is in Foreground
        if(CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse){
            locationManager.requestWhenInUseAuthorization();
        }
        
        //TODO:- Handle the user denying the location request
        
        beaconActivityIndicator.center = self.view.center
        beaconActivityIndicator.hidesWhenStopped = true
        beaconActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func toggleMethodPressed(sender: AnyObject) {
        //Reload all of the table data
        self.tableView.reloadData();
    }
    
    @IBAction func parkPressed(sender: AnyObject) {
        println("park the vehicle");
        //TODO:- Validation checking on the input fields
        
        if (self.selectedCarParkID != nil){
            //Use the determined location
            parkUserVehicle(self.selectedCarParkID!)
            //Use the user provided location
        }else if (validateLocationID(self.locationTextField.text)){
            parkUserVehicle((self.locationTextField.text).toInt()!);
        }else{
            //No valid location, display an error
            displayAlert("Incorrect Location", "Please enter a correct location ID", "Ok!");
            return;
        }
    }
    
    
    func parkUserVehicle(selectedCarParkID: Int){
        let userVehicle = selectedVehicle?.VehicleID;
        parkVehicle(User.sharedInstance.token!, selectedCarParkID, userVehicle!, selectedTimeBand!.BandID,  {(success: Bool, parkTransactionID: Int?, error: String?) -> () in
            
            var alert = UIAlertView(title: "Success!", message: "", delegate: nil, cancelButtonTitle: "Okay.")
            
            if(!success) {
                alert.title = "Park Failed";
                alert.message = String(error!);
            }else{
                alert.title = "Park Success";
                alert.message = String(parkTransactionID!);
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                alert.show();
                if (parkTransactionID != nil && success){
                    println(parkTransactionID!)
                    var newParkSession = ParkSession(parkSessionID: parkTransactionID!, carParkID: selectedCarParkID, startTime: NSDate(), currentSession: true, parkedVehicleID: self.selectedVehicle!.VehicleID!);
                    User.sharedInstance.addParkSession(newParkSession);
                    
                    //Display the new parking session
                    println("View the parking session")
                    let viewSessionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("viewParkingSession") as SessionViewController;
                    viewSessionViewController.parkingSession = newParkSession;
                    self.navigationController?.showViewController(viewSessionViewController, sender: nil);
                }
                
                if error != nil{
                    println(error!);
                }
                
            });
            
            }
        );
    }

    //MARK:- Beacon functions
    @IBAction func determineLocation(sender: AnyObject) {
        //Start looking for beacons so long as we have permission
        if (editLocationButton){
            manuallyEnterLocation();
        }else{
            if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse){
            //Start looks for regions
            NSLog("Start monitoring for regions");
            locationTextField.text = "Searching..."
            beaconActivityIndicator.startAnimating()
            locationManager.startRangingBeaconsInRegion(region);
            }
        }
    }
    
    func getBeaconDetails(major: Int, minor: Int, rssi: Int){
        println("getBeaconDetails")
        var locationName: String;
        
        //The beacon ID needs to be in the format stored on the server.
        var beacon = String(major) + "." + String(minor);
        
        determineCarPark(User.sharedInstance.token!, beacon, {(success: Bool, carParkID: Int, carParkName: String, error: String?) -> () in
            var alert = UIAlertView(title: "Success!", message: carParkName, delegate: nil, cancelButtonTitle: "Okay.")
            if(success) {
                alert.title = "Success!"
                alert.message = carParkName
                
            }
            else {
                alert.title = "Failed : ("
                alert.message = carParkName
            }
            
            // Move to the UI thread
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                // Show the alert
                self.locationTextField.text = "\(carParkID): \(carParkName)";
                self.selectedCarParkID = carParkID;
                self.determineLocationButton.setTitle("Manually Enter location", forState: UIControlState.Normal);
                self.editLocationButton = true;
                
                alert.show();
            });
            
            }
        );

    }

    //MARK:- LocationManager Delegates
    func locationManager(manager: CLLocationManager!, rangingBeaconsDidFailForRegion region: CLBeaconRegion!, withError error: NSError!) {
        println("rangingDidFailForRegion");
        println(error.localizedDescription);
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        
        //Disregard beacons that are Unknown proximity
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown };
        

        if(knownBeacons.count > 0){
            println("Known Beacons \(knownBeacons)");
            let closestBeacon = knownBeacons[0] as CLBeacon;
            
            
            getBeaconDetails(closestBeacon.major.integerValue, minor: closestBeacon.minor.integerValue, rssi: closestBeacon.rssi);
            
            //We have found the closest beacon, stop ranging for new locations
            locationManager.stopRangingBeaconsInRegion(region);
            beaconActivityIndicator.stopAnimating();
            //TODO:- Only turn of beacon ranging, when the server has returned a car park ID?
            //TODO:- Or keep sending the same ID until a response is retunred?
        }
    }
    
    
    //MARK:- TableView Delegates
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 2 && toggleMethod.on){
            //Set the header & footer heights to 0
            self.tableView.sectionHeaderHeight = 0;
            return 0;
        } else {
            return super.tableView(tableView, heightForHeaderInSection: section);
        }  //keeps inalterate all other Header
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(section == 2 && toggleMethod.on) {
            //Set the header & footer heights to 0
            self.tableView.sectionFooterHeight = 0;
            return 0;
        } else {
            return super.tableView(tableView, heightForFooterInSection: section)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 2) //Index number of interested section
        {
            if(section == 2 && toggleMethod.on){
                return 0;
            } else  {
                return 1;
            }
            
        }else{
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section == 0 && indexPath.row == 1 && !editLocationButton) {
            determineLocation(self);
        }else if (indexPath.section == 0 && indexPath.row == 1 && editLocationButton){
            self.manuallyEnterLocation();
        }else if(indexPath.section == 3 && indexPath.row == 0){
            parkPressed(self);
        }
    }

    
    //MARK:- Segue Functions
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PickTimeBand" {
            
            println("PickTimeBand Segue")
            let timeBandSelectViewController = segue.destinationViewController as TimeBandSelectViewController
            timeBandSelectViewController.selectedTimeBand = selectedTimeBand
            timeBandSelectViewController.delegate = self;
            timeBandSelectViewController.selectedCarPark = selectedCarParkID;
            
        }else if segue.identifier == "PickUserVehicle" {
            
            println("PickVehicleBand Segue")
            let vehicleSelectViewController = segue.destinationViewController as VehicleSelectViewController
            vehicleSelectViewController.selectedVehicle = selectedVehicle
            vehicleSelectViewController.delegate = self;
        }
        
    }
    
    
    //MARK:- Exit Functions
    @IBAction func selectedTimeBandSave(segue:UIStoryboardSegue) {
        let timeBandSelectViewController = segue.sourceViewController as TimeBandSelectViewController
        if let _selectedTimeBand = timeBandSelectViewController.selectedTimeBand {
            timeBandLabel.text = _selectedTimeBand.displayBand()
            selectedTimeBand = _selectedTimeBand
            println("selected time band: \(selectedTimeBand)");
        }
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    
    //MARK:- SelectUserVehicleDelegate
    func didSelectUserVehicle(userVehicle: Vehicle) {
        println("vehicle Selected")
        vehicleLabel.text = userVehicle.displayVehicle();
        selectedVehicle = userVehicle
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    
    //MARK:- CreateUserVehicleDelegate
    func newVehicleCreated() {
        println("New Vehicle")
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    
    //MARK:- TimeBandSelectedDelegate
    func didSelectTimeBand(timeBandID: PricingBand){
        println(timeBandID);
    }
    
    
    //MARK:- Custom Functions
    func manuallyEnterLocation(){
        self.locationTextField.text = "";
        self.locationTextField.placeholder = "Location ID"
        self.selectedCarParkID = nil;
        self.locationTextField.becomeFirstResponder()
    }
}

