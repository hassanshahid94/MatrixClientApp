//
//  MatrixRoom.swift
//  MessagingApp
//
//  Created by Hassan Shahid on 22.11.2025.
//

import Foundation

struct MatrixRoom: Identifiable, Codable {
    let roomId: String
    let name: String?
    let topic: String?
    let numJoinedMembers: Int
    
    var id: String { roomId }
    
    enum CodingKeys: String, CodingKey {
        case roomId = "room_id"
        case name
        case topic
        case numJoinedMembers = "num_joined_members"
    }
}
