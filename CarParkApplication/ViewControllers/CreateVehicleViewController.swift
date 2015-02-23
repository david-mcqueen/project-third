//
//  CreateVehicleViewController.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 07/01/2015.
//  Copyright (c) 2015 DavidMcQueen. All rights reserved.
//

import Foundation
import UIKit

//Controller to allow the user to create a new vehicle. This is used by both the main register process, and also from the VehicleSelector
class CreateVehicleViewController: UITableViewController,UIPickerViewDataSource,UIPickerViewDelegate, UITextFieldDelegate{
    
    //MARK:- UI Outlets
    @IBOutlet var makeLabel: UILabel!
    @IBOutlet var modelLabel: UILabel!
    @IBOutlet weak var modelInput: UITextField!
    @IBOutlet weak var makeInput: UITextField!
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
    
    //MARK:- Variables
    weak var delegate: CreateVehicleDelegate?;
    var keyboardIsShowing: Bool = false
    
    //MARK:- default functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create a navbar item
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .Bordered, target: self, action: "submit:")
        
        //Setup the picker delegates
        makePicker.dataSource = self;
        makePicker.delegate = self;
        makePicker.tag = 0;
        
        modelPicker.dataSource = self;
        modelPicker.delegate = self;
        modelPicker.tag = 1;
        
        //Setup the pickers as the input methods for the Make & model text fields.
        makeInput.inputView = makePicker;
        makeInput.frame = CGRectZero
        makeInput.userInteractionEnabled = false;
        makeInput.delegate = self;
        
        modelInput.inputView = modelPicker;
        modelInput.frame = CGRectZero;
        modelInput.userInteractionEnabled = false;
        
        //Attach a handler to move the view up when displaying the keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShowVehicle:"), name:UIKeyboardWillShowNotification, object: nil);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHideVehicle:"), name:UIKeyboardWillHideNotification, object: nil);
        
        populateMakes();
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated);
        //Remove the keyboard handlers when leaving this view
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil);
    }
    
    //MARK:- Keyboard functions
    func keyboardWillShowVehicle(notification: NSNotification) {
        println("keyboardWillShowVehicle")
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        if (screenHeight < 500){
            if let info = notification.userInfo {
                var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
                
                if (!self.keyboardIsShowing){
                    self.keyboardIsShowing = true
                    if(registrationLabel.isFirstResponder() || colourLabel.isFirstResponder()){
                        self.tableView.frame.origin.y -= 50;
                    }else{
                        self.tableView.frame.origin.y -= 75;
                    }
                    
                }
            }
        }
    }
    
    func keyboardWillHideVehicle(notification: NSNotification) {
        println("keyboardWillHideVehicle")
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        if (screenHeight < 500){
            if let info = notification.userInfo {
                var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
                
                
                if (self.keyboardIsShowing){
                    self.keyboardIsShowing = false
                    if(registrationLabel.isFirstResponder() || colourLabel.isFirstResponder()){
                        self.tableView.frame.origin.y += 50;
                    }else{
                        self.tableView.frame.origin.y += 75;
                    }
                    
                    
                }
            }
        }
        
    }

    
    
    //MARK:- TextField Delegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        //Dont allow the user to PASTE into the make / model inputs
        if textField == makeInput || textField == modelInput{
            return false;
        }else{
            return true;
        }
    }
    
    
    //MARK:- Add vehicle
    func submit(_: UIBarButtonItem!) {
        println("Register new vehicle with user")
        
        if(allInputsComplete()){
            let newUserVehicle = Vehicle(
                make: makeInput.text!,
                model: modelInput.text!,
                colour: colourLabel.text!,
                registrationNumber: registrationLabel.text!,
                deleted: false
            )
            
            //Process the new vehicle registration with the server
            createVehicle(User.sharedInstance.token!, newUserVehicle, {(success: Bool, createdVehicle: Vehicle, error:String?) -> () in
                // Move to the UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // Show the alert
                    
                    if(success){
                        println("New vehicle added")
                        //Add the new vehicle to the user vehicle list
                        User.sharedInstance.addVehicle(createdVehicle);
                        
                        if (self.delegate != nil){
                            self.delegate?.newVehicleCreated();
                        }else{
                            //Navigate to the logged in section (replacing the previous view)
                            let userRegistered = self.storyboard?.instantiateViewControllerWithIdentifier("viewLoggedInViewController") as UITabBarController;
                            self.navigationController?.showDetailViewController(userRegistered, sender: self);
                        }
                    }else{
                        println("Create Vehicle: Something went wrong.")
                    }
                });
                
                }
            );
            
        }else{
            displayAlert("Missing data!", "Please complete all fields", "Okay.");
        }
    }
    
    //MARK:- viewFunctions
    func allInputsComplete() -> Bool{
        if (modelInput.text == nil || modelInput.text == ""
            || makeInput.text == nil || makeInput.text == ""
            || registrationLabel.text == nil || registrationLabel.text == ""
            || colourLabel.text == nil || colourLabel.text == ""){
                return false;
        }else{
            return true;
        }
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
        println(pickerView.tag);
        if (pickerView.tag == 0){
            //Display the selected car make
            makeInput.text = makePickerData[row]
            println(makePickerData[row]);
            
            //Make the model read only, until the models for that make are loaded
            modelInput.userInteractionEnabled = false;
            modelInput.placeholder = "Loading models..."
            
            populateModels(self.makeDictionary[makePickerData[row]]!);
        }else{
            modelInput.text = modelPickerData[row]
        }
    }
    
    //MARK:- Picker Function
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    
    //MARK:- Table delegates
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 0){
            registrationLabel.becomeFirstResponder();
        }else if(indexPath.row == 1){
            colourLabel.becomeFirstResponder();
        }else if(indexPath.row == 2){
            makeInput.becomeFirstResponder();
        }else if(indexPath.row == 3){
            modelInput.becomeFirstResponder();
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as UITableViewHeaderFooterView
        
        header.textLabel.textColor = UIColor.whiteColor() //make the text white
        header.textLabel.font = UIFont.boldSystemFontOfSize(12);
    }
    
    
    //MARK:- Vehicle data
    func populateMakes(){
        //Get the makes from the API
        getMakes({(success: Bool, vehicleMakes: [CarMake], serverError:NSError?, JSONerror: NSError?) -> () in
            //Switch to the UI thread
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if(success) {
                
                var listOfMakes: [String] = []
                
                for make in vehicleMakes{
                    listOfMakes.append(make.make_display);
                    
                    //Save the make name & ID in a dictionary
                    self.makeDictionary[make.make_display] = make.make_id;
                }
                //TODO:- Handle no data being returned from the server (empty list for picker etc)
                self.makePickerData = listOfMakes;
                self.makeInput.userInteractionEnabled = true;
                self.makeInput.placeholder = "Select Make";
                
            }else{
                println("Something went wrong");
                //TODO:- Handler the 2 error vairables
            }
            });
        });
    }
    
    func populateModels(selectedMakeID: String){
        //Get the models from the API
        getModels(selectedMakeID, {(success: Bool, vehicleModels: [CarModel], serverError:NSError?, JSONerror: NSError?) -> () in
            //Switch to the UI thread
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if(success) {
                    var listOfModels: [String] = []
                
                    for model in vehicleModels{
                        listOfModels.append(model.model_name);
                        self.modelDictionary[model.model_name] = model.model_make_id;
                    }
                    //TODO:- Handle no data being returned from the server (empty list for picker etc)
                    self.modelPickerData = listOfModels;
                    self.modelInput.placeholder = "Select Model";
                    self.modelInput.userInteractionEnabled = true;
                
                }else{
                    println("Something went wrong");
                    //TODO:- Handler the 2 error vairables
                }
            });
        });
    }

}

