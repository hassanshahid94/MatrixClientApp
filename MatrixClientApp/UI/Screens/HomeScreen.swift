//
//  HomeScreen.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 22.11.2025.
//


import SwiftUI

struct HomeScreen: View {
    @ObservedObject var viewModel: MatrixVM
    
    var body: some View {
        VStack {
            if viewModel.isLoading && viewModel.rooms.isEmpty {
                ProgressView("Loading rooms...")
            } else if viewModel.rooms.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "tray")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                    Text("No public rooms available")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
            } else {
                List(viewModel.rooms) { room in
                    NavigationLink(destination: RoomDetailScreen(viewModel: viewModel, room: room)) {
                        RoomRowView(room: room)
                    }
                }
                .refreshable {
                    await viewModel.fetchPublicRooms()
                }
            }
        }
        .navigationTitle("Public Rooms")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Logout") {
                    viewModel.logout()
                }
            }
        }
        .task {
            await viewModel.fetchPublicRooms()
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            if let error = viewModel.errorMessage {
                Text(error)
            }
        }
    }
}
