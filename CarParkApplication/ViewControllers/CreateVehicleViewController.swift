//
//  CreateVehicleViewController.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 07/01/2015.
//  Copyright (c) 2015 DavidMcQueen. All rights reserved.
//

import Foundation
import UIKit

class CreateVehicleViewController: UITableViewController{
    
    @IBOutlet var colourLabel: UITextField!
    @IBOutlet var registrationLabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0){
            registrationLabel.becomeFirstResponder();
        }else if(indexPath.section == 1){
            colourLabel.becomeFirstResponder();
        }
    }
    
}