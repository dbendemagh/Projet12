//
//  FirestoreSession.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 23/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import Foundation
import Firebase

extension QueryDocumentSnapshot : FirestoreDocumentProtocol {}

class FirestoreSession: FirestoreProtocol {
    let db = Firestore.firestore()
    
    func loadDocuments(collection: String, completion: @escaping (FirestoreResult) -> Void ) {
        db.collection(collection).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(self.getDocuments(querySnapshot: querySnapshot)))
//                if let firebaseDocuments: [FirestoreDocumentProtocol] = querySnapshot?.documents {
//                    completion(.success(firebaseDocuments))
//                }
            }
        }
    }
    
    /// Create or modify Firestore Document
    func addDocument(collection: String, data: [String: Any], completion: @escaping (Result<Bool, Error>) -> Void ) {
        db.collection(collection).addDocument(data: data) { (error) in
            if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func searchDocuments(collection: String, field: String, text: String, completion: @escaping (FirestoreResult) -> Void ) {
        db.collection(collection).whereField(field, isEqualTo: text).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(self.getDocuments(querySnapshot: querySnapshot)))
//                if let firebaseDocuments: [FirestoreDocumentProtocol] = querySnapshot?.documents {
//                    completion(firebaseDocuments)
//                }
            }
        }
    }
    
    private func getDocuments(querySnapshot: QuerySnapshot?) -> [FirestoreDocumentProtocol] {
        if let firestoreDocuments: [FirestoreDocumentProtocol] = querySnapshot?.documents {
            return firestoreDocuments
        } else {
            return []
        }
    }
}




