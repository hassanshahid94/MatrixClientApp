//
//  HomeVMTests.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 27.11.2025.
//

import XCTest
import Combine

@MainActor
final class HomeVMTests: XCTestCase {

    // MARK: - Variables
    private var mockRoomManager: MockRoomManager!
    private var mockSessionManager: MockSessionManager!
    private var homeVM: HomeVM!
    private var cancellables: Set<AnyCancellable> = []

    let testRooms = [
        PublicRoom(
            roomId: "1",
            name: "SwiftUI Lounge",
            canonicalAlias: "#swiftui:matrix.org",
            numJoinedMembers: 42,
            worldReadable: true,
            guestCanJoin: true,
            joinRule: "public"
        ),
        PublicRoom(
            roomId: "2",
            name: "iOS Devs",
            canonicalAlias: "#ios:matrix.org",
            numJoinedMembers: 20,
            worldReadable: true,
            guestCanJoin: true,
            joinRule: "public"
        )
    ]
    
    override func setUp() {
        mockRoomManager = MockRoomManager()
        mockSessionManager = MockSessionManager()
        homeVM = HomeVM(
            roomManager: mockRoomManager,
            sessionManager: mockSessionManager
        )
    }

    override func tearDown() {
        cancellables.removeAll()
        mockRoomManager = nil
        mockSessionManager = nil
        homeVM = nil
    }

    // MARK: - Tests
    func testFetchPublicRoomsSuccess() async {
        mockRoomManager.shouldSucceed = true
        mockRoomManager.roomsToReturn = testRooms
        
        let expectation = expectation(description: "testFetchPublicRoomsSuccess")
        
        homeVM.$isLoading
            .dropFirst()
            .sink { isLoading in
                if !isLoading {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        homeVM.fetchPublicRooms()
        
        await fulfillment(of: [expectation], timeout: 2.0)
        
        XCTAssertEqual(homeVM.rooms.count, 2)
        XCTAssertEqual(homeVM.rooms, testRooms)
        XCTAssertNil(homeVM.errorMessage)
        XCTAssertFalse(homeVM.isLoading)
        XCTAssertTrue(mockRoomManager.fetchPublicRoomsCalled)
    }
    
    func testFetchPublicRoomsFailure() async {
        mockRoomManager.shouldSucceed = false
        mockRoomManager.thrownError = URLError(.unknown)
        
        let expectation = expectation(description: "testFetchPublicRoomsFailure")
        
        homeVM.$isLoading
            .dropFirst()
            .sink { isLoading in
                if !isLoading {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        homeVM.fetchPublicRooms()
        
        await fulfillment(of: [expectation], timeout: 2.0)
        
        XCTAssertEqual(homeVM.rooms.count, 0)
        XCTAssertNotNil(homeVM.errorMessage)
        XCTAssertFalse(homeVM.isLoading)
    }
    
    func testLogoutClearsSession() {
        mockSessionManager.accessToken = "abc123token"
        
        homeVM.logout()
        
        XCTAssertTrue(mockSessionManager.clearCalled)
        XCTAssertNil(mockSessionManager.accessToken)
    }
}
