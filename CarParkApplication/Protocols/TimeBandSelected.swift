//
//  TimeBandSelected.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 31/01/2015.
//  Copyright (c) 2015 DavidMcQueen. All rights reserved.
//

import Foundation

protocol TimeBandSelectedDelegate : class{
    func didSelectTimeBand(timeBand: PricingBand);
}