//
//  FireCluster.swift
//  Quebec Firefighters
//
//  Created by Alireza on 2/2/25.
//

import MapKit

struct FireCluster: Identifiable {
    var id = UUID()
    var predictions: [FirePrediction]

    var coordinate: CLLocationCoordinate2D {
        let avgLat = predictions.map { $0.latitude }.reduce(0, +) / Double(predictions.count)
        let avgLon = predictions.map { $0.longitude }.reduce(0, +) / Double(predictions.count)
        return CLLocationCoordinate2D(latitude: avgLat, longitude: avgLon)
    }

    var count: Int {
        predictions.count
    }

    func isNear(_ coordinate: CLLocationCoordinate2D, threshold: Double) -> Bool {
        guard let first = predictions.first else { return false }
        return abs(first.latitude - coordinate.latitude) < threshold && abs(first.longitude - coordinate.longitude) < threshold
    }
}
