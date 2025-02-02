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
    
    init(predictions: [FirePrediction]) {
        self.predictions = predictions
        if let first = predictions.first {
            let coordinate = CLLocationCoordinate2D(latitude: first.latitude, longitude: first.longitude)
            _region = State(initialValue: MKCoordinateRegion(center: coordinate,
                                                            latitudinalMeters: 5000,
                                                            longitudinalMeters: 5000))
        } else {
            _region = State(initialValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                                                            latitudinalMeters: 10000,
                                                            longitudinalMeters: 10000))
        }
    }
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: predictions) { prediction in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: prediction.latitude,
                                                               longitude: prediction.longitude)) {
                Circle()
                    .fill(Color.colorForSeverity(prediction.fireSeverity))
                    .frame(width: 40, height: 40)
            }
        }
    }
}
