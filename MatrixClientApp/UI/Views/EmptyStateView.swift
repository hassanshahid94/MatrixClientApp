//
//  EmptyStateView.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 28.11.2025.
//

import SwiftUI

struct EmptyStateView: View {
    let imageName: String
    let message: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: imageName)
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            Text(message)
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    EmptyStateView(
        imageName: "bubble.left.and.bubble.right",
        message: "no_messages_title".localized
    )
}
