//
//  SeverityColorModel.swift
//  Quebec Firefighters
//
//  Created by Alireza on 2/2/25.
//

import SwiftUI

extension Color {
    static func colorForSeverity(_ severity: String) -> Color {
        let opacity: Double = 0.6
        switch severity.lowercased() {
        case "high":
            return .red.opacity(opacity)
        case "medium":
            return .orange.opacity(opacity)
        case "low":
            return .green.opacity(opacity)
        default:
            return .gray.opacity(opacity)
        }
    }
}
