//
//  CustomAnnotation.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 26/02/2015.
//  Copyright (c) 2015 DavidMcQueen. All rights reserved.
//

import Foundation
import MapKit

class CustomAnnotation: MKPointAnnotation {
    var OpeningTime: String!
    var ClosingTime: String!
    var MaxSpaces: Int!
    var UsedSpaces: Int!
    var ID: Int!
    var Name: String!
}