//
//  JoinRoomView.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 28.11.2025.
//

import SwiftUI

struct JoinRoomView: View {
    
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

#Preview(traits: .sizeThatFitsLayout) {
    JoinRoomView(joinAction: {})
}
