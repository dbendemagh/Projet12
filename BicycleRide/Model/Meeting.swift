//
//  Meeting.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 04/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

struct Meeting: Decodable {
    //var id: String?
    var creatorId: String
    var name: String
    var street: String
    var city: String
    var date: String
    var time: String
    var description: String
    var bikeType: String
    var latitude: Double
    var longitude: Double
    
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
