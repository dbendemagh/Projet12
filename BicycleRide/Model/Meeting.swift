//
//  Meeting.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 04/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

struct Coordinate {
    var latitude: Double
    var longitude: Double
}

struct Meeting {
    var id: String
    var creatorId: String
    var name: String
    var coordinate: Coordinate
    var date: String
    var time: String
    var description: String
}
