//
//  SessionViewController.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 22/01/2015.
//  Copyright (c) 2015 DavidMcQueen. All rights reserved.
//

import UIKit

class SessionViewController: UITableViewController{
    
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
                    }else{
                        NSLog("Something went wrong. \(error)")
                    }
                    
                });
                
            });
        }
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
        for vehicle in User.sharedInstance.getVehicles(){
            if vehicle.VehicleID! == parkingSession?.ParkedVehicleID{
                vehicleText = vehicle.displayVehicle();
            }
        }
        vehicleLabel.text = vehicleText;
        sessionStartLabel.text = parkingSession?.startTimeAsString();
        sessionEndLabel.text = (parkingSession?.EndTime != nil ? parkingSession?.endTimeAsString() : "Session not ended");
        sessionDurationLabel.text = (parkingSession?.EndTime != nil ? parkingSession!.calculateDuration() : "Session not ended");
        sessionCostLabel.text = (parkingSession?.Value != nil ? parkingSession?.Value!.description : "Session not ended");
    }
    
    
    func refresh(sender:AnyObject)
    {
        populateSessionFields();
        self.tableView.reloadData();
        //        self.refreshControl?.endRefreshing();
    }
}