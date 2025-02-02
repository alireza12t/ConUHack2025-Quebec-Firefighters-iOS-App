//
//  FireReportView.swift
//  Quebec Firefighters
//
//  Created by Alireza on 2/1/25.
//

import SwiftUI
import Charts

/// Displays fire response statistics and a stacked bar chart visualization.
struct FireReportView: View {
    /// The view model providing fire report data.
    @ObservedObject var viewModel: FireReportViewModel
    
    /// Indicates whether the detailed popup is shown.
    @State private var showPopup = false
    
    /// Contains data for the selected severity level when a bar is tapped.
    @State private var selectedData: (severity: String, addressed: Int, delayed: Int, total: Int)? = nil
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack(alignment: .leading, spacing: 16) {
                    if let report = viewModel.fireReport {
                        headerView
                        FireReportStatisticsView(report: report)
                        Text("Fires by Severity")
                            .font(.headline)
                            .padding(.horizontal)
                        FireResponseChartView(report: report,
                                              showPopup: $showPopup,
                                              selectedData: $selectedData)
                    } else {
                        Text("No data available")
                            .padding()
                    }
                }
                .padding()
                
                if showPopup, let data = selectedData {
                    FireReportPopup(
                        severity: data.severity,
                        addressed: data.addressed,
                        delayed: data.delayed,
                        total: data.total,
                        showPopup: $showPopup
                    )
                }
            }
        }
    }
    
    /// The header view for the report.
    private var headerView: some View {
        Text("Fire Response Report")
            .font(.title)
            .bold()
            .padding()
    }
}

#Preview {
    FireReportView(viewModel: FireReportViewModel(fireReport: FireReportModel(
        firesAddressed: ["low": 4, "medium": 12, "high": 12],
        firesDelayed: ["low": 1, "medium": 2, "high": 1],
        operationalCosts: 50000,
        estimatedDamageCosts: 350000
    )))
}
