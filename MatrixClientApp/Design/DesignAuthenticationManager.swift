//
//  DesignAuthenticationManager.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 28.11.2025.
//

import Foundation

class DesignAuthenticationManager: AuthenticationManager {
    func login(username: String, password: String) async throws -> LoginResponse {
        throw NSError(domain: "preview.mock", code: -1,
                      userInfo: [NSLocalizedDescriptionKey: "Design mock does nothing."])
    }
}
