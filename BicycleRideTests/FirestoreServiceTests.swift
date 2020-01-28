//
//  FirestoreServiceTests.swift
//  BicycleRideTests
//
//  Created by Daniel BENDEMAGH on 27/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import XCTest
@testable import BicycleRide

class FirestoreServiceTests: XCTestCase {
    
    let fakeData: [String: Any] = ["creatorId": "aa",
                               "name": "Nom",
                               "description": "text",
                               "street": "12 rue des Cocotiers",
                               "city": "Chantilly",
                               "latitude": 12,
                               "longitude": 4,
                               "date": "01/01/2020",
                               "time": "12:00",
                               "bikeType": "VTT"]
    
    var fakeFirestoreDocument = FakeFirestoreDocument(documentID: "azerty", datas: [:])
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        fakeFirestoreDocument = FakeFirestoreDocument(documentID: "azerty", datas: fakeData)
    }

    func testLoadDataShouldResultSuccess() {
        let fakequerySnapshot = FakeQuerySnapshot(documents: [fakeFirestoreDocument])
        let fakeFirestoreResponse = FakeFirestoreResponse(querySnapshot: fakequerySnapshot, error: nil)
        
        let firestoreSessionFake = FirestoreSessionFake(fakeFirestoreResponse: fakeFirestoreResponse)
        let firestoreService = FirestoreService<Meeting>(firestoreSession: firestoreSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        firestoreService.loadData(collection: "Meeting") { (result) in
            
            guard case .success(let documents) = result else {
                XCTFail()
                return
            }

            guard let document = documents.first else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(document.name, "Nom")
            XCTAssertEqual(document.latitude, 12)
            XCTAssertEqual(document.longitude, 4)
            XCTAssertEqual(document.description, "text")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    func testLoadDataShouldResultFailure() {
        let fakeFirestoreResponse = FakeFirestoreResponse(querySnapshot: nil, error: FakeNetworkResponse.networkError)
        
        let firestoreSessionFake = FirestoreSessionFake(fakeFirestoreResponse: fakeFirestoreResponse)
        let firestoreService = FirestoreService<Meeting>(firestoreSession: firestoreSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        firestoreService.loadData(collection: "Meeting") { (result) in
            guard case .failure(_) = result else {
                XCTFail()
                return
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testAddDataShouldResultSuccess() {
        let fakequerySnapshot = FakeQuerySnapshot(documents: [fakeFirestoreDocument])
        let fakeFirestoreResponse = FakeFirestoreResponse(querySnapshot: fakequerySnapshot, error: nil)
        
        let firestoreSessionFake = FirestoreSessionFake(fakeFirestoreResponse: fakeFirestoreResponse)
        let firestoreService = FirestoreService<Meeting>(firestoreSession: firestoreSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        firestoreService.addData(collection: "Meeting", data: fakeData) { (error) in
            guard error == nil else {
                XCTFail()
                return
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testAddDataShouldResultFailure() {
        let fakequerySnapshot = FakeQuerySnapshot(documents: [fakeFirestoreDocument])
        let fakeFirestoreResponse = FakeFirestoreResponse(querySnapshot: fakequerySnapshot, error: FakeNetworkResponse.networkError)
        
        let firestoreSessionFake = FirestoreSessionFake(fakeFirestoreResponse: fakeFirestoreResponse)
        let firestoreService = FirestoreService<Meeting>(firestoreSession: firestoreSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        firestoreService.addData(collection: "Meeting", data: fakeData) { (error) in
            guard let _ = error else {
                XCTFail()
                return
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSearchDataShouldResultSuccess() {
        let fakequerySnapshot = FakeQuerySnapshot(documents: [fakeFirestoreDocument])
        let fakeFirestoreResponse = FakeFirestoreResponse(querySnapshot: fakequerySnapshot, error: nil)
        
        let firestoreSessionFake = FirestoreSessionFake(fakeFirestoreResponse: fakeFirestoreResponse)
        let firestoreService = FirestoreService<Meeting>(firestoreSession: firestoreSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        firestoreService.searchData(collection: "", field: "", text: "") { (result) in
            guard case .success(let documents) = result else {
                XCTFail()
                return
            }

            guard let document = documents.first else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(document.name, "Nom")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSearchDataShouldResultFailure() {
        let fakeFirestoreResponse = FakeFirestoreResponse(querySnapshot: nil, error: FakeNetworkResponse.networkError)
        
        let firestoreSessionFake = FirestoreSessionFake(fakeFirestoreResponse: fakeFirestoreResponse)
        let firestoreService = FirestoreService<Meeting>(firestoreSession: firestoreSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        firestoreService.searchData(collection: "", field: "", text: "")  { (result) in
            guard case .failure(_) = result else {
                XCTFail()
                return
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
