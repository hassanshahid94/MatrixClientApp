//
//  SessionManager.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 26.11.2025.
//


import Foundation
import Combine

protocol SessionManager {
    var accessToken: String? { get }
    
    func updateSession(token: String, userId: String)
    func clear()
}

final class SessionManagerImp: ObservableObject, SessionManager {
    static let shared = SessionManagerImp(keychain: KeychainManagerImp())
    
    @Published private(set) var accessToken: String?
    private let keychain: KeychainManager
    
    init(keychain: KeychainManager) {
        self.keychain = keychain

        accessToken = keychain.read(key: "accessToken")
    }
    
    func updateSession(token: String, userId: String) {
        accessToken = token
        keychain.save(key: "accessToken", value: token)
    }
    
    func clear() {
        accessToken = nil
        keychain.delete(key: "accessToken")
    }
}
