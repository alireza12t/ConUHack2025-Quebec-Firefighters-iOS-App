//
//  MKCoordinateRegion+Extension.swift
//  Quebec Firefighters
//
//  Created by Alireza on 2/2/25.
//

import MapKit

extension MKCoordinateRegion {
    func contains(coordinate: CLLocationCoordinate2D) -> Bool {
        let minLat = center.latitude - span.latitudeDelta / 2
        let maxLat = center.latitude + span.latitudeDelta / 2
        let minLon = center.longitude - span.longitudeDelta / 2
        let maxLon = center.longitude + span.longitudeDelta / 2
        return (minLat...maxLat).contains(coordinate.latitude) &&
               (minLon...maxLon).contains(coordinate.longitude)
    }
}
