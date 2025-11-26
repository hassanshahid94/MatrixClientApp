//
//  JoinedRoomResponse.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 26.11.2025.
//


import Foundation

struct JoinedRoomResponse: Codable {
    let joinedRooms: [String]
    
    enum CodingKeys: String, CodingKey {
        case joinedRooms = "joined_rooms"
    }
}