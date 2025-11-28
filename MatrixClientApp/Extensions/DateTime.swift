//
//  DateTime.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 26.11.2025.
//

import Foundation

extension Date {
    var dayTitle: String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        
        if calendar.isDateInToday(self) {
            return "today_title".localized
        } else if calendar.isDateInYesterday(self) {
            return "yesterday_title".localized
        } else if calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear) {
            formatter.dateFormat = "EEEE"
            return formatter.string(from: self)
        } else {
            formatter.dateFormat = "dd.MM.yyyy"
            return formatter.string(from: self)
        }
    }

    var messageTime: String {
        Date.messageTimeFormatter.string(from: self)
    }
    
    private static let messageTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}
