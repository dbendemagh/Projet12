//
//  AuthProtocol.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 15/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

protocol AuthUserProtocol {
    var displayName: String? { get }
    var email: String? { get }
}

typealias AuthResult = Result<AuthUserProtocol, Error>

protocol AuthProtocol {
    var currentUser: AuthUserProtocol? { get }
    
    //func addUserConnectionListener(completion: @escaping (Result<AuthUserProtocol?, Error>) -> Void)
    func addUserConnectionListener(completion: @escaping (Bool) -> Void)
    func createUser(email: String, password: String, completion: @escaping (Result<AuthUserProtocol, Error>) -> Void)
    func signIn(email: String, password: String, completion: @escaping (Result<AuthUserProtocol, Error>) -> Void)
    func signOut(completion: @escaping (Result<Bool, Error>) -> Void)
}


struct Essai: AuthUserProtocol {
    var displayName: String?
    
    var email: String?
    
    
}
