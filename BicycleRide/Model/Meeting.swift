//
//  Meeting.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 04/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

struct Coordinate {
    var latitude: String
    var longitude: String
}

struct Meeting {
    //var id: String
    var creatorId: String
    var name: String
    var street: String
    var city: String
    //var coordinate: Coordinate
    var date: String
    var time: String
    var description: String
    var bikeType: String
    var latitude: String
    var longitude: String
    
    var dictionary: [String: Any] {
        return [
            "creatorId": creatorId,
            "name": name,
            "street": street,
            "city": city,
            "date": date,
            "time": time,
            "description": description,
            "bikeType": bikeType,
            "latitude": latitude,
            "longitude": longitude
        ]
    }
}
