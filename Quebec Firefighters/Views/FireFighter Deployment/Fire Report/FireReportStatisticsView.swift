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
            Section(header: Text(LocalizationKeys.generalStatistics.localized)) {
                Text(LocalizationKeys.totalFiresAddressed.localized + " \(report.totalFiresAddressed)")
                Text(LocalizationKeys.totalFiresDelayed.localized + " \(report.totalFiresDelayed)")
                Text(LocalizationKeys.totalFires.localized + " \(report.totalFires)")
                Text(LocalizationKeys.operationalCosts.localized + " \(String(format: "$%.2f", report.operationalCosts))")
                Text(LocalizationKeys.damageCosts.localized + " \(String(format: "$%.2f", report.estimatedDamageCosts))")
            }
        }
        .scrollDisabled(true)
        .frame(height: 300)
    }
}
