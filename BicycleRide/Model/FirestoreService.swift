//
//  FirestoreService.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 05/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

public class FirestoreService<T: Decodable> {
    
    private var firestoreSession: FirestoreProtocol
    
    init(firestoreSession: FirestoreProtocol = FirestoreSession()) {
        self.firestoreSession = firestoreSession
    }
    
    func loadData(collection: String, completion: @escaping (Result<[T], Error>) -> Void) {
        firestoreSession.loadDocuments(collection: collection) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let firebaseDocuments):
                let documents: [T] = firebaseDocuments.compactMap( { $0.data().decoded() })
                print(documents)
                completion(.success(documents))
            }
        }
    }
    
    func addData(collection: String, data: [String: Any], completion: @escaping (Error?) -> Void) {
        firestoreSession.addDocument(collection: collection, data: data) { result in
            switch result {
            case .failure(let error):
                completion(error)
            case .success(_):
                break
            }
        }
    }
    
    func searchData(collection: String, field: String, text: String, completion: @escaping (Result<[T], Error>) -> Void) {
        firestoreSession.searchDocuments(collection: "", field: "", text: "") { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let firebaseDocuments):
                let documents: [T] = firebaseDocuments.compactMap( { $0.data().decoded() })
                print(documents)
                completion(.success(documents))
            }
        }
    }
}


