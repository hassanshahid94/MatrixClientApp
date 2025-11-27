//
//  RoomDetailVMTests.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 27.11.2025.
//

import XCTest
import Combine

@MainActor
final class RoomDetailVMTests: XCTestCase {
    
    private var mockRoomManager: MockRoomManager!
    private var mockMessageManager: MockMessageManager!
    private var roomDetailVM: RoomDetailVM!
    private var cancellables: Set<AnyCancellable> = []
    
    private let testMessage = TimelineEvent.message(
        MessageEvent(
            id: "msg1",
            sender: "@alice:matrix.org",
            displayName: "Alice",
            body: "Hello",
            timestamp: Int(Date().timeIntervalSince1970 * 1000)
        )
    )
    private let testRoomId = "!room123:matrix.org"
    
    override func setUp() {
        mockRoomManager = MockRoomManager()
        mockMessageManager = MockMessageManager()
        roomDetailVM = RoomDetailVM(
            roomManager: mockRoomManager,
            messageManager: mockMessageManager
        )
    }
    
    override func tearDown() {
        mockRoomManager = nil
        mockMessageManager = nil
        roomDetailVM = nil
    }
    
    func testLoadRoomUserAlreadyJoinedFetchesMessages() async {
        mockRoomManager.shouldSucceed = true
        mockRoomManager.joinedRooms = [testRoomId]
        
        
        mockMessageManager.timelineEventsToReturn = [testMessage]
        
        let expectation = expectation(description: "testLoadRoomUserAlreadyJoinedFetchesMessages")
        
        roomDetailVM.$isLoading
            .dropFirst()
            .sink { isLoading in
                if !isLoading {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        roomDetailVM.loadRoom(roomId: testRoomId)
        
        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertTrue(roomDetailVM.hasJoinedRoom)
        XCTAssertEqual(roomDetailVM.timelineEvents.count, 1)
        XCTAssertNil(roomDetailVM.errorMessage)
        XCTAssertFalse(roomDetailVM.isLoading)
        XCTAssertEqual(mockMessageManager.fetchMessagesCalledWith, testRoomId)
        XCTAssertTrue(mockRoomManager.fetchJoinedRoomsCalled)
    }
    
    func testLoadRoomUserNotJoinedDoesNotFetchMessages() async {
        mockRoomManager.shouldSucceed = true
        mockRoomManager.joinedRooms = []
        
        let expectation = expectation(description: "testLoadRoomUserNotJoinedDoesNotFetchMessages")
        
        roomDetailVM.$isLoading
            .dropFirst()
            .sink { isLoading in
                if !isLoading {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        roomDetailVM.loadRoom(roomId: testRoomId)
        
        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertFalse(roomDetailVM.hasJoinedRoom)
        XCTAssertEqual(roomDetailVM.timelineEvents.count, 0)
        XCTAssertNil(roomDetailVM.errorMessage)
        XCTAssertFalse(roomDetailVM.isLoading)
        XCTAssertNil(mockMessageManager.fetchMessagesCalledWith)
        XCTAssertTrue(mockRoomManager.fetchJoinedRoomsCalled)
    }
    
    func testJoinRoomSuccess() async {
        mockRoomManager.shouldSucceed = true
        mockMessageManager.timelineEventsToReturn = [testMessage]
        
        let expectation = expectation(description: "testJoinRoomSuccess")
        
        roomDetailVM.$isLoading
            .dropFirst()
            .sink { isLoading in
                if !isLoading {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        roomDetailVM.joinRoom(roomId: testRoomId)
        
        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertTrue(roomDetailVM.hasJoinedRoom)
        XCTAssertEqual(roomDetailVM.timelineEvents.count, 1)
        XCTAssertNil(roomDetailVM.errorMessage)
        XCTAssertFalse(roomDetailVM.isLoading)
        XCTAssertEqual(mockRoomManager.joinRoomCalledWith, testRoomId)
        XCTAssertEqual(mockMessageManager.fetchMessagesCalledWith, testRoomId)
    }
    
    func testJoinRoomFailure() async {
        mockRoomManager.shouldSucceed = false
        mockRoomManager.thrownError = URLError(.unknown)
        
        let expectation = expectation(description: "testJoinRoomFailure")
        
        roomDetailVM.$isLoading
            .dropFirst()
            .sink { isLoading in
                if !isLoading {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        roomDetailVM.joinRoom(roomId: testRoomId)
        
        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertFalse(roomDetailVM.hasJoinedRoom)
        XCTAssertEqual(roomDetailVM.timelineEvents.count, 0)
        XCTAssertNotNil(roomDetailVM.errorMessage)
        XCTAssertFalse(roomDetailVM.isLoading)
    }
    
    func testLoadRoomAndFetchJoinedRoomsFailure() async {
        mockRoomManager.shouldSucceed = false
        mockRoomManager.thrownError = URLError(.timedOut)

        let expectation = expectation(description: "testLoadRoomAndFetchJoinedRoomsFailure")

        roomDetailVM.$isLoading
            .dropFirst()
            .sink { isLoading in
                if !isLoading {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        roomDetailVM.loadRoom(roomId: testRoomId)

        await fulfillment(of: [expectation], timeout: 1.0)

        XCTAssertNotNil(roomDetailVM.errorMessage)
        XCTAssertFalse(roomDetailVM.hasJoinedRoom)
        XCTAssertEqual(roomDetailVM.timelineEvents.count, 0)
        XCTAssertTrue(mockRoomManager.fetchJoinedRoomsCalled)
    }
    
    func testFetchMessagesFailure() async {
        mockRoomManager.shouldSucceed = true
        mockRoomManager.joinedRooms = [testRoomId]
        
        mockMessageManager.shouldSucceed = false
        mockMessageManager.thrownError = URLError(.unknown)
        
        let expectation = expectation(description: "testFetchMessagesFailure")
        
        roomDetailVM.$isLoading
            .dropFirst()
            .sink { isLoading in
                if !isLoading {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        roomDetailVM.loadRoom(roomId: testRoomId)
        
        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertTrue(roomDetailVM.hasJoinedRoom)
        XCTAssertNotNil(roomDetailVM.errorMessage)
        XCTAssertEqual(roomDetailVM.timelineEvents.count, 0)
        XCTAssertEqual(mockMessageManager.fetchMessagesCalledWith, testRoomId)
    }
}
