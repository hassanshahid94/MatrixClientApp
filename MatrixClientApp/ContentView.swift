//
//  ContentView.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 22.11.2025.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var loginVM = LoginVM()

    var body: some View {
        NavigationView {
            if loginVM.isAuthenticated {
                HomeScreen()
            } else {
                LoginScreen(loginVM: loginVM)
            }
        }
    }
}
