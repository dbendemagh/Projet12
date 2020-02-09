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
    
    func addUserConnectionListener(completion: @escaping (Bool) -> Void) {
        authSession.addUserConnectionListener { (connected) in
            if connected {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func createUser(email: String, password: String, completion: @escaping (AuthResult) -> Void) {
        authSession.createUser(email: email, password: password) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription.formatedError(path: #file, functionName: #function))
                completion(.failure(error))
            case .success(let user):
                completion(.success(user))
            }
        }
    }
    
    func updateCurrentUser(userProfile: UserProfile, completion: @escaping (Error?) -> Void) {
        authSession.updateCurrentUser(userProfile: userProfile) { (error) in
            completion(error)
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<AuthUserProtocol, Error>) -> Void) {
        authSession.signIn(email: email, password: password) { (result) in
        switch result {
            case .failure(let error):
                print(error.localizedDescription.formatedError(path: #file, functionName: #function))
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
