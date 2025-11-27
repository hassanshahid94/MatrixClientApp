//
//  PublicRoomResponse.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 24.11.2025.
//


import Foundation

struct PublicRoomResponse: Codable {
    let chunk: [PublicRoom]
    let totalRoomCountEstimate: Int

    enum CodingKeys: String, CodingKey {
        case chunk
        case totalRoomCountEstimate = "total_room_count_estimate"
    }
}

struct PublicRoom: Identifiable, Codable, Equatable {
    let roomId: String
    let name: String
    let canonicalAlias: String
    let numJoinedMembers: Int
    let worldReadable: Bool
    let guestCanJoin: Bool
    let joinRule: String

    var id: String { roomId }
    
    enum CodingKeys: String, CodingKey {
        case roomId = "room_id"
        case name
        case canonicalAlias = "canonical_alias"
        case numJoinedMembers = "num_joined_members"
        case worldReadable = "world_readable"
        case guestCanJoin = "guest_can_join"
        case joinRule = "join_rule"
    }
}
