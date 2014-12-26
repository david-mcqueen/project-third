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

        row = FormRowDescriptor(tag: "make", rowType: .Name, title: "Make")
        row.cellConfiguration = ["textField.placeholder" : "Vehicle Make", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        row.required = true;
        section1.addRow(row)
        
        row = FormRowDescriptor(tag: "model", rowType: .Name, title: "Model")
        row.cellConfiguration = ["textField.placeholder" : "Vehicle Model", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        row.required = true;
        section1.addRow(row)
        
        row = FormRowDescriptor(tag: "colour", rowType: .Name, title: "Colour")
        row.cellConfiguration = ["textField.placeholder" : "Vehicle Colour", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        row.required = true;
        section1.addRow(row)
        
        let section2 = FormSectionDescriptor()
        
        row = FormRowDescriptor(tag: Static.picker, rowType: .Picker, title: "Gender")
        row.options = ["F", "M", "U"]
        row.titleFormatter = { value in
            switch( value ) {
            case "F":
                return "Female"
            case "M":
                return "Male"
            case "U":
                return "I'd rather not to say"
            default:
                return nil
            }
        }
        section2.addRow(row)

        
        form.sections = [section1, section2]
        
        self.form = form
    }
    
    
    /// MARK: FormViewControllerDelegate
    
    func formViewController(controller: FormViewController, didSelectRowDescriptor rowDescriptor: FormRowDescriptor) {
        if rowDescriptor.tag == Static.button {
            self.view.endEditing(true)
        }
    }
}
