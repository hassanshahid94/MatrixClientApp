//
//  RoomDetailScreen.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 22.11.2025.
//


import SwiftUI

struct RoomDetailScreen: View {
    @StateObject var roomDetailVM = RoomDetailVM()
    let room: PublicRoom
    
    var body: some View {
        ZStack {
            if roomDetailVM.isLoading {
                LoadingView(message: roomDetailVM.hasJoinedRoom ? "loading_messages_title".localized : "loading_checking_room_title".localized)
            }
            else if !roomDetailVM.hasJoinedRoom {
                JoinRoomView {
                    roomDetailVM.joinRoom(roomId: room.roomId)
                }
            }
            else if roomDetailVM.timelineEvents.isEmpty {
                EmptyStateView(
                    imageName: "bubble.left.and.bubble.right",
                    message: "no_messages_title".localized
                )
            }
            else {
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
        .onAppear {
            roomDetailVM.loadRoom(roomId: room.roomId)
        }
        .alert("error_title".localized, isPresented: .constant(roomDetailVM.errorMessage != nil)) {
            Button("ok_button".localized) { roomDetailVM.errorMessage = nil }
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
            Text("join_room_title".localized)
                .font(.headline)
            Button("join_room_button".localized, action: joinAction)
                .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    RoomDetailScreen(
        roomDetailVM: RoomDetailVM(
            roomManager: DesignRoomManager(),
            messageManager: DesignMessageManager()
        ),
        room: PreviewData.sampleRooms.first!
    )
}
