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
            loginUser(userLogin, {(success: Bool, msg: String) -> () in
                var alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay.")
                if(success) {
                    alert.title = "Success!"
                    alert.message = msg
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
    
    func loginUser(user: UserLogin, loginCompleted: (success: Bool, msg: String) -> ()) -> (){
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
            
            loginCompleted(success: true, msg: "Login Successful");
        });
        
        jsonResponse.resume();
        
    }

}
