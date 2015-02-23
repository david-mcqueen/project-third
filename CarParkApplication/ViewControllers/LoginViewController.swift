//
//  LoginViewController.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 16/10/2014.
//  Copyright (c) 2014 DavidMcQueen. All rights reserved.
//

import UIKit
import LocalAuthentication

//The login view controller. The user can enter their credentials to login, or select to go to the register screen.
class LoginViewController: UITableViewController{

    //MARK:- UI Outlets
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var loginCell: UITableViewCell!
    @IBOutlet weak var passwordCell: UITableViewCell!
    
    //MARK:- Variables
    var keyboardIsShowing: Bool = false
    
    //MARK:- Default Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Get the saved username from the phone memory, if it exists, and populate the input field
        if let savedUsername: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("userName") {
            inputEmail.text = savedUsername.description;
        }
        
        //Attach a handler to move the view up when displaying the keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShowLogin:"), name:UIKeyboardWillShowNotification, object: nil);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHideLogin:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    func requestFingerPrintAuthentication(password: String){
        let context = LAContext()
        var authError: NSError?
        let authenticationReason: String = "Quick Login"
        
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &authError) {
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: authenticationReason, reply: {
                (success: Bool, error: NSError?) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if success {
                        self.inputPassword.text = password;
                        self.LoginButtonPressed(self)
                    } else {
                        println("Unable to Authenticate")
                        displayAlert("Unable to Authenticate", "Please enter your credentials manually", "Ok")
                   
                    }
                });
            })
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated);
        //Remove the keyboard handlers when leaving this view
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil);
    }
    
     override func viewWillAppear(animated: Bool) {
        self.inputPassword.text = "";
        
        //If the user has previously logged in, get the password from Keychain and attempt to login using TouchID
        let (dictionary, error) = Locksmith.loadDataForUserAccount("carParkApplication")
        
        if let dictionaryResult: AnyObject = dictionary{
            if let userPassword: AnyObject =  dictionary!["password"]{
                requestFingerPrintAuthentication(userPassword.description);
            }
        }
        
        
        super.viewWillAppear(animated);
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- TableView Delegates
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
    
    
    //MARK:- Keyboard functions
    func keyboardWillShowLogin(notification: NSNotification) {
        println("keyboardWillShowLogin")
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        if (screenHeight < 500){
            if let info = notification.userInfo {
                var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
                
                if (!self.keyboardIsShowing){
                    self.keyboardIsShowing = true
                    self.tableView.frame.origin.y -= 100;
                }
            }
        }
    }
    
    func keyboardWillHideLogin(notification: NSNotification) {
        println("keyboardWillHideLogin")
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        if (screenHeight < 500){
            if let info = notification.userInfo {
                var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
                
                
                if (self.keyboardIsShowing){
                    self.keyboardIsShowing = false
                    self.tableView.frame.origin.y += 100;
                    
                }
            }
        }
        
    }
    

    //MARK:- Button Actions
    @IBAction func LoginButtonPressed(sender: AnyObject) {
        clearBorderRed(self.loginCell);
        clearBorderRed(self.passwordCell);
        
        let userLogin = UserLogin(userName: inputEmail.text, password: inputPassword.text);
        
        //Setup an activity to display when loggin the user in.
        var loginIndicator : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 100, 100)) as UIActivityIndicatorView
        loginIndicator.center = self.view.center
        loginIndicator.hidesWhenStopped = true
        loginIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        inputEmail.endEditing(true);
        inputPassword.endEditing(true);
        
        //Check that the inputs have been completed
        if(userLogin.emptyInputUsername()){
            borderRed(loginCell);
        }else if(userLogin.emptyInputPassword()){
            borderRed(passwordCell);
        }else{
            view.addSubview(loginIndicator)
            loginIndicator.startAnimating()
            
            //Start the network access to log the user in
            loginUser(userLogin, {(success: Bool, token: String?, error:String?) -> () in
                var alert = UIAlertView(title: "Success!", message: token, delegate: nil, cancelButtonTitle: "Okay.")
                
                // Move to the UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    //Dispay the error to the user
                    if(!success) {
                        alert.title = "Login Failed";
                        alert.message = error!;
                    }
                   
                    if(success){
                        NSLog("Login successful");
                        
                        //Save the username to phone memory, for fast login
                        NSUserDefaults.standardUserDefaults().setObject(userLogin.UserName, forKey: "userName");
                        let error = Locksmith.saveData(["password": userLogin.Password], forUserAccount: "carParkApplication")
                        NSUserDefaults.standardUserDefaults().synchronize();
                        
                        loginIndicator.stopAnimating();
                        //Save the token into the Singleton object, for use throughut the app
                        User.sharedInstance.token = token!;
                        User.sharedInstance.UserName = userLogin.UserName;
        
                        self.performSegueWithIdentifier("loggedIn", sender: self);
                        
                    }else{
                         alert.show();
                        //Highlight the relevant fieldss
                        borderRed(self.loginCell);
                        borderRed(self.passwordCell);
                        loginIndicator.stopAnimating();
                    }
                })
                
                }
            );
        }
    }
    
    
    //MARK:- Segue Functions
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
