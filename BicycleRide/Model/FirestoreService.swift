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
    
    func loadData(collection: String, completion: @escaping (Result<[T], Error>) -> Void) {
        firestoreSession.loadDocuments(collection: collection) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let firebaseDocuments):
//                for document in firebaseDocuments {
//                    print(document.data())
//                }
                let documents: [T] = firebaseDocuments.compactMap( { self.decode(data: $0.data()) }) //$0.data().decoded()                //print(documents)
                //for document in documents {
                //    print(document)
                //}
                
                completion(.success(documents))
            }
        }
    }
    
//    func saveData(collection: String, object: T, completion: @escaping (Error?) -> Void) {
//        let data = encode(object: object)
//        
//        firestoreSession.addDocument(collection: collection, data: data) { error in
//            completion(error)
//        }
//    }
    
    func modifyData(id: String, collection: String, object: T, completion: @escaping (Error?) -> Void) {
        let data = encode(object: object)
        
        firestoreSession.modifyDocument(id: id, collection: collection, data: data) { error in
            completion(error)
        }
    }
    
    func searchData(collection: String, field: String, text: String, completion: @escaping (Result<[T], Error>) -> Void) {
        firestoreSession.searchDocuments(collection: collection, field: field, text: text) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let firebaseDocuments):
                let documents: [T] = firebaseDocuments.compactMap( { self.decode(data: $0.data()) }) // $0.data().decoded()
                print(documents)
                completion(.success(documents))
            }
        }
    }
    
    func encode(object: T) -> [String: Any] {
        do {
            let dictionaryData: [String: Any] = try FirebaseEncoder().encode(object) as! [String: Any]
            print(dictionaryData)
            return dictionaryData
        } catch {
            print(error)
        }
        
        return [:]
    }
    
    func decode(data: [String: Any]) -> T? {
        do {
            let objectData = try FirebaseDecoder().decode(T.self, from: data) // encode(object) as! [String: Any]
            print(objectData)
            return objectData
        } catch {
            print(error)
        }
        
        return nil
    }
}


