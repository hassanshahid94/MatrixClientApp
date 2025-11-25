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
    
    // MARK: - Properties
    let accessToken: String  // Store accessToken here
    
    // MARK: - Dependencies
    private let roomManager: RoomManager
    
    // MARK: - Initializer
    init(roomManager: RoomManager, accessToken: String) {
        self.roomManager = roomManager
        self.accessToken = accessToken
        
        Task {
            await fetchPublicRooms()
        }
    }
    
    // MARK: - Public Methods
    func fetchPublicRooms() async {
        isLoading = true
        errorMessage = nil
        
        do {
            self.rooms = try await roomManager.fetchPublicRooms(accessToken: accessToken)
        } catch {
            self.errorMessage = "Failed to fetch rooms: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
