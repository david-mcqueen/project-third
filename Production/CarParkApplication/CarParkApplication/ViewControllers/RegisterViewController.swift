//
//  RegisterViewController.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 06/10/2014.
//  Copyright (c) 2014 DavidMcQueen. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

   
    //MARK:- Variables & Constants
    
    @IBOutlet weak var Scroller: UIScrollView! //Un-needed?
    @IBOutlet weak var FirstNameInput: UITextField!
    @IBOutlet weak var SurNameInput: UITextField!
    @IBOutlet weak var EmailInput: UITextField!
    @IBOutlet weak var EmailInputConfirm: UITextField!
    @IBOutlet weak var PasswordInput: UITextField!
    @IBOutlet weak var PasswordInputConfirm: UITextField!
    @IBOutlet weak var RegisterButton: UIBarButtonItem!
    
    //MARK:- Required Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let sceenSize: CGRect = UIScreen.mainScreen().bounds;
       // Scroller.scrollEnabled = true;
       // Scroller.contentSize = CGSize(width:sceenSize.width, height: 1000);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Actions
    
    @IBAction func RegisterPressed(sender: AnyObject) {
        
        //TODO:- Process new registration
        /*
        1) Validate details are good
        If bad then stay on page
        2) If details are good, pass them to the server
        3) Get a response back from the server
        If success: Proceed to vehicle details
        If Failure: take appropiate action dependent on failed reason.
        */
        
        var result: String;
        let userInput =  UserRegistration(firstName: FirstNameInput.text, surname: SurNameInput.text, email: EmailInput.text, confirmEmail: EmailInputConfirm.text, password: PasswordInput.text, confirmPassword: PasswordInputConfirm.text)
        
        if(validateUserDetails(userInput)){
            sendUserDetails(userInput);
            NSLog(userInput.FirstName);
            NSLog(userInput.SurName);
            NSLog(userInput.Email);
            NSLog(userInput.ConfirmEmail!);
            NSLog(userInput.Password);
            NSLog(userInput.ConfirmPassword!);
            if (validateEmail(userInput.Email)){
                NSLog("emailed Passed");
            }else {
                NSLog("email Failed");
            }
            
        }else{
            result = "failed";
        }
    }
    
    //MARK:- Functions
    
    func validateUserDetails(userInput:UserRegistration) -> (Bool) {
        //TODO:- User Details validation
        
        /*
        //Pre: All of the user input fields will be passed in, via the class RegistrationUser
        //Post: Bool = True Then the validation has passed
        //      Bool = False. Then the validation has failed
        
        //This will take the user input, validate it, and then return the result (Pass / Fail)
        */
        
        return true;
    }
    
    func validateEmail(inputEmail: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        
        var emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx);
        return emailTest.evaluateWithObject(inputEmail);
    }
    
    func sendUserDetails(validatedInput:UserRegistration){
        //TODO:- Send registration details to server
        /*
            PRE: Validated user details are passed in
            POST: Unique userID is returned from the server
        */
        
        //Encrypt user details
    }


}
