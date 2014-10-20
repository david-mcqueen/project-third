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
        
        let userInput =  UserRegistration(firstName: FirstNameInput.text, surname: SurNameInput.text, email: EmailInput.text.lowercaseString, confirmEmail: EmailInputConfirm.text.lowercaseString, password: PasswordInput.text, confirmPassword: PasswordInputConfirm.text)
       
        var emailMatch = userInput.matchingEmail()
        var passwordMatch = userInput.matchingPassword();
        
        if (emailMatch && passwordMatch){
            userInput.validate();
            
            if(userInput.validationSuccess.password && userInput.validationSuccess.email) {
                NSLog("Validate Success");
                userInput.register();
            }else{
                NSLog("Validation Failed");
                validationFailed(!userInput.validationSuccess.email, password: !userInput.validationSuccess.password);
            }
            
            if(userInput.RegistrationSuccess){
                NSLog("Registration Successful");
                
                let viewVehicleRegistration = self.storyboard?.instantiateViewControllerWithIdentifier("viewVehicleRegistration") as RegisterVehicleViewController
                self.navigationController?.pushViewController(viewVehicleRegistration, animated: true);
            }else{
                //Get the error messages
                NSLog("Registration Failed");
                NSLog(userInput.RegistrationErrors!);
            }
            
        }else{
            inputMatchFailed(!emailMatch, password: !passwordMatch);
        }
    }
    
    func inputMatchFailed(email: Bool, password: Bool){
        if(email){
            borderRed(EmailInput);
            borderRed(EmailInputConfirm);
        }else if(password){
            borderRed(PasswordInput);
            borderRed(PasswordInputConfirm);
        }
    }
    
    func validationFailed(email: Bool, password: Bool){
        if(email){
            borderRed(EmailInput);
        }else if(password){
            borderRed(PasswordInput);
        }
    }
    
    func borderRed(inputField: UITextField){
        inputField.layer.borderColor = (UIColor( red: 1, green: 0, blue:0, alpha: 1.0 )).CGColor;
    }

}
