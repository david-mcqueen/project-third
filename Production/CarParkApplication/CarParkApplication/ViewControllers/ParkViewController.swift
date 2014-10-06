//
//  ParkViewController.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 06/10/2014.
//  Copyright (c) 2014 DavidMcQueen. All rights reserved.
//

import UIKit

class ParkViewController: UIViewController {

    @IBOutlet weak var ManuallyPayView: UIView!
    @IBOutlet weak var HourPayView: UIView!
    @IBOutlet weak var PayMethodSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        Set the initial view, based on the direction of the switch.
        The default pay method can be set in the settings.
        */
        if(PayMethodSwitch.on){
            HourPayView.hidden = true;
            ManuallyPayView.hidden = false;
        }else{
            HourPayView.hidden = false;
            ManuallyPayView.hidden = true;
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ParkMethodChanged(sender: AnyObject) {
        viewInvert();
    }

    func viewInvert(){
        //Inverts the current state of the views
        HourPayView.hidden = !HourPayView.hidden;
        ManuallyPayView.hidden = !ManuallyPayView.hidden;
    }
}
