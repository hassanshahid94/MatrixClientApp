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
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                // Avatar circle with first letter
                Circle()
                    .fill(Color.purple.opacity(0.7))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Text(String(message.displayName.prefix(1).uppercased()))
                            .foregroundColor(.white)
                            .font(.caption)
                            .fontWeight(.bold)
                    )
                
                Text(message.displayName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(message.formattedTime)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Text(message.body)
                .font(.body)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.leading, 40) // Align with username, not avatar
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }
}

// Membership Event View (join/leave)
struct MembershipEventView: View {
    let event: MembershipEvent
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color.purple.opacity(0.5))
                .frame(width: 20, height: 20)
                .overlay(
                    Text(String(event.displayName.prefix(1).uppercased()))
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                        .fontWeight(.bold)
                )
            
            Text(event.displayText)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 12)
    }
}

// System Message View
struct SystemMessageView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.caption)
            .foregroundColor(.secondary)
            .italic()
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 4)
    }
}
