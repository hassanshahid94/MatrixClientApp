//
//  HomeVM.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 25.11.2025.
//

import Foundation

@MainActor
class HomeVM: ObservableObject {
    
    // MARK: - Published Properties
    @Published var rooms: [PublicRoom] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Dependencies
    private let roomManager: RoomManager
    private let sessionManager: SessionManager
    
    // MARK: - Initializer
    init(roomManager: RoomManager = RoomManagerImp(),
         sessionManager: SessionManager = SessionManagerImp.shared) {
        self.roomManager = roomManager
        self.sessionManager = sessionManager
    }
    
    // MARK: - Functions
    func fetchPublicRooms() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                rooms = try await roomManager.fetchPublicRooms()
            } catch {
                errorMessage = "Failed to fetch rooms: \(error.localizedDescription)"
            }
            isLoading = false
        }
    }
    
    func logout() {
        sessionManager.clear()
    }
}
