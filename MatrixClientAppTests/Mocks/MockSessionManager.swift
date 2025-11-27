//
//  MockSessionManager.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 27.11.2025.
//

import Foundation

final class MockSessionManager: SessionManager {
    var accessToken: String?
    var updatedToken: String?
    var updatedUserId: String?
    
    func updateSession(token: String, userId: String) {
        updatedToken = token
        updatedUserId = userId
        accessToken = token
    }
    
    func clear() {
        accessToken = nil
        updatedToken = nil
        updatedUserId = nil
    }
}
