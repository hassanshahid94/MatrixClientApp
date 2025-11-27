//
//  LoginVM.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 25.11.2025.
//

import Foundation

@MainActor
class LoginVM: ObservableObject {
    
    // MARK: - Published Properties
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAuthenticated = false
    
    // MARK: - Dependencies
    private let authenticationManager: AuthenticationManager
    
    // MARK: - Initializer
    init(authenticationManager: AuthenticationManager = AuthenticationManagerImp()) {
        self.authenticationManager = authenticationManager
    }
    
    // MARK: - Functions
    func login(username: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await authenticationManager.login(username: username, password: password)
                
                // Save session globally
                SessionManagerImp.shared.updateSession(
                    token: response.accessToken,
                    userId: response.userId
                )
                
                self.isAuthenticated = true
                
            } catch let error as NetworkError {
                self.errorMessage = error.errorDescription
            } catch {
                self.errorMessage = "Network error: \(error.localizedDescription)"
            }
            
            isLoading = false
        }
    }
}
