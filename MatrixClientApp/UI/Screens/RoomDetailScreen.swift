//
//  RoomDetailScreen.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 22.11.2025.
//


import SwiftUI

struct RoomDetailScreen: View {
    @StateObject var roomDetailVM: RoomDetailVM = RoomDetailVM()
    let room: PublicRoom
    
    var body: some View {
        ZStack {
            if (roomDetailVM.isLoading && roomDetailVM.hasJoinedRoom) {
                LoadingView(message: roomDetailVM.hasJoinedRoom ? "Loading messages..." : "Joining room...")
            } else if !roomDetailVM.hasJoinedRoom {
                // Show join button if user has not joined yet
                JoinRoomView {
                    roomDetailVM.joinRoom(roomId: room.roomId)
                }
            } else if roomDetailVM.timelineEvents.isEmpty {
                // Empty messages state
                EmptyStateView(
                    imageName: "bubble.left.and.bubble.right",
                    message: "No messages yet"
                )
            } else {
                // Show messages timeline
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(roomDetailVM.timelineEvents.reversed()) { event in
                            TimelineEventView(event: event)
                        }
                    }
                    .padding()
                }
            }
        }
        
        .navigationTitle(room.name)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error", isPresented: .constant(roomDetailVM.errorMessage != nil)) {
            Button("OK") { roomDetailVM.errorMessage = nil }
        } message: {
            if let error = roomDetailVM.errorMessage {
                Text(error)
            }
        }
    }
}

// MARK: - Subviews

private struct LoadingView: View {
    let message: String
    var body: some View {
        ProgressView(message)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct EmptyStateView: View {
    let imageName: String
    let message: String
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: imageName)
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            Text(message)
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct JoinRoomView: View {
    let joinAction: () -> Void
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "lock.fill")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            Text("Join room to view messages")
                .font(.headline)
            Button("Join Room", action: joinAction)
                .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


//import SwiftUI
//
//struct RoomDetailScreen: View {
//    @ObservedObject var roomDetailVM: RoomDetailVM = RoomDetailVM()
//    let room: PublicRoom
//    @State private var hasJoined = false
//
//    var body: some View {
//        VStack {
//            if roomDetailVM.isLoading && roomDetailVM.timelineEvents.isEmpty {
//                ProgressView("Loading messages...")
//            } else if !hasJoined {
//                VStack(spacing: 16) {
//                    Image(systemName: "lock.fill")
//                        .font(.system(size: 60))
//                        .foregroundColor(.secondary)
//                    Text("Join room to view messages")
//                        .font(.headline)
//                    Button("Join Room") {
//                        Task {
//                            await roomDetailVM.joinRoom(roomId: room.roomId)
//                            hasJoined = true
//                            await roomDetailVM.fetchMessages(roomId: room.roomId)
//                        }
//                    }
//                    .buttonStyle(.borderedProminent)
//                }
//            } else if roomDetailVM.timelineEvents.isEmpty {
//                VStack(spacing: 16) {
//                    Image(systemName: "bubble.left.and.bubble.right")
//                        .font(.system(size: 60))
//                        .foregroundColor(.secondary)
//                    Text("No messages yet")
//                        .font(.headline)
//                        .foregroundColor(.secondary)
//                }
//            } else {
//                // Display the timeline
//                ScrollView {
//                    LazyVStack(spacing: 8) {
//                        ForEach(roomDetailVM.timelineEvents.reversed()) { event in
//                            TimelineEventView(event: event)
//                        }
//                    }
//                    .padding()
//                }
//            }
//        }
//        .navigationTitle(room.name)
//        .navigationBarTitleDisplayMode(.inline)
//        .task {
//            // Automatically join and fetch messages when view appears
//            await roomDetailVM.joinRoom(roomId: room.roomId)
//            hasJoined = true
//            await roomDetailVM.fetchMessages(roomId: room.roomId)
//        }
//    }
//}
