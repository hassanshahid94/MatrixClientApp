//
//  DesignMessageManager.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 28.11.2025.
//

import Foundation

class DesignMessageManager: MessageManager {
    func fetchMessages(roomId: String) async throws -> [TimelineEvent] {
        return PreviewData.sampleTimelineEvents
    }
}
