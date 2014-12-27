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
        
        if(userLogin.emptyInputUsername()){
            borderRed(inputEmail);
        }else if(userLogin.emptyInputPassword()){
            borderRed(inputPassword);
        }else{
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
                        let viewLoggedInViewController = self.storyboard?.instantiateViewControllerWithIdentifier("viewLoggedInViewController") as UITabBarController
                        self.navigationController?.pushViewController(viewLoggedInViewController, animated: true);
                    }else{
                        //Highlight the relevant fields
                        self.borderRed(self.inputEmail);
                        self.borderRed(self.inputPassword);
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
    
    func loginUser(user: UserLogin, loginCompleted: (success: Bool, token: String?, error:String?) -> ()) -> (){
        //Pass the user details to the server, to register
        
        //TODO:- Handle failure reponse / unknown failure
        
        let urlSession = NSURLSession.sharedSession();
        
        let url = NSURL(string:"http://projectthird.ddns.net:8181/WebAPI/webapi/login");
        var request = NSMutableURLRequest(URL: url!);
        
        var error1 : NSError?;
        var errorResponse: String?;
        
        request.HTTPMethod = "POST";
        var params: Dictionary<String, String> = ([
            "Email" : user.UserName,
            "Password" : user.Password
            ]);
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &error1);
        request.addValue("application/json", forHTTPHeaderField: "Content-Type");
        request.addValue("text/plain", forHTTPHeaderField: "Accept");
        
        
        var loginResponse = urlSession.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
            
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding);
            var success:Bool = false;
            var token:String?;
            
            if (error != nil) {
                println(error.localizedDescription);
                errorResponse = error.localizedDescription;
            }
            
            if (strData != nil){
                if (validateGUID(strData!.description)){
                    token = strData!.description;
                    success = true;
                }else{
                    errorResponse = strData!.description;
                }
            }
            
            loginCompleted(success: success, token: token, error: errorResponse);
        });
        
        loginResponse.resume();
        
    }

}
