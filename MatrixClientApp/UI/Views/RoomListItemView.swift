//
//  RoomRowView.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 22.11.2025.
//


import SwiftUI

struct RoomListItemView: View {
    let room: PublicRoom
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(room.name)
                .font(.headline)
            HStack {
                Image(systemName: "person.2.fill")
                    .font(.caption)
                Text("members_count".localizedWithFormat(room.numJoinedMembers))
                    .font(.caption)
            }
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    let sampleRoom = PublicRoom(
        roomId: "1",
        name: "SwiftUI Lounge",
        canonicalAlias: "#swiftui:matrix.org",
        numJoinedMembers: 42,
        worldReadable: true,
        guestCanJoin: true,
        joinRule: "public"
    )

    RoomListItemView(room: sampleRoom)
}
