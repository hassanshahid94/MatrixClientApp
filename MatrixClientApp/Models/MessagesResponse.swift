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
    let originServerTs: Int
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
