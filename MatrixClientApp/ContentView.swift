//
//  ContentView.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 22.11.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MatrixVM(
            authenticationManager: AuthenticationManagerImp(),
            roomManager: RoomManagerImp(), messageManager:
                MessageManagerImp())
    
    var body: some View {
        NavigationView {
            if viewModel.isAuthenticated {
                HomeScreen(viewModel: viewModel)
            } else {
                LoginScreen(viewModel: viewModel)
            }
        }
    }
}
