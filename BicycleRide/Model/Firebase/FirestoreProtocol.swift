//
//  FirestoreProtocol.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 15/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

protocol FirestoreDocumentProtocol {
    var documentID: String { get }
    func data() -> [String: Any]
}

typealias FirestoreResult = Result<[FirestoreDocumentProtocol], Error>

protocol FirestoreProtocol {
    func loadDocuments(collection: String, completion: @escaping (FirestoreResult) -> Void )
    func addDocument(collection: String, data: [String: Any], completion: @escaping (Error?) -> Void)
    func modifyDocument(id: String, collection: String, data: [String: Any], completion: @escaping (Error?) -> Void)
    func searchDocuments(collection: String, field: String, text: String, completion: @escaping (FirestoreResult) -> Void )
}



