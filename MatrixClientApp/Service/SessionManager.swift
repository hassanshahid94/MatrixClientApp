//
//  SessionManager.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 26.11.2025.
//


import Foundation
import Combine

protocol SessionManager: ObservableObject {
    var accessToken: String? { get }
    var userId: String? { get }

    func updateSession(token: String, userId: String)
    func loadSession()
    func clear()
}


class SessionManagerImp: SessionManager {
    static let shared = SessionManagerImp(keychain: KeychainManagerImpl())

    @Published private(set) var accessToken: String?
    @Published private(set) var userId: String?

    private let keychain: KeychainManager

    private init(keychain: KeychainManager) {
        self.keychain = keychain
        loadSession()
    }

    func updateSession(token: String, userId: String) {
        self.accessToken = token
        self.userId = userId

        keychain.save(key: "accessToken", value: token)
        keychain.save(key: "userId", value: userId)
    }

    func loadSession() {
        self.accessToken = keychain.read(key: "accessToken")
        self.userId = keychain.read(key: "userId")
    }

    func clear() {
        self.accessToken = nil
        self.userId = nil

        keychain.delete(key: "accessToken")
        keychain.delete(key: "userId")
    }
}
