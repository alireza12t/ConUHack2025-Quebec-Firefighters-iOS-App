//
//  FireResponseChartView.swift
//  Quebec Firefighters
//
//  Created by Alireza on 2/1/25.
//

import SwiftUI
import Charts

/// Displays a stacked bar chart for fire responses by severity.
/// The chart uses different colors for the two types of responses and annotates each bar
/// with the total number for that severity. A legend is automatically provided.
struct FireResponseChartView: View {
    /// The fire response report model.
    let report: FireResponseModel
    
    /// Binding to control display of the detailed popup.
    @Binding var showPopup: Bool
    
    /// Binding for the selected data details.
    @Binding var selectedData: (severity: String, addressed: Int, delayed: Int, total: Int)?
    
    /// A helper structure representing a single chart data item.
    private struct SeverityChartData: Identifiable {
        let id = UUID()
        let severity: String
        let type: String  // "Addressed" or "Missed"
        let value: Int
    }
    
    /// A helper structure for the total values per severity.
    private struct SeverityTotal: Identifiable {
        let id: String  // severity (capitalized)
        let total: Int
    }
    
    /// Computed array of data points for the stacked bar chart.
    private var chartData: [SeverityChartData] {
        let severities = ["low", "medium", "high"]
        var data: [SeverityChartData] = []
        for severity in severities {
            let addressed = report.firesAddressed[severity] ?? 0
            let delayed = report.firesDelayed[severity] ?? 0
            data.append(SeverityChartData(severity: severity.capitalized, type: "Addressed", value: addressed))
            data.append(SeverityChartData(severity: severity.capitalized, type: "Missed", value: delayed))
        }
        return data
    }
    
    /// Computed array of total values per severity (used for annotations).
    private var totals: [SeverityTotal] {
        let severities = ["low", "medium", "high"]
        return severities.map { severity in
            let addressed = report.firesAddressed[severity] ?? 0
            let delayed = report.firesDelayed[severity] ?? 0
            return SeverityTotal(id: severity.capitalized, total: addressed + delayed)
        }
    }
    
    var body: some View {
        VStack {
            Chart {
                // Create a stacked bar for each data item.
                ForEach(chartData) { dataPoint in
                    BarMark(
                        x: .value("Severity", dataPoint.severity),
                        y: .value("Value", dataPoint.value)
                    )
                    // The use of .foregroundStyle(by:) automatically creates a legend.
                    .foregroundStyle(by: .value("Type", dataPoint.type))
                }
                // Add invisible bars to annotate the top of each stacked bar with the total.
                ForEach(totals) { totalItem in
                    BarMark(
                        x: .value("Severity", totalItem.id),
                        y: .value("Total", totalItem.total)
                    )
                    .opacity(0)
                    .annotation(position: .overlay) {
                        Text("\(totalItem.total)")
                            .font(.caption)
                    }
                }
            }
            // Define the color mapping for the two types.
            .chartForegroundStyleScale([
                "Addressed": Color.green,
                "Missed": Color.red
            ])
            // Place the automatically generated legend at the bottom.
            .chartLegend(position: .bottom)
            .frame(height: 250)
            .padding()
            // Overlay a transparent layer to capture tap gestures.
            .chartOverlay { proxy in
                GeometryReader { _ in
                    Rectangle()
                        .fill(Color.clear)
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
                                        selectedData = (severity: tappedSeverity,
                                                        addressed: addressed,
                                                        delayed: delayed,
                                                        total: total)
                                        showPopup = true
                                    }
                                }
                        )
                }
            }
        }
    }
}
