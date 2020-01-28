//
//  AuthService.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 31/12/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

public class AuthService {
    private var authSession: AuthProtocol

    init(authSession: AuthProtocol = AuthSession()) {
        self.authSession = authSession
    }
    
    func getCurrentUser() -> AuthUserProtocol? {
        let currentUser = authSession.currentUser
    
        if let currentUser = currentUser {
            return currentUser
        } else {
            return nil
        }
    }
    
//    func addUserConnectionListener0(completion: @escaping (Result<Bool, Error>) -> Void) {
//        authSession.addUserConnectionListener { (result) in
//            switch result {
//            case .failure(let error):
//                completion(.failure(error))
//            case .success(let user):
//                if let _ = user {
//                    // Utilisateur connecté
//                    completion(.success(true))
//                } else {
//                    // Utilisateur non connecté
//                    completion(.success(false))
//                }
//            }
//        }
//    }
    
    func addUserConnectionListener(completion: @escaping (Bool) -> Void) {
        authSession.addUserConnectionListener { (connected) in
            if connected {
                // Utilisateur connecté
                completion(true)
            } else {
                // Utilisateur non connecté
                completion(false)
            }
        }
    }
    
    func createUser(email: String, password: String, completion: @escaping (Result<AuthUserProtocol, Error>) -> Void) {
        authSession.createUser(email: email, password: password) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let user):
                completion(.success(user))
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<AuthUserProtocol, Error>) -> Void) {
        authSession.signIn(email: email, password: password) { (result) in
        switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let user):
                completion(.success(user))
            }
        }
    }
    
    func signOut(completion: @escaping (Result<Bool, Error>) -> Void) {
        authSession.signOut(completion: completion)
    }
}
