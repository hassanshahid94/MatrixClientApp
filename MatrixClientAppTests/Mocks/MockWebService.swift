//
//  MockWebService.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 27.11.2025.
//

import Foundation

class MockWebService: WebService {

    var mockResponse: Result<Data, Error> = .failure(URLError(.badURL))

    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        body: [String : Any]?,
        headers: [String : String]?
    ) async throws -> T {

        switch mockResponse {
        case .success(let data):
            return try JSONDecoder().decode(T.self, from: data)

        case .failure(let error):
            throw error
        }
    }
}
