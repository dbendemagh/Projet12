//
//  AuthSessionFake.swift
//  BicycleRideTests
//
//  Created by Daniel BENDEMAGH on 26/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import Foundation
@testable import Bicycle_Ride

class AuthSessionFake: AuthProtocol {
    private let fakeResponse: FakeAuthDataResponse
    
    init(fakeResponse: FakeResponse) {
        self.fakeResponse = fakeResponse
    }
    
    func createUser(email: String, password: String, completion: @escaping (Result<AuthUserProtocol, Error>) -> Void) {
        let authDataResult = FakeAuthDataResponse(currentUser: FakeUser(displayName: "Nom", email: "az@er.com"))
        let authDataResult1 = FakeAuthDataResponse(currentUser: nil) //fakeResponse.querySnapshot
        
        
    }
}
