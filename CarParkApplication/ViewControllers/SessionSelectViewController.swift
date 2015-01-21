//
//  SessionSelectViewController.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 20/01/2015.
//  Copyright (c) 2015 DavidMcQueen. All rights reserved.
//


import UIKit

class SessionSelectViewController: UITableViewController {
    
    var parkSessions:[String] = []
    var allParkSessions:[ParkSession] = [];
    var allUserVehicles:[Vehicle] = []
    var currentSessions = true;
    
    weak var delegate: SelectUserVehicleDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allUserVehicles = User.sharedInstance.getVehicles();
        
        updateTabelData(currentSessions);
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 //Can only select 1 item from the list of vehicles
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parkSessions.count //The amount of vehicles linked to the user
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("sessionCell", forIndexPath: indexPath) as ParkSessionViewCell
//        cell.textLabel?.text = parkSessions[indexPath.row]
        var cellSession = allParkSessions[indexPath.row];
        
        cell.sessionDetails.text = "\(cellSession.StartTime)"
        cell.vehicleDetails.text = parkSessions[indexPath.row]
        
        var sessionVehicle: Vehicle?;
        for vehicle in allUserVehicles{
            if vehicle.VehicleID == allParkSessions[indexPath.row].ParkedVehicleID{
                sessionVehicle = vehicle;
            }
        }
        cell.vehicleDetails.text = "\(sessionVehicle!.displayVehicle())";
        
        return cell
    }
    
    //MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        //TODO:- Change the colour of the END button
        if(currentSessions){
            var deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "End", handler:{action, indexpath in
                //Delete vehicle
                self.allParkSessions[indexPath.row].CurrentSession = false;
                self.parkSessions.removeAtIndex(indexPath.row);
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade);
            });
             return [deleteRowAction];
        }else{
            return nil;
        }
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if (currentSessions){
            return true
        }else{
            return false;
        }
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    
    func updateTabelData(currentSession: Bool){
        if (currentSession){
            allParkSessions = User.sharedInstance.getCurrentParkSessions()
        }else{
            allParkSessions = User.sharedInstance.getPreviousParkSessions()
        }
        parkSessions.removeAll(keepCapacity: false);
        
        for session in allParkSessions{
            parkSessions.append(String(session.ParkSessionID.description));
            println(session.ParkSessionID);
        }
    }
    
}
