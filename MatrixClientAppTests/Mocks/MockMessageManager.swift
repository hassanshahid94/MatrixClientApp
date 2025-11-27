//
//  MockMessageManager.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 27.11.2025.
//

import Foundation

final class MockMessageManager: MessageManager {
    
    var shouldSucceed = true
    var timelineEventsToReturn: [TimelineEvent] = []
    var thrownError: Error = URLError(.badServerResponse)
    
    var fetchMessagesCalledWith: String?
    
    func fetchMessages(roomId: String) async throws -> [TimelineEvent] {
        fetchMessagesCalledWith = roomId
        if shouldSucceed {
            return timelineEventsToReturn
        } else {
            throw thrownError
        }
    }
}
