//
//  SessionManager.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 26.11.2025.
//


final class SessionManager {
    static let shared = SessionManager()
    private init() {}

    private(set) var accessToken: String?
    private(set) var userId: String?

    func updateSession(token: String, userId: String) {
        self.accessToken = token
        self.userId = userId
    }

    func clear() {
        accessToken = nil
        userId = nil
    }
}
