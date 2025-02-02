//
//  FireResponseModel.swift
//  Quebec Firefighters
//
//  Created by Alireza on 2/1/25.
//

import Foundation

/// Model representing the fire response data
struct FireResponseModel {
    var firesAddressed: [String: Int]
    var firesDelayed: [String: Int]
    var operationalCosts: Double
    var estimatedDamageCosts: Double

    /// Total fires (addressed + delayed)
    var totalFiresAddressed: Int {
        firesAddressed.values.reduce(0, +)
    }

    var totalFiresDelayed: Int {
        firesDelayed.values.reduce(0, +)
    }

    var totalFires: Int {
        totalFiresAddressed + totalFiresDelayed
    }
}
