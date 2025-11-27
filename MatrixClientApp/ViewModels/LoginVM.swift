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
    
    // MARK: - Dependencies
    private let authenticationManager: AuthenticationManager
    private let sessionManager: SessionManager
    
    // MARK: - Initializer
    init(
        authenticationManager: AuthenticationManager = AuthenticationManagerImp(),
        sessionManager: SessionManager = SessionManagerImp.shared
    ) {
        self.authenticationManager = authenticationManager
        self.sessionManager = sessionManager
    }
    
    // MARK: - Functions
    func login(username: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await authenticationManager.login(username: username, password: password)
                
                sessionManager.updateSession(
                    token: response.accessToken,
                    userId: response.userId
                )
                
            } catch let error as NetworkError {
                errorMessage = error.errorDescription
            } catch {
                errorMessage = "Network error: \(error.localizedDescription)"
            }
            
            isLoading = false
        }
    }
}
