//
//  PredictionListView.swift
//  Quebec Firefighters
//
//  Created by Alireza on 2/2/25.
//

import SwiftUI

/// A SwiftUI view that displays a list of fire predictions in a card style.
/// Each row navigates to a detailed map view showing the incident location.
struct PredictionListView: View {
    var predictions: [FirePrediction]
    var backgroundColor: Color
    
    init(predictions: [FirePrediction]) {
        self.predictions = predictions
        #if os(iOS)
        self.backgroundColor = UIColor.secondarySystemBackground.swiftUIColor
        #else
        self.backgroundColor = NSColor.windowBackgroundColor.swiftUIColor
        #endif
    }
    
    var body: some View {
        List {
            ForEach(predictions) { prediction in
                NavigationLink(destination: PredictionMapDetailView(prediction: prediction)) {
                    HStack(spacing: 12) {
                        // Severity indicator.
                        Circle()
                            .fill(Color.colorForSeverity(prediction.fireSeverity))
                            .frame(width: 16, height: 16)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(prediction.timestamp)
                                .font(.headline)
                            
                            Text("\(LocalizationKeys.location.localized): \("\(prediction.latitude), \(prediction.longitude)")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                            
                            // Display the fire probability as a percentage.
                            let probablilityValue = String(format: "%.0f%%", prediction.fireProb * 100)
                            Text("\(LocalizationKeys.probability.localized): \(probablilityValue)")
                                .font(.headline)
                            
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(backgroundColor)
                    )
                    .padding(.vertical, 4)
                }
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct PredictionListView_Previews: PreviewProvider {
    static var previews: some View {
        let dummyPredictions = [
            FirePrediction(
                timestamp: "2025-02-01 12:00:00",
                latitude: 45.5017,
                longitude: -73.5673,
                fireProb: 0.89,
                fireSeverity: "high",
                address: "123 Main St, Montreal, QC"
            ),
            FirePrediction(
                timestamp: "2025-02-01 13:00:00",
                latitude: 45.5088,
                longitude: -73.5540,
                fireProb: 0.75,
                fireSeverity: "medium",
                address: "456 Elm St, Montreal, QC"
            )
        ]
        NavigationView {
            PredictionListView(predictions: dummyPredictions)
                .navigationTitle("Predictions")
        }
    }
}
