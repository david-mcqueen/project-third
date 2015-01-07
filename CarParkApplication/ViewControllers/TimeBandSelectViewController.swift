//
//  TimeBandSelectViewController.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 07/01/2015.
//  Copyright (c) 2015 DavidMcQueen. All rights reserved.
//

import UIKit

class TimeBandSelectViewController: UITableViewController {
    
    var timeBands:[String]!
    var selectedTimeBand:String? = nil
    var selectedTimeBandIndex:Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeBands = [
            "2 hours",
            "2-4 hours",
            "4+ hours"
        ];
        
        if let timeBand = selectedTimeBand {
            selectedTimeBandIndex = find(timeBands, timeBand)!
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
        return timeBands.count //The amount of vehicles linked to the user
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("timeBandCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = timeBands[indexPath.row]
        
        if indexPath.row == selectedTimeBandIndex {
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
        if let index = selectedTimeBandIndex {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
            cell?.accessoryType = .None
        }
        
        selectedTimeBandIndex = indexPath.row
        selectedTimeBand = timeBands[indexPath.row]
        
        //update the checkmark for the current row
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SaveTimeBand" {
            let cell = sender as UITableViewCell;
            let indexPath = tableView.indexPathForCell(cell);
            selectedTimeBandIndex = indexPath?.row
            
            if let index = selectedTimeBandIndex {
                selectedTimeBand = timeBands[index]
            }
        }
    }
    
}
