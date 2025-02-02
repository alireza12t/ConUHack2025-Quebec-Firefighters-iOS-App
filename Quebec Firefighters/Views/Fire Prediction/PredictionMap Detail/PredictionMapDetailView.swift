//
//  PredictionMapDetailView.swift
//  Quebec Firefighters
//
//  Created by Alireza on 2/2/25.
//

import SwiftUI
import MapKit

/// A SwiftUI view that displays a map centered on a fire prediction's location,
/// with a bottom sheet overlay showing detailed incident information.
struct PredictionMapDetailView: View {
    var prediction: FirePrediction
    
    @StateObject private var viewModel: MapDetailViewModel
    
    private let latitudeOffset: CLLocationDegrees = 0.002
    @State private var region: MKCoordinateRegion
    
    init(prediction: FirePrediction) {
        self.prediction = prediction
        let adjustedCoordinate = CLLocationCoordinate2D(
            latitude: prediction.latitude + 0.002,
            longitude: prediction.longitude
        )
        _region = State(initialValue: MKCoordinateRegion(
            center: adjustedCoordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        ))
        _viewModel = StateObject(wrappedValue: MapDetailViewModel(prediction: prediction))
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $region, annotationItems: [prediction]) { item in
                MapAnnotation(coordinate: CLLocationCoordinate2D(
                    latitude: prediction.latitude,
                    longitude: prediction.longitude)
                ) {
                    Circle()
                        .fill(Color.colorForSeverity(prediction.fireSeverity))
                        .frame(width: 50, height: 50)
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                }
            }
            .edgesIgnoringSafeArea(.all)
            .clipped()
            
            // Updated BottomSheetView to accept the ViewModel's address
            BottomSheetView(prediction: prediction, address: viewModel.address)
                .padding(.horizontal)
                .padding(.bottom, 20)
        }
        .navigationTitle("Incident Location")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline) // Only for iOS
        #endif
    }
}


/// The bottom sheet view showing the incident’s address, time, and severity.
struct BottomSheetView: View {
    var prediction: FirePrediction
    var address: String
    var backgroundColor: Color

    init(prediction: FirePrediction, address: String) {
        self.prediction = prediction
        self.address = address
        #if os(iOS)
        self.backgroundColor = UIColor.systemGroupedBackground.swiftUIColor
        #else
        self.backgroundColor = NSColor.controlBackgroundColor.swiftUIColor
        #endif
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Capsule()
                .fill(Color.secondary)
                .frame(width: 40, height: 5)
                .padding(.top, 8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(address)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text("\(LocalizationKeys.time.localized): \(prediction.timestamp)")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Text("\(LocalizationKeys.severity.localized): \(prediction.fireSeverity.capitalized)")
                    .font(.subheadline)
                    .foregroundColor(Color.colorForSeverity(prediction.fireSeverity))
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(backgroundColor)
                .shadow(radius: 5)
        )
    }
}

struct MapDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Dummy prediction for preview
        let dummy = FirePrediction(
            timestamp: "2025-02-01 12:00:00",
            latitude: 45.5017,
            longitude: -73.5673,
            fireProb: 0.89,
            fireSeverity: "high",
            address: "123 Main St, Montreal, QC"
        )
        NavigationView {
            PredictionMapDetailView(prediction: dummy)
        }
    }
}
