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

class RegisterViewController: FormViewController, FormViewControllerDelegate {
    
    struct Static {
        //The tags are used on the Submit section to extract the data
        static let nameTag = "name"
        static let passwordTag = "password"
        static let lastNameTag = "lastName"
        static let jobTag = "job"
        static let emailTag = "email"
        static let URLTag = "url"
        static let phoneTag = "phone"
        static let enabled = "enabled"
        static let check = "check"
        static let segmented = "segmented"
        static let picker = "picker"
        static let birthday = "birthday"
        static let categories = "categories"
        static let button = "button"
        static let textView = "textview"
    }
    
    override init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .Bordered, target: self, action: "submit:")
    }
    
    /// MARK: Actions
    
    func submit(_: UIBarButtonItem!) {
        
        var validationErrors = self.form.validateForm();
 
        if validationErrors.count > 0 {
            var validationMessage = "Please complete all fields!."
            for (inputField) in validationErrors{
                validationMessage = validationMessage + "\n" +  inputField.title;
            }
            
            var validationAlert = UIAlertView(title: "Missing data!", message: validationMessage, delegate: nil, cancelButtonTitle: "Okay.")
            validationAlert.show();
        }else{
            
            let message = self.form.formValues().description
            let inputs:Dictionary = self.form.formValues()
            
            var emailInput = inputs["email"] as String!
            var forenameInput = inputs["name"] as String!
            var lastnameInput = inputs["lastName"] as String!
            var passwordInput = inputs["password"] as String!
            var phoneNumberInput = inputs["phone"] as String!
            
            var newUser = UserRegistration(
                _firstName: forenameInput,
                _surname: lastnameInput,
                _email: emailInput,
                _password: passwordInput,
                _phoneNumber: phoneNumberInput);
            
            if(!newUser.validEmailPattern() || !newUser.validPasswordPattern() || !newUser.validPhonePattern()){
                var invalidInputsMessage = "Please correct your inputs"
                if (!newUser.validEmailPattern()){
                    invalidInputsMessage = invalidInputsMessage + "\n" + "Invalid Email"
                }
                if (!newUser.validPasswordPattern()){
                    invalidInputsMessage = invalidInputsMessage + "\n" + "Invalid Password"
                }
                if (!newUser.validPhonePattern()){
                    invalidInputsMessage = invalidInputsMessage + "\n" + "Invalid Phone Number"
                }
                var invalidInputsAlert = UIAlertView(title: "Incomplete data!", message: invalidInputsMessage, delegate: nil, cancelButtonTitle: "Okay.")
                invalidInputsAlert.show();
                
                println("Email failed: \(!newUser.validEmailPattern())");
                println("Password failed: \(!newUser.validPasswordPattern())");
                println("Phone failed: \(!newUser.validPhonePattern())");
                
                return;
            }
            
            registerUser(newUser, {(success: Bool, token: String, error: String?) -> () in
                var alert = UIAlertView(title: "Success!", message: token, delegate: nil, cancelButtonTitle: "Okay.")
                if(success) {
                    alert.title = "Success!"
                    alert.message = message
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
                        let viewVehicleRegistration = self.storyboard?.instantiateViewControllerWithIdentifier("viewVehicleRegistration") as RegisterVehicleViewController;
                        self.navigationController?.pushViewController(viewVehicleRegistration, animated: true);
                    }
                });
                
                }
            );
            
        }
        
    }
    
    
    func registerUser(newUser: UserRegistration, registerCompleted: (success: Bool, token: String, error: String?) -> ()) -> (){
        //Pass the user details to the server, to register
        //TODO:- Handle failure reponse / unknown failure
        
        let urlSession = NSURLSession.sharedSession();

        let url = NSURL(string:"http://projectthird.ddns.net:8181/WebAPI/webapi/register");
        var request = NSMutableURLRequest(URL: url!);
        
        var error1 : NSError?;
        var errorResponse: String?;
        request.HTTPMethod = "POST";
        var params: Dictionary<String, String> = ([
            "Forename" : newUser.FirstName,
            "Surname" : newUser.SurName,
            "Email" : newUser.Email,
            "PhoneNumber" : newUser.PhoneNumber,
            "Password" : newUser.Password
            ]);

        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &error1);
        request.addValue("application/json", forHTTPHeaderField: "Content-Type");
        request.addValue("text/plain", forHTTPHeaderField: "Accept");

        var registerResponse = urlSession.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in

            println(response);
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            var success = false;
                
            println(strData);

            if (error != nil) {
                println(error.localizedDescription);
                errorResponse = error.localizedDescription;
            }
//            var err: NSError?
        
            //Parse the resonse into JSON
            //var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                    
//            if (err != nil){
//                println("JSON Error \(err!.localizedDescription) ");
//            }
            
            var token:String?;
            //TODO:- CHeck of the response contains an error message
            if (strData != nil){
                if (validateGUID(strData!.description)){
                    token = strData!.description;
                    success = true;
                }
            }
            
            registerCompleted(success: success, token: token!, error: errorResponse);
            });
        
        registerResponse.resume();
    }

    
    /// MARK: Private interface
    
    private func loadForm() {
        
        let form = FormDescriptor()
        
        form.title = "Personal Details"
        
        let section1 = FormSectionDescriptor()
        
        var row: FormRowDescriptor! = FormRowDescriptor(tag: Static.nameTag, rowType: .Name, title: "First Name")
        
        row.cellConfiguration = ["textField.placeholder" : "e.g. David", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        row.required = true;
        section1.addRow(row)
        
        row = FormRowDescriptor(tag: Static.lastNameTag, rowType: .Name, title: "Last Name")
        row.cellConfiguration = ["textField.placeholder" : "e.g. McQueen", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        row.required = true;
        section1.addRow(row)
        
        
        let section2 = FormSectionDescriptor()
        
        row = FormRowDescriptor(tag: Static.emailTag, rowType: .Email, title: "Email")
        row.cellConfiguration = ["textField.placeholder" : "e.g. myemail@gmail.com", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        row.required = true;
        section2.addRow(row)
        
        row = FormRowDescriptor(tag: Static.phoneTag, rowType: .Phone, title: "Phone")
        row.cellConfiguration = ["textField.placeholder" : "e.g. 0034666777999", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        row.required = true;
        section2.addRow(row)
        
        row = FormRowDescriptor(tag: Static.passwordTag, rowType: .Password, title: "Password")
        row.cellConfiguration = ["textField.placeholder" : "Enter password", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        row.required = true;
        section2.addRow(row)
        
        form.sections = [section1, section2]
        
        self.form = form
    }
    
    /// MARK: FormViewControllerDelegate
    
    func formViewController(controller: FormViewController, didSelectRowDescriptor rowDescriptor: FormRowDescriptor) {
        if rowDescriptor.tag == Static.button {
            self.view.endEditing(true)
        }
    }
}