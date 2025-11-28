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
extension TimelineEvent {
    var date: Date {
        switch self {
        case .message(let msg): return msg.date
        case .membershipChange(let mem): return mem.date
        }
    }
}

extension Array where Element == TimelineEvent {
    func groupedByDay() -> [(title: String, events: [TimelineEvent])] {
        let grouped = Dictionary(grouping: self) { $0.date.dayTitle }

        let sortedKeys = grouped.keys.sorted { key1, key2 in
            guard let date1 = grouped[key1]?.first?.date,
                  let date2 = grouped[key2]?.first?.date else { return false }
            return date1 > date2
        }
        
        return sortedKeys.map { (title: $0, events: grouped[$0] ?? []) }
    }
}
