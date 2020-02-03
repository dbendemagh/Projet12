//
//  UserProfile.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 05/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

struct UserProfile: Codable {
    var name: String?
    var email: String
    var bikeType: String?
    var experience: String?
}
