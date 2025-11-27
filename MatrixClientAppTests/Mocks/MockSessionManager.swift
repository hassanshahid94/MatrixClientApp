//
//  MockSessionManager.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 27.11.2025.
//

import Foundation

class MockSessionManager: SessionManager {
    var accessToken: String?
    var updatedToken: String?
    var updatedUserId: String?
    
    var clearCalled = false
    
    func updateSession(token: String, userId: String) {
        updatedToken = token
        updatedUserId = userId
        accessToken = token
    }
    
    func clear() {
        clearCalled = true
        accessToken = nil
        updatedToken = nil
        updatedUserId = nil
    }
}
