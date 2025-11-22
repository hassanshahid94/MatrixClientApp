//
//  AuthenticationManager.swift
//  MessagingApp
//
//  Created by Hassan Shahid on 21.11.2025.
//

import Foundation

protocol AuthenticationManager {
    func login(username: String, password: String) async throws -> AuthResponse
}

class AuthenticationManagerImp: AuthenticationManager {
    private let webService: WebServiceProtocol
    
    init(webService: WebServiceProtocol = WebService.shared) {
        self.webService = webService
    }
    
    func login(username: String, password: String) async throws -> AuthResponse {
        let body: [String: Any] = [
            "type": "m.login.password",
            "user": username,
            "password": password
        ]
        
        return try await webService.request(
            endpoint: "/_matrix/client/r0/login",
            method: .post,
            body: body,
            headers: nil
        )
    }
}
