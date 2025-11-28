//
//  PreviewData.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 28.11.2025.
//


import Foundation

struct PreviewData {
    
    // MARK: - Sample Room
    static let sampleRooms: [PublicRoom] = [
        PublicRoom(
            roomId: "!swiftui:matrix.org",
            name: "SwiftUI Lounge",
            canonicalAlias: "#swiftui:matrix.org",
            numJoinedMembers: 42,
            worldReadable: true,
            guestCanJoin: true,
            joinRule: "public"
        ),
        PublicRoom(
            roomId: "!iosdev:matrix.org",
            name: "iOS Developers",
            canonicalAlias: "#iosdev:matrix.org",
            numJoinedMembers: 128,
            worldReadable: true,
            guestCanJoin: false,
            joinRule: "public"
        ),
        PublicRoom(
            roomId: "!matrix:matrix.org",
            name: "Matrix HQ",
            canonicalAlias: "#matrix:matrix.org",
            numJoinedMembers: 5032,
            worldReadable: true,
            guestCanJoin: true,
            joinRule: "public"
        )
    ]
    
    // MARK: - Sample Message Event
    static let sampleMessage = MessageEvent(
        id: "msg1",
        sender: "@alice:matrix.org",
        displayName: "Alice",
        body: "Hello! This is a sample preview message. 😊",
        timestamp: 1700000000000
    )
    
    // MARK: - Sample Membership Events
    static let sampleJoinedEvent = MembershipEvent(
        id: "mem1",
        sender: "@bob:matrix.org",
        displayName: "Bob",
        action: .joined,
        timestamp: 1700000100000
    )

    static let sampleLeftEvent = MembershipEvent(
        id: "mem2",
        sender: "@carol:matrix.org",
        displayName: "Carol",
        action: .left,
        timestamp: 1700000200000
    )

    static let sampleInvitedEvent = MembershipEvent(
        id: "mem3",
        sender: "@dave:matrix.org",
        displayName: "Dave",
        action: .invited,
        timestamp: 1700000300000
    )
    
    static let sampleTimelineEvents: [TimelineEvent] = [
        .message(sampleMessage),
        .membershipChange(sampleLeftEvent),
        .membershipChange(sampleInvitedEvent)
    ]
}
