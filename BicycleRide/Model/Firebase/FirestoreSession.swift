//
//  FirestoreSession.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 23/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import Foundation
import Firebase

extension QueryDocumentSnapshot : DocumentSnapshotProtocol {}

class FirestoreSession: FirestoreProtocol {
    let db = Firestore.firestore()
    
    func addSnapshotListenerForAllDocuments(collection: String, completion: @escaping (FirestoreResult) -> Void ) {
        db.collection(collection)
            .order(by: Constants.Firestore.timeStamp)
            .addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(self.getDocuments(querySnapshot: querySnapshot)))
            }
        }
    }
    
    func addSnapshotListenerForSelectedDocuments(collection: String, fieldName: String, text: String, completion: @escaping (FirestoreResult) -> Void ) {
        db.collection(collection)
            .whereField(fieldName, isEqualTo: text)
            .order(by: Constants.Firestore.timeStamp)
            .addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(self.getDocuments(querySnapshot: querySnapshot)))
            }
        }
    }
    
    func loadDocuments(collection: String, completion: @escaping (FirestoreResult) -> Void) {
        db.collection(collection).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(self.getDocuments(querySnapshot: querySnapshot)))
            }
        }
    }
    
    // Create new  document
    func addDocument(collection: String, data: [String: Any], completion: @escaping (Error?) -> Void ) {
        db.collection(collection).addDocument(data: data) { (error) in
            completion(error)
        }
    }
    
    // Create or modify a document with specific id
    func modifyDocument(id: String, collection: String, data: [String: Any], completion: @escaping (Error?) -> Void ) {
        db.collection(collection).document(id).setData(data) { (error) in
            completion(error)
        }
    }
    
    func searchDocuments(collection: String, field: String, text: String, completion: @escaping (FirestoreResult) -> Void ) {
        db.collection(collection).whereField(field, isEqualTo: text).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(self.getDocuments(querySnapshot: querySnapshot)))
            }
        }
    }
    
    private func getDocuments(querySnapshot: QuerySnapshot?) -> [DocumentSnapshotProtocol] {
        if let firestoreDocuments: [DocumentSnapshotProtocol] = querySnapshot?.documents {
            return firestoreDocuments
        } else {
            return []
        }
    }
}




