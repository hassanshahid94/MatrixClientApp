//
//  WebService.swift
//  MessagingApp
//
//  Created by Hassan Shahid on 22.11.2025.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol WebService {
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        body: [String: Any]?,
        headers: [String: String]?
    ) async throws -> T
}

class WebServiceImp: WebService {
    static let shared = WebServiceImp()
    private let baseURL = "https://matrix.7aeb1508.sshmatrix.com"
    private var session =  SessionManagerImp.shared
    
    private init() {}
    
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        body: [String: Any]? = nil,
        headers: [String: String]? = nil
    ) async throws -> T {

        let url = URL(string: "\(baseURL)\(endpoint)")!
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Inject saved access token automatically
        if let accessToken = session.accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        // Additional custom headers
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Set content type
        if method == .post || method == .put {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        // Body
        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        
        // Execute request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            let message = errorJson?["error"] as? String ?? "Request failed with status \(httpResponse.statusCode)"
            throw NetworkError.serverError(message)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}

