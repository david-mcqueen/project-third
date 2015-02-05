//
//  LoginViewController.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 16/10/2014.
//  Copyright (c) 2014 DavidMcQueen. All rights reserved.
//

import UIKit

class LoginViewController: UITableViewController{

    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
   
    @IBOutlet weak var loginCell: UITableViewCell!
    @IBOutlet weak var passwordCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let savedUsername: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("userName") {
            inputEmail.text = savedUsername.description;
        }else{
            inputEmail.text = "frank@underwood.com"
        }
        
        //TODO:- remove this line
        inputPassword.text = "Password123"
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let cellRowHeight = CGFloat(44.0);
        let sectionHeight = cellRowHeight * 2; //2 rows in the section
        
        let tabheight = (self.navigationController?.navigationBar.frame.height)!;
        
        let viewHeight = self.view.frame.height;
        
        let screenHeight = viewHeight + tabheight;
        
        return ((screenHeight - sectionHeight) / 3);
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section == 0 && indexPath.row == 0) {
            self.inputEmail.becomeFirstResponder();
        }else if (indexPath.section == 0 && indexPath.row == 1){
            self.inputPassword.becomeFirstResponder();
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as UITableViewHeaderFooterView
        
        header.textLabel.textColor = UIColor.whiteColor() //make the text white
        header.textLabel.font = UIFont.boldSystemFontOfSize(12);
    }
    

    @IBAction func LoginButtonPressed(sender: AnyObject) {
        let userLogin = UserLogin(userName: inputEmail.text, password: inputPassword.text);
        
        var loginIndicator : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 100, 100)) as UIActivityIndicatorView
        loginIndicator.center = self.view.center
        loginIndicator.hidesWhenStopped = true
        loginIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        inputEmail.endEditing(true);
        inputPassword.endEditing(true);
        
        if(userLogin.emptyInputUsername()){
            borderRed(loginCell);
        }else if(userLogin.emptyInputPassword()){
            borderRed(passwordCell);
        }else{
            view.addSubview(loginIndicator)
            loginIndicator.startAnimating()
            loginUser(userLogin, {(success: Bool, token: String?, error:String?) -> () in
                var alert = UIAlertView(title: "Success!", message: token, delegate: nil, cancelButtonTitle: "Okay.")
                
                if(!success) {
                    alert.title = "Login Failed";
                    alert.message = error!;
                }
                
                // Move to the UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // Show the alert
                   
                    if(success){
                        NSLog("Login successful");
                        
                        //Save the username to phone memory, for fast login
                        NSUserDefaults.standardUserDefaults().setObject(userLogin.UserName, forKey: "userName");
                        NSUserDefaults.standardUserDefaults().synchronize();
                        
                        loginIndicator.stopAnimating();
                        //Save the token into the Singleton object, for use throughut the app
                        User.sharedInstance.token = token!;
                        User.sharedInstance.UserName = userLogin.UserName;
        
                        self.performSegueWithIdentifier("loggedIn", sender: self);
                        
                    }else{
                         alert.show();
                        //Highlight the relevant fields
                        borderRed(self.loginCell);
                        borderRed(self.passwordCell);
                        loginIndicator.stopAnimating();
                    }
                })
                
                }
            );
        }
    }
    
    @IBAction func cancelRegistration(segue:UIStoryboardSegue) {
        //Log the user out, removing all of their information from the singleton.
        User.sharedInstance.logout();
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    @IBAction func logout(segue:UIStoryboardSegue) {
        User.sharedInstance.logout();
        User.sharedInstance.deleteAllParkSessions();
        //TODO:- Need to logout on the server as well
        self.navigationController?.popViewControllerAnimated(true);
    }




}
