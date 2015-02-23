//
//  RegisterViewController.swift
//  CarParkApplication
//
//  Makes use of SwiftForms (Miguel Angel Ortuño), an open library distributed under the MIT license
//  https://github.com/ortuman/SwiftForms
//
//  Created by David McQueen on 06/10/2014.
//  Copyright (c) 2014 David McQueen. All rights reserved.
//

import UIKit

class RegisterViewController: UITableViewController {
    
    //MARK:- UI Outlets
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var keyboardIsShowing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Attach a handler to move the view up when displaying the keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShowRegister:"), name:UIKeyboardWillShowNotification, object: nil);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHideRegister:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated);
        //Remove the keyboard handlers when leaving this view
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil);
    }
    
    //MARK:- Keyboard functions
    func keyboardWillShowRegister(notification: NSNotification) {
        println("keyboardWillShowRegister")
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        if (screenHeight < 500 && (txtEmail.isFirstResponder() || txtPhone.isFirstResponder() || txtPassword.isFirstResponder())){
            if let info = notification.userInfo {
                var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
                
                if (!self.keyboardIsShowing){
                    self.keyboardIsShowing = true
                    self.tableView.frame.origin.y -= 150;
                }
            }
        }
    }
    
    func keyboardWillHideRegister(notification: NSNotification) {
        println("keyboardWillHideRegister")
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        if (screenHeight < 500 && (txtEmail.isFirstResponder() || txtPhone.isFirstResponder() || txtPassword.isFirstResponder())){
            if let info = notification.userInfo {
                var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
                
                
                if (self.keyboardIsShowing){
                    self.keyboardIsShowing = false
                    self.tableView.frame.origin.y += 150;
                    
                }
            }
        }
        
    }
    
    //MARK:- Table delegates
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0 && indexPath.row == 0){
            txtFirstName.becomeFirstResponder();
        }else if(indexPath.section == 0 && indexPath.row == 1){
            txtLastName.becomeFirstResponder();
        }else if(indexPath.section == 1 && indexPath.row == 0){
            txtEmail.becomeFirstResponder();
        }else if(indexPath.section == 1 && indexPath.row == 1){
            txtPhone.becomeFirstResponder();
        }else if(indexPath.section == 1 && indexPath.row == 2){
            txtPassword.becomeFirstResponder();
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as UITableViewHeaderFooterView
        
        header.textLabel.textColor = UIColor.whiteColor() //make the text white
        header.textLabel.font = UIFont.boldSystemFontOfSize(12);
    }
    
    
    //MARK:- Button Functions
    @IBAction func registerUserPressed(sender: AnyObject) {
        let (inputsCompleted, missingInputs) = allFieldsCompleted();
        
        if (!inputsCompleted){
            var validationMessage = "Please complete all fields!."
            for (inputField) in missingInputs{
                validationMessage = validationMessage + "\n" +  inputField;
            }
            var validationAlert = UIAlertView(title: "Missing data!", message: validationMessage, delegate: nil, cancelButtonTitle: "Okay.")
            validationAlert.show();
        }else{
            var newUser = UserRegistration(
                    _firstName: txtFirstName.text,
                    _surname: txtLastName.text,
                    _email: txtEmail.text,
                    _password: txtPassword.text,
                    _phoneNumber: txtPhone.text);
            
            if(!newUser.validEmailPattern() || !newUser.validPasswordPattern() || !newUser.validPhonePattern()){
                var invalidInputsMessage = "Please correct your inputs"
                if (!newUser.validEmailPattern()){
                    invalidInputsMessage = invalidInputsMessage + "\n" + "Invalid Email"
                }
                if (!newUser.validPhonePattern()){
                    invalidInputsMessage = invalidInputsMessage + "\n" + "Invalid Phone Number"
                }
                if (!newUser.validPasswordPattern()){
                    invalidInputsMessage = invalidInputsMessage + "\n" + "Invalid Password"
                }
                
                
                var invalidInputsAlert = UIAlertView(title: "Incomplete data!", message: invalidInputsMessage, delegate: nil, cancelButtonTitle: "Okay.")
                invalidInputsAlert.show();

                return;
            }
            
            registerUser(newUser, {(success: Bool, token: String, error: String?) -> () in
                // Move to the UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // Show the alert
                    
                    if(success){
                        User.sharedInstance.token = token;
                        User.sharedInstance.FirstName = newUser.FirstName;
                        User.sharedInstance.Surname = newUser.SurName;
                        let createVehicleViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CreateVehicleViewController") as CreateVehicleViewController;
                        self.navigationController?.pushViewController(createVehicleViewController, animated: true);
                    }else{
                        displayAlert("FAILED", "Something went wrong", "OK")
                    }
                });
                
                }
          );
            
        }
        
    }
    
    
    //MARK:- Functions
    func allFieldsCompleted() -> (Bool, [String]){
        var success = true;
        var missingInputs: [String] = [];
        
        if(txtFirstName.text == nil || txtFirstName.text == ""){
            success = false;
            missingInputs.append("First Name");
        }
        if(txtLastName.text == nil || txtLastName.text == ""){
            success = false;
            missingInputs.append("Last Name");
        }
        if(txtEmail.text == nil || txtEmail.text == ""){
            success = false;
            missingInputs.append("Email");
        }
        if(txtPhone.text == nil || txtPhone.text == ""){
            success = false;
            missingInputs.append("Phone Number");
        }
        if(txtPassword.text == nil || txtPassword.text == ""){
            success = false;
            missingInputs.append("Password");
        }
        
        return (success, missingInputs);
    }
    
}