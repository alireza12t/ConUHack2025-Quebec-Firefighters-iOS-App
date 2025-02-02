//
//  FireReportStatisticsView.swift
//  Quebec Firefighters
//
//  Created by Alireza on 2/1/25.
//

import SwiftUI

/// Displays general fire response statistics in a form.
struct FireReportStatisticsView: View {
    /// The fire response report model.
    let report: FireReportModel
    
    var body: some View {
        Form {
            Section(header: Text("General Statistics")) {
                Text("Total Fires Addressed: \(report.totalFiresAddressed)")
                Text("Total Fires Delayed: \(report.totalFiresDelayed)")
                Text("Total Fires: \(report.totalFires)")
                Text("Operational Costs: $\(report.operationalCosts, specifier: "%.2f")")
                Text("Damage Costs: $\(report.estimatedDamageCosts, specifier: "%.2f")")
            }
        }
        .scrollDisabled(true)
        .frame(height: 300)
    }
}
