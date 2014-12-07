//
//  LoginViewController.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 16/10/2014.
//  Copyright (c) 2014 DavidMcQueen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController{

    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func LoginButtonPressed(sender: AnyObject) {
        let userLogin = UserLogin(userName: inputEmail.text, password: inputPassword.text);
        
        if(!userLogin.emptyInputUsername()){
            borderRed(inputEmail);
        }else if(!userLogin.emptyInputPassword()){
            borderRed(inputPassword);
        }else{
            if(userLogin.login()){
                //Login has been successful
                //Display the logged in section
                NSLog("Login successful");
                let viewLoggedInViewController = self.storyboard?.instantiateViewControllerWithIdentifier("viewLoggedInViewController") as UITabBarController
                self.navigationController?.pushViewController(viewLoggedInViewController, animated: true);
                
            }else{
                NSLog("Login unsuccessful");
            }
        }
    }

    func borderRed(inputField: UITextField){
        //Set the border colour red for the input that failed
        inputField.layer.borderColor = (UIColor( red: 1, green: 0, blue:0, alpha: 1.0 )).CGColor;
        inputField.layer.borderWidth = 2.0;
        inputField.layer.cornerRadius = 5;
        inputField.clipsToBounds = true;
    }
    
    func clearBorderRed(inputField: UITextField){
        inputField.layer.borderColor = (UIColor( red: 1, green: 0, blue:0, alpha: 1.0 )).CGColor;
        inputField.layer.borderWidth = 0.0;
        inputField.layer.cornerRadius = 5;
        inputField.clipsToBounds = true;
    }

}
