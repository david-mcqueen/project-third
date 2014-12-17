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
        
        let message = self.form.formValues().description
        let test = self.form.formValues()
        
        let alert: UIAlertView = UIAlertView(title: "Form output", message: message, delegate: nil, cancelButtonTitle: "OK")
        
        //alert.show()
        
        registerUser({(success: Bool, msg: String) -> () in
                    var alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay.")
                        if(success) {
                            alert.title = "Success!"
                            alert.message = message
                        }
                        else {
                            alert.title = "Failed : ("
                            alert.message = msg
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
    
    
    func registerUser(registerCompleted: (success: Bool, msg: String) -> ()) -> (){
                //Pass the user details to the server, to register
        
                let url = NSURL(string:"http://api.openweathermap.org/data/2.5/weather?q=London,uk");
                let urlSession = NSURLSession.sharedSession();
        
        
                //Used for POST messages
        //        let url = NSURL(string:"http://api.openweathermap.org/data/2.5/weather");
        //        var request = NSMutableURLRequest(URL: url!);
        
        //        var error1 : NSError?;
        //        request.HTTPMethod = "POST";
        //        var params: Dictionary<String, String> = (["q" : "London,uk", "password" : "Test 2"]);
        //
        //        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &error1);
        //        request.addValue("application/json", forHTTPHeaderField: "Content-Type");
        //        request.addValue("application/json", forHTTPHeaderField: "Accept");
        //        println(error1?.localizedDescription);
        //        let jsonResponse = urlSession.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
        
                let jsonResponse = urlSession.dataTaskWithURL(url!, completionHandler: { data, response, error -> Void in
                    if (error != nil) {
                        println(error.localizedDescription);
                    }
                    var err: NSError?
        
                    var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                    if (err != nil){
                        println("JSON Error \(err!.localizedDescription) ");
                    }
                    let city:String! = jsonResult["name"] as NSString;
                    println(jsonResult);
        
                    registerCompleted(success: true, msg: "Register Successful");
                    });
        
                jsonResponse.resume();
        
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



////
////  RegisterViewController.swift
////  CarParkApplication
////
////  Created by David McQueen on 06/10/2014.
////  Copyright (c) 2014 David McQueen. All rights reserved.
////
//
//import UIKit
//import QuartzCore
//
//class RegisterViewController: UIViewController, NSURLSessionDataDelegate {
//
//   
//    //MARK:- Variables & Constants
//    
//    @IBOutlet weak var Scroller: UIScrollView! //Un-needed?
//    @IBOutlet weak var FirstNameInput: UITextField!
//    @IBOutlet weak var SurNameInput: UITextField!
//    @IBOutlet weak var EmailInput: UITextField!
//    @IBOutlet weak var EmailInputConfirm: UITextField!
//    @IBOutlet weak var PasswordInput: UITextField!
//    @IBOutlet weak var PasswordInputConfirm: UITextField!
//    @IBOutlet weak var RegisterButton: UIBarButtonItem!
//    
//    //MARK:- Required Functions
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        let sceenSize: CGRect = UIScreen.mainScreen().bounds;
//       // Scroller.scrollEnabled = true;
//       // Scroller.contentSize = CGSize(width:sceenSize.width, height: 1000);
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    //MARK:- Functions
//    
//    @IBAction func RegisterPressed(sender: AnyObject) {
//        
//        
//        let newRegistration =  UserRegistration(
//            _firstName: FirstNameInput.text,
//            _surname: SurNameInput.text,
//            _email: EmailInput.text.lowercaseString,
//            _confirmEmail: EmailInputConfirm.text.lowercaseString,
//            _password: PasswordInput.text,
//            _confirmPassword: PasswordInputConfirm.text,
//            _phoneNumber: "1",
//            _confirmPhoneNumber: "2");
//        
//        
//        if(!validInputs(newRegistration)){
//            NSLog("All inputs valid");
//            
//            registerUser(newRegistration, {(success: Bool, msg: String) -> () in
//                var alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay.")
//                if(success) {
//                    alert.title = "Success!"
//                    alert.message = msg
//                }
//                else {
//                    alert.title = "Failed : ("
//                    alert.message = msg
//                }
//                
//                // Move to the UI thread
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    // Show the alert
//                    alert.show()
//                    if(success){
//                        let viewVehicleRegistration = self.storyboard?.instantiateViewControllerWithIdentifier("viewVehicleRegistration") as RegisterVehicleViewController;
//                        self.navigationController?.pushViewController(viewVehicleRegistration, animated: true);
//                    }
//                });
//                
//                }
//            );
//
//        }
//        
//    }
//    
//    func validInputs(newUser: UserRegistration) -> Bool{
//        clearBorderRed(FirstNameInput);
//        clearBorderRed(SurNameInput);
//        clearBorderRed(EmailInput);
//        clearBorderRed(EmailInputConfirm);
//        clearBorderRed(PasswordInput);
//        clearBorderRed(PasswordInputConfirm);
//        
//        var valid = true;
//        
//        if (newUser.FirstName == ""){
//            valid = false;
//            borderRed(FirstNameInput);
//        }
//        if (newUser.SurName == ""){
//            valid = false;
//            borderRed(SurNameInput);
//        }
//        if (newUser.Email == "" || !newUser.validEmailPattern()){
//            valid = false;
//            borderRed(EmailInput);
//        }
//        if (newUser.ConfirmEmail == "" || !newUser.matchingEmail() || !newUser.validEmailPattern()){
//            valid = false;
//            borderRed(EmailInputConfirm);
//        }
//        if (newUser.Password == "" || newUser.validPasswordPattern()){
//            valid = false;
//            borderRed(PasswordInput);
//        }
//        if (newUser.ConfirmPassword == "" || !newUser.matchingPassword() || newUser.validPasswordPattern()){
//            valid = false;
//            borderRed(PasswordInputConfirm)
//        }
//        if (newUser.PhoneNumber == ""){
//            //TODO:- Border red the phone number inputs
//            valid = false;
//        }
//        if (newUser.ConfirmPhoneNumber == "" || !newUser.matchingPhoneNumber()){
//            valid = false;
//        }
//        
//        return valid;
//    }
//    
//    func borderRed(inputField: UITextField){
//        //Set the border colour red for the input that failed
//        inputField.layer.borderColor = (UIColor( red: 1, green: 0, blue:0, alpha: 1.0 )).CGColor;
//        inputField.layer.borderWidth = 2.0;
//        inputField.layer.cornerRadius = 5;
//        inputField.clipsToBounds = true;
//        
//    }
//    
//    func clearBorderRed(inputField: UITextField){
//        inputField.layer.borderColor = (UIColor( red: 1, green: 0, blue:0, alpha: 1.0 )).CGColor;
//        inputField.layer.borderWidth = 0.0;
//        inputField.layer.cornerRadius = 5;
//        inputField.clipsToBounds = true;
//    }
//    
//    func registerUser(newUser: UserRegistration, registerCompleted: (success: Bool, msg: String) -> ()) -> (){
//        //Pass the user details to the server, to register
//
//        let url = NSURL(string:"http://api.openweathermap.org/data/2.5/weather?q=London,uk");
//        let urlSession = NSURLSession.sharedSession();
//        
//        
//        //Used for POST messages
////        let url = NSURL(string:"http://api.openweathermap.org/data/2.5/weather");
////        var request = NSMutableURLRequest(URL: url!);
//        
////        var error1 : NSError?;
////        request.HTTPMethod = "POST";
////        var params: Dictionary<String, String> = (["q" : "London,uk", "password" : "Test 2"]);
////        
////        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &error1);
////        request.addValue("application/json", forHTTPHeaderField: "Content-Type");
////        request.addValue("application/json", forHTTPHeaderField: "Accept");
////        println(error1?.localizedDescription);
////        let jsonResponse = urlSession.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
//        
//        let jsonResponse = urlSession.dataTaskWithURL(url!, completionHandler: { data, response, error -> Void in
//            if (error != nil) {
//                println(error.localizedDescription);
//            }
//            var err: NSError?
//            
//            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
//            if (err != nil){
//                println("JSON Error \(err!.localizedDescription) ");
//            }
//            let city:String! = jsonResult["name"] as NSString;
//            println(jsonResult);
//            
//            registerCompleted(success: true, msg: "Register Successful");
//            });
//        
//        jsonResponse.resume();
//        
//    }
//    
//    
//
//}
