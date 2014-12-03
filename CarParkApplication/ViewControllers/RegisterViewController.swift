//
//  RegisterViewController.swift
//  CarParkApplication
//
//  Created by David McQueen on 06/10/2014.
//  Copyright (c) 2014 David McQueen. All rights reserved.
//

import UIKit
import QuartzCore

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
    
    //MARK:- Functions
    
    @IBAction func RegisterPressed(sender: AnyObject) {
        
        let newRegistration =  UserRegistration(firstName: FirstNameInput.text, surname: SurNameInput.text, email: EmailInput.text.lowercaseString, confirmEmail: EmailInputConfirm.text.lowercaseString, password: PasswordInput.text, confirmPassword: PasswordInputConfirm.text)
       
        var emailMatch = newRegistration.matchingEmail();
        var passwordMatch = newRegistration.matchingPassword();
        
        if (emailMatch && passwordMatch){
            NSLog("Input match successful");
            newRegistration.validate();
            
            if(newRegistration.validationSuccess.password && newRegistration.validationSuccess.email) {
                NSLog("Validation Success");
                newRegistration.register();
            }else{
                NSLog("Validation Failed");
                validationFailed(!newRegistration.validationSuccess.email, password: !newRegistration.validationSuccess.password);
            }
            
            if(newRegistration.RegistrationSuccess){
                NSLog("Registration Successful");
                
                let viewVehicleRegistration = self.storyboard?.instantiateViewControllerWithIdentifier("viewVehicleRegistration") as RegisterVehicleViewController
                self.navigationController?.pushViewController(viewVehicleRegistration, animated: true);
            }else{
                //Get the error messages
                NSLog("Registration Failed");
                NSLog(newRegistration.RegistrationErrors!);
            }
            
        }else{
            NSLog("Input match failed");
            inputMatchFailed(!emailMatch, password: !passwordMatch);
        }
    }
    
    func inputMatchFailed(email: Bool, password: Bool){
        //The email and/or password entered did not match the confirmation entry
        if(email){
            borderRed(EmailInput);
            borderRed(EmailInputConfirm);
        }else if(password){
            borderRed(PasswordInput);
            borderRed(PasswordInputConfirm);
        }
    }
    
    func validationFailed(email: Bool, password: Bool){
        //The email and/or password entered failed validation.
        if(email){
            borderRed(EmailInput);
        }else if(password){
            borderRed(PasswordInput);
        }
    }
    
    func borderRed(inputField: UITextField){
        //Set the border colour red for the input that failed
        inputField.layer.borderColor = (UIColor( red: 1, green: 0, blue:0, alpha: 1.0 )).CGColor;
    }

}
