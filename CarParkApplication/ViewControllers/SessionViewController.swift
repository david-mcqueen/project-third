//
//  SessionViewController.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 22/01/2015.
//  Copyright (c) 2015 David McQueen. All rights reserved.
//

import UIKit

class SessionViewController: UITableViewController{
    
    //MARK:- UI Outlets
    @IBOutlet weak var sessionLocationLabel: UILabel!
    @IBOutlet weak var vehicleLabel: UILabel!
    @IBOutlet weak var sessionStartLabel: UILabel!
    @IBOutlet weak var sessionEndLabel: UILabel!
    @IBOutlet weak var sessionDurationLabel: UILabel!
    @IBOutlet weak var sessionCostLabel: UILabel!
    @IBOutlet weak var btnEndExtentParking: UIButton!
    
    
    //MARk:- Variables
    var parkingSession: ParkSession?;
    var extendParking: Bool = false;
    
    //MARK:- Default functions
    override func viewDidLoad() {
        super.viewDidLoad()
        println("SessionViewController")
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged);
        
        populateSessionFields();
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true);
    }
    
    
    
    //MARK:- TableView delegate
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as UITableViewHeaderFooterView
        
        header.textLabel.textColor = UIColor.whiteColor() //make the text white
        header.textLabel.font = UIFont.boldSystemFontOfSize(12);
    }
    
    
    //MARK:- Custom Functions
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
                        self.parkingSession?.Finished = true;
                        self.refresh(self);
                    }else{
                        NSLog("Something went wrong. \(error)")
                    }
                    
                });
                
            });
        }
    }
    
    func populateSessionFields(){
        if (parkingSession?.Finished == true){
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

        println(parkingSession?.EndTime)
        println(parkingSession?.Value)
        vehicleLabel.text = vehicleText;
        sessionStartLabel.text = parkingSession?.startTimeAsString();
        sessionEndLabel.text = (parkingSession?.Finished == true ? parkingSession?.endTimeAsString() : "Latest Endtime: \(parkingSession!.endTimeAsString())");
        sessionDurationLabel.text = (parkingSession?.Finished == true ? parkingSession!.calculateDuration() : "Max Duration: \(parkingSession!.calculateDuration())");
        sessionCostLabel.text = (parkingSession?.Finished == true ? parkingSession?.displaySessionCost() : "Max Cost: \(parkingSession!.displaySessionCost())");
        sessionLocationLabel.text = parkingSession?.locationDetails();
        println("CarParkID \(parkingSession?.CarParkID.description)");
    }
    
    
    //The function called when the user pulls the table view down to refresh the data.
    func refresh(sender:AnyObject)
    {
        populateSessionFields();
        self.tableView.reloadData();
        self.refreshControl?.endRefreshing();
    }
}