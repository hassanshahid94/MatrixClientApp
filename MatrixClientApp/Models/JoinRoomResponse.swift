//
//  JoinRoomResponse.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 24.11.2025.
//


struct JoinRoomResponse: Codable {
    let roomId: String

    enum CodingKeys: String, CodingKey {
        case roomId = "room_id"
    }
}