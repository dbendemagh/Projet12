//
//  FirestoreService.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 05/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import Foundation
import FirebaseFirestore

public class FirestoreService {
    let db = Firestore.firestore()
    
    public func saveData(collection: String, data: [String: Any], completion: @escaping (Error?) -> Void) {
        db.collection(collection).addDocument(data: data, completion: completion)
    }
}
