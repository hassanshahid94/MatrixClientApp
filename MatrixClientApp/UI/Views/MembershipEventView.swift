//
//  MembershipEventView.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 27.11.2025.
//

import SwiftUI

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
            
            Text(event.date.messageTime)
                .font(.caption2)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 12)
    }
}

#Preview {
    VStack(spacing: 12) {
        MembershipEventView(event: PreviewData.sampleJoinedEvent)
        MembershipEventView(event: PreviewData.sampleLeftEvent)
        MembershipEventView(event: PreviewData.sampleInvitedEvent)
    }
    .padding()
}
