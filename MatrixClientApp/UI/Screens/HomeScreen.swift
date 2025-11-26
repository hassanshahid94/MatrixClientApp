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
                ProgressView("Loading rooms...")
            } else if homeVM.rooms.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "tray")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                    Text("No public rooms available")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
            } else {
                List(homeVM.rooms) { room in
                    NavigationLink(
                        destination: RoomDetailScreen(room: room)
                    ) {
                        RoomRowView(room: room)
                    }
                }
                .refreshable {
                    await homeVM.fetchPublicRooms()
                }
            }
        }
        .navigationTitle("Public Rooms")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Logout") {
                   // homeVM.logout()
                }
            }
        }
        .alert("Error", isPresented: .constant(homeVM.errorMessage != nil)) {
            Button("OK") {
                homeVM.errorMessage = nil
            }
        } message: {
            if let error = homeVM.errorMessage {
                Text(error)
            }
        }
    }
}
