//
//  MessageManager.swift
//  MessagingApp
//
//  Created by Hassan Shahid on 21.11.2025.
//

import Foundation

protocol MessageManager {
    func fetchMessages(roomId: String) async throws -> [TimelineEvent]
}

class MessageManagerImp: MessageManager {
    private let webService: WebService
    
    init(webService: WebService = WebServiceImp.shared) {
        self.webService = webService
    }
    
    func fetchMessages(roomId: String) async throws -> [TimelineEvent] {
        
        let response: MessagesResponse = try await webService.request(
            endpoint: "/rooms/\(roomId)/messages?dir=b&limit=50",
            method: .get,
            body: nil,
            headers: nil
        )
        
        return response.chunk.compactMap { event in
            parseEvent(event)
        }
    }
    
    private func parseEvent(_ event: RoomEvent) -> TimelineEvent? {
        switch event.type {
        case "m.room.message":
            return parseMessageEvent(event)
            
        case "m.room.member":
            return parseMembershipEvent(event)
            
        default:
            return nil
        }
    }
    
    private func parseMessageEvent(_ event: RoomEvent) -> TimelineEvent? {
        guard let body = event.content.body else { return nil }
        
        let displayName = event.content.displayname ?? extractDisplayName(from: event.sender)
        
        let messageEvent = MessageEvent(
            id: event.eventId,
            sender: event.sender,
            displayName: displayName,
            body: body,
            timestamp: event.originServerTs
        )
        
        return .message(messageEvent)
    }
    
    private func parseMembershipEvent(_ event: RoomEvent) -> TimelineEvent? {
        guard let membership = event.content.membership else { return nil }
        
        let displayName = event.content.displayname ?? extractDisplayName(from: event.sender)
        
        let action: MembershipEvent.MembershipAction
        switch membership {
        case "join":
            action = .joined
        case "leave":
            action = .left
        case "invite":
            action = .invited
        default:
            return nil
        }
        
        let membershipEvent = MembershipEvent(
            id: event.eventId,
            sender: event.sender,
            displayName: displayName,
            action: action,
            timestamp: event.originServerTs
        )
        
        return .membershipChange(membershipEvent)
    }
    
    private func extractDisplayName(from userId: String) -> String {
        // Extract username from @username:domain format
        if let username = userId.split(separator: "@").last?.split(separator: ":").first {
            return String(username)
        }
        return userId
    }
}
