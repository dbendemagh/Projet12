//
//  User.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 05/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

struct UserProfile: Decodable {
    //let id: String
    let name: String
    let email: String
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "email": email
        ]
    }
}
