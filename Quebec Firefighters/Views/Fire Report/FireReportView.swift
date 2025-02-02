//
//  FireReportView.swift
//  Quebec Firefighters
//
//  Created by Alireza on 2/1/25.
//

import SwiftUI
import Charts

/// Displays fire response statistics and a bar chart visualization.
struct FireReportView: View {
    @ObservedObject var viewModel: FireReportViewModel
    @State private var showPopup = false
    @State private var selectedData: (severity: String, addressed: Int, delayed: Int, total: Int)? = nil

    var body: some View {
        ScrollView {
            ZStack {
                VStack(alignment: .leading, spacing: 16) {
                    if let report = viewModel.fireReport {
                        Text("Fire Response Report")
                            .font(.title)
                            .bold()
                            .padding()
                        
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
                        
                        Text("Fires by Severity")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Chart {
                            ForEach(["low", "medium", "high"], id: \.self) { severity in
                                let addressed = report.firesAddressed[severity] ?? 0
                                let delayed = report.firesDelayed[severity] ?? 0
                                
                                BarMark(
                                    x: .value("Severity", severity.capitalized),
                                    y: .value("Addressed", addressed)
                                )
                                .foregroundStyle(.green)
                                .cornerRadius(4)
                                
                                BarMark(
                                    x: .value("Severity", severity.capitalized),
                                    y: .value("Missed", delayed)
                                )
                                .foregroundStyle(.red)
                                .cornerRadius(4)
                            }
                        }
                        .frame(height: 250)
                        .padding()
                        .chartOverlay { proxy in
                            GeometryReader { geometry in
                                Rectangle()
                                    .fill(.clear)
                                    .contentShape(Rectangle())
                                    .gesture(
                                        DragGesture(minimumDistance: 0)
                                            .onEnded { value in
                                                let location = value.location
                                                if let tappedSeverity: String = proxy.value(atX: location.x) {
                                                    let key = tappedSeverity.lowercased()
                                                    let addressed = report.firesAddressed[key] ?? 0
                                                    let delayed = report.firesDelayed[key] ?? 0
                                                    let total = addressed + delayed
                                                    
                                                    selectedData = (severity: tappedSeverity, addressed: addressed, delayed: delayed, total: total)
                                                    showPopup = true
                                                }
                                            }
                                    )
                            }
                        }
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
}

#Preview {
    FireReportView(viewModel: FireReportViewModel(fireReport: FireResponseModel(
        firesAddressed: ["low": 4, "medium": 12, "high": 12],
        firesDelayed: ["low": 1, "medium": 2, "high": 1],
        operationalCosts: 50000,
        estimatedDamageCosts: 350000
    )))
}
