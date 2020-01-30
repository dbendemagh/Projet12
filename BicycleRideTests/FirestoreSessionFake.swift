//
//  FirestoreSessionFake.swift
//  BicycleRideTests
//
//  Created by Daniel BENDEMAGH on 27/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import Foundation
@testable import BicycleRide

class FirestoreSessionFake: FirestoreProtocol {
    
    
    
    private let fakeFirestoreResponse: FakeFirestoreResponse
    
    init(fakeFirestoreResponse: FakeFirestoreResponse) {
        self.fakeFirestoreResponse = fakeFirestoreResponse
    }
    
    func loadDocuments(collection: String, completion: @escaping (FirestoreResult) -> Void) {
        let querySnapshot = fakeFirestoreResponse.querySnapshot
        let error = fakeFirestoreResponse.error
        
        if let error = error {
            completion(.failure(error))
        } else {
            if let querySnapshot = querySnapshot {
                completion(.success(querySnapshot.documents))
            }
        }
    }
    
    func addDocument(collection: String, data: [String : Any], completion: @escaping (Error?) -> Void) {
        let error = fakeFirestoreResponse.error

        if let error = error {
            completion(error)
        } else {
            completion(nil)
        }
    }
    
//    func addDocument(collection: String, data: [String: Any], completion: @escaping (Result<Bool, Error>) -> Void ) {
//        //let querySnapshot = fakeFirestoreResponse.querySnapshot
//
//
//        if let error = error {
//            completion(.failure(error))
//        } else {
//            completion(.success(true))
//        }
//    }
    
    func searchDocuments(collection: String, field: String, text: String, completion: @escaping (FirestoreResult) -> Void ) {
        let querySnapshot = fakeFirestoreResponse.querySnapshot
        let error = fakeFirestoreResponse.error
        
        if let error = error {
            completion(.failure(error))
        } else {
            if let querySnapshot = querySnapshot {
                completion(.success(querySnapshot.documents))
            }
        }
    }
}
