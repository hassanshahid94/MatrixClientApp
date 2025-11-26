//
//  DateTime.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 26.11.2025.
//

import Foundation

extension Date {
    var messageTime: String {
        Date.messageTimeFormatter.string(from: self)
    }
 
    private static let messageTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}
