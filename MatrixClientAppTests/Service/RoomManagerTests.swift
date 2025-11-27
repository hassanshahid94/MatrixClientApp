//
//  RoomManagerTests.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 27.11.2025.
//


import XCTest

final class RoomManagerTests: XCTestCase {
    
    // MARK: - Variables
    private var roomManager: RoomManager!
    private var mockWebService: MockWebService!
    
    private let testPublicRooms: [PublicRoom] = [
        PublicRoom(
            roomId: "!room1:matrix.org",
            name: "General",
            canonicalAlias: "#general:matrix.org",
            numJoinedMembers: 42,
            worldReadable: true,
            guestCanJoin: true,
            joinRule: "public"
        ),
        PublicRoom(
            roomId: "!room2:matrix.org",
            name: "Random",
            canonicalAlias: "#random:matrix.org",
            numJoinedMembers: 10,
            worldReadable: true,
            guestCanJoin: true,
            joinRule: "public"
        )
    ]
    
    private let testJoinedRooms: [String] = ["!room1:matrix.org", "!room2:matrix.org"]
    
    override func setUp() {
        mockWebService = MockWebService()
        roomManager = RoomManagerImp(webService: mockWebService)
    }
    
    override func tearDown() {
        mockWebService = nil
        roomManager = nil
    }
    
    // MARK: - Tests
    func testFetchPublicRoomsSuccess() async throws {
        let responseData = try JSONEncoder().encode(
            PublicRoomResponse(chunk: testPublicRooms, totalRoomCountEstimate: 2)
        )
        mockWebService.mockResponse = .success(responseData)
        
        let rooms = try await roomManager.fetchPublicRooms()
        
        XCTAssertEqual(rooms.count, testPublicRooms.count)
        XCTAssertEqual(rooms.first?.roomId, testPublicRooms.first?.roomId)
        XCTAssertEqual(rooms.last?.name, testPublicRooms.last?.name)
    }
    
    func testFetchPublicRoomsFailure() async {
        mockWebService.mockResponse = .failure(URLError(.unknown))
        
        do {
            _ = try await roomManager.fetchPublicRooms()
            XCTFail("Expected failure but got success")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
    
    func testJoinRoomSuccess() async throws {
        let joinResponse = JoinRoomResponse(roomId: testJoinedRooms.first!)
        let responseData = try JSONEncoder().encode(joinResponse)
        mockWebService.mockResponse = .success(responseData)
        
        do {
            try await roomManager.joinRoom(roomId: testJoinedRooms.first!)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    func testJoinRoomFailure() async {
        mockWebService.mockResponse = .failure(URLError(.unknown))
        
        do {
            try await roomManager.joinRoom(roomId: testJoinedRooms.first!)
            XCTFail("Expected failure but got success")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
    
    func testFetchJoinedRoomsSuccess() async throws {
        let response = JoinedRoomResponse(joinedRooms: testJoinedRooms)
        let responseData = try JSONEncoder().encode(response)
        mockWebService.mockResponse = .success(responseData)
        
        let joinedRooms = try await roomManager.fetchJoinedRooms()
        
        XCTAssertEqual(joinedRooms, testJoinedRooms)
    }
    
    func testFetchJoinedRoomsFailure() async {
        mockWebService.mockResponse = .failure(URLError(.unknown))
        
        do {
            _ = try await roomManager.fetchJoinedRooms()
            XCTFail("Expected failure but got success")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
}
