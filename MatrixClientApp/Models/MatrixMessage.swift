//
//  MatrixMessage.swift
//  MessagingApp
//
//  Created by Hassan Shahid on 21.11.2025.
//

import Foundation

struct MatrixMessage: Identifiable, Codable {
    let eventId: String
    let sender: String
    let body: String
    let timestamp: Int64
    
    var id: String { eventId }
    
    var formattedTimestamp: String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp) / 1000)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
