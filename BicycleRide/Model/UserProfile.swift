//
//  User.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 05/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

struct UserProfile {
    let id: String
    let email: String
    let name: String
    
    var dictionary: [String: Any] {
        return [
            "id": id,
            "email": email,
            "name": name
        ]
    }
}
