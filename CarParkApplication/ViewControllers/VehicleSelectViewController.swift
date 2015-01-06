//
//  VehicleSelectViewController
//  CarParkApplication
//
//  Created by DavidMcQueen on 06/10/2014.
//  Copyright (c) 2014 DavidMcQueen. All rights reserved.
//

import UIKit

class VehicleSelectViewController: UITableViewController {
    
    var vehicles:[String]!
    var selectedVehicle:String? = nil
    var selectedVehicleIndex:Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vehicles = [
            "Renault Megane",
            "Peugeot 206",
            "All other user vehicles"
        ];
        
        if let vehicle = selectedVehicle {
            selectedVehicleIndex = find(vehicles, vehicle)!
        }
        
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
        return vehicles.count //The amount of vehicles linked to the user
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("vehicleCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = vehicles[indexPath.row]
        
        if indexPath.row == selectedVehicleIndex {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        return cell
    }
    
    //MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //Other row is selected - need to deselect it
        if let index = selectedVehicleIndex {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
            cell?.accessoryType = .None
        }
        
        selectedVehicleIndex = indexPath.row
        selectedVehicle = vehicles[indexPath.row]
        
        //update the checkmark for the current row
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("prepare to exit \(segue.identifier)")
        if segue.identifier == "SaveSelectedVehicle" {
            println("exiting")
            let cell = sender as UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            selectedVehicleIndex = indexPath?.row
            if let index = selectedVehicleIndex {
                selectedVehicle = vehicles[index]
            }
        }
    }
    
}
