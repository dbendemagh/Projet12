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

    let fakeEmail = "bill@gmail.com"
    let fakeName = "Bill"
    let fakeDescription = ""
    let fakeStreet = "12 rue du Connétable"
    let fakeCity = "60500 Chantilly"
    let fakeTimeStamp = 1580687917.557203
    let fakeDistance = 30
    let fakeLatitude = 48.812067467454426
    let fakeLongitude = 2.5108430149408605
    let fakeBikeType = "VTT"
    
    var fakeMeetingData: [String: Any] = [:]
    
    var meeting = Meeting(creatorId: "",
                          name: "",
                          street: "",
                          city: "",
                          timeStamp: 0,
                          description: "",
                          bikeType: "",
                          distance: 0,
                          latitude: 0,
                          longitude: 0,
                          participants: [])
    
    let id = "xhyAOHONTRtgWjYpgiun"
    var fakeFirestoreDocument = FakeFirestoreDocument(documentID: "", datas: [:])
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        //fakeFirestoreDocument = FakeFirestoreDocument(documentID: "azerty", datas: fakeData)
        fakeMeetingData = ["creatorId": fakeEmail,
                    "name": fakeName,
                    "description": fakeDescription,
                    "street": fakeStreet,
                    "city": fakeCity,
                    "timeStamp": fakeTimeStamp,
                    "distance": fakeDistance,
                    "latitude": fakeLatitude,
                    "longitude": fakeLongitude,
                    "bikeType": fakeBikeType,
                    "participants": []]
        
        meeting.creatorId = fakeEmail
        meeting.name = fakeName
        meeting.street = fakeStreet
        meeting.city = fakeCity
        meeting.timeStamp = fakeTimeStamp
        meeting.description = fakeDescription
        meeting.bikeType = fakeBikeType
        meeting.distance = fakeDistance
        meeting.latitude = fakeLatitude
        meeting.longitude = fakeLongitude
        meeting.participants.append(Participant(name: fakeName, email: fakeEmail))
        
        fakeFirestoreDocument.documentID = id
        fakeFirestoreDocument.datas = fakeMeetingData
    }
    
    func testAddSnapshotListenerShouldResultSuccess() {
        let fakequerySnapshot = FakeQuerySnapshot(documents: [fakeFirestoreDocument])
        let fakeFirestoreResponse = FakeFirestoreResponse(querySnapshot: fakequerySnapshot, error: nil)
        let firestoreSessionFake = FirestoreSessionFake(fakeFirestoreResponse: fakeFirestoreResponse)
        let firestoreService = FirestoreService<Meeting>(firestoreSession: firestoreSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        firestoreService.addSnapshotListener(collection: Constants.Firestore.messageCollectionName, field: "VTT", text: fakeBikeType) { (result) in
            guard case .success(let documents) = result else {
                XCTFail()
                return
            }

            guard let document = documents.first else {
                XCTFail()
                return
            }
            
            if let data = document.data {
                XCTAssertEqual(data.name, self.fakeName)
                XCTAssertEqual(data.creatorId, self.fakeEmail)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testAddSnapshotListenerShouldResultFailure() {
        let fakeFirestoreResponse = FakeFirestoreResponse(querySnapshot: nil, error: FakeNetworkResponse.networkError)
        
        let firestoreSessionFake = FirestoreSessionFake(fakeFirestoreResponse: fakeFirestoreResponse)
        let firestoreService = FirestoreService<Meeting>(firestoreSession: firestoreSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        firestoreService.addSnapshotListener(collection: Constants.Firestore.messageCollectionName, field: "VTT", text: fakeBikeType)  { (result) in
            guard case .failure(_) = result else {
                XCTFail()
                return
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testLoadDataShouldResultSuccess() {
        let fakeQuerySnapshot = FakeQuerySnapshot(documents: [fakeFirestoreDocument])
        let fakeFirestoreResponse = FakeFirestoreResponse(querySnapshot: fakeQuerySnapshot, error: nil)
        
        let firestoreSessionFake = FirestoreSessionFake(fakeFirestoreResponse: fakeFirestoreResponse)
        let firestoreService = FirestoreService<Meeting>(firestoreSession: firestoreSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        firestoreService.loadData(collection: Constants.Firestore.meetingCollectionName) { (result) in
            
            guard case .success(let documents) = result else {
                XCTFail()
                return
            }

            guard let document = documents.first else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(document.documentId, "xhyAOHONTRtgWjYpgiun")
            
            if let data = document.data {
                XCTAssertEqual(data.name, self.fakeName)
                XCTAssertEqual(data.latitude, self.fakeLatitude)
                XCTAssertEqual(data.longitude, self.fakeLongitude)
                XCTAssertEqual(data.description, self.fakeDescription)
                
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    func testLoadDataShouldResultFailure() {
        let fakeFirestoreResponse = FakeFirestoreResponse(querySnapshot: nil, error: FakeNetworkResponse.networkError)
        
        let firestoreSessionFake = FirestoreSessionFake(fakeFirestoreResponse: fakeFirestoreResponse)
        let firestoreService = FirestoreService<Meeting>(firestoreSession: firestoreSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        firestoreService.loadData(collection: Constants.Firestore.meetingCollectionName) { (result) in
            guard case .failure(_) = result else {
                XCTFail()
                return
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testAddDataShouldResultSuccess() {
        let fakeQuerySnapshot = FakeQuerySnapshot(documents: [fakeFirestoreDocument])
        let fakeFirestoreResponse = FakeFirestoreResponse(querySnapshot: fakeQuerySnapshot, error: nil)
        
        let firestoreSessionFake = FirestoreSessionFake(fakeFirestoreResponse: fakeFirestoreResponse)
        let firestoreService = FirestoreService<Meeting>(firestoreSession: firestoreSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        firestoreService.saveData(collection: Constants.Firestore.meetingCollectionName, object: meeting) { (error) in
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
        
        firestoreService.saveData(collection: Constants.Firestore.meetingCollectionName, object: meeting) { (error) in
            guard let _ = error else {
                XCTFail()
                return
            }

            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testModifyDataShouldResultSuccess() {
        let fakeQuerySnapshot = FakeQuerySnapshot(documents: [fakeFirestoreDocument])
        let fakeFirestoreResponse = FakeFirestoreResponse(querySnapshot: fakeQuerySnapshot, error: nil)
        
        let firestoreSessionFake = FirestoreSessionFake(fakeFirestoreResponse: fakeFirestoreResponse)
        let firestoreService = FirestoreService<Meeting>(firestoreSession: firestoreSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        firestoreService.modifyData(id: id, collection: Constants.Firestore.meetingCollectionName, object: meeting) { (error) in
            guard error == nil else {
                XCTFail()
                return
            }

            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testModifyDataShouldResultFailure() {
        let fakequerySnapshot = FakeQuerySnapshot(documents: [fakeFirestoreDocument])
        let fakeFirestoreResponse = FakeFirestoreResponse(querySnapshot: fakequerySnapshot, error: FakeNetworkResponse.networkError)
        
        let firestoreSessionFake = FirestoreSessionFake(fakeFirestoreResponse: fakeFirestoreResponse)
        let firestoreService = FirestoreService<Meeting>(firestoreSession: firestoreSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        firestoreService.modifyData(id: id, collection: Constants.Firestore.meetingCollectionName, object: meeting) { (error) in
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
        
        firestoreService.searchData(collection: Constants.Firestore.meetingCollectionName, field: "email", text: fakeEmail) { (result) in
            guard case .success(let documents) = result else {
                XCTFail()
                return
            }

            guard let document = documents.first else {
                XCTFail()
                return
            }
            
            if let data = document.data {
                XCTAssertEqual(data.name, self.fakeName)
                XCTAssertEqual(data.creatorId, self.fakeEmail)
                expectation.fulfill()
            }
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
