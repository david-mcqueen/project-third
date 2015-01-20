//
//  ViewController.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 05/10/2014.
//  Copyright (c) 2014 DavidMcQueen. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UITableViewController, UITableViewDelegate, CLLocationManagerDelegate, SelectUserVehicleDelegate, CreateVehicleDelegate {

    @IBOutlet var locationTextField: UITextField!
    let locationManager = CLLocationManager();
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "EBEFD083-70A2-47C8-9837-E7B5634DF524"), identifier: "CarPark");
    var beaconActivityIndicator : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 100, 100)) as UIActivityIndicatorView
    
    var editLocationButton = false;
    
    @IBOutlet var determineLocationButton: UIButton!

    @IBOutlet var timeBandLabel: UILabel!
    @IBOutlet var vehicleLabel: UILabel!
    var selectedVehicle:Vehicle?;
    var selectedTimeBand: String?;
    
    @IBOutlet var toggleMethod: UISwitch!
    
    @IBAction func toggleMethodPressed(sender: AnyObject) {
        //Reload all of the table data
        self.tableView.reloadData();
    }
    
    @IBAction func parkPressed(sender: AnyObject) {
        println("park the vehicle");
        //TODO:- Validation checking on the input fields
        let userVehicle = selectedVehicle?.VehicleID
        
        let carParkLocationID: Int = 1
        let parkingTimeMinutes: Int = 37;
        parkVehicle(User.sharedInstance.token!, carParkLocationID, userVehicle!, parkingTimeMinutes,  {(success: Bool, parkTransactionID: Int?, error: String?) -> () in
            
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
                    var newParkSession = ParkSession(parkSessionID: parkTransactionID!, carParkID: carParkLocationID, startTime: NSDate(), currentSession: true, parkedVehicle: self.selectedVehicle!);
                    User.sharedInstance.addParkSession(newParkSession);
                }
                
                if error != nil{
                    println(error!);
                }
                
                })
            
            }
        );
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var firstVehicle = User.sharedInstance.getFirstVehicle();
        selectedVehicle = firstVehicle;
        
        locationManager.delegate = self;
        vehicleLabel.text = selectedVehicle?.displayVehicle();
        if ((selectedTimeBand) != nil){
            timeBandLabel.text = selectedTimeBand;
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
    
    @IBAction func determineLocation(sender: AnyObject) {
        //Start looking for beacons so long as we have permission
        if (editLocationButton){
            self.locationTextField.becomeFirstResponder()
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
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                self.determineLocationButton.setTitle("Edit location", forState: UIControlState.Normal);
                self.editLocationButton = true;
                
                alert.show();
            });
            
            }
        );

    }

   
    func locationManager(manager: CLLocationManager!, rangingBeaconsDidFailForRegion region: CLBeaconRegion!, withError error: NSError!) {
        println("rangingDidFailForRegion");
        println(error.localizedDescription);
    }
    
    
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        //This is called when:
        // A new beacon is within range
        // A beacon goe out of range
        // A beacon gets closer / further away
        
        //the CLBeacon object (beacons) is an array of all beacons in region
        
        // Look on http://willd.me/posts/getting-started-with-ibeacon-a-swift-tutorial for more properties that can be accessed
        // Proximity / rssi / accuracy
        
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
            self.locationTextField.becomeFirstResponder();
        }else if(indexPath.section == 3 && indexPath.row == 0){
            parkPressed(self);
        }
    }

    
    //MARK:- Segue - Prepare
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PickTimeBand" {
            println("PickTimeBand Segue")
            let timeBandSelectViewController = segue.destinationViewController as TimeBandSelectViewController
            timeBandSelectViewController.selectedTimeBand = selectedTimeBand
        }else if segue.identifier == "PickUserVehicle" {
            println("PickVehicleBand Segue")
            let vehicleSelectViewController = segue.destinationViewController as VehicleSelectViewController
            vehicleSelectViewController.selectedVehicle = selectedVehicle
            vehicleSelectViewController.delegate = self;
        }
        
    }
    
    //MARK:- Segue unwind
    @IBAction func selectedTimeBandSave(segue:UIStoryboardSegue) {
        let timeBandSelectViewController = segue.sourceViewController as TimeBandSelectViewController
        if let _selectedTimeBand = timeBandSelectViewController.selectedTimeBand {
            timeBandLabel.text = _selectedTimeBand
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
    
    
    //CreateUserVehicleDelegate
    func newVehicleCreated() {
        println("New Vehicle")
        self.navigationController?.popViewControllerAnimated(true);
    }
}

