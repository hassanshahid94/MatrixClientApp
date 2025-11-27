//
//  ContentView.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 22.11.2025.
//

import SwiftUI

struct RouteView: View {
    @StateObject private var sessionManager = SessionManagerImp.shared

    var body: some View {
        NavigationView {
            if sessionManager.accessToken != nil {
                HomeScreen()
            } else {
                LoginScreen()
            }
        }
    }
}
