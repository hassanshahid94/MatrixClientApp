//
//  DesignRoomManager.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 28.11.2025.
//

import Foundation

class DesignRoomManager: RoomManager {
    func fetchPublicRooms() async throws -> [PublicRoom] {
        return PreviewData.sampleRooms
    }
    
    func joinRoom(roomId: String) async throws { }
    
    func fetchJoinedRooms() async throws -> [String] {
        return PreviewData.sampleRooms.map { $0.roomId }
    }
}
