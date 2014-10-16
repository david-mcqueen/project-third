//
//  RegisterViewController.swift
//  CarParkApplication
//
//  Created by David McQueen on 06/10/2014.
//  Copyright (c) 2014 David McQueen. All rights reserved.
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
        
        let userInput =  UserRegistration(firstName: FirstNameInput.text, surname: SurNameInput.text, email: EmailInput.text, confirmEmail: EmailInputConfirm.text, password: PasswordInput.text, confirmPassword: PasswordInputConfirm.text)
       
        userInput.validate();
        
        if(userInput.validationPassed) {
            NSLog("Validate Success");
            userInput.register();
        }else{
            NSLog(userInput.validationErrors!);
        }
        
        if(userInput.RegistrationSuccess){
            let viewVehicleRegistration = self.storyboard?.instantiateViewControllerWithIdentifier("viewVehicleRegistration") as RegisterVehicleViewController
            self.navigationController?.pushViewController(viewVehicleRegistration, animated: true)
        }else{
            //Get the error messages
            NSLog(userInput.RegistrationErrors!);
        }
        
    }

}
