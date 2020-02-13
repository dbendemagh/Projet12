//
//  FakeResponse.swift
//  BicycleRideTests
//
//  Created by Daniel BENDEMAGH on 26/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import Foundation
@testable import BicycleRide

struct FakeAuthResponse {
    var authDataResult: FakeAuthDataResult?
    var error: Error?
}

struct FakeAuthDataResult {
    var user: FakeUser?
}

struct FakeUser: AuthUserProtocol {
    var displayName: String?
    var email: String?
}


