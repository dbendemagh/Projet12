//
//  FakeResponse.swift
//  BicycleRideTests
//
//  Created by Daniel BENDEMAGH on 26/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import Foundation
//@testable import Bicycle_Ride

struct FakeUser { //: AuthUserProtocol {
    var displayName: String
    var email: String
}

struct FakeAuthDataResponse {
    var currentUser: FakeUSer?

    //var displayName: String?
    //var email: String?
    
//    var documentID: String
//    var data: [String: Any]
//
//    func data() -> [String: Any] {
//        return data
//    }
}
