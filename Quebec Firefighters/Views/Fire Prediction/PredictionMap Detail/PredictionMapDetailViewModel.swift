//
//  MapDetailViewModel.swift
//  Quebec Firefighters
//
//  Created by Alireza on 2/2/25.
//

import Foundation
import MapKit
import Combine

/// ViewModel to manage the logic for `MapDetailView`
class MapDetailViewModel: ObservableObject {
    @Published var address: String = LocalizationKeys.fetchingAddress.localized
    
    private var geocoder = CLGeocoder()
    
    init(prediction: FirePrediction) {
        fetchAddress(for: prediction)
    }
    
    /// Fetch address using reverse geocoding
    func fetchAddress(for prediction: FirePrediction) {
        let location = CLLocation(latitude: prediction.latitude, longitude: prediction.longitude)
        
        Task {
            do {
                let fetchedAddress = try await reverseGeocode(location: location)
                DispatchQueue.main.async {
                    self.address = fetchedAddress
                }
            } catch {
                DispatchQueue.main.async {
                    self.address = LocalizationKeys.addressNotAvailable.localized
                }
            }
        }
    }
    
    /// Reverse geocode using Apple’s CLGeocoder
    private func reverseGeocode(location: CLLocation) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                if let placemark = placemarks?.first,
                   let street = placemark.thoroughfare,
                   let city = placemark.locality,
                   let country = placemark.country {
                    continuation.resume(returning: "\(street), \(city), \(country)")
                } else {
                    continuation.resume(returning: LocalizationKeys.addressNotAvailable.localized)
                }
            }
        }
    }
}
