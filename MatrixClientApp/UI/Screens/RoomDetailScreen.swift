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
                ProgressView(roomDetailVM.hasJoinedRoom ? "loading_messages_title".localized : "loading_checking_room_title".localized)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
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

#Preview {
    RoomDetailScreen(
        roomDetailVM: RoomDetailVM(
            roomManager: DesignRoomManager(),
            messageManager: DesignMessageManager()
        ),
        room: PreviewData.sampleRooms.first!
    )
}
