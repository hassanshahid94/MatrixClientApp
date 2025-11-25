//
//  RoomManager.swift
//  MessagingApp
//
//  Created by Hassan Shahid on 21.11.2025.
//

import Foundation

protocol RoomManager {
    func fetchPublicRooms(accessToken: String) async throws -> [PublicRoom]
    func joinRoom(roomId: String, accessToken: String) async throws
}

class RoomManagerImp: RoomManager {
    private let webService: WebService
    
    init(webService: WebService = WebServiceImp.shared) {
        self.webService = webService
    }
    
    func fetchPublicRooms(accessToken: String) async throws -> [PublicRoom] {
        let headers = ["Authorization": "Bearer \(accessToken)"]
        
        let response: PublicRoomResponse = try await webService.request(
            endpoint: "/_matrix/client/v3/publicRooms",
            method: .get,
            body: nil,
            headers: headers
        )
        
        return response.chunk
    }
    
    func joinRoom(roomId: String, accessToken: String) async throws {
        let headers = ["Authorization": "Bearer \(accessToken)"]
        
        let _: JoinRoomResponse = try await webService.request(
            endpoint: "_matrix/client/v3/join/\(roomId)",
            method: .post,
            body: [:],
            headers: headers
        )
    }
}
