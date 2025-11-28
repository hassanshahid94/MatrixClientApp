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
    
    var localizedText: String {
        switch action {
        case .joined:
            return "membership_joined".localizedWithFormat(displayName)
        case .left:
            return "membership_left".localizedWithFormat(displayName)
        case .invited:
            return "membership_invited".localizedWithFormat(displayName)
        }
    }
}
