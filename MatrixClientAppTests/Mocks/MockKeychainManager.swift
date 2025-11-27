//
//  MockKeychainManager.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 27.11.2025.
//


class MockKeychainManager: KeychainManager {
    
    private var storage: [String: String] = [:]
    
    func save(key: String, value: String) {
        storage[key] = value
    }
    
    func read(key: String) -> String? {
        storage[key]
    }
    
    func delete(key: String) {
        storage.removeValue(forKey: key)
    }
}
