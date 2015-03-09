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
    var selectedVehicle: Vehicle?;
    var allVehicles: [Vehicle] = [];
    var selectedTimeBand: PricingBand?;
    var selectedCarParkID: Int?;
    var selectedCarParkName: String?;
    var edidtingSession: Bool = false;
    var timeBands: [PricingBand] = []
    var bandDuration: Int?;
    var bandDescription: String?;
    var originalParkID: Int?
    var originalSession: ParkSession?;
    var keyboardIsShowing = false;
    var newTimeBandSelected = false;
    
    
    //MARK:- UI Outlets
    @IBOutlet weak var parkButton: UIButton!
    @IBOutlet weak var vehicleCell: UITableViewCell!
    @IBOutlet weak var locationIDCell: UITableViewCell!
    @IBOutlet weak var selectTimeBandCell: UITableViewCell!
    @IBOutlet var determineLocationButton: UIButton!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var timeBandLabel: UILabel!
    @IBOutlet var vehicleLabel: UILabel!
    @IBOutlet var toggleMethod: UISwitch!
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var notificationMinsInput: UITextField!
    
    //MARK:- Default functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self;
        
        if (selectedTimeBand != nil){
            timeBandLabel.text = selectedTimeBand!.displayBand();
        }else{
            timeBandLabel.text = "Select Time";
            selectTimeBandCell.userInteractionEnabled = false;
        }
        
        //Request permission to access beacons - Whilst the app is in Foreground
        if(CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse){
            locationManager.requestWhenInUseAuthorization();
            self.toggleLocationButton(false, locatedBeacon: false);
        }
        
        beaconActivityIndicator.center = self.view.center
        beaconActivityIndicator.hidesWhenStopped = true
        beaconActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray;
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        if edidtingSession {
            if (selectedCarParkID != nil){
                locationTextField.text = "\(selectedCarParkID!)"
                locationTextField.textColor = UIColor(red: 0.557, green: 0.557, blue: 0.557, alpha: 1.0)
            }
            vehicleLabel.text = selectedVehicle?.displayVehicle();
            selectTimeBandCell.userInteractionEnabled = true;
            locationIDCell.userInteractionEnabled = false;
            vehicleCell.userInteractionEnabled = false;
            parkButton.setTitle("Extend Stay", forState: .Normal);
            if (!newTimeBandSelected){
                timeBandLabel.text = bandDescription!;
            }
        }else {
            
            allVehicles = User.sharedInstance.getActiveVehicles();
            var selectedVehicleActive = false;
            
            for vehicle in allVehicles{
                if vehicle.displayVehicle() == selectedVehicle?.displayVehicle(){
                    selectedVehicleActive = true;
                }
            }
            
            if selectedVehicle == nil || !selectedVehicleActive{
                var firstVehicle = User.sharedInstance.getFirstVehicle();
                selectedVehicle = firstVehicle;
                vehicleLabel.text = selectedVehicle?.displayVehicle();
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated);
        //Remove the keyboard handlers when leaving this view
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil);
    }
    
    func keyboardWillShow(notification: NSNotification) {
        println("keyboardWillShow")
        if (notificationMinsInput.isFirstResponder()){
            if let info = notification.userInfo {
                var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
                
                if (!self.keyboardIsShowing){
                    self.keyboardIsShowing = true
                    self.tableView.frame.origin.y -= keyboardFrame.height;
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        println("keyboardWillHide")
        if (notificationMinsInput.isFirstResponder()){
            if let info = notification.userInfo {
                var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
                
                
                if (self.keyboardIsShowing){
                    self.keyboardIsShowing = false
                    self.tableView.frame.origin.y += keyboardFrame.height;
                    
                }
            }
        }
        
    }
    
    
    
    //MARK:- Button Functions
    @IBAction func toggleMethodPressed(sender: AnyObject) {
        //Reload all of the table data
        self.tableView.reloadData();
    }
    
    @IBAction func didFinishEditingLocationID(sender: AnyObject) {
        println("finished editing")
        if (validateLocationID(self.locationTextField.text)){
            self.selectedCarParkID = (self.locationTextField.text).toInt();
            selectTimeBandCell.userInteractionEnabled = true;
        }else{
            displayAlert("Invalid ID", "Please enter a valid location ID", "Ok");
        }
    }
    
    @IBAction func determineLocation(sender: AnyObject) {
        //Start looking for beacons so long as we have permission
        if (editLocationButton){
            manuallyEnterLocation();
        }else{
            if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse){
                //Start looks for regions
                beaconActivityIndicator.startAnimating();
                self.view.addSubview(beaconActivityIndicator);
                NSLog("Start monitoring for regions");
                locationTextField.text = "Searching..."
                locationManager.startRangingBeaconsInRegion(region);
                
                //Start a timer for 5 seconds, after which stop attempting to find beacons.
                var timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("cancelRanging"), userInfo: nil, repeats: false);
                toggleLocationButton(true, locatedBeacon: false)
            }
        }
    }

    @IBAction func parkPressed(sender: AnyObject) {
        println("park the vehicle");
        
        if (selectedTimeBand == nil && !toggleMethod.on){
            displayAlert("Time Band", "Please select a valid time band", "Ok")
            return;
        }
        
        if (User.sharedInstance.CurrentBalance < selectedTimeBand?.BandCost && !toggleMethod.on){
            displayAlert("Insufficient Fund", "Please ensure you have enough funds on your account for this parking", "Ok");
            return;
        }
        
        if (notificationSwitch.on && (notificationMinsInput.text == nil || notificationMinsInput.text == "")){
            displayAlert("Incorrect Value", "Please enter a notification time in minutes", "Ok");
            return;
        }
        
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
    
    
    //MARL:- Custom functions
    func parkUserVehicle(selectedCarParkID: Int){
        
        let userVehicle = selectedVehicle?.VehicleID;
        //Check all inputs are filled in
        
        // -1 time band indicates that no time band is selected
        var timeBand: Int = toggleMethod.on ? -1 : selectedTimeBand!.BandID;
        if (!edidtingSession){
            createParkSession(userVehicle!, timeBandID: timeBand);
        }else{
            extendParkSession(selectedTimeBand!.BandID);
        }
        
    }
    
    func extendParkSession(newBandID: Int){
        extendParkingSession(User.sharedInstance.token!, self.originalParkID!, newBandID) { (success, newFinishTime, newCost, error) -> () in
            println(success);
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
                if(success){
                    self.originalSession?.EndTime = newFinishTime;
                    self.originalSession?.Value = newCost;
                
                    User.sharedInstance.removeParkSession(self.originalSession!);
                    User.sharedInstance.addParkSession(self.originalSession!)
                    displayAlert("Success", "Parking session successfully modified", "Ok")
                    self.navigationController?.popViewControllerAnimated(true);
                    if (self.notificationSwitch.on){
                        var notificationWarning = Double(self.notificationMinsInput.text.toInt()!)
                        notificationWarning = (notificationWarning * 60) * -1;
                        
                        //Schedule a notification for 30 mins before the expirary time
                        scheduleNotification("Your modified parking for vehicle \(self.selectedVehicle!.displayVehicle()) is due to expire in \(self.notificationMinsInput.text) minutes",
                            newFinishTime!,
                            notificationWarning
                        )
                    }
                }
            });
        }
    }
    
    func createParkSession(userVehicleID: Int, timeBandID: Int){
        var parkIndicator : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 100, 100)) as UIActivityIndicatorView
        parkIndicator.center = self.view.center
        parkIndicator.hidesWhenStopped = true
        parkIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(parkIndicator)
        parkIndicator.startAnimating()
        
        
        parkVehicle(User.sharedInstance.token!, selectedCarParkID!, userVehicleID, timeBandID, {(success: Bool, parkTransactionID: Int?, parkFinished: Bool?, parkFinishTime: NSDate?, parkCost: Double?, error: String?) -> () in

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if (self.selectedCarParkName == nil){
                    self.selectedCarParkName = "";
                }
                if (parkTransactionID != nil && success){
                    println(parkTransactionID!)
                    
                    let startTime = NSDate();
                    
                    var newParkSession = ParkSession(
                        parkSessionID: parkTransactionID!,
                        carParkID: self.selectedCarParkID!,
                        carParkName: self.selectedCarParkName!,
                        startTime: startTime,
                        endTimeParking: parkFinishTime!,
                        currentSession: !parkFinished!,
                        parkedVehicleID: self.selectedVehicle!.VehicleID!,
                        value: parkCost!,
                        finished: parkFinished!
                    );
                    User.sharedInstance.addParkSession(newParkSession);
                    
                    if (self.notificationSwitch.on){
                        var notificationWarning = Double(self.notificationMinsInput.text.toInt()!)
                        notificationWarning = (notificationWarning * 60) * -1;
                        
                        //Schedule a notification for 30 mins before the expirary time
                        scheduleNotification("Your parking for vehicle \(self.selectedVehicle!.displayVehicle()) is due to expire in \(self.notificationMinsInput.text) minutes",
                            parkFinishTime!,
                            notificationWarning
                        )
                    }
                    
                    
                    //Display the new parking session
                    println("View the parking session")
                    parkIndicator.stopAnimating()
                    let viewSessionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("viewParkingSession") as SessionViewController;
                    viewSessionViewController.parkingSession = newParkSession;
                    self.navigationController?.showViewController(viewSessionViewController, sender: nil);
                }
                if error != nil{
                    parkIndicator.stopAnimating()
                    displayAlert("Park Failed", "Something went wrong. (\(error!))", "Ok")
                }
                
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

        }
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status{
        case .Authorized, .AuthorizedWhenInUse:
            self.toggleLocationButton(true, locatedBeacon: false);
            break;
        case .Denied, .NotDetermined, .Restricted:
            self.toggleLocationButton(false, locatedBeacon: false);
            break;
        default:
            self.toggleLocationButton(false, locatedBeacon: false);
            break;
        }
    }
    
    //MARK:- TableView Delegates
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 2 && toggleMethod.on){
            //Set the header & footer heights to 0
            self.tableView.sectionHeaderHeight = 0;
            return 0;
        } else{
            return super.tableView(tableView, heightForHeaderInSection: section);
        }  //keeps all other Header
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
        
        if (edidtingSession && section == 0){
            
            return 1;
            
        }else{
            
            if(section == 2){
                if(toggleMethod.on){
                    return 0;
                } else {
                    return 1
                }
            }else if (section == 4){
                if(notificationSwitch.on){
                    return 2;
                }else{
                    return 1;
                }
            }else{
                return super.tableView(tableView, numberOfRowsInSection: section)
            }
            
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section == 0 && indexPath.row == 0 && editLocationButton) {
            locationTextField.becomeFirstResponder();
        }else if(indexPath.section == 0 && indexPath.row == 1 && !editLocationButton) {
            determineLocation(self);
        }else if (indexPath.section == 0 && indexPath.row == 1 && editLocationButton){
            self.manuallyEnterLocation();
        }else if(indexPath.section == 3 && indexPath.row == 0){
            parkPressed(self);
        }else if(indexPath.section == 4 && indexPath.row == 1){
            notificationMinsInput.becomeFirstResponder();
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as UITableViewHeaderFooterView
        
        header.textLabel.textColor = UIColor.whiteColor() //make the text white
        header.textLabel.font = UIFont.boldSystemFontOfSize(12);
    }

    
    //MARK:- Segue Functions
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PickTimeBand" {
            
            println("PickTimeBand Segue")
            self.didFinishEditingLocationID(self);
            self.locationTextField.endEditing(true);
            let timeBandSelectViewController = segue.destinationViewController as TimeBandSelectViewController
            timeBandSelectViewController.selectedTimeBand = selectedTimeBand
            timeBandSelectViewController.delegate = self;
            timeBandSelectViewController.bandDuration = bandDuration;
            
            if self.timeBands.count > 0 {
                timeBandSelectViewController.timeBands = self.timeBands;
            }
            
            timeBandSelectViewController.selectedCarPark = selectedCarParkID;
            
        }else if segue.identifier == "PickUserVehicle" {
            println("PickVehicleBand Segue")
            let vehicleSelectViewController = segue.destinationViewController as VehicleSelectViewController
            if (selectedVehicle != nil){
                println(selectedVehicle?.displayVehicle())
                vehicleSelectViewController.selectedVehicle = selectedVehicle
            }
            vehicleSelectViewController.delegate = self;
        }
        
    }
    
    
    //MARK:- Exit Functions
    @IBAction func selectedTimeBandSave(segue:UIStoryboardSegue) {
        let timeBandSelectViewController = segue.sourceViewController as TimeBandSelectViewController
        if let _selectedTimeBand = timeBandSelectViewController.selectedTimeBand {
            timeBandLabel.text = _selectedTimeBand.displayBand()
            selectedTimeBand = _selectedTimeBand;
            self.newTimeBandSelected = true;
            println("selected time band: \(selectedTimeBand)");
        }
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    
    //MARK:- SelectUserVehicleDelegate
    func didSelectUserVehicle(userVehicle: Vehicle) {
        println("vehicle Selected")
        vehicleLabel.text = userVehicle.displayVehicle();
        selectedVehicle = userVehicle
        println(selectedVehicle?.displayVehicle())
        self.tableView.reloadData()
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
        self.selectedTimeBand = nil;
        self.timeBandLabel.text = "Select Time";
        self.locationTextField.text = "";
        self.locationTextField.placeholder = "Location ID"
        self.selectedCarParkID = nil;
        selectTimeBandCell.userInteractionEnabled = false;
        self.locationTextField.becomeFirstResponder()
    }
    
    func toggleLocationButton(automatic: Bool, locatedBeacon: Bool){
        if(automatic && !locatedBeacon){
            editLocationButton = false;
            self.determineLocationButton.setTitle("Determine location", forState: UIControlState.Normal);
            locationIDCell.userInteractionEnabled = false;
        }else if (automatic && locatedBeacon){
            editLocationButton = true;
            self.determineLocationButton.setTitle("Enter location", forState: UIControlState.Normal);
            locationIDCell.userInteractionEnabled = true
        }else{
            editLocationButton = true;
            self.determineLocationButton.setTitle("Enter location", forState: UIControlState.Normal);
            locationIDCell.userInteractionEnabled = true
        }
    }
    
    func cancelRanging(){
        if (self.selectedCarParkID == nil){
            locationManager.stopRangingBeaconsInRegion(region);
            beaconActivityIndicator.stopAnimating();
            self.locationTextField.text = "";
            self.locationTextField.placeholder = "Location ID"
            displayAlert("Error", "Failed to find a beacon, please enter the car park ID", "ok");
            toggleLocationButton(false, locatedBeacon: false);
        }
    }
    
    func getBeaconDetails(major: Int, minor: Int, rssi: Int){
        println("getBeaconDetails")
        var locationName: String;
        
        //The beacon ID needs to be in the format stored on the server.
        var beacon = String(major) + "." + String(minor);
        
        determineCarPark(User.sharedInstance.token!, beacon, {(success: Bool, carParkID: Int, carParkName: String, error: String?) -> () in
            
            // Move to the UI thread
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                if success {
                    displayAlert("Success", "Car Park Found (\(carParkName))", "OK")
                    self.locationTextField.text = "\(carParkID)";
                    self.selectedCarParkID = carParkID;
                    self.selectTimeBandCell.userInteractionEnabled = true;
                    self.toggleLocationButton(true, locatedBeacon: true)
                }else{
                    self.toggleLocationButton(false, locatedBeacon: false);
                    displayAlert("Failed", "No car park was found. Please enter the Carpark ID manually", "OK")
                }
            });
            }
        );
        
    }
}

