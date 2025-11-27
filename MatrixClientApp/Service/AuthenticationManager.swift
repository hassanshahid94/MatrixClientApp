//
//  AuthenticationManager.swift
//  MessagingApp
//
//  Created by Hassan Shahid on 21.11.2025.
//

import Foundation

protocol AuthenticationManager {
    func login(username: String, password: String) async throws -> LoginResponse
}

class AuthenticationManagerImp: AuthenticationManager {
    private let webService: WebService
    
    init(webService: WebService = WebServiceImp.shared) {
        self.webService = webService
    }
    
    func login(username: String, password: String) async throws -> LoginResponse {
        let body: [String: Any] = [
            "identifier": [
                "type": "m.id.user",
                "user": username
            ],
            "initial_device_display_name": "iPhone",
            "password": password,
            "type": "m.login.password"
        ]
        
        let response: LoginResponse = try await webService.request(
            endpoint: "/login",
            method: .post,
            body: body,
            headers: nil
        )
        return response
    }
}
