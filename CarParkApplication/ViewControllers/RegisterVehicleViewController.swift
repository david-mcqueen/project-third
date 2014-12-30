//
//  RegisterVehicleViewController.swift
//  CarParkApplication
//
//  Makes use of SwiftForms (Miguel Angel Ortuño), an open library distributed under the MIT license
//  https://github.com/ortuman/SwiftForms
//
//  Created by David McQueen on 06/10/2014.
//  Copyright (c) 2014 David McQueen. All rights reserved.
//

import UIKit

class RegisterVehicleViewController: FormViewController, FormViewControllerDelegate {
    
    struct Static {
        static let nameTag = "name"
        static let passwordTag = "password"
        static let lastNameTag = "lastName"
        static let jobTag = "job"
        static let emailTag = "email"
        static let URLTag = "url"
        static let phoneTag = "phone"
        static let enabled = "enabled"
        static let check = "check"
        static let segmented = "segmented"
        static let picker = "picker"
        static let birthday = "birthday"
        static let categories = "categories"
        static let button = "button"
        static let textView = "textview"
        static let regTag = "Kitten"
        static let makeTag = "Make"
        static let modelTag = "Model"
    }
    
    override init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .Bordered, target: self, action: "submit:")
        
        getMakes({(success: Bool, vehicleMakes: [Car]) -> () in
            if(success) {
                var listOfMakes: [NSObject] = []
                
                for make in vehicleMakes{
                    listOfMakes.append(make.make_display.description);
                }
                
                var sectionIndex = 0
                var rowIndex = 0
            
                for section in self.form.sections {
                    for row in section.rows {
                        if row.tag == "picker" && row.title == "Make"{
                        
                            row.options = listOfMakes;
                            row.titleFormatter = { value in
                                switch( value ) {
                                default:
                                    return value.description
                                }
                            }
                            if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowIndex, inSection: sectionIndex)) as? FormBaseCell {
                                cell.update()
                            }
                            return
                        }
                    
                        ++rowIndex
                    }
                    ++sectionIndex
                }
            }
            

        });
    }
    
    
    /// MARK: Actions
    
    func submit(_: UIBarButtonItem!) {
        
        let message = self.form.formValues().description
        
        let alert: UIAlertView = UIAlertView(title: "Form output", message: message, delegate: nil, cancelButtonTitle: "OK")
        
        alert.show()
    }
    
    /// MARK: Private interface
    
    private func loadForm() {
        
        let form = FormDescriptor()
        
        form.title = "Vehicle Details"
        
        let section1 = FormSectionDescriptor()
        
        var row: FormRowDescriptor! = FormRowDescriptor(tag: Static.nameTag, rowType: .Name, title: "Registration")
        
        row.cellConfiguration = ["textField.placeholder" : "e.g. PR05 ABC", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        row.required = true;
        section1.addRow(row)
        
        row = FormRowDescriptor(tag: "colour", rowType: .Name, title: "Colour")
        row.cellConfiguration = ["textField.placeholder" : "Vehicle Colour", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        row.required = true;
        section1.addRow(row)
        
        
        let section2 = FormSectionDescriptor()
        
        row = FormRowDescriptor(tag: Static.picker, rowType: .Picker, title: "Make")
        row.options = ["U"]
        row.required = true;
        row.titleFormatter = { value in
            switch( value ) {
            case "U":
                return "Loading Makes..."
            default:
                return nil
            }
        }
        section2.addRow(row)
        
        row = FormRowDescriptor(tag: Static.picker, rowType: .Picker, title: "Model")
        row.options = ["U"]
        row.required = true;
        row.titleFormatter = { value in
            switch( value ) {
            case "U":
                return "Loading Models..."
            default:
                return nil
            }
        }
        section2.addRow(row)
        
        form.sections = [section1, section2]
        
        self.form = form
    }
    
    func getMakes(requestCompleted: (success: Bool, vehicleMakes: [Car]) -> ()) -> (){
        //Pass the user details to the server, to register
        
        let url = NSURL(string:"http://www.carqueryapi.com/api/0.3/?cmd=getMakes");
        let urlSession = NSURLSession.sharedSession();
        
        
        let jsonResponse = urlSession.dataTaskWithURL(url!, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                println(error.localizedDescription);
            }
            var err: NSError?
            
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            if (err != nil){
                println("JSON Error \(err!.localizedDescription) ");
            }
         
            var makes: [Car] = [];
            
            if let vehicleMakeArray = jsonResult["Makes"] as? NSArray{
                println(vehicleMakeArray);
                for make in vehicleMakeArray {
                    let carCountry: AnyObject? = make["make_display"]!
                    let carDisplay: AnyObject?  = make["make_display"]!
                    let carID: AnyObject?  = make["make_id"]!
                    let carCommon: AnyObject?  = make["make_is_common"]!
                    
                    let newCar = Car(_make_country: carCountry!, _make_display: carDisplay!, _make_id: carID!, _make_is_common: carCommon!)
                    
                    makes.append(newCar);
                }
            }
            
            requestCompleted(success: true, vehicleMakes: makes);
        });
        
        jsonResponse.resume();
    }

    
    /// MARK: FormViewControllerDelegate
    
    func formViewController(controller: FormViewController, didSelectRowDescriptor rowDescriptor: FormRowDescriptor) {
        
        if rowDescriptor.tag == Static.button {
            self.view.endEditing(true)
        }
        
        //TODO:- Handle the option for when a make has been selected.
        //Need to retrieve all the models for that make
        println(rowDescriptor.title)
        
    }
}
