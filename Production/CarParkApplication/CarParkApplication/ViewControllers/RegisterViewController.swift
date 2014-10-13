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
    
    @IBOutlet weak var Scroller: UIScrollView!
    @IBOutlet weak var FirstNameInput: UITextField!
    @IBOutlet weak var SurNameInput: UITextField!
    @IBOutlet weak var EmailInput: UITextField!
    @IBOutlet weak var EmailInputConfirm: UITextField!
    @IBOutlet weak var PasswordInput: UITextField!
    @IBOutlet weak var PasswordInputConfirm: UITextField!
    @IBOutlet weak var VehicleDetailsButton: UIBarButtonItem!
    
    //MARK:- Required Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //TODO:- Disable VehicleDetailsButton until all fields are complete / have content
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let sceenSize: CGRect = UIScreen.mainScreen().bounds;
        Scroller.scrollEnabled = true;
        Scroller.contentSize = CGSize(width:sceenSize.width, height: 1000);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Actions
    
    //Vehicle Details button has been pressed
    @IBAction func VehicleDetails(sender: AnyObject) {
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
    
    func sendUserDetails(validatedInput:UserRegistration){
        //TODO:- Send registration details to server
        /*
            PRE: Validated user details are passed in
            POST: Unique userID is returned from the server
        */
        
        //Encrypt user details
    }


}
