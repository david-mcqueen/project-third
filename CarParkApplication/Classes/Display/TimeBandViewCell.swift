//
//  TimeBandViewCell.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 02/02/2015.
//  Copyright (c) 2015 DavidMcQueen. All rights reserved.
//

import Foundation
import UIKit

class TimeBandViewCell: UITableViewCell {
    
    @IBOutlet weak var timeBand: UILabel!
    @IBOutlet weak var cost: UILabel!
    
    override func awakeFromNib(){
        super.awakeFromNib();
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}