//
//  RoomDetailScreen.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 22.11.2025.
//


import SwiftUI

struct RoomDetailScreen: View {
    @ObservedObject var viewModel: MatrixVM
    let room: PublicRoom
    @State private var hasJoined = false
    
    var body: some View {
        VStack {
            if viewModel.isLoading && viewModel.timelineEvents.isEmpty {
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
            } else if viewModel.timelineEvents.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "bubble.left.and.bubble.right")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                    Text("No messages yet")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
            } else {
                // Display the timeline
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.timelineEvents.reversed()) { event in
                            TimelineEventView(event: event)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(room.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            // Automatically join and fetch messages when view appears
            await viewModel.joinRoom(roomId: room.roomId)
            hasJoined = true
            await viewModel.fetchMessages(roomId: room.roomId)
        }
    }
}
