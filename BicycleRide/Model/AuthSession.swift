//
//  AuthSession.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 15/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import Foundation
import Firebase

class AuthSession: AuthProtocol {
    
    var currentUser: AuthUser? {
        return Auth.auth().currentUser
    }
    
    func createUser(withEmail: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().createUser(withEmail: withEmail, password: password, completion: completion)
    }
    
    
}
