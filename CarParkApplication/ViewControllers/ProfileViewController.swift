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
    
    var paymentIndicator : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 100, 100)) as UIActivityIndicatorView;
    
    var config = PayPalConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Populate all the labes with the relevant information
        lblBalance.text = User.sharedInstance.getBalanceString();
        lblForename.text = User.sharedInstance.FirstName;
        lblSurname.text = User.sharedInstance.Surname;
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
        
                paymentIndicator.center = self.view.center
        paymentIndicator.hidesWhenStopped = true
        paymentIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        println("amount \(amount)")
        
        var payment = PayPalPayment()
        payment.amount = amount
        payment.currencyCode = "GBP"
        payment.shortDescription = "Car Parking Funds"
        
        if (!payment.processable) {
            println("Can't process payment")
        } else {
            println("Processing payment")
            
            view.addSubview(paymentIndicator)
            paymentIndicator.startAnimating()
            
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
        paymentIndicator.stopAnimating();
    }
    
    func sendCompletedPaymentToServer(completedPayment: PayPalPayment){
        NSLog("Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
        NSLog(String(format: "%f", completedPayment.amount));
        
        var alert = UIAlertController(title: "Payment Complete", message: "Funds added to your account", preferredStyle: UIAlertControllerStyle.Alert);
        
        paymentIndicator.stopAnimating();
        self.presentViewController(alert, animated: true, completion: nil);
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil));
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "currentParkingSessions" {
            println("currentParkingSessions Segue")
            let currentSessionViewController = segue.destinationViewController as SessionSelectViewController
            currentSessionViewController.currentSessions = true
        }
    }
    
}
