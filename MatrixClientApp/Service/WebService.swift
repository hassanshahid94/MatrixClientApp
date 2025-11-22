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
    
    func requestJSON(
        endpoint: String,
        method: HTTPMethod,
        body: [String: Any]?,
        headers: [String: String]?
    ) async throws -> [String: Any]
}

class WebServiceImp: WebService {
    static let shared = WebServiceImp()
    private let baseURL = "https://matrix.7aeb1508.sshmatrix.com"
    
    private init() {}
    
    // Generic request with Codable response
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        body: [String: Any]? = nil,
        headers: [String: String]? = nil
    ) async throws -> T {
        let url = URL(string: "\(baseURL)\(endpoint)")!
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Set headers
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Set default content type for POST/PUT
        if method == .post || method == .put {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        // Set body
        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            let errorMsg = errorJson?["error"] as? String ?? "Request failed with status \(httpResponse.statusCode)"
            throw NetworkError.serverError(errorMsg)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    // Request with JSON dictionary response (for non-Codable responses)
    func requestJSON(
        endpoint: String,
        method: HTTPMethod = .get,
        body: [String: Any]? = nil,
        headers: [String: String]? = nil
    ) async throws -> [String: Any] {
        let url = URL(string: "\(baseURL)\(endpoint)")!
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if method == .post || method == .put {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            let errorMsg = errorJson?["error"] as? String ?? "Request failed"
            throw NetworkError.serverError(errorMsg)
        }
        
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw NetworkError.invalidResponse
        }
        
        return json
    }
}
