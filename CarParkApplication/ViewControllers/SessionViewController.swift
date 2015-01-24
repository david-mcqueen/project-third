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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateSessionFields();
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true);
    }
    
    func populateSessionFields(){
        var vehicleText: String?;
        for vehicle in User.sharedInstance.getVehicles(){
            if vehicle.VehicleID! == parkingSession?.ParkedVehicleID{
                vehicleText = vehicle.displayVehicle();
            }
        }
        vehicleLabel.text = vehicleText;
        sessionStartLabel.text = parkingSession?.startTimeAsString();
        sessionEndLabel.text = (parkingSession?.EndTime != nil ? parkingSession?.endTimeAsString() : "Session not ended");
        sessionDurationLabel.text = "TODO";
        sessionCostLabel.text = (parkingSession?.Value != nil ? parkingSession?.Value!.description : "Session not ended");
    }
    
    
    @IBAction func endParkingPressed(sender: AnyObject) {
        var sessionID = self.parkingSession?.ParkSessionID
        stopParking(User.sharedInstance.token!, sessionID!, { (success, value, error) -> () in
            
            // Move to the UI thread
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if (success){
                    
                    println("\(value)")
                    
                }else{
                    NSLog("Something went wrong. \(error)")
                }
                
            });
            
        });
    }
 
    
    //MARK:- Table delegates
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if (indexPath.section == 1 && indexPath.row == 1){
//            extendAddFunds(self);
//        } else if (indexPath.section == 2 && indexPath.row == 0){
//            textAddFunds.becomeFirstResponder();
//        }
    }
    
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if(section == 2 && !displayAddFunds){
//            //Set the header & footer heights to 0
//            self.tableView.sectionHeaderHeight = 0;
//            return 0;
//        } else {
//            return super.tableView(tableView, heightForHeaderInSection: section);
//        }  //keeps inalterate all other Header
//    }
    
//    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if(section == 2 && !displayAddFunds) {
//            //Set the header & footer heights to 0
//            self.tableView.sectionFooterHeight = 0;
//            return 0;
//        } else {
//            return super.tableView(tableView, heightForFooterInSection: section)
//        }
//    }
    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if(section == 2) //Index number of interested section
//        {
//            if (displayAddFunds){
//                return 1;
//            }else{
//                return 0;
//            }
//        }else{
//            return super.tableView(tableView, numberOfRowsInSection: section)
//        }
//    }
}