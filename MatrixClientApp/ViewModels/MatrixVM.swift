//
//  MatrixVM.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 22.11.2025.
//


import Foundation

@MainActor
class MatrixVM: ObservableObject {

    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var rooms: [MatrixRoom] = []
    @Published var messages: [MatrixMessage] = []
    
    private var accessToken: String?
    private var userId: String?
    
    private let authenticationManager: AuthenticationManager
    private let roomManager: RoomManager
    private let messageManager: MessageManager
    
    // MARK: - Initializer with Dependency Injection
    init(
        authenticationManager: AuthenticationManager,
        roomManager: RoomManager,
        messageManager: MessageManager
    ) {
        self.authenticationManager = authenticationManager
        self.roomManager = roomManager
        self.messageManager = messageManager
    }
    
    // MARK: - Public Methods
    
    func login(username: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await authenticationManager.login(username: username, password: password)
                self.accessToken = response.accessToken
                self.userId = response.userId
                self.isAuthenticated = true
            } catch let error as NetworkError {
                self.errorMessage = error.errorDescription
            } catch {
                self.errorMessage = "Network error: \(error.localizedDescription)"
            }
            
            isLoading = false
        }
    }
    
    func fetchPublicRooms() async {
        guard let token = accessToken else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            self.rooms = try await roomManager.fetchPublicRooms(accessToken: token)
        } catch {
            self.errorMessage = "Failed to fetch rooms: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func joinRoom(roomId: String) async {
        guard let token = accessToken else { return }
        
        do {
            try await roomManager.joinRoom(roomId: roomId, accessToken: token)
        } catch {
            print("Failed to join room: \(error)")
        }
    }
    
    func fetchMessages(roomId: String) async {
        guard let token = accessToken else { return }
        
        isLoading = true
        
        do {
            self.messages = try await messageManager.fetchMessages(roomId: roomId, accessToken: token)
        } catch {
            self.errorMessage = "Failed to fetch messages: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func logout() {
        isAuthenticated = false
        accessToken = nil
        userId = nil
        rooms = []
        messages = []
    }
}
