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
    
    private let fullTestRoomEvents: [RoomEvent] = [
        RoomEvent( // valid message
            type: "m.room.message",
            roomId: "!123:matrix.org",
            sender: "@alice:matrix.org",
            content: EventContent(msgtype: "m.text", body: "Hello world", membership: nil, displayname: "Alice"),
            originServerTs: 1700000000000,
            eventId: "evt1",
            stateKey: nil
                 ),
        RoomEvent( // valid membership join
            type: "m.room.member",
            roomId: "!123:matrix.org",
            sender: "@bob:matrix.org",
            content: EventContent(msgtype: nil, body: nil, membership: "join", displayname: "Bob"),
            originServerTs: 1700000100000,
            eventId: "evt2",
            stateKey: nil
                 ),
        RoomEvent( // unknown type
            type: "m.unknown",
            roomId: "!room123:matrix.org",
            sender: "@user:matrix.org",
            content: EventContent(msgtype: nil, body: nil, membership: nil, displayname: nil),
            originServerTs: 123,
            eventId: "evtX",
            stateKey: nil
                 ),
        RoomEvent( // message with nil body
            type: "m.room.message",
            roomId: "!room123:matrix.org",
            sender: "@alice:matrix.org",
            content: EventContent(msgtype: "m.text", body: nil, membership: nil, displayname: nil),
            originServerTs: 0,
            eventId: "evtNoBody",
            stateKey: nil
                 ),
        RoomEvent( // membership nil
            type: "m.room.member",
            roomId: "!room123:matrix.org",
            sender: "@bob:matrix.org",
            content: EventContent(msgtype: nil, body: nil, membership: nil, displayname: nil),
            originServerTs: 0,
            eventId: "evtNoMembership",
            stateKey: nil
                 ),
        RoomEvent( // membership leave
            type: "m.room.member",
            roomId: "!room123:matrix.org",
            sender: "@bob:matrix.org",
            content: EventContent(msgtype: nil, body: nil, membership: "leave", displayname: "Bob"),
            originServerTs: 111,
            eventId: "evtLeave",
            stateKey: nil
                 ),
        RoomEvent( // membership invite
            type: "m.room.member",
            roomId: "!room123:matrix.org",
            sender: "@carol:matrix.org",
            content: EventContent(msgtype: nil, body: nil, membership: "invite", displayname: "Carol"),
            originServerTs: 222,
            eventId: "evtInvite",
            stateKey: nil
                 ),
        RoomEvent( // unknown membership
            type: "m.room.member",
            roomId: "!room123:matrix.org",
            sender: "@dave:matrix.org",
            content: EventContent(msgtype: nil, body: nil, membership: "unknownValue", displayname: nil),
            originServerTs: 333,
            eventId: "evtUnknown",
            stateKey: nil
                 ),
        RoomEvent( // message missing displayName
            type: "m.room.message",
            roomId: "!room123:matrix.org",
            sender: "@charlie:matrix.org",
            content: EventContent(msgtype: "m.text", body: "hello", membership: nil, displayname: nil),
            originServerTs: 444,
            eventId: "evtDisplay",
            stateKey: nil
                 ),
        RoomEvent( // message invalid userId
            type: "m.room.message",
            roomId: "!room123:matrix.org",
            sender: "invalidUserId",
            content: EventContent(msgtype: "m.text", body: "hi", membership: nil, displayname: nil),
            originServerTs: 0,
            eventId: "evtFallback",
            stateKey: nil
                 )
    ]
    
    private lazy var testMessagesResponse = MessagesResponse(
        chunk: fullTestRoomEvents,
        start: nil,
        end: nil
    )
    
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
        
        XCTAssertEqual(events.count, 6)
        
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
    
    func testUnknownEventTypeIsIgnored() async throws {
        let response = MessagesResponse(chunk: [fullTestRoomEvents[2]], start: nil, end: nil)
        mockWebService.mockResponse = .success(try JSONEncoder().encode(response))
        
        let events = try await messageManager.fetchMessages(roomId: roomId)
        
        XCTAssertTrue(events.isEmpty)
    }
    
    func testParseMessageEventBodyNilIsIgnored() async throws {
        let response = MessagesResponse(chunk: [fullTestRoomEvents[3]], start: nil, end: nil)
        mockWebService.mockResponse = .success(try JSONEncoder().encode(response))
        
        let events = try await messageManager.fetchMessages(roomId: roomId)
        
        XCTAssertTrue(events.isEmpty)
    }
    
    func testParseMembershipEventNilMembershipIsIgnored() async throws {
        let response = MessagesResponse(chunk: [fullTestRoomEvents[4]], start: nil, end: nil)
        mockWebService.mockResponse = .success(try JSONEncoder().encode(response))
        
        let events = try await messageManager.fetchMessages(roomId: roomId)
        
        XCTAssertTrue(events.isEmpty)
    }
    
    func testParseMembershipEventLeave() async throws {
        let response = MessagesResponse(chunk: [fullTestRoomEvents[5]], start: nil, end: nil)
        mockWebService.mockResponse = .success(try JSONEncoder().encode(response))
        
        let events = try await messageManager.fetchMessages(roomId: roomId)
        
        guard case let .membershipChange(mem) = events.first else { return XCTFail("Expected leave membership event") }
        XCTAssertEqual(mem.action, .left)
    }
    
    func testParseMembershipEventInvite() async throws {
        let response = MessagesResponse(chunk: [fullTestRoomEvents[6]], start: nil, end: nil)
        mockWebService.mockResponse = .success(try JSONEncoder().encode(response))
        
        let events = try await messageManager.fetchMessages(roomId: roomId)
        
        guard case let .membershipChange(mem) = events.first else { return XCTFail("Expected invite membership event") }
        XCTAssertEqual(mem.action, .invited)
    }
    
    func testParseMembershipEventUnknownMembershipIsIgnored() async throws {
        let response = MessagesResponse(chunk: [fullTestRoomEvents[7]], start: nil, end: nil)
        mockWebService.mockResponse = .success(try JSONEncoder().encode(response))
        
        let events = try await messageManager.fetchMessages(roomId: roomId)
        
        XCTAssertTrue(events.isEmpty)
    }
    
    func testExtractDisplayNameFallback() async throws {
        let response = MessagesResponse(chunk: [fullTestRoomEvents[8]], start: nil, end: nil)
        mockWebService.mockResponse = .success(try JSONEncoder().encode(response))
        
        let events = try await messageManager.fetchMessages(roomId: roomId)
        
        guard case let .message(msg) = events.first else { return XCTFail("Expected message event") }
        XCTAssertEqual(msg.displayName, "charlie")
    }
    
    func testFallbackDisplayNameInvalidUserId() async throws {
        let response = MessagesResponse(chunk: [fullTestRoomEvents[9]], start: nil, end: nil)
        mockWebService.mockResponse = .success(try JSONEncoder().encode(response))
        
        let events = try await messageManager.fetchMessages(roomId: roomId)
        
        guard case let .message(msg) = events.first else { return XCTFail("Expected message event") }
        XCTAssertEqual(msg.displayName, "invalidUserId")
    }
}
