//
//  NetworkError.swift
//  MessagingApp
//
//  Created by Hassan Shahid on 21.11.2025.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidResponse
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server"
        case .serverError(let message):
            return message
        }
    }
}
