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
    
    func addSnapshotListener(collection: String, field: String, text: String, completion: @escaping (Result<[AppDocument<T>], Error>) -> Void) {
        firestoreSession.addSnapshotListener(collection: collection, field: field, text: text) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let firebaseDocuments):
                let appDocuments = self.getAppDocuments(firebaseDocuments: firebaseDocuments)
                completion(.success(appDocuments))
            }
        }
    }
    
    func loadData(collection: String, completion: @escaping (Result<[AppDocument<T>], Error>) -> Void) {
        firestoreSession.loadDocuments(collection: collection) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let firebaseDocuments):
                let appDocuments = self.getAppDocuments(firebaseDocuments: firebaseDocuments)
                completion(.success(appDocuments))
            }
        }
    }
    
    func saveData(collection: String, object: T, completion: @escaping (Error?) -> Void) {
        let data = encode(object: object)
        
        firestoreSession.addDocument(collection: collection, data: data) { error in
            completion(error)
        }
    }
    
    func modifyData(id: String, collection: String, object: T, completion: @escaping (Error?) -> Void) {
        let data = encode(object: object)
        
        firestoreSession.modifyDocument(id: id, collection: collection, data: data) { error in
            completion(error)
        }
    }
    
    func searchData(collection: String, field: String, text: String, completion: @escaping (Result<[AppDocument<T>], Error>) -> Void) {
        firestoreSession.searchDocuments(collection: collection, field: field, text: text) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let firebaseDocuments):
                let appDocuments = self.getAppDocuments(firebaseDocuments: firebaseDocuments)
                completion(.success(appDocuments))
            }
        }
    }
    
    private func encode(object: T) -> [String: Any] {
        do {
            let dictionaryData: [String: Any] = try FirebaseEncoder().encode(object) as! [String: Any]
            return dictionaryData
        } catch {
            print("Erreur codage : \(error)")
        }
        
        return [:]
    }
    
    private func decode(data: [String: Any]) -> T? {
        do {
            let objectData = try FirebaseDecoder().decode(T.self, from: data)
            return objectData
        } catch {
            print("Erreur décodage : \(error)")
        }
        
        return nil
    }
    
    private func getAppDocuments(firebaseDocuments: [FirestoreDocumentProtocol]) -> [AppDocument<T>]{
        var appDocuments: [AppDocument<T>] = []
        
        for firebaseDocument in firebaseDocuments {
            var appDocument = AppDocument<T>()
            appDocument.documentId = firebaseDocument.documentID
            appDocument.data = self.decode(data: firebaseDocument.data())
            appDocuments.append(appDocument)
        }
        
        return appDocuments
    }
}


