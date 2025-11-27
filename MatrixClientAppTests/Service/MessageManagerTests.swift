//
//  MessageManagerTests.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 27.11.2025.
//

import XCTest

final class MessageManagerTests: XCTestCase {

    // MARK: - Variables
    private var messageManager: MessageManager!
    private var mockWebService: MockWebService!
    
    private let roomId = "!room123:matrix.org"
    
    private lazy var testTimelineEvents: [TimelineEvent] = {
        let messageEvent = MessageEvent(
            id: "evt1",
            sender: "@alice:matrix.org",
            displayName: "Alice",
            body: "Hello world",
            timestamp: 1700000000000
        )
        
        let membershipEvent = MembershipEvent(
            id: "evt2",
            sender: "@bob:matrix.org",
            displayName: "Bob",
            action: .joined,
            timestamp: 1700000100000
        )
        
        return [
            .message(messageEvent),
            .membershipChange(membershipEvent)
        ]
    }()
    
    private lazy var testMessagesResponse: MessagesResponse = {
        let roomEvents: [RoomEvent] = [
            RoomEvent(
                type: "m.room.message",
                roomId: roomId,
                sender: "@alice:matrix.org",
                content: EventContent(msgtype: "m.text", body: "Hello world", membership: nil, displayname: "Alice"),
                originServerTs: 1700000000000,
                eventId: "evt1",
                stateKey: nil
            ),
            RoomEvent(
                type: "m.room.member",
                roomId: roomId,
                sender: "@bob:matrix.org",
                content: EventContent(msgtype: nil, body: nil, membership: "join", displayname: "Bob"),
                originServerTs: 1700000100000,
                eventId: "evt2",
                stateKey: nil
            )
        ]
        return MessagesResponse(chunk: roomEvents, start: nil, end: nil)
    }()
    
    override func setUp() {
        mockWebService = MockWebService()
        messageManager = MessageManagerImp(webService: mockWebService)
    }
    
    override func tearDown() {
        mockWebService = nil
        messageManager = nil
    }
    
    // MARK: - Tests
    func testFetchMessagesSuccess() async throws {
        let responseData = try JSONEncoder().encode(testMessagesResponse)
        mockWebService.mockResponse = .success(responseData)
        
        let events = try await messageManager.fetchMessages(roomId: roomId)
        
        XCTAssertEqual(events.count, testTimelineEvents.count)
        
        if case let .message(msg) = events[0] {
            XCTAssertEqual(msg.id, "evt1")
            XCTAssertEqual(msg.sender, "@alice:matrix.org")
            XCTAssertEqual(msg.body, "Hello world")
        } else {
            XCTFail("Expected first event to be message")
        }
        
        if case let .membershipChange(mem) = events[1] {
            XCTAssertEqual(mem.id, "evt2")
            XCTAssertEqual(mem.displayName, "Bob")
            XCTAssertEqual(mem.action, .joined)
        } else {
            XCTFail("Expected second event to be membership change")
        }
    }
    
    func testFetchMessagesFailure() async {
        mockWebService.mockResponse = .failure(URLError(.cannotLoadFromNetwork))
        
        do {
            _ = try await messageManager.fetchMessages(roomId: roomId)
            XCTFail("Expected failure but got success")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
}
