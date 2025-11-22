//
//  RoomManager.swift
//  MessagingApp
//
//  Created by Hassan Shahid on 21.11.2025.
//

import Foundation

protocol RoomManager {
    func fetchPublicRooms(accessToken: String) async throws -> [MatrixRoom]
    func joinRoom(roomId: String, accessToken: String) async throws
}

class RoomManagerImp: RoomManager {
    private let webService: WebServiceProtocol
    
    init(webService: WebServiceProtocol = WebService.shared) {
        self.webService = webService
    }
    
    func fetchPublicRooms(accessToken: String) async throws -> [MatrixRoom] {
        let headers = ["Authorization": "Bearer \(accessToken)"]
        
        let json: [String: Any] = try await webService.requestJSON(
            endpoint: "/_matrix/client/r0/publicRooms",
            method: .get,
            body: nil,
            headers: headers
        )
        
        guard let chunk = json["chunk"] as? [[String: Any]] else {
            return []
        }
        
        return chunk.compactMap { roomDict in
            guard let roomId = roomDict["room_id"] as? String else { return nil }
            return MatrixRoom(
                roomId: roomId,
                name: roomDict["name"] as? String,
                topic: roomDict["topic"] as? String,
                numJoinedMembers: roomDict["num_joined_members"] as? Int ?? 0
            )
        }
    }
    
    func joinRoom(roomId: String, accessToken: String) async throws {
        let encodedRoomId = roomId.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? roomId
        let headers = ["Authorization": "Bearer \(accessToken)"]
        
        let _: [String: Any] = try await webService.requestJSON(
            endpoint: "/_matrix/client/r0/rooms/\(encodedRoomId)/join",
            method: .post,
            body: [:],
            headers: headers
        )
    }
}
