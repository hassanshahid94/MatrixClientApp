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
        roomManager: RoomManager = RoomManagerImp(),
        messageManager: MessageManager = MessageManagerImp()
    ) {
        self.roomManager = roomManager
        self.messageManager = messageManager
    }
    
    // MARK: - Functions
    func loadRoom(roomId: String) {
        Task {
            isLoading = true
            await checkIfJoined(roomId: roomId)
            
            if hasJoinedRoom {
                fetchMessages(roomId: roomId)
            }
            
            isLoading = false
        }
    }
    
    func joinRoom(roomId: String) {
        Task {
            do {
                isLoading = true
                try await roomManager.joinRoom(roomId: roomId)
                self.hasJoinedRoom = true
                fetchMessages(roomId: roomId)
            } catch {
                self.errorMessage = "Failed to join room: \(error.localizedDescription)"
            }
            isLoading = false
        }
    }
    
    func fetchMessages(roomId: String) {
        Task {
            do {
                self.timelineEvents = try await messageManager.fetchMessages(roomId: roomId)
            } catch {
                self.errorMessage = "Failed to fetch messages: \(error.localizedDescription)"
            }
        }
    }
    
    // MARK: - Private Functions
    private func checkIfJoined(roomId: String) async {
        do {
            let joinedRooms = try await roomManager.fetchJoinedRooms()
            self.hasJoinedRoom = joinedRooms.contains(roomId)
        } catch {
            self.errorMessage = "Failed to check room membership: \(error.localizedDescription)"
        }
    }
}
