//
//  CreateVehicleViewController.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 07/01/2015.
//  Copyright (c) 2015 DavidMcQueen. All rights reserved.
//

import Foundation
import UIKit

class CreateVehicleViewController: UITableViewController,UIPickerViewDataSource,UIPickerViewDelegate{
    
    @IBOutlet var makeLabel: UILabel!

    @IBOutlet var modelLabel: UILabel!
    @IBOutlet var modelInput: UITextField!
    @IBOutlet var makeInput: UITextField!
    @IBOutlet var colourLabel: UITextField!
    @IBOutlet var registrationLabel: UITextField!
    var makePicker: UIPickerView = UIPickerView();
    var modelPicker: UIPickerView = UIPickerView();
    var makeData = ["Mozzarella","Gorgonzola","Provolone","Brie","Maytag Blue","Sharp Cheddar","Monterrey Jack","Stilton","Gouda","Goat Cheese", "Asiago"]
    var modelData = ["Mozzarella","Gorgonzola","Provolone","Brie","Maytag Blue","Sharp Cheddar","Monterrey Jack","Stilton","Gouda","Goat Cheese", "Asiago"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makePicker.dataSource = self;
        makePicker.delegate = self;
        makePicker.tag = 0;
        
        modelPicker.dataSource = self;
        modelPicker.delegate = self;
        modelPicker.tag = 1;
        
        makeInput.inputView = makePicker;
        makeInput.frame = CGRectZero
        makeInput.hidden = true;
        
        modelInput.inputView = modelPicker;
        modelInput.frame = CGRectZero;
        modelInput.hidden = true;
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0){
            registrationLabel.becomeFirstResponder();
        }else if(indexPath.section == 1){
            colourLabel.becomeFirstResponder();
        }else if(indexPath.section == 2){
            makeInput.becomeFirstResponder();
        }else if(indexPath.section == 3){
            modelInput.becomeFirstResponder();
        }
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 0){
            return makeData.count
        }else{
            return modelData.count
        }
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if (pickerView.tag == 0){
            return makeData[row]
        }else{
            return modelData[row]
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 0){
            makeLabel.text = makeData[row]
        }else{
            modelLabel.text = modelData[row]
        }
        
    }
    
}