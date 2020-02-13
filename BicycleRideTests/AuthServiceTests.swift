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
    
    let fakeName = "Test"
    let fakeEmail = "test@gmail.com"
    
    var fakeAuthDataResult = FakeAuthDataResult(user: FakeUser(displayName: "", email: ""))
    
    override func setUp() {
        fakeAuthDataResult.user?.displayName = fakeName
        fakeAuthDataResult.user?.email = fakeEmail
    }

    func testGetCurrentUser_UserIsNotNil_ShouldReturnUser() {
        let fakeAuthResponse = FakeAuthResponse(authDataResult: fakeAuthDataResult, error: nil)
        let authSessionFake = AuthSessionFake(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(authSession: authSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        guard let user: AuthUserProtocol = authService.getCurrentUser() else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(user.displayName, self.fakeName)
        XCTAssertEqual(user.email, self.fakeEmail)
            
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrentUser_UserIsNil_ShouldReturnNil() {
        let fakeAuthResponse = FakeAuthResponse(authDataResult: nil, error: nil)
        let authSessionFake = AuthSessionFake(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(authSession: authSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        guard authService.getCurrentUser() == nil else {
            XCTFail()
            return
        }
            
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testAddUserConnectionListener_UserIsConnected_ShouldReturnTrue() {
        let fakeAuthResponse = FakeAuthResponse(authDataResult: fakeAuthDataResult, error: nil)
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
    
    func testAddUserConnectionListener_UserIsNotConnected_ShouldReturnFalse() {
        let fakeAuthResponse = FakeAuthResponse(authDataResult: nil, error: nil)
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
    
    func testCreateUser_CreationSucced_ShouldReturnUser() {
        let fakeAuthResponse = FakeAuthResponse(authDataResult: fakeAuthDataResult, error: nil)
        let authSessionFake = AuthSessionFake(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(authSession: authSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        authService.createUser(email: "Nom", password: "123456") { (result) in
            guard case .success(let user) = result else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(user.displayName, self.fakeName)
            XCTAssertEqual(user.email, self.fakeEmail)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    func testCreateUser_CreationFailed_ShouldReturnFailure() {
        let fakeAuthResponse = FakeAuthResponse(authDataResult: nil, error: FakeNetworkResponse.networkError)
        let authSessionFake = AuthSessionFake(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(authSession: authSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        authService.createUser(email: fakeEmail, password: "123456") { (result) in
            guard case .failure(_) = result else {
                XCTFail()
                return
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    func testUpdateCurrentUser_UpdateSucced_ShouldReturnNoError() {
        let fakeAuthResponse = FakeAuthResponse(authDataResult: fakeAuthDataResult, error: nil)
        let authSessionFake = AuthSessionFake(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(authSession: authSessionFake)
        let userProfile = UserProfile(name: fakeName, email: fakeEmail, bikeType: "VTT", experience: "20-25")

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        authService.updateCurrentUser(userProfile: userProfile) { (error) in
            guard error == nil else {
                XCTFail()
                return
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testUpdateCurrentUser_UpdateFailed_ShouldReturnError() {
        let fakeAuthResponse = FakeAuthResponse(authDataResult: nil, error: FakeNetworkResponse.networkError)
        let authSessionFake = AuthSessionFake(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(authSession: authSessionFake)
        let userProfile = UserProfile(name: fakeName, email: fakeEmail, bikeType: "VTT", experience: "20-25")

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        authService.updateCurrentUser(userProfile: userProfile) { (error) in
            guard error != nil else {
                XCTFail()
                return
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSignIn_UserOk_ShouldReturnUser() {
        let fakeAuthResponse = FakeAuthResponse(authDataResult: fakeAuthDataResult, error: nil)
        let authSessionFake = AuthSessionFake(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(authSession: authSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        authService.signIn(email: fakeEmail, password: "123456") { (result) in
            guard case .success(let user) = result else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(user.displayName, self.fakeName)
            XCTAssertEqual(user.email, self.fakeEmail)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSignIn_UserIsNil_ShouldReturnFailure() {
        let fakeAuthResponse = FakeAuthResponse(authDataResult: nil, error: FakeNetworkResponse.networkError)
        let authSessionFake = AuthSessionFake(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(authSession: authSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        authService.signIn(email: fakeEmail, password: "123456") { (result) in
            guard case .failure(_) = result else {
                XCTFail()
                return
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSignOut_SignOutOk_ShouldReturnSuccess() {
        let fakeAuthResponse = FakeAuthResponse(authDataResult: fakeAuthDataResult, error: nil)
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
    
    func testSignOut_SignOutFailed_ShouldReturnFailure() {
        let fakeAuthResponse = FakeAuthResponse(authDataResult: nil, error: FakeNetworkResponse.networkError)
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
