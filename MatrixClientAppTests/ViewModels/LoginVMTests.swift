//
//  LoginVMTests.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 27.11.2025.
//

import XCTest
import Combine

@MainActor
final class LoginVMTests: XCTestCase {

    // MARK: - Variables
    private var mockAuthenticationManager: MockAuthenticationManager!
    private var mockSessionManager: MockSessionManager!
    private var loginVM: LoginVM!
    private var cancellables: Set<AnyCancellable> = []
    
    private let testResponse = LoginResponse(
        userId: "@john:matrix.org",
        accessToken: "abc123token",
        homeServer: "matrix.org",
        deviceId: "DEVICE123",
        wellKnown: WellKnown(
            homeserver: Homeserver(baseUrl: "https://matrix.org"),
            identityServer: IdentityServer(baseUrl: "https://vector.im")
        )
    )
    
    override func setUp() {
        mockAuthenticationManager = MockAuthenticationManager()
        mockSessionManager = MockSessionManager()
        loginVM = LoginVM(
            authenticationManager: mockAuthenticationManager,
            sessionManager: mockSessionManager
        )
    }
    
    override func tearDown() {
        mockAuthenticationManager = nil
        mockSessionManager = nil
        loginVM = nil
    }
    
    // MARK: - Tests
    func testLoginSuccess() async {
        mockAuthenticationManager.shouldSucceed = true
        mockAuthenticationManager.response = testResponse
        
        let expectation = expectation(description: "testLoginSuccess")
        
        loginVM.$isLoading
            .dropFirst()
            .sink { isLoading in
                if !isLoading {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        loginVM.login(username: "john", password: "pass123")

        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertNil(loginVM.errorMessage)
        XCTAssertEqual(mockSessionManager.updatedToken, testResponse.accessToken)
        XCTAssertEqual(mockSessionManager.updatedUserId, testResponse.userId)
        XCTAssertFalse(loginVM.isLoading)
    }
    
    func testLoginFailure() async {
        mockAuthenticationManager.shouldSucceed = false
        mockAuthenticationManager.thrownError = URLError(.unknown)
        
        let expectation = expectation(description: "testLoginFailure")
        
        loginVM.$isLoading
            .dropFirst()
            .sink { isLoading in
                if !isLoading {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        loginVM.login(username: "john", password: "pass123")
        
        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertNotNil(loginVM.errorMessage)
        XCTAssertNil(mockSessionManager.updatedToken)
        XCTAssertFalse(loginVM.isLoading)
    }
}
