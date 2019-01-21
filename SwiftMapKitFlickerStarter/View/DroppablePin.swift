//
//  DroppablePin.swift
//  SwiftMapKitFlickerStarter
//
//  Created by MacBook on 1/21/19.
//  Copyright © 2019 Ahil. All rights reserved.
//

import UIKit
import MapKit

class DroppablePin: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    var identifier: String
    
    init(coordinate: CLLocationCoordinate2D, identifier: String) {
        self.coordinate = coordinate
        self.identifier = identifier
        super.init()
    }
}
