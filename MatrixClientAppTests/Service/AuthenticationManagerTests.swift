//
//  AuthenticationManagerTests.swift
//  MatrixClientAppTests
//
//  Created by Hassan Shahid on 27.11.2025.
//

import XCTest

final class AuthenticationManagerTests: XCTestCase {
    
    //MARK: Variables
    private var authenticationManager: AuthenticationManager!
    private var mockWebService: MockWebService!
    
    private let testLoginResponse = LoginResponse(
        userId: "@john:matrix.org",
        accessToken: "abc123token",
        homeServer: "matrix.org",
        deviceId: "DEVICE123",
        wellKnown: WellKnown(
            homeserver: Homeserver(
                baseUrl: "https://matrix.org"
            ),
            identityServer: IdentityServer(
                baseUrl: "https://vector.im"
            )
        )
    )
    
    override func setUp() {
        mockWebService = MockWebService()
        authenticationManager = AuthenticationManagerImp(webService: mockWebService)
    }
    
    func testLoginSuccess() async throws {
        let responseData = try! JSONEncoder().encode(testLoginResponse)
        mockWebService.mockResponse = .success(responseData)
        
        let response = try await authenticationManager.login(
            username: "john",
            password: "pass123"
        )
        
        XCTAssertEqual(response, testLoginResponse)
    }
    
    func testLoginFailure() async {
        mockWebService.mockResponse = .failure(URLError(.unknown))
        
        do {
            _ = try await authenticationManager.login(
                username: "john",
                password: "pass123"
            )
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
}
