//
//  FakeQuerySnapshot.swift
//  BicycleRideTests
//
//  Created by Daniel BENDEMAGH on 27/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import Foundation
@testable import BicycleRide

struct FakeFirestoreResponse {
    var querySnapshot: FakeQuerySnapshot?
    var error: Error?
}

struct FakeQuerySnapshot {
    var documents: [FakeQueryDocumentSnapshot]
}

struct FakeQueryDocumentSnapshot: QueryDocumentSnapshotProtocol {
    var documentID: String
    var datas: [String : Any]
    
    func data() -> [String : Any] {
        return datas
    }
}

class FakeNetworkResponse {
    class NetworkError: Error {}
    static let networkError = NetworkError()
}
