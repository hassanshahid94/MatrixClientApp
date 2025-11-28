//
//  HomeScreen.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 22.11.2025.
//


import SwiftUI

struct HomeScreen: View {
    @ObservedObject var homeVM: HomeVM = HomeVM()
    
    var body: some View {
        VStack {
            if homeVM.isLoading && homeVM.rooms.isEmpty {
                ProgressView("loading_room_title".localized)
            } else if homeVM.rooms.isEmpty {
                VStack(spacing: 16) {
                    EmptyStateView(imageName: "tray", message: "empty_list_description".localized)
                }
            } else {
                List(homeVM.rooms) { room in
                    NavigationLink(
                        destination: RoomDetailScreen(room: room)
                    ) {
                        RoomListItemView(room: room)
                    }
                }
                .refreshable {
                    homeVM.fetchPublicRooms()
                }
            }
        }
        .onAppear {
            homeVM.fetchPublicRooms()
        }
        .navigationTitle("public_room_title".localized)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("logout_button".localized) {
                    homeVM.logout()
                }
            }
        }
        .alert("error_title".localized, isPresented: .constant(homeVM.errorMessage != nil)) {
            Button("ok_button".localized) {
                homeVM.errorMessage = nil
            }
        } message: {
            if let error = homeVM.errorMessage {
                Text(error)
            }
        }
    }
}

#Preview {
    HomeScreen(
        homeVM: HomeVM(
            roomManager: DesignRoomManager(),
            sessionManager: DesignSessionManager()
        )
    )
}
