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
}
