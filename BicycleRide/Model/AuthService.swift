//
//  AuthService.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 31/12/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import Foundation
import Firebase

public class AuthService {
    private var authSession: AuthProtocol
    
    init(authSession: AuthProtocol = AuthSession()) {
        self.authSession = authSession
    }
    
    static func getCurrentUser() -> User? {
        let currentUser = Auth.auth().currentUser
        
        if let currentUser = currentUser {
            return currentUser
        } else {
            return nil
        }
    }
    
    static func addUserConnectionListener(completion: @escaping (User?) -> Void) {
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            completion(user)
        }
    }
    
    func createUSer(email: String, password: String, completion: @escaping AuthDataResultCallback) {
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    
    func signIn(email: String, password: String, completion: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
