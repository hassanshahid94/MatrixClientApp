//
//  ContentView.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 22.11.2025.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var session = SessionManagerImp.shared

    var body: some View {
        NavigationView {
            if session.accessToken != nil {
                HomeScreen()
            } else {
                LoginScreen()
            }
        }
    }
}
