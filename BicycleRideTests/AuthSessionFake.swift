//
//  AuthSessionFake.swift
//  BicycleRideTests
//
//  Created by Daniel BENDEMAGH on 26/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import Foundation
@testable import BicycleRide

class AuthSessionFake: AuthProtocol {
    var currentUser: AuthUserProtocol?
    
    private let fakeAuthResponse: FakeAuthResponse
    
    init(fakeAuthResponse: FakeAuthResponse) {
        self.fakeAuthResponse = fakeAuthResponse
    }
    
    func addUserConnectionListener(completion: @escaping (Bool) -> Void) {
        let authDataResult = fakeAuthResponse.authData
        
        if let _ = authDataResult?.user {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func createUser(email: String, password: String, completion: (Result<AuthUserProtocol, Error>) -> Void) {
        let authDataResult = fakeAuthResponse.authData
        let error = fakeAuthResponse.error
        
        if let error = error {
            completion(.failure(error))
        }
        
        if let user = authDataResult?.user {
            completion(.success(user))
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<AuthUserProtocol, Error>) -> Void) {
        let authDataResult = fakeAuthResponse.authData
        let error = fakeAuthResponse.error
        
        if let error = error {
            completion(.failure(error))
        }
        
        if let user = authDataResult?.user {
            completion(.success(user))
        }
    }
    
    func signOut(completion: @escaping (Result<Bool, Error>) -> Void) {
        let error = fakeAuthResponse.error
        
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(true))
        }
    }
}
