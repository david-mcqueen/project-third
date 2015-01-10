//
//  SelectUserVehicle.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 10/01/2015.
//  Copyright (c) 2015 DavidMcQueen. All rights reserved.
//

import UIKit

protocol SelectUserVehicleDelegate : class{
    func didSelectUserVehicle(userVehicle: Vehicle);
}