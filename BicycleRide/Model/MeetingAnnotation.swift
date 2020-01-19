//
//  MeetingAnnotation.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 12/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import UIKit
import MapKit

class MeetingAnnotation: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    //let bikeType: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, bikeType: String) {
        self.title = title
        self.coordinate = coordinate
        //self.bikeType = bikeType
    }
}
