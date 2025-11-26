//
//  RoomDetailVM.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 25.11.2025.
//

import Foundation

@MainActor
class RoomDetailVM: ObservableObject {
    
    // MARK: - Published Properties
    @Published var timelineEvents: [TimelineEvent] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var hasJoinedRoom = false
    
    // MARK: - Dependencies
    private let roomManager: RoomManager
    private let messageManager: MessageManager
    
    // MARK: - Initializer
    init(
        roomManager: RoomManager,
        messageManager: MessageManager,
        room: PublicRoom
    ) {
        self.roomManager = roomManager
        self.messageManager = messageManager
    }
    
    // MARK: - Public Methods
    
    func joinRoom(roomId: String) async {
        do {
            try await roomManager.joinRoom(roomId: roomId)
            self.hasJoinedRoom = true
        } catch {
            self.errorMessage = "Failed to join room: \(error.localizedDescription)"
            print("Failed to join room: \(error)")
        }
    }
    
    func fetchMessages(roomId: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            self.timelineEvents = try await messageManager.fetchMessages(
                roomId: roomId
            )
        } catch {
            self.errorMessage = "Failed to fetch messages: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
//    func loadRoomContent() async {
//        await joinRoom()
//        await fetchMessages()
//    }
}
