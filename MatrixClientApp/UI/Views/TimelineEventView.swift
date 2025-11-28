//
//  TimelineEventView.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 25.11.2025.
//

import SwiftUI

struct TimelineEventView: View {
    let event: TimelineEvent
    
    var body: some View {
        switch event {
        case .message(let message):
            MessageBubbleView(message: message)
            
        case .membershipChange(let membership):
            MembershipEventView(event: membership)
            
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        ForEach(PreviewData.sampleTimelineEvents) { event in
            TimelineEventView(event: event)
        }
    }
}
