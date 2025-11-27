//
//  SessionManagerTests.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 27.11.2025.
//

import XCTest

final class SessionManagerTests: XCTestCase {

    // MARK: - Variables
    private var mockKeychainManager: MockKeychainManager!
    private var sessionManager: SessionManagerImp!
    
    override func setUp() {
        mockKeychainManager = MockKeychainManager()
        sessionManager = SessionManagerImp(keychain: mockKeychainManager)
    }
    
    override func tearDown() {
        sessionManager.clear()
        mockKeychainManager = nil
        sessionManager = nil
    }
    
    // MARK: - Tests
    func testInitialAccessTokenIsNilWhenKeychainEmpty() {
        XCTAssertNil(sessionManager.accessToken)
    }
    
    func testInitialAccessTokenIsLoadedFromKeychain() {
        mockKeychainManager.save(key: "accessToken", value: "token123")
        
        let manager = SessionManagerImp(keychain: mockKeychainManager)
        
        XCTAssertEqual(manager.accessToken, "token123")
    }
    
    func testUpdateSessionSavesTokenAndUpdatesAccessToken() {
        sessionManager.updateSession(token: "newToken", userId: "@user:matrix.org")
        
        XCTAssertEqual(sessionManager.accessToken, "newToken")
        XCTAssertEqual(mockKeychainManager.read(key: "accessToken"), "newToken")
    }
    
    func testClearRemovesTokenAndAccessTokenIsNil() {
        sessionManager.updateSession(token: "tokenToDelete", userId: "@user:matrix.org")
        
        sessionManager.clear()
        
        XCTAssertNil(sessionManager.accessToken)
        XCTAssertNil(mockKeychainManager.read(key: "accessToken"))
    }
}
