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
        
        if(userLogin.login()){
            //Login has been successful
            //Display the logged in section
            NSLog("Login successful");
            let viewParkViewController = self.storyboard?.instantiateViewControllerWithIdentifier("viewParkViewController") as ViewController
            self.navigationController?.pushViewController(viewParkViewController, animated: true);
            
        }else{
            NSLog("Login unsuccessful");
        }
        
    }


}
