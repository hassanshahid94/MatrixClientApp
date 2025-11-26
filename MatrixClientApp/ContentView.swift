//
//  ContentView.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 22.11.2025.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var loginVM = LoginVM(
        authenticationManager: AuthenticationManagerImp()
    )
    @State private var homeVM: HomeVM?

    var body: some View {
        NavigationView {
            if loginVM.isAuthenticated {
                HomeScreen(
                    homeVM: HomeVM(
                        roomManager: RoomManagerImp()
                    )
                )
            } else {
                LoginScreen(loginVM: loginVM)
            }
        }
    }
}
