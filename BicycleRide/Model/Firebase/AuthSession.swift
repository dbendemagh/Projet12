//
//  AuthSession.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 15/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import Foundation
import Firebase

extension User: UserProtocol {}

class AuthSession: AuthProtocol {
    
    let auth = Auth.auth()
    
    var currentUser: UserProtocol? {
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
    
    func createUser(email: String, password: String, completion: @escaping (AuthResult) -> Void) {
        auth.createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let user = authDataResult?.user {
                completion(.success(user))
                return
            }
        }
    }
    
    func updateCurrentUser(userProfile: UserProfile, completion: @escaping (Error?) -> Void) {
        let user = auth.currentUser
        if let userChange = user?.createProfileChangeRequest() {
            userChange.displayName = userProfile.name
            userChange.commitChanges { (error) in
                completion(error)
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (AuthResult) -> Void) {
        auth.signIn(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let user = authDataResult?.user {
                completion(.success(user))
                return
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
