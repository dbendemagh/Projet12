//
//  AuthServiceTests.swift
//  BicycleRideTests
//
//  Created by Daniel BENDEMAGH on 27/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import XCTest
@testable import BicycleRide

class AuthServiceTests: XCTestCase {
    
    let fakeAuthData =  FakeAuthData(user: FakeUser(displayName: "Nom", email: "az@er.com"))

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testAddUserConnectionListenerShouldUserIsConnected() {
        let fakeAuthResponse = FakeAuthResponse(authData: fakeAuthData, error: nil)
        let authSessionFake = AuthSessionFake(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(authSession: authSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        authService.addUserConnectionListener { (connected) in
            guard connected == true else {
                XCTFail()
                return
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testAddUserConnectionListenerShouldShouldUserIsNotConnected() {
        let fakeAuthResponse = FakeAuthResponse(authData: nil, error: nil)
        let authSessionFake = AuthSessionFake(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(authSession: authSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        authService.addUserConnectionListener { (connected) in
            guard connected == false else {
                XCTFail()
                return
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testCreateUserShouldResultSuccess() {
        let fakeAuthResponse = FakeAuthResponse(authData: fakeAuthData, error: nil)
        let authSessionFake = AuthSessionFake(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(authSession: authSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        authService.createUser(email: "Nom", password: "123456") { (result) in
            guard case .success(let user) = result else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(user.displayName, "Nom")
            XCTAssertEqual(user.email, "az@er.com")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    func testCreateUserShouldResultFailure() {
        let fakeAuthResponse = FakeAuthResponse(authData: nil, error: FakeNetworkResponse.networkError)
        let authSessionFake = AuthSessionFake(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(authSession: authSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        authService.createUser(email: "Nom", password: "123456") { (result) in
            guard case .failure(_) = result else {
                XCTFail()
                return
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    func testSignInShouldResultSuccess() {
        let fakeAuthResponse = FakeAuthResponse(authData: fakeAuthData, error: nil)
        let authSessionFake = AuthSessionFake(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(authSession: authSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        authService.signIn(email: "Nom", password: "123456") { (result) in
            guard case .success(let user) = result else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(user.displayName, "Nom")
            XCTAssertEqual(user.email, "az@er.com")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSignInShouldResultFailure() {
        let fakeAuthResponse = FakeAuthResponse(authData: nil, error: FakeNetworkResponse.networkError)
        let authSessionFake = AuthSessionFake(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(authSession: authSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        authService.signIn(email: "Nom", password: "123456") { (result) in
            guard case .failure(_) = result else {
                XCTFail()
                return
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSignOutShouldResultSuccess() {
        let fakeAuthResponse = FakeAuthResponse(authData: fakeAuthData, error: nil)
        let authSessionFake = AuthSessionFake(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(authSession: authSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        authService.signOut() { (result) in
            guard case .success(true) = result else {
                XCTFail()
                return
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSignOutShouldResultFailure() {
        let fakeAuthResponse = FakeAuthResponse(authData: nil, error: FakeNetworkResponse.networkError)
        let authSessionFake = AuthSessionFake(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(authSession: authSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        authService.signOut() { (result) in
            guard case .failure(_) = result else {
                XCTFail()
                return
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
