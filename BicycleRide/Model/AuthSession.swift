//
//  AuthSession.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 15/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import Foundation
import Firebase

extension User: AuthUserProtocol {}

class AuthSession: AuthProtocol {
    
    let auth = Auth.auth()
    
    var currentUser: AuthUserProtocol? {
        return auth.currentUser
    }
        
    func addUserConnectionListener(completion: @escaping (Bool) -> Void) {
        _ = auth.addStateDidChangeListener { (auth, user) in
            if let _ = user {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func createUser(email: String, password: String, completion: @escaping (Result<AuthUserProtocol, Error>) -> Void ) {
        auth.createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let user = authDataResult?.user {
                completion(.success(user))
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<AuthUserProtocol, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let user = authDataResult?.user {
                completion(.success(user))
            }
        }
    }
    
    func signOut(completion: @escaping (Result<Bool, Error>) -> Void) {
        do {
            try auth.signOut()
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
}
