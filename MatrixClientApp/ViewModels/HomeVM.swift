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
    
    // MARK: - Initializer
    init(roomManager: RoomManager = RoomManagerImp()) {
        self.roomManager = roomManager
        
        fetchPublicRooms()
    }
    
    // MARK: - Functions
    func fetchPublicRooms() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                self.rooms = try await roomManager.fetchPublicRooms()
            } catch {
                self.errorMessage = "Failed to fetch rooms: \(error.localizedDescription)"
            }
            isLoading = false
        }
    }
}
