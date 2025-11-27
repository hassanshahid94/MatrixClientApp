//
//  MessageBubbleView.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 25.11.2025.
//

import SwiftUI

struct MessageBubbleView: View {
    let message: MessageEvent
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            // Avatar circle
            Circle()
                .fill(Color.purple.opacity(0.7))
                .frame(width: 32, height: 32)
                .overlay(
                    Text(String(message.displayName.prefix(1).uppercased()))
                        .foregroundColor(.white)
                        .font(.caption)
                        .fontWeight(.bold)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                // Sender name
                Text(message.displayName)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                
                // Message bubble
                Text(message.body)
                    .padding(12)
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.primary)
                    .cornerRadius(16)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Timestamp
                Text(message.date.messageTime)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}
