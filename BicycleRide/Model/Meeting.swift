//
//  Meeting.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 04/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

struct Meeting: Codable {
    //var id: String?
    var creatorId: String
    var name: String
    var street: String
    var city: String
    var date: String
    var time: String
    var description: String
    var bikeType: String
    var distance: Int
    var latitude: Double
    var longitude: Double
    var participants: [Participant]
    
//    var dictionary: [String: Any] {
//        return [
//            "creatorId": creatorId,
//            "name": name,
//            "street": street,
//            "city": city,
//            "date": date,
//            "time": time,
//            "description": description,
//            "bikeType": bikeType,
//            "distance": distance,
//            "latitude": latitude,
//            "longitude": longitude,
//            //"participants": participants
//        ]
//    }
}

struct Participant: Codable {
    var name: String
    var email: String
    
//    var dictionary: [String: Any] {
//        return [
//            "name": name,
//            "email": email
//        ]
//    }
}
