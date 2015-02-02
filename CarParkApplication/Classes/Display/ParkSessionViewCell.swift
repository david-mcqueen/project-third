//
//  ParkSessionViewCell.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 20/01/2015.
//  Copyright (c) 2015 DavidMcQueen. All rights reserved.
//

import UIKit

class ParkSessionViewCell: UITableViewCell {
    
    @IBOutlet weak var locationDetails: UILabel!
    @IBOutlet weak var vehicleDetails: UILabel!
    @IBOutlet weak var sessionDetails: UILabel!
    
    override func awakeFromNib(){
        super.awakeFromNib();
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}