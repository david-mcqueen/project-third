//
//  SessionSelectViewController.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 20/01/2015.
//  Copyright (c) 2015 DavidMcQueen. All rights reserved.
//

/*
//  TableViewController, displaying all the users parking sessions (either current, or previous).
//  Allows the user to select a a session they want to view in detail.
*/
import UIKit

class SessionSelectViewController: UITableViewController {
    
    //MARK:- Variables & Constants
    var parkSessions:[String] = []
    var allParkSessions:[ParkSession] = [];
    var allUserVehicles:[Vehicle] = []
    var currentSessions = true;
    var selectedSession: ParkSession?
    
    
    //MARK:- Default functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        allUserVehicles = User.sharedInstance.getVehicles();
        
        updateTabelData(currentSessions);
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true);
        println("viewWillAppear");
        updateTabelData(currentSessions);
        refresh(self);
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

        var cellSession = allParkSessions[indexPath.row];
        
        cell.sessionDetails.text = (cellSession.startTimeAsString()) + (!currentSessions ? " -> \(cellSession.endTimeAsString())" : "");
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
        selectedSession = allParkSessions[indexPath.row];
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("viewParkingSession", sender: self);
    }
    
    
    //MARK:- Row side-buttons
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        //TODO:- Change the colour of the END button
        if(currentSessions){
            var deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "End", handler:{action, indexpath in
                
                
                stopParking(User.sharedInstance.token!, self.allParkSessions[indexPath.row].ParkSessionID, { (success, value, error) -> () in
                
                    // Move to the UI thread
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if (success){
                            self.allParkSessions[indexPath.row].CurrentSession = false;
                            self.parkSessions.removeAtIndex(indexPath.row);
                            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade);
                            //TODO:- Display the cost of the parking session.
                            println("\(value)")
                        }else{
                            displayAlert("Server Error", error!, "Ok");
                            NSLog("Something went wrong. \(error)");
                        }

                    });
                    
                });
                
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
        }
    }
    
    
    //MARK:- Segue Functions
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "viewParkingSession"){
            println("viewSession Segue")
            println(selectedSession!)
            let currentSessionViewController = segue.destinationViewController as SessionViewController
            currentSessionViewController.parkingSession = selectedSession!;
        }
    }
    
    
    func refresh(sender:AnyObject)
    {
        println("Refresh")
        
        self.tableView.reloadData();
        self.refreshControl?.endRefreshing();
    }
}
