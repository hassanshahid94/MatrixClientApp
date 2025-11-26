//
//  RoomManager.swift
//  MessagingApp
//
//  Created by Hassan Shahid on 21.11.2025.
//

import Foundation

protocol RoomManager {
    func fetchPublicRooms() async throws -> [PublicRoom]
    func joinRoom(roomId: String) async throws
    func fetchJoinedRooms() async throws -> [String]
}

class RoomManagerImp: RoomManager {
    private let webService: WebService
    
    init(webService: WebService = WebServiceImp.shared) {
        self.webService = webService
    }
    
    func fetchPublicRooms() async throws -> [PublicRoom] {
        let response: PublicRoomResponse = try await webService.request(
            endpoint: "/_matrix/client/v3/publicRooms",
            method: .get,
            body: nil,
            headers: nil
        )
        
        return response.chunk
    }
    
    func joinRoom(roomId: String) async throws {
        let _: JoinRoomResponse = try await webService.request(
            endpoint: "/_matrix/client/v3/join/\(roomId)",
            method: .post,
            body: [:],
            headers: nil
        )
    }
    
    func fetchJoinedRooms() async throws -> [String] {
        let response: JoinedRoomResponse = try await webService.request(
            endpoint: "/_matrix/client/v3/joined_rooms",
            method: .get,
            body: nil,
            headers: nil
        )
        return response.joinedRooms
    }
}
