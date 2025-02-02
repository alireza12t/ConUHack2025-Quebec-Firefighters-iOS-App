//
//  PredictionMapView.swift
//  Quebec Firefighters
//
//  Created by Alireza on 2/2/25.
//

import SwiftUI
import MapKit

struct PredictionMapView: View {
    var predictions: [FirePrediction]
    
    @State private var region: MKCoordinateRegion
    @State private var clusteredPredictions: [FireCluster] = []
    @State private var debounceTimer: Timer?
    
    @State private var lastCenter: CLLocationCoordinate2D
    @State private var lastSpan: MKCoordinateSpan
    
    // Clustering control parameters
    private let zoomOutThreshold: Double = 1.5 // Aggressive clustering when zoomed out
    private let midZoomThreshold: Double = 0.5 // Moderate clustering at medium zoom
    private let closeZoomThreshold: Double = 0.15 // No clustering at close zoom

    init(predictions: [FirePrediction]) {
        self.predictions = predictions
        if let first = predictions.first {
            let coordinate = CLLocationCoordinate2D(latitude: first.latitude, longitude: first.longitude)
            _region = State(initialValue: MKCoordinateRegion(center: coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000))
            _lastCenter = State(initialValue: coordinate)
            _lastSpan = State(initialValue: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        } else {
            _region = State(initialValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 10000, longitudinalMeters: 10000))
            _lastCenter = State(initialValue: CLLocationCoordinate2D(latitude: 0, longitude: 0))
            _lastSpan = State(initialValue: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        }
    }
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: clusteredPredictions) { cluster in
            MapAnnotation(coordinate: cluster.coordinate) {
                if cluster.count > 1 {
                    // Show Cluster
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.6))
                            .frame(width: 40, height: 40)
                        Text("\(cluster.count)")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .bold))
                    }
                } else if let prediction = cluster.predictions.first {
                    // Show Individual Fire
                    Circle()
                        .fill(Color.colorForSeverity(prediction.fireSeverity))
                        .frame(width: 40, height: 40)
                }
            }
        }
        .onAppear {
            updateAnnotations()
        }
        .onChange(of: region.center.latitude) { _ in checkForRegionChange() }
        .onChange(of: region.center.longitude) { _ in checkForRegionChange() }
        .onChange(of: region.span.latitudeDelta) { _ in checkForRegionChange() }
        .onChange(of: region.span.longitudeDelta) { _ in checkForRegionChange() }
    }
    
    private func checkForRegionChange() {
        let centerChanged = lastCenter.latitude != region.center.latitude || lastCenter.longitude != region.center.longitude
        let spanChanged = lastSpan.latitudeDelta != region.span.latitudeDelta || lastSpan.longitudeDelta != region.span.longitudeDelta

        if centerChanged || spanChanged {
            debounceTimer?.invalidate()
            debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                updateAnnotations()
                lastCenter = region.center
                lastSpan = region.span
            }
        }
    }

    private func updateAnnotations() {
        let visiblePredictions = predictions.filter { prediction in
            region.contains(coordinate: CLLocationCoordinate2D(latitude: prediction.latitude, longitude: prediction.longitude))
        }
        
        let clusterDistance = determineClusterDistance(for: region.span.latitudeDelta)
        
        clusteredPredictions = clusterPredictions(visiblePredictions, clusterDistance: clusterDistance)
    }

    /// Dynamically determine cluster distance based on zoom level
    private func determineClusterDistance(for zoomLevel: Double) -> Double {
        print("Zoom level: \(zoomLevel)")
        if zoomLevel > zoomOutThreshold {
            return 1.0 // Very aggressive clustering (group everything)
        } else if zoomLevel > midZoomThreshold {
            return 0.3 // Medium clustering
        } else if zoomLevel > closeZoomThreshold {
            return 0.1 // Light clustering
        } else {
            return 0.0 // No clustering (show individual fires)
        }
    }

    private func clusterPredictions(_ predictions: [FirePrediction], clusterDistance: Double) -> [FireCluster] {
        var clusters: [FireCluster] = []

        for prediction in predictions {
            let coordinate = CLLocationCoordinate2D(latitude: prediction.latitude, longitude: prediction.longitude)

            if clusterDistance == 0 {
                // No clustering (full zoom in)
                clusters.append(FireCluster(predictions: [prediction]))
            } else {
                // Cluster based on proximity
                if let index = clusters.firstIndex(where: { $0.isNear(coordinate, threshold: clusterDistance) }) {
                    clusters[index].predictions.append(prediction)
                } else {
                    clusters.append(FireCluster(predictions: [prediction]))
                }
            }
        }
        
        return clusters
    }
}
