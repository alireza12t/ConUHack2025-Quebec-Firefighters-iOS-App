//
//  FireResponseModel.swift
//  Quebec Firefighters
//
//  Created by Alireza on 2/1/25.
//

import Foundation

// MARK: - Log Model

/// Model representing an individual log entry.
struct FireReportLog: Codable {
    let action: String
    let eventIndex: Int
    let location: String
    let operationalCost: Int
    let resource: String?
    let severity: String
    let timestamp: String

    enum CodingKeys: String, CodingKey {
        case action
        case eventIndex = "event_index"
        case location
        case operationalCost = "operational_cost"
        case resource
        case severity
        case timestamp
    }
}

// MARK: - Fire Response Model

/// Model representing the fire response data.
/// This is based on the snippet you provided.
struct FireReportModel: Codable {
    var firesAddressed: [String: Int]
    var firesDelayed: [String: Int]
    var operationalCosts: Double
    var estimatedDamageCosts: Double

    enum CodingKeys: String, CodingKey {
        case operationalCosts = "operational_costs"
        case estimatedDamageCosts = "estimated_damage_costs"
        case firesAddressed = "fires_addressed"
        case firesDelayed = "fires_delayed"
    }
    
    /// Total fires addressed (summing all severity levels).
    var totalFiresAddressed: Int {
        firesAddressed.values.reduce(0, +)
    }

    /// Total fires delayed (summing all severity levels).
    var totalFiresDelayed: Int {
        firesDelayed.values.reduce(0, +)
    }

    /// The total number of fires (addressed + delayed).
    var totalFires: Int {
        totalFiresAddressed + totalFiresDelayed
    }
}

// MARK: - Overall Response Model

/// Model representing the full response structure.
struct FireReportResponse: Codable {
    let logs: [FireReportLog]
    let message: String
    let report: FireReportModel
    let status: String
}
