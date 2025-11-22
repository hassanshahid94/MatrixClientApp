//
//  MessageManager.swift
//  MessagingApp
//
//  Created by Hassan Shahid on 21.11.2025.
//

import Foundation

protocol MessageManager {
    func fetchMessages(roomId: String, accessToken: String) async throws -> [MatrixMessage]
}

class MessageManagerImp: MessageManager {
    private let webService: WebService
    
    init(webService: WebService = WebServiceImp.shared) {
        self.webService = webService
    }
    
    func fetchMessages(roomId: String, accessToken: String) async throws -> [MatrixMessage] {
        let encodedRoomId = roomId.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? roomId
        let headers = ["Authorization": "Bearer \(accessToken)"]
        
        let json: [String: Any] = try await webService.requestJSON(
            endpoint: "/_matrix/client/r0/rooms/\(encodedRoomId)/messages?dir=b&limit=50",
            method: .get,
            body: nil,
            headers: headers
        )
        
        guard let chunk = json["chunk"] as? [[String: Any]] else {
            return []
        }
        
        return chunk.compactMap { eventDict in
            guard let eventId = eventDict["event_id"] as? String,
                  let sender = eventDict["sender"] as? String,
                  let content = eventDict["content"] as? [String: Any],
                  let body = content["body"] as? String,
                  let timestamp = eventDict["origin_server_ts"] as? Int64 else {
                return nil
            }
            
            return MatrixMessage(
                eventId: eventId,
                sender: sender,
                body: body,
                timestamp: timestamp
            )
        }
    }
}
