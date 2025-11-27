//
//  MockRoomManager.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 27.11.2025.
//

import Foundation

final class MockRoomManager: RoomManager {
    
    var shouldSucceed = true
    var roomsToReturn: [PublicRoom] = []
    var joinedRooms: [String] = []
    var thrownError: Error = URLError(.badServerResponse)
    
    // Track calls if needed
    var fetchPublicRoomsCalled = false
    var joinRoomCalledWith: String?
    var fetchJoinedRoomsCalled = false
    
    func fetchPublicRooms() async throws -> [PublicRoom] {
        fetchPublicRoomsCalled = true
        if shouldSucceed {
            return roomsToReturn
        } else {
            throw thrownError
        }
    }
    
    func joinRoom(roomId: String) async throws {
        joinRoomCalledWith = roomId
        if !shouldSucceed {
            throw thrownError
        }
    }
    
    func fetchJoinedRooms() async throws -> [String] {
        fetchJoinedRoomsCalled = true
        if shouldSucceed {
            return joinedRooms
        } else {
            throw thrownError
        }
    }
}
