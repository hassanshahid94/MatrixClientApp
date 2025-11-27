//
//  String.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 27.11.2025.
//

import Foundation

extension String {
    
    var localized: String {
        NSLocalizedString(self, comment: " ")
    }
    
    func localizedWithFormat(_ args: CVarArg... ) -> String {
        let format = NSLocalizedString(self, comment: "")
        return String(format: format, locale: Locale.current, arguments: args)
    }
}
