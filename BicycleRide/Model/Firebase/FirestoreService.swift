//
//  FirestoreService.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 05/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import Foundation
import CodableFirebase

public class FirestoreService<T: Codable> {
    
    private var firestoreSession: FirestoreProtocol
    
    init(firestoreSession: FirestoreProtocol = FirestoreSession()) {
        self.firestoreSession = firestoreSession
    }
    
    // Listener for all documents
    func addSnapshotListenerForAllDocuments(collection: String, completion: @escaping (Result<[Document<T>], Error>) -> Void) {
        firestoreSession.addSnapshotListenerForAllDocuments(collection: collection) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription.formatedError(path: #file, functionName: #function))
                completion(.failure(error))
            case .success(let firebaseDocuments):
                let appDocuments = self.getDocuments(firebaseDocuments: firebaseDocuments)
                completion(.success(appDocuments))
            }
        }
    }
    
    // Listener for selected documents
    func addSnapshotListenerForSelectedDocuments(collection: String, field: String, text: String, completion: @escaping (Result<[Document<T>], Error>) -> Void) {
        firestoreSession.addSnapshotListenerForSelectedDocuments(collection: collection, fieldName: field, text: text) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription.formatedError(path: #file, functionName: #function))
                completion(.failure(error))
            case .success(let firebaseDocuments):
                let appDocuments = self.getDocuments(firebaseDocuments: firebaseDocuments)
                completion(.success(appDocuments))
            }
        }
    }
    
    func loadDocuments(collection: String, completion: @escaping (Result<[Document<T>], Error>) -> Void) {
        firestoreSession.loadDocuments(collection: collection) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription.formatedError(path: #file, functionName: #function))
                completion(.failure(error))
            case .success(let firebaseDocuments):
                let appDocuments = self.getDocuments(firebaseDocuments: firebaseDocuments)
                completion(.success(appDocuments))
            }
        }
    }
    
    func addDocument(collection: String, object: T, completion: @escaping (Error?) -> Void) {
        let data = encode(object: object)
        
        firestoreSession.addDocument(collection: collection, data: data) { error in
            completion(error)
        }
    }
    
    func modifyDocument(id: String, collection: String, object: T, completion: @escaping (Error?) -> Void) {
        let data = encode(object: object)
        
        firestoreSession.modifyDocument(id: id, collection: collection, data: data) { error in
            completion(error)
        }
    }
    
    func searchDocuments(collection: String, field: String, text: String, completion: @escaping (Result<[Document<T>], Error>) -> Void) {
        firestoreSession.searchDocuments(collection: collection, field: field, text: text) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription.formatedError(path: #file, functionName: #function))
                completion(.failure(error))
            case .success(let firebaseDocuments):
                let appDocuments = self.getDocuments(firebaseDocuments: firebaseDocuments)
                completion(.success(appDocuments))
            }
        }
    }
    
    private func encode(object: T) -> [String: Any] {
        do {
            let dictionaryData: [String: Any] = try FirebaseEncoder().encode(object) as! [String: Any]
            return dictionaryData
        } catch {
            print(error.localizedDescription.formatedError(path: #file, functionName: #function))
        }
        
        return [:]
    }
    
    private func decode(data: [String: Any]) -> T? {
        do {
            let objectData = try FirebaseDecoder().decode(T.self, from: data)
            return objectData
        } catch {
            print(error.localizedDescription.formatedError(path: #file, functionName: #function))
        }
        
        return nil
    }
    
    private func getDocuments(firebaseDocuments: [QueryDocumentSnapshotProtocol]) -> [Document<T>]{
        var documents: [Document<T>] = []
        
        for firebaseDocument in firebaseDocuments {
            var document = Document<T>()
            document.documentId = firebaseDocument.documentID
            document.data = self.decode(data: firebaseDocument.data())
            documents.append(document)
        }
        
        return documents
    }
}


