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
        super.setUp()
        mockKeychainManager = MockKeychainManager()
        sessionManager = SessionManagerImp(keychain: mockKeychainManager)
    }
    
    override func tearDown() {
        sessionManager.clear()
        mockKeychainManager = nil
        sessionManager = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testInitialAccessTokenIsNilWhenKeychainEmpty() {
        XCTAssertNil(sessionManager.accessToken, "Access token should be nil when keychain is empty")
    }
    
    func testInitialAccessTokenIsLoadedFromKeychain() {
        mockKeychainManager.save(key: "accessToken", value: "token123")
        
        let manager = SessionManagerImp(keychain: mockKeychainManager)
        
        XCTAssertEqual(manager.accessToken, "token123", "Access token should load from keychain")
    }
    
    func testUpdateSessionSavesTokenAndUpdatesAccessToken() {
        sessionManager.updateSession(token: "newToken", userId: "@user:matrix.org")
        
        XCTAssertEqual(sessionManager.accessToken, "newToken", "Access token should be updated in memory")
        XCTAssertEqual(mockKeychainManager.read(key: "accessToken"), "newToken", "Access token should be saved in keychain")
    }
    
    func testClearRemovesTokenAndAccessTokenIsNil() {
        sessionManager.updateSession(token: "tokenToDelete", userId: "@user:matrix.org")
        
        sessionManager.clear()
        
        XCTAssertNil(sessionManager.accessToken, "Access token should be nil after clearing session")
        XCTAssertNil(mockKeychainManager.read(key: "accessToken"), "Keychain should not contain access token after clearing session")
    }
}
