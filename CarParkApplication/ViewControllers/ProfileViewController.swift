//
//  ProfileVewController.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 07/12/2014.
//  Copyright (c) 2014 DavidMcQueen. All rights reserved.
//

import UIKit

//The profile controller
class ProfileVewController: UITableViewController, PayPalPaymentDelegate {
    
    //MARK:- UI Outlets
    @IBOutlet var textAddFunds: UITextField!
    @IBOutlet var lblBalance: UILabel!
    @IBOutlet var btnPay: UIButton!
    @IBOutlet var btnAddFunds: UIButton!
    @IBOutlet var lblForename: UILabel!
    @IBOutlet var lblSurname: UILabel!
    @IBOutlet weak var lblCurrentSessionCount: UILabel!
    @IBOutlet weak var lblPreviousSessionCount: UILabel!

    
    //MARK:- Variables
    var displayAddFunds: Bool = false;
    var paymentIndicatorView: UIView = UIView(frame: CGRectMake(50, 50, 200, 200));
    var paymentIndicatorActivitySpinner : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 100, 100)) as UIActivityIndicatorView;
    var paymentIndicatorLabel: UILabel = UILabel(frame: CGRectMake(20, 115, 130, 22));
    var config = PayPalConfiguration()
    

    //MARK:- Default Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        //Get all the user information from the server.
        getUserDetails();
        getUserVehicles();
        getUserParkingSessions();
        displayUserInfo();
        
        //Setup a payment indicator
        paymentIndicatorView.frame = CGRectMake(((self.view.frame.width - 200) / 2), ((self.view.frame.height - 200) / 3), 200, 200);
        
        paymentIndicatorView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5);
        paymentIndicatorView.clipsToBounds = true;
        paymentIndicatorView.layer.cornerRadius = 10.0;
        
        paymentIndicatorActivitySpinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge;
        paymentIndicatorActivitySpinner.backgroundColor = UIColor.clearColor();
        paymentIndicatorActivitySpinner.frame = CGRect(x: 65, y: 40, width: paymentIndicatorActivitySpinner.bounds.size.width, height: paymentIndicatorActivitySpinner.bounds.size.height);
        
        paymentIndicatorLabel.backgroundColor = UIColor.clearColor();
        paymentIndicatorLabel.textColor = UIColor.whiteColor()
        paymentIndicatorLabel.adjustsFontSizeToFitWidth = true;
        paymentIndicatorLabel.textAlignment = .Center;
        paymentIndicatorLabel.text = "Adding Funds...";
        
        paymentIndicatorView.addSubview(paymentIndicatorLabel);
        paymentIndicatorView.addSubview(paymentIndicatorActivitySpinner);
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true);
        
        //Preconnect to PayPal, as per their SDK.
        PayPalMobile.preconnectWithEnvironment(PayPalEnvironmentSandbox)
        displaySessionCount();
        displayUserBalance();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK:- Table delegates
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 1 && indexPath.row == 1){
            extendAddFunds(self);
        } else if (indexPath.section == 2 && indexPath.row == 0){
            textAddFunds.becomeFirstResponder();
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 2 && !displayAddFunds){
            //Set the header & footer heights to 0
            self.tableView.sectionHeaderHeight = 0;
            return 0;
        } else {
            return super.tableView(tableView, heightForHeaderInSection: section);
        }  //keeps inalterate all other Header
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(section == 2 && !displayAddFunds) {
            //Set the header & footer heights to 0
            self.tableView.sectionFooterHeight = 0;
            return 0;
        } else {
            return super.tableView(tableView, heightForFooterInSection: section)
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as UITableViewHeaderFooterView
        
        header.textLabel.textColor = UIColor.whiteColor() //make the text white
        header.textLabel.font = UIFont.boldSystemFontOfSize(12);
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 2) //Index number of interested section
        {
            if (displayAddFunds){
                 return 1;
            }else{
                return 0;
            }
        }else{
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    
    //MARK:- Button Functions
    @IBAction func extendAddFunds(sender: AnyObject) {
        displayAddFunds = true;
        self.tableView.reloadData();
    }
    
    @IBAction func addFunds(sender: AnyObject) {
        var amountInput = textAddFunds.text;
        let amount = NSDecimalNumber(string:amountInput)
        
        println("amount \(amount)")
        
        var payment = PayPalPayment()
        payment.amount = amount
        payment.currencyCode = "GBP"
        payment.shortDescription = "Car Parking Funds"
        
        if (!payment.processable) {
            println("Can't process payment")
        } else {
            println("Processing payment")
            
            var paymentViewController = PayPalPaymentViewController(payment: payment, configuration: config, delegate: self)
            self.presentViewController(paymentViewController, animated: true, completion: nil)
        }
    }
    
    
    //MARK:- PayPal Delegate
    func payPalPaymentViewController(paymentViewController: PayPalPaymentViewController!, didCompletePayment completedPayment: PayPalPayment!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        paymentIndicatorActivitySpinner.startAnimating();
        self.tableView.addSubview(paymentIndicatorView);
        sendCompletedPaymentToServer(completedPayment);
    }
    
    func payPalPaymentDidCancel(paymentViewController: PayPalPaymentViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        paymentIndicatorActivitySpinner.stopAnimating();
        self.paymentIndicatorView.removeFromSuperview();
        
    }

    
    //MARK:- Custom functions
    func sendCompletedPaymentToServer(completedPayment: PayPalPayment){
        NSLog("Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
        NSLog(String(format: "%f", completedPayment.amount));
        
        var alert = UIAlertController(title: "Payment Complete", message: "Funds added to your account", preferredStyle: UIAlertControllerStyle.Alert);
        var paypalTransactionID: String?;
        
        paymentIndicatorActivitySpinner.stopAnimating();
        println(completedPayment.confirmation);
        
        if let newTransaction: NSDictionary = completedPayment.confirmation["response"] as? NSDictionary{
            
            if let transactionID = newTransaction["id"] as? String{
                paypalTransactionID = transactionID;
                
                userAddFunds(User.sharedInstance.token!, paypalTransactionID!) { (success, balance, error) -> () in
                    if (success) {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            println(balance);
                            self.paymentIndicatorActivitySpinner.stopAnimating();
                            self.paymentIndicatorView.removeFromSuperview();
                            
                            self.presentViewController(alert, animated: true, completion: nil);
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil));
                            User.sharedInstance.CurrentBalance = balance!;
                            self.displayUserBalance();
                        });
                        
                    }else{
                        NSLog("Something went wrong")
                    }
                }
            }
        }
    }
    
    func getUserDetails(){
        userBalance(User.sharedInstance.token!, {(success, userBalance, userForename, userSurname, error) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                println("getUserBalance()")
                if (success){
                    User.sharedInstance.CurrentBalance = userBalance!;
                    User.sharedInstance.FirstName = userForename!;
                    User.sharedInstance.Surname = userSurname!;
                    self.displayUserInfo()
                }
            });
        });
    }
    
    func getUserVehicles() {
        //TODO:- Get the users vehicles from the API
        User.sharedInstance.deleteAllvehciles();
        getAllUserVehicles(User.sharedInstance.token!, { (success, vehicles, error) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                println("getUserVehicles()")
                User.sharedInstance.Vehicles = vehicles;
            });
        });
    }
    
    func getUserParkingSessions(){
        getAllParkingSessions(User.sharedInstance.token!, {(success, sessions, error) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                User.sharedInstance.ParkSessions = sessions;
                self.displaySessionCount();
            });
        });
    }
    
    func displaySessionCount(){
        self.lblCurrentSessionCount.text = String(User.sharedInstance.getCurrentParkSessionsCount());
        self.lblPreviousSessionCount.text = String(User.sharedInstance.getPreviousParkSessionsCount());
    }
    
    func displayUserBalance(){
        self.lblBalance.text = "£" + User.sharedInstance.getBalanceString();
    }
    
    func displayUserInfo(){
        //Populate all the labes with the relevant information
        displayUserBalance();
        println("displayUserInfo")
        self.lblForename.text = User.sharedInstance.FirstName;
        self.lblSurname.text = User.sharedInstance.Surname;
    }
    
    
    //The function called when the user pulls the table view down to refresh the data.
    func refresh(sender:AnyObject)
    {
        println("Refresh");
        getUserDetails();
        getUserVehicles();
        getUserParkingSessions();
        
        self.tableView.reloadData();
        self.refreshControl?.endRefreshing();
    }
    
    
    //MARK:- Segue functions
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "previousParkingSessions" {
            println("currentParkingSessions Segue")
            let currentSessionViewController = segue.destinationViewController as SessionSelectViewController
            currentSessionViewController.currentSessions = false
        }
    }

    
}
