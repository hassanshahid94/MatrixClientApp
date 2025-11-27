//
//  MockAuthenticationManager.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 27.11.2025.
//

import Foundation

class MockAuthenticationManager: AuthenticationManager {
    var shouldSucceed = true
    var response: LoginResponse?
    var thrownError: Error = URLError(.badServerResponse)
    
    func login(username: String, password: String) async throws -> LoginResponse {
        if shouldSucceed, let response = response {
            return response
        } else {
            throw thrownError
        }
    }
}
