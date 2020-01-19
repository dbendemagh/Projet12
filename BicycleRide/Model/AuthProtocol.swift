//
//  AuthProtocol.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 15/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import Foundation
import Firebase

protocol AuthUser {
    var uid: String { get }
    var displayName: String? { get }
    var email: String? { get }
}

extension User: AuthUser {}

protocol AuthProtocol {
    var currentUser: AuthUser? { get }
    
    func createUser(withEmail: String, password: String, completion: AuthDataResultCallback?)
}


