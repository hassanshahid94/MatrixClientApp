//
//  MessagesResponse.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 25.11.2025.
//

import Foundation

struct MessagesResponse: Codable {
    let chunk: [RoomEvent]
    let start: String?
    let end: String?
}

struct RoomEvent: Codable {
    let type: String
    let roomId: String?
    let sender: String
    let content: EventContent
    let originServerTs: Int64
    let eventId: String
    let stateKey: String?
    
    enum CodingKeys: String, CodingKey {
        case type
        case roomId = "room_id"
        case sender
        case content
        case originServerTs = "origin_server_ts"
        case eventId = "event_id"
        case stateKey = "state_key"
    }
}

struct EventContent: Codable {
    // For m.room.message
    let msgtype: String?
    let body: String?
    
    // For m.room.member
    let membership: String?
    let displayname: String?
    
    enum CodingKeys: String, CodingKey {
        case msgtype
        case body
        case membership
        case displayname
    }
}

// MARK: - UI Models

enum TimelineEvent: Identifiable {
    case message(MessageEvent)
    case membershipChange(MembershipEvent)
    case systemMessage(SystemEvent)
    
    var id: String {
        switch self {
        case .message(let event):
            return event.id
        case .membershipChange(let event):
            return event.id
        case .systemMessage(let event):
            return event.id
        }
    }
    
    var timestamp: Int64 {
        switch self {
        case .message(let event):
            return event.timestamp
        case .membershipChange(let event):
            return event.timestamp
        case .systemMessage(let event):
            return event.timestamp
        }
    }
}

struct MessageEvent: Identifiable {
    let id: String
    let sender: String
    let displayName: String
    let body: String
    let timestamp: Int64
    
    var formattedTime: String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp) / 1000)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

struct MembershipEvent: Identifiable {
    let id: String
    let sender: String
    let displayName: String
    let action: MembershipAction
    let timestamp: Int64
    
    enum MembershipAction {
        case joined
        case left
        case invited
    }
    
    var displayText: String {
        switch action {
        case .joined:
            return "\(displayName) joined the room"
        case .left:
            return "\(displayName) left the room"
        case .invited:
            return "\(displayName) was invited to the room"
        }
    }
}

struct SystemEvent: Identifiable {
    let id: String
    let message: String
    let timestamp: Int64
}
