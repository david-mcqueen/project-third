//
//  VehicleSelectViewController
//  CarParkApplication
//
//  Created by DavidMcQueen on 06/10/2014.
//  Copyright (c) 2014 DavidMcQueen. All rights reserved.
//

/*
//  TableViewController, displaying all the users vehicles.
//  Allows the user to select a vehicle they want to park
*/
import UIKit

class VehicleSelectViewController: UITableViewController, CreateVehicleDelegate {
    
    //MARK:- Variables & Constants
    var vehicles:[String] = []
    var selectedVehicle:Vehicle?
    var selectedVehicleObject: Vehicle?;
    var selectedVehicleIndex:Int? = nil
    var allVehicles:[Vehicle] = [];
    
    weak var delegate: SelectUserVehicleDelegate?
    
    //MARK:- Default functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTabelData();
        
        if let vehicle = selectedVehicle?.displayVehicle() {
            selectedVehicleIndex = find(vehicles, vehicle)!
        }
//        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- Custom Functions
    @IBAction func addNewVehicle(sender: AnyObject) {
        let createVehicleViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CreateVehicleViewController") as CreateVehicleViewController
        createVehicleViewController.delegate = self;
        self.navigationController?.pushViewController(createVehicleViewController, animated: true);
        
    }
    
    func updateTabelData(){
        //Update the view with the latest data.
        allVehicles = User.sharedInstance.getVehicles();
        vehicles.removeAll(keepCapacity: false);
        for vehicle in allVehicles{
            vehicles.append(vehicle.displayVehicle());
        }
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
        cell.textLabel?.textColor = UIColor(red: 0.275, green: 0.4, blue: 0.459, alpha: 1);
        

        if indexPath.row == selectedVehicleIndex {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        return cell
    }
    
    
    //MARK: - Table view delegates
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //Other row is selected - need to deselect it
        if let index = selectedVehicleIndex {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
            cell?.accessoryType = .None
        }
        
        selectedVehicleIndex = indexPath.row
        selectedVehicle = allVehicles[indexPath.row]
        
        if (delegate != nil){
            //update the checkmark for the current row
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            cell?.accessoryType = .Checkmark
        }

        selectedVehicleIndex = indexPath.row
        if let index = selectedVehicleIndex {
            selectedVehicle = allVehicles[index]
        }
        
        //Return to the delegate, with the selected vehicle
        delegate?.didSelectUserVehicle(selectedVehicle!);
        
    }
    
    //MARK:- Row side-buttons
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        var editRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Edit", handler:{action, indexpath in
            println("EDIT•ACTION");
        });
        editRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        var deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler:{action, indexpath in
            //Delete vehicle
            self.vehicles.removeAtIndex(indexPath.row);
            User.sharedInstance.deleteVehicle(self.allVehicles[indexPath.row]);
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade);
        });
        
        return [deleteRowAction, editRowAction];
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    //MARK:- CreateVehicleDelegate
    func newVehicleCreated(){
        self.navigationController?.popViewControllerAnimated(true);
        updateTabelData();
        self.tableView.reloadData();
    }
    
}
