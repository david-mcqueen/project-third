//
//  SessionViewController.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 22/01/2015.
//  Copyright (c) 2015 David McQueen. All rights reserved.
//

import UIKit

class SessionViewController: UITableViewController{
    
    @IBOutlet weak var sessionLocationLabel: UILabel!
    @IBOutlet weak var vehicleLabel: UILabel!
    @IBOutlet weak var sessionStartLabel: UILabel!
    @IBOutlet weak var sessionEndLabel: UILabel!
    @IBOutlet weak var sessionDurationLabel: UILabel!
    @IBOutlet weak var sessionCostLabel: UILabel!
    var parkingSession: ParkSession?;
    
    @IBOutlet weak var btnEndExtentParking: UIButton!
    var extendParking: Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("SessionViewController")
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged);
        
        populateSessionFields();
        
    }
    
    @IBAction func ModifyParkingPressed(sender: AnyObject) {
        if(extendParking){
            println("Extend the parking session")
        }else{
            stopParking(User.sharedInstance.token!, self.parkingSession!.ParkSessionID, { (success, value, error) -> () in
                
                // Move to the UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if (success){
                        //TODO:- Display the cost of the parking session.
                        println("\(value)")
                        self.parkingSession?.EndTime = NSDate();
                        self.parkingSession?.Value = value;
                        self.parkingSession?.CurrentSession = false;
                        self.refresh(self);
                    }else{
                        NSLog("Something went wrong. \(error)")
                    }
                    
                });
                
            });
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as UITableViewHeaderFooterView
        
        header.textLabel.textColor = UIColor.whiteColor() //make the text white
        header.textLabel.font = UIFont.boldSystemFontOfSize(12);
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true);
    }
    
    func populateSessionFields(){
        if (parkingSession?.EndTime != nil){
            btnEndExtentParking.setTitle("Extend", forState: .Normal);
            extendParking = true;
        }else{
            btnEndExtentParking.setTitle("End", forState: .Normal);
            extendParking = false;
        }
        
        var vehicleText: String?;
        for vehicle in User.sharedInstance.getActiveVehicles(){
            if vehicle.VehicleID! == parkingSession?.ParkedVehicleID{
                vehicleText = vehicle.displayVehicle();
            }
        }
        vehicleLabel.text = vehicleText;
        sessionStartLabel.text = parkingSession?.startTimeAsString();
        sessionEndLabel.text = (parkingSession?.EndTime != nil ? parkingSession?.endTimeAsString() : "Session not ended");
        sessionDurationLabel.text = (parkingSession?.EndTime != nil ? parkingSession!.calculateDuration() : "Session not ended");
        sessionCostLabel.text = (parkingSession?.Value != nil ? parkingSession?.displaySessionCost() : "Session not ended");
        sessionLocationLabel.text = parkingSession?.locationDetails();
        println("CarParkID \(parkingSession?.CarParkID.description)");
    }
    
    
    func refresh(sender:AnyObject)
    {
        populateSessionFields();
        self.tableView.reloadData();
        self.refreshControl?.endRefreshing();
    }
}