//
//  ProfileVewController.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 07/12/2014.
//  Copyright (c) 2014 DavidMcQueen. All rights reserved.
//

import UIKit

class ProfileVewController: UITableViewController, PayPalPaymentDelegate {
    
    
    @IBOutlet var textAddFunds: UITextField!
    @IBOutlet var lblBalance: UILabel!
    @IBOutlet var btnPay: UIButton!
    @IBOutlet var btnAddFunds: UIButton!
    
    @IBOutlet var lblForename: UILabel!
    @IBOutlet var lblSurname: UILabel!
    
    var displayAddFunds: Bool = false;
    
    var paymentIndicatorView: UIView = UIView(frame: CGRectMake(0, 0, 200, 200));
    var paymentIndicatorActivity : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 100, 100)) as UIActivityIndicatorView;
    var paymentIndicatorLabel: UILabel = UILabel(frame: CGRectMake(20, 115, 130, 22));
    
    var config = PayPalConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        getUserBalance();
        getUserVehicles();
        getUserName();
        getUserParkingSessions();
        
        //Populate all the labes with the relevant information
        lblBalance.text = User.sharedInstance.getBalanceString();
        lblForename.text = User.sharedInstance.FirstName;
        lblSurname.text = User.sharedInstance.Surname;
        
        paymentIndicatorView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7);
        paymentIndicatorView.clipsToBounds = true;
        paymentIndicatorView.layer.cornerRadius = 10.0;
        
        
        paymentIndicatorActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray;
        paymentIndicatorActivity.frame = CGRect(x: 65, y: 40, width: paymentIndicatorActivity.bounds.size.width, height: paymentIndicatorActivity.bounds.size.height);
        
        paymentIndicatorView.addSubview(paymentIndicatorActivity);
        
        paymentIndicatorLabel.backgroundColor = UIColor.clearColor();
        paymentIndicatorLabel.textColor = UIColor.whiteColor()
        paymentIndicatorLabel.adjustsFontSizeToFitWidth = true;
        paymentIndicatorLabel.textAlignment = .Center;
        paymentIndicatorLabel.text = "Processing...";
        
        paymentIndicatorView.addSubview(paymentIndicatorLabel);
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true);
        PayPalMobile.preconnectWithEnvironment(PayPalEnvironmentSandbox)
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
            
            self.view.addSubview(paymentIndicatorView);
            paymentIndicatorActivity.startAnimating();
            
            var paymentViewController = PayPalPaymentViewController(payment: payment, configuration: config, delegate: self)
            self.presentViewController(paymentViewController, animated: true, completion: nil)
        }
    }
    
    func payPalPaymentViewController(paymentViewController: PayPalPaymentViewController!, didCompletePayment completedPayment: PayPalPayment!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        sendCompletedPaymentToServer(completedPayment);
    }
    
    func payPalPaymentDidCancel(paymentViewController: PayPalPaymentViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        paymentIndicatorActivity.stopAnimating();
        self.paymentIndicatorView.removeFromSuperview();
        
    }
    
    func sendCompletedPaymentToServer(completedPayment: PayPalPayment){
        NSLog("Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
        NSLog(String(format: "%f", completedPayment.amount));
        
        var alert = UIAlertController(title: "Payment Complete", message: "Funds added to your account", preferredStyle: UIAlertControllerStyle.Alert);
        var paypalTransactionID: String?;
        
        paymentIndicatorActivity.stopAnimating();
        println(completedPayment.confirmation);
        
        if let newTransaction: NSDictionary = completedPayment.confirmation["response"] as? NSDictionary{
            
            if let transactionID = newTransaction["id"] as? String{
                paypalTransactionID = transactionID;
                
                userAddFunds(User.sharedInstance.token!, paypalTransactionID!) { (success, balance, error) -> () in
                    if (success) {
                        println(balance);
                        self.paymentIndicatorActivity.stopAnimating();
                        self.paymentIndicatorView.removeFromSuperview();
                        self.presentViewController(alert, animated: true, completion: nil);
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil));
                        User.sharedInstance.CurrentBalance = balance!;
                        self.lblBalance.text = User.sharedInstance.getBalanceString();
                    }else{
                        NSLog("Something went wrong")
                    }
                }
            }
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "previousParkingSessions" {
            println("currentParkingSessions Segue")
            let currentSessionViewController = segue.destinationViewController as SessionSelectViewController
            currentSessionViewController.currentSessions = false
        }
    }
    
    
    //MARK:- Gte user information from the server
    
    func getUserBalance(){
        userBalance(User.sharedInstance.token!, {(success, userBalance, error) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                println("getUserBalance()")
                println("\(success) \(userBalance)")
                if (success){
                    User.sharedInstance.CurrentBalance = userBalance!;
                    self.lblBalance.text = User.sharedInstance.getBalanceString();
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
    
    func getUserName(){
        var testToken = User.sharedInstance.token!;
        testToken = "This is a new token";
        //TODO:- Get the users name from the API
        User.sharedInstance.FirstName = "David";
        User.sharedInstance.Surname = "McQueen";
    }
    
    func getUserParkingSessions(){
        getAllParkingSessions(User.sharedInstance.token!, {(success, sessions, error) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                User.sharedInstance.ParkSessions = sessions;
                
            });
        });
    }
    
    func refresh(sender:AnyObject)
    {
        self.tableView.reloadData();
        self.refreshControl?.endRefreshing();
    }
    
}
