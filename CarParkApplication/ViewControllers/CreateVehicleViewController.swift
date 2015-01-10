//
//  CreateVehicleViewController.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 07/01/2015.
//  Copyright (c) 2015 DavidMcQueen. All rights reserved.
//

import Foundation
import UIKit

class CreateVehicleViewController: UITableViewController,UIPickerViewDataSource,UIPickerViewDelegate{
    
    //MARK:- Static view objects
    @IBOutlet var makeLabel: UILabel!
    @IBOutlet var modelLabel: UILabel!
    @IBOutlet var modelInput: UITextField!
    @IBOutlet var makeInput: UITextField!
    @IBOutlet var colourLabel: UITextField!
    @IBOutlet var registrationLabel: UITextField!
    
    //MARK:- Dynamic view objects
    var makePicker: UIPickerView = UIPickerView();
    var modelPicker: UIPickerView = UIPickerView();
    
    //MRK:- Vehicle data
    var makePickerData = ["Loading..."];
    var makeDictionary: [String: String] = ["": ""];
    var modelPickerData = ["Loading..."];
    var modelDictionary: [String: String] = ["": ""];
    
    weak var delegate: CreateVehicleDelegate?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create a navbar item
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .Bordered, target: self, action: "submit:")
        
        makePicker.dataSource = self;
        makePicker.delegate = self;
        makePicker.tag = 0;
        
        modelPicker.dataSource = self;
        modelPicker.delegate = self;
        modelPicker.tag = 1;
        
        makeInput.inputView = makePicker;
        makeInput.frame = CGRectZero
        makeInput.hidden = true;
        
        modelInput.inputView = modelPicker;
        modelInput.frame = CGRectZero;
        modelInput.hidden = true;
        modelInput.userInteractionEnabled = false;
        
        populateMakes();
    }
    
    //MARK:- Add vehicle
    func submit(_: UIBarButtonItem!) {
        println("Register new vehicle with user")
        
        println(allInputsComplete());
        if(allInputsComplete()){
            let newUserVehicle = Vehicle(make: makeLabel.text!, model: modelLabel.text!, colour: colourLabel.text!, registrationNumber: registrationLabel.text!)
            
            //Process the new vehicle registration with the server
            
            //Add the new vehicle to the user vehicle list
            User.sharedInstance.addVehicle(newUserVehicle);
            
            println("New vehicle added")
            //delegate?.newVehicleCreated();
            
            //TODO:- After registering first time, navigate the user to the "logged in" section
        }else{
            var validationAlert = UIAlertView(title: "Missing data!", message: "Please complete all fields", delegate: nil, cancelButtonTitle: "Okay.")
            validationAlert.show();
        }
    }
    
    //MARK:- viewFunctions
    func allInputsComplete() -> Bool{
        if (modelLabel.text == nil || modelLabel.text == ""
            || makeLabel.text == nil || makeLabel.text == ""
            || registrationLabel.text == nil || registrationLabel.text == ""
            || colourLabel.text == nil || colourLabel.text == ""){
                return false;
        }else{
            return true;
        }
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    //MARK:- Picker data sources
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 0){
            return makePickerData.count
        }else{
            return modelPickerData.count
        }
    }
    
    //MARK:- Picker delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if (pickerView.tag == 0){
            return makePickerData[row]
        }else{
            return modelPickerData[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var result: (String, String) = ("","");
        //makePicker.tag == 0
        if (pickerView.tag == 0){
            //Display the selected car make
            makeLabel.text = makePickerData[row]
            
            //Make the model read only, until the models for that make are loaded
            modelInput.userInteractionEnabled = false;
            modelLabel.text = "Loading models..."
            
            populateModels(self.makeDictionary[makePickerData[row]]!);
        }else{
            modelLabel.text = modelPickerData[row]
        }
    }
    
    //MARK:- Table delegates
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0){
            registrationLabel.becomeFirstResponder();
        }else if(indexPath.section == 1){
            colourLabel.becomeFirstResponder();
        }else if(indexPath.section == 2){
            makeInput.becomeFirstResponder();
        }else if(indexPath.section == 3){
            modelInput.becomeFirstResponder();
        }
    }
    
    //MARK:- Vehicle data
    func populateMakes(){
        //Get the makes from the API
        getMakes({(success: Bool, vehicleMakes: [CarMake]) -> () in
            //Switch to the UI thread
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if(success) {
                
                var listOfMakes: [String] = []
                
                for make in vehicleMakes{
                    listOfMakes.append(make.make_display.description);
                    
                    //Save the make name & ID in a dictionary
                    self.makeDictionary[make.make_display.description] = make.make_id.description;
                }
                //TODO:- Handle no data being returned from the server (empty list for picker etc)
                self.makePickerData = listOfMakes;
                self.makeLabel.text = "Select Make";
                
            }else{
                println("Something went wrong");
            }
            });
        });
    }
    
    func populateModels(selectedMakeID: String){
        //Get the makes from the API
        getModels(selectedMakeID, {(success: Bool, vehicleModels: [CarModel]) -> () in
            //Switch to the UI thread
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if(success) {
                    var listOfModels: [String] = []
                
                    for model in vehicleModels{
                        listOfModels.append(model.model_name.description);
                        self.modelDictionary[model.model_name.description] = model.model_make_id.description;
                    }
                    //TODO:- Handle no data being returned from the server (empty list for picker etc)
                    self.modelPickerData = listOfModels;
                    self.modelLabel.text = "Select Model";
                    self.modelInput.userInteractionEnabled = true;
                
                }else{
                    println("Something went wrong");
                }
            });
        });
    }

}

