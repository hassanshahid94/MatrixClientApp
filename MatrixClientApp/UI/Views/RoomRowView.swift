//
//  RoomRowView.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 22.11.2025.
//


import SwiftUI

struct RoomRowView: View {
    let room: MatrixRoom
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(room.name ?? room.roomId)
                .font(.headline)
            
            if let topic = room.topic, !topic.isEmpty {
                Text(topic)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            HStack {
                Image(systemName: "person.2.fill")
                    .font(.caption)
                Text("\(room.numJoinedMembers) members")
                    .font(.caption)
            }
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}