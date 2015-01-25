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
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                var alert = UIAlertView(title: "Success!", message: token, delegate: nil, cancelButtonTitle: "Okay.")
                if(success) {
                    alert.title = "Success!"
                    println(token)
                }
                else {
                    alert.title = "Failed : ("
                    alert.message = token
                }

                // Move to the UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // Show the alert
                    alert.show()
                    if(success){
                        User.sharedInstance.token = token;
                        User.sharedInstance.FirstName = newUser.FirstName;
                        User.sharedInstance.Surname = newUser.SurName;
                        let createVehicleViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CreateVehicleViewController") as CreateVehicleViewController;
                        self.navigationController?.pushViewController(createVehicleViewController, animated: true);
                    }
                });
                
                }
          );
            
        }
        
    }
    
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
            missingInputs.append("Phone Number");
        }
        
        return (success, missingInputs);
    }
    /// MARK: Actions
    
    //func submit(_: UIBarButtonItem!) {
        
        
//        var validationErrors = self.form.validateForm();
// 
//        if validationErrors.count > 0 {
//            var validationMessage = "Please complete all fields!."
//            for (inputField) in validationErrors{
//                validationMessage = validationMessage + "\n" +  inputField.title;
//            }
//            
//            var validationAlert = UIAlertView(title: "Missing data!", message: validationMessage, delegate: nil, cancelButtonTitle: "Okay.")
//            validationAlert.show();
//        }else{
//            
//            let message = self.form.formValues().description
//            let inputs:Dictionary = self.form.formValues()
//            
//            var emailInput = inputs["email"] as String!
//            var forenameInput = inputs["name"] as String!
//            var lastnameInput = inputs["lastName"] as String!
//            var passwordInput = inputs["password"] as String!
//            var phoneNumberInput = inputs["phone"] as String!
//            
//            var newUser = UserRegistration(
//                _firstName: forenameInput,
//                _surname: lastnameInput,
//                _email: emailInput,
//                _password: passwordInput,
//                _phoneNumber: phoneNumberInput);
//            
//            if(!newUser.validEmailPattern() || !newUser.validPasswordPattern() || !newUser.validPhonePattern()){
//                var invalidInputsMessage = "Please correct your inputs"
//                if (!newUser.validEmailPattern()){
//                    invalidInputsMessage = invalidInputsMessage + "\n" + "Invalid Email"
//                }
//                if (!newUser.validPasswordPattern()){
//                    invalidInputsMessage = invalidInputsMessage + "\n" + "Invalid Password"
//                }
//                if (!newUser.validPhonePattern()){
//                    invalidInputsMessage = invalidInputsMessage + "\n" + "Invalid Phone Number"
//                }
//                var invalidInputsAlert = UIAlertView(title: "Incomplete data!", message: invalidInputsMessage, delegate: nil, cancelButtonTitle: "Okay.")
//                invalidInputsAlert.show();
//                
//                println("Email failed: \(!newUser.validEmailPattern())");
//                println("Password failed: \(!newUser.validPasswordPattern())");
//                println("Phone failed: \(!newUser.validPhonePattern())");
//                
//                return;
//            }
//            
//            registerUser(newUser, {(success: Bool, token: String, error: String?) -> () in
//                var alert = UIAlertView(title: "Success!", message: token, delegate: nil, cancelButtonTitle: "Okay.")
//                if(success) {
//                    alert.title = "Success!"
//                    println(token)
//                    alert.message = message
//                    //TODO:- Add the token and user details into the user object
//                }
//                else {
//                    alert.title = "Failed : ("
//                    alert.message = token
//                }
//                
//                // Move to the UI thread
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    // Show the alert
//                    alert.show()
//                    if(success){
//                        User.sharedInstance.token = token;
//                        User.sharedInstance.FirstName = newUser.FirstName;
//                        User.sharedInstance.Surname = newUser.SurName;
//                        let createVehicleViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CreateVehicleViewController") as CreateVehicleViewController;
//                        self.navigationController?.pushViewController(createVehicleViewController, animated: true);
//                    }
//                });
//                
//                }
//            );
//            
//        }
//        
//    }
}