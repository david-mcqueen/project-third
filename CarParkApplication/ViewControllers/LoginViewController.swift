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
        
        if let savedUsername: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("userName") {
            inputEmail.text = savedUsername.description;
        }
        
        //TODO:- remove this line
        inputPassword.text = "password"
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func LoginButtonPressed(sender: AnyObject) {
        let userLogin = UserLogin(userName: inputEmail.text, password: inputPassword.text);
        
        var loginIndicator : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 100, 100)) as UIActivityIndicatorView
        loginIndicator.center = self.view.center
        loginIndicator.hidesWhenStopped = true
        loginIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        if(userLogin.emptyInputUsername()){
            borderRed(inputEmail);
        }else if(userLogin.emptyInputPassword()){
            borderRed(inputPassword);
        }else{
            view.addSubview(loginIndicator)
            loginIndicator.startAnimating()
            loginUser(userLogin, {(success: Bool, token: String?, error:String?) -> () in
                var alert = UIAlertView(title: "Success!", message: token, delegate: nil, cancelButtonTitle: "Okay.")
                
                if(success) {
                    alert.title = "Success!"
                    alert.message = token
                }
                else {
                    alert.title = "Login Failed"
                    alert.message = error!;
                }
                
                // Move to the UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // Show the alert
                    alert.show()
                    if(success){
                        NSLog("Login successful");
                        
                        //Save the token, and username
                        NSUserDefaults.standardUserDefaults().setObject(token, forKey: "token");
                        NSUserDefaults.standardUserDefaults().setObject(userLogin.UserName, forKey: "userName");
                        NSUserDefaults.standardUserDefaults().synchronize();
                        
                        loginIndicator.stopAnimating()
                        
                        let viewLoggedInViewController = self.storyboard?.instantiateViewControllerWithIdentifier("viewLoggedInViewController") as UITabBarController
                        self.navigationController?.pushViewController(viewLoggedInViewController, animated: true);
                    }else{
                        //Highlight the relevant fields
                        self.borderRed(self.inputEmail);
                        self.borderRed(self.inputPassword);
                        loginIndicator.stopAnimating()
                    }
                })
                
                }
            );
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
