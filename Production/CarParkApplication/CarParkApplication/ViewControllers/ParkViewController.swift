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
   
    //TODO:- Confirm the var name
    @IBOutlet weak var PayMethodButton: UISwitch!

    
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

    
    //MARK:- Functions
    
    func viewInvert(){
        //Inverts the current state of the views
        HourPayView.hidden = !HourPayView.hidden;
        ManuallyPayView.hidden = !ManuallyPayView.hidden;
    }
    
    
    func getTime() -> (hour:Int, minute:Int){
        //POST: Returns the current hour & minute
        //This will need to be confirmed with the server
        let date = NSDate();
        let calendar = NSCalendar.currentCalendar();
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date);
        let hour = components.hour;
        let minutes = components.minute;
        
        NSLog(String(minutes));
        
        return (hour, minutes);
    }
    
    func getDate() -> (day:Int, month:Int, year: Int){
        //POST: Returns the current day / Month / Year
        //This will need to be confirmed with the server
        let date = NSDate();
        let calendar = NSCalendar.currentCalendar();
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date);
        let day = components.day;
        let month = components.month;
        let year = components.year;
        
        return (day, month, year);
    }
    
}
