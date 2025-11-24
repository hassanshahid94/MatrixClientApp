//
//  LoginResponse.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 24.11.2025.
//


import Foundation

struct LoginResponse: Codable {
    let userId: String
    let accessToken: String
    let homeServer: String
    let deviceId: String
    let wellKnown: WellKnown

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case accessToken = "access_token"
        case homeServer = "home_server"
        case deviceId = "device_id"
        case wellKnown = "well_known"
    }
}

struct WellKnown: Codable {
    let homeserver: Homeserver
    let identityServer: IdentityServer

    enum CodingKeys: String, CodingKey {
        case homeserver = "m.homeserver"
        case identityServer = "m.identity_server"
    }
}

struct Homeserver: Codable {
    let baseUrl: String

    enum CodingKeys: String, CodingKey {
        case baseUrl = "base_url"
    }
}

struct IdentityServer: Codable {
    let baseUrl: String

    enum CodingKeys: String, CodingKey {
        case baseUrl = "base_url"
    }
}