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

    let fakeEmail = "test@gmail.com"
    let fakeName = "Test"
    let fakeDescription = ""
    let fakeStreet = "Place de la Gare"
    let fakeCity = "60500 Vineuil-Saint-Firmin"
    let fakeTimeStamp = 1580687917.557203
    let fakeDistance = 30
    let fakeLatitude = 49.202012
    let fakeLongitude = 2.490793
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
    
    struct incorrectMeeting {
        var planet: String
    }
    
    let id = "xhyAOHONTRtgWjYpgiun"
    var fakeFirestoreDocument = FakeQueryDocumentSnapshot(documentID: "", datas: [:])
    
    override func setUp() {
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
    
    func testAddSnapshotListenerForAllDocuments_NewDocumentsAvailable_ShouldReturnSuccess() {
        let fakequerySnapshot = FakeQuerySnapshot(documents: [fakeFirestoreDocument])
        let fakeFirestoreResponse = FakeFirestoreResponse(querySnapshot: fakequerySnapshot, error: nil)
        
        let firestoreSessionFake = FirestoreSessionFake(fakeFirestoreResponse: fakeFirestoreResponse)
        let firestoreService = FirestoreService<Meeting>(firestoreSession: firestoreSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        firestoreService.addSnapshotListenerForAllDocuments(collection: Constants.Firestore.messagesCollection) { (result) in
            guard case .success(let appDocuments) = result else {
                XCTFail()
                return
            }

            guard let appDocument = appDocuments.first else {
                XCTFail()
                return
            }
            
            if let data = appDocument.data {
                XCTAssertEqual(data.name, self.fakeName)
                XCTAssertEqual(data.creatorId, self.fakeEmail)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testAddSnapshotListenerForAllDocuments_NetworkErrorOccured_ShouldReturnFailure() {
        let fakeFirestoreResponse = FakeFirestoreResponse(querySnapshot: nil, error: FakeNetworkResponse.networkError)
        
        let firestoreSessionFake = FirestoreSessionFake(fakeFirestoreResponse: fakeFirestoreResponse)
        let firestoreService = FirestoreService<Meeting>(firestoreSession: firestoreSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        firestoreService.addSnapshotListenerForAllDocuments(collection: Constants.Firestore.messagesCollection)  { (result) in
            guard case .failure(_) = result else {
                XCTFail()
                return
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testAddSnapshotListenerForSelectedDocuments_NewDocumentsAvailable_ShouldReturnSuccess() {
        let fakequerySnapshot = FakeQuerySnapshot(documents: [fakeFirestoreDocument])
        let fakeFirestoreResponse = FakeFirestoreResponse(querySnapshot: fakequerySnapshot, error: nil)
        
        let firestoreSessionFake = FirestoreSessionFake(fakeFirestoreResponse: fakeFirestoreResponse)
        let firestoreService = FirestoreService<Meeting>(firestoreSession: firestoreSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        firestoreService.addSnapshotListenerForSelectedDocuments(collection: Constants.Firestore.messagesCollection, field: "VTT", text: fakeBikeType) { (result) in
            guard case .success(let appDocuments) = result else {
                XCTFail()
                return
            }

            guard let appDocument = appDocuments.first else {
                XCTFail()
                return
            }
            
            if let data = appDocument.data {
                XCTAssertEqual(data.name, self.fakeName)
                XCTAssertEqual(data.creatorId, self.fakeEmail)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testAddSnapshotListenerForSelectedDocuments_ErrorOccured_ShouldReturnFailure() {
        let fakeFirestoreResponse = FakeFirestoreResponse(querySnapshot: nil, error: FakeNetworkResponse.networkError)
        
        let firestoreSessionFake = FirestoreSessionFake(fakeFirestoreResponse: fakeFirestoreResponse)
        let firestoreService = FirestoreService<Meeting>(firestoreSession: firestoreSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        firestoreService.addSnapshotListenerForSelectedDocuments(collection: Constants.Firestore.messagesCollection, field: "VTT", text: fakeBikeType)  { (result) in
            guard case .failure(_) = result else {
                XCTFail()
                return
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testLoadDocuments_ErrorIsNil_ShouldReturnSuccess() {
        let fakeQuerySnapshot = FakeQuerySnapshot(documents: [fakeFirestoreDocument])
        let fakeFirestoreResponse = FakeFirestoreResponse(querySnapshot: fakeQuerySnapshot, error: nil)
        
        let firestoreSessionFake = FirestoreSessionFake(fakeFirestoreResponse: fakeFirestoreResponse)
        let firestoreService = FirestoreService<Meeting>(firestoreSession: firestoreSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        firestoreService.loadDocuments(collection: Constants.Firestore.meetingsCollection) { (result) in
            
            guard case .success(let appDocuments) = result else {
                XCTFail()
                return
            }

            guard let appDocument = appDocuments.first else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(appDocument.documentId, "xhyAOHONTRtgWjYpgiun")
            
            if let data = appDocument.data {
                XCTAssertEqual(data.name, self.fakeName)
                XCTAssertEqual(data.latitude, self.fakeLatitude)
                XCTAssertEqual(data.longitude, self.fakeLongitude)
                XCTAssertEqual(data.description, self.fakeDescription)
                
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    func testLoadDocuments_ErrorOccured_ShouldReturnFailure() {
        let fakeFirestoreResponse = FakeFirestoreResponse(querySnapshot: nil, error: FakeNetworkResponse.networkError)
        
        let firestoreSessionFake = FirestoreSessionFake(fakeFirestoreResponse: fakeFirestoreResponse)
        let firestoreService = FirestoreService<Meeting>(firestoreSession: firestoreSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        firestoreService.loadDocuments(collection: Constants.Firestore.meetingsCollection) { (result) in
            guard case .failure(_) = result else {
                XCTFail()
                return
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testLoadDocuments_DocumentWithIncorrectData_ShouldReturnEmptyObject() {
        var incorrectFirestoreDocument = fakeFirestoreDocument
        incorrectFirestoreDocument.datas = [:]
        let fakequerySnapshot = FakeQuerySnapshot(documents: [incorrectFirestoreDocument])
        let fakeFirestoreResponse = FakeFirestoreResponse(querySnapshot: fakequerySnapshot, error: nil)
        
        let firestoreSessionFake = FirestoreSessionFake(fakeFirestoreResponse: fakeFirestoreResponse)
        let firestoreService = FirestoreService<Meeting>(firestoreSession: firestoreSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        firestoreService.loadDocuments(collection: Constants.Firestore.messagesCollection) { (result) in
            guard case .success(let appDocuments) = result else {
                XCTFail()
                return
            }
            
            guard let appDocument = appDocuments.first else {
                XCTFail()
                return
            }
            
            if appDocument.data == nil {
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testAddDocument_ErrorIsNil_ShouldReturnSuccess() {
        let fakeQuerySnapshot = FakeQuerySnapshot(documents: [fakeFirestoreDocument])
        let fakeFirestoreResponse = FakeFirestoreResponse(querySnapshot: fakeQuerySnapshot, error: nil)
        
        let firestoreSessionFake = FirestoreSessionFake(fakeFirestoreResponse: fakeFirestoreResponse)
        let firestoreService = FirestoreService<Meeting>(firestoreSession: firestoreSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        firestoreService.addDocument(collection: Constants.Firestore.meetingsCollection, object: meeting) { (error) in
            guard error == nil else {
                XCTFail()
                return
            }

            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    
    func testAddDocument_ErrorOccured_ShouldReturnFailure() {
        let fakequerySnapshot = FakeQuerySnapshot(documents: [fakeFirestoreDocument])
        let fakeFirestoreResponse = FakeFirestoreResponse(querySnapshot: fakequerySnapshot, error: FakeNetworkResponse.networkError)
        
        let firestoreSessionFake = FirestoreSessionFake(fakeFirestoreResponse: fakeFirestoreResponse)
        let firestoreService = FirestoreService<Meeting>(firestoreSession: firestoreSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        firestoreService.addDocument(collection: Constants.Firestore.meetingsCollection, object: meeting) { (error) in
            guard let _ = error else {
                XCTFail()
                return
            }

            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testModifyDocument_ErrorIsNil_ShouldReturnSuccess() {
        let fakeQuerySnapshot = FakeQuerySnapshot(documents: [fakeFirestoreDocument])
        let fakeFirestoreResponse = FakeFirestoreResponse(querySnapshot: fakeQuerySnapshot, error: nil)
        
        let firestoreSessionFake = FirestoreSessionFake(fakeFirestoreResponse: fakeFirestoreResponse)
        let firestoreService = FirestoreService<Meeting>(firestoreSession: firestoreSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        firestoreService.modifyDocument(id: id, collection: Constants.Firestore.meetingsCollection, object: meeting) { (error) in
            guard error == nil else {
                XCTFail()
                return
            }

            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testModifyDocument_ErrorOccured_ShouldReturnFailure() {
        let fakequerySnapshot = FakeQuerySnapshot(documents: [fakeFirestoreDocument])
        let fakeFirestoreResponse = FakeFirestoreResponse(querySnapshot: fakequerySnapshot, error: FakeNetworkResponse.networkError)
        
        let firestoreSessionFake = FirestoreSessionFake(fakeFirestoreResponse: fakeFirestoreResponse)
        let firestoreService = FirestoreService<Meeting>(firestoreSession: firestoreSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        firestoreService.modifyDocument(id: id, collection: Constants.Firestore.meetingsCollection, object: meeting) { (error) in
            guard let _ = error else {
                XCTFail()
                return
            }

            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSearchDocument_DocumentFound_ShouldReturnSuccess() {
        let fakequerySnapshot = FakeQuerySnapshot(documents: [fakeFirestoreDocument])
        let fakeFirestoreResponse = FakeFirestoreResponse(querySnapshot: fakequerySnapshot, error: nil)
        
        let firestoreSessionFake = FirestoreSessionFake(fakeFirestoreResponse: fakeFirestoreResponse)
        let firestoreService = FirestoreService<Meeting>(firestoreSession: firestoreSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        firestoreService.searchDocuments(collection: Constants.Firestore.meetingsCollection, field: "email", text: fakeEmail) { (result) in
            guard case .success(let appDocuments) = result else {
                XCTFail()
                return
            }

            guard let appDocument = appDocuments.first else {
                XCTFail()
                return
            }
            
            if let data = appDocument.data {
                XCTAssertEqual(data.name, self.fakeName)
                XCTAssertEqual(data.creatorId, self.fakeEmail)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSearchData_ErrorOccured_ShouldResultFailure() {
        let fakeFirestoreResponse = FakeFirestoreResponse(querySnapshot: nil, error: FakeNetworkResponse.networkError)
        
        let firestoreSessionFake = FirestoreSessionFake(fakeFirestoreResponse: fakeFirestoreResponse)
        let firestoreService = FirestoreService<Meeting>(firestoreSession: firestoreSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        firestoreService.searchDocuments(collection: "", field: "", text: "")  { (result) in
            guard case .failure(_) = result else {
                XCTFail()
                return
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
