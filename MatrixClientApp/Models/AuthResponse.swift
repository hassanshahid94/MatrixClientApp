//
//  AuthResponse.swift
//  MessagingApp
//
//  Created by Hassan Shahid on 21.11.2025.
//

import Foundation

struct AuthResponse: Codable {
    let accessToken: String
    let userId: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case userId = "user_id"
    }
}
