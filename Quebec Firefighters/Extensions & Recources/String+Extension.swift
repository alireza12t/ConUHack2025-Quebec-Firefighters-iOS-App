//
//  String+Extension.swift
//  Quebec Firefighters
//
//  Created by Alireza on 2/2/25.
//

import Foundation

extension String {
    /// Returns a localized version of the string.
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    
    /// Returns a localized and formatted string using the provided arguments.
    func localized(with arguments: CVarArg...) -> String {
        let format = NSLocalizedString(self, comment: "")
        return String(format: format, arguments: arguments)
    }
}
