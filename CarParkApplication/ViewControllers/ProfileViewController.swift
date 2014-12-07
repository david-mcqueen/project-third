//
//  ProfileVewController.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 07/12/2014.
//  Copyright (c) 2014 DavidMcQueen. All rights reserved.
//

import UIKit

class ProfileVewController: UIViewController, PayPalPaymentDelegate {
    
    @IBOutlet weak var valueInput: UITextField!
    
    
    var config = PayPalConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true);
        PayPalMobile.preconnectWithEnvironment(PayPalEnvironmentSandbox)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addFunds(sender: AnyObject) {
        var amountInput = valueInput.text;
        let amount = NSDecimalNumber(string:amountInput)
        
        println("amount \(amount)")
        
        var payment = PayPalPayment()
        payment.amount = amount
        payment.currencyCode = "GBP"
        payment.shortDescription = "Carparking payment"
        
        if (!payment.processable) {
            println("Can't process payment")
        } else {
            println("Processing payment")
            var paymentViewController = PayPalPaymentViewController(payment: payment, configuration: config, delegate: self)
            self.presentViewController(paymentViewController, animated: false, completion: nil)
        }
    }
    
    func payPalPaymentViewController(paymentViewController: PayPalPaymentViewController!, didCompletePayment completedPayment: PayPalPayment!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        sendCompletedPaymentToServer(completedPayment);
    }
    
    func payPalPaymentDidCancel(paymentViewController: PayPalPaymentViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func sendCompletedPaymentToServer(completedPayment: PayPalPayment){
        NSLog("Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
        NSLog(String(format: "%f", completedPayment.amount));
        var alert = UIAlertController(title: "Payment Complete", message: "Funds added to your account", preferredStyle: UIAlertControllerStyle.Alert);
        self.presentViewController(alert, animated: true, completion: nil);
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil));
    }
    
}
