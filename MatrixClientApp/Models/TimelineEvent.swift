//
//  TimelineEvent.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 27.11.2025.
//

import Foundation

enum TimelineEvent: Identifiable {
    case message(MessageEvent)
    case membershipChange(MembershipEvent)
    
    var id: String {
        switch self {
        case .message(let event):
            return event.id
        case .membershipChange(let event):
            return event.id
        }
    }
    
    var timestamp: Int {
        switch self {
        case .message(let event):
            return event.timestamp
        case .membershipChange(let event):
            return event.timestamp
        }
    }
}

struct MessageEvent: Identifiable {
    let id: String
    let sender: String
    let displayName: String
    let body: String
    let timestamp: Int
    var date: Date { Date(timeIntervalSince1970: TimeInterval(timestamp) / 1000) }
}

struct MembershipEvent: Identifiable {
    let id: String
    let sender: String
    let displayName: String
    let action: MembershipAction
    let timestamp: Int
    var date: Date { Date(timeIntervalSince1970: TimeInterval(timestamp) / 1000) }
    
    
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
