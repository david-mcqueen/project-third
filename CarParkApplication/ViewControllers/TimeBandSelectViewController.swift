//
//  TimeBandSelectViewController.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 07/01/2015.
//  Copyright (c) 2015 DavidMcQueen. All rights reserved.
//

/*
//  TableViewController, displaying all the time bands for a speciic car park.
//  Allows the user to select a a legth of time to park for
*/
import UIKit

class TimeBandSelectViewController: UITableViewController {
    
    //MARK:- Variables & Constants
    var timeBands:[PricingBand] = []
    var selectedTimeBand:PricingBand?
    var selectedTimeBandIndex:Int? = nil
    var selectedCarPark: Int?
    weak var delegate: TimeBandSelectedDelegate?;
    
    
    //MARK:- Default functions
    override func viewDidLoad() {
        super.viewDidLoad();
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged);
        
        refresh(self);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeBands.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("timeBandCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = timeBands[indexPath.row].displayBand();
        
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
        delegate?.didSelectTimeBand(selectedTimeBand!);
        
        //update the checkmark for the current row
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
    }
    
    //MARK:- Segue Functions
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
    
    
    func refresh(sender:AnyObject)
    {
        println("Refresh");
        timeBands.removeAll(keepCapacity: false);
        loadTimeBands();
        
        self.tableView.reloadData();
        self.refreshControl?.endRefreshing();
        
    }
    
    func loadTimeBands(){
        
        println("loadTimeBands")
        println(User.sharedInstance.token!);
        getCarParkParkingBands(User.sharedInstance.token!, selectedCarPark!, { (success, allPricingBands, error) -> () in
            for band in allPricingBands{
                self.timeBands.append(band);
                
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData();
            });
            
        });
    }
    
}
