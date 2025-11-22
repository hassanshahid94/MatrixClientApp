//
//  RoomDetailScreen.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 22.11.2025.
//


import SwiftUI

struct RoomDetailScreen: View {
    @ObservedObject var viewModel: MatrixVM
    let room: MatrixRoom
    @State private var hasJoined = false
    
    var body: some View {
        VStack {
            if viewModel.isLoading && viewModel.messages.isEmpty {
                ProgressView("Loading messages...")
            } else if !hasJoined {
                VStack(spacing: 16) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                    Text("Join room to view messages")
                        .font(.headline)
                    Button("Join Room") {
                        Task {
                            await viewModel.joinRoom(roomId: room.roomId)
                            hasJoined = true
                            await viewModel.fetchMessages(roomId: room.roomId)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else if viewModel.messages.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "bubble.left.and.bubble.right")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                    Text("No messages yet")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.messages.reversed()) { message in
                            MessageView(message: message)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(room.name ?? "Room")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.joinRoom(roomId: room.roomId)
            hasJoined = true
            await viewModel.fetchMessages(roomId: room.roomId)
        }
    }
}

