//
//  FirePredictionsViewModel.swift
//  Quebec Firefighters
//
//  Created by Alireza on 2/2/25.
//

import Foundation
import CoreLocation

class FirePredictionsViewModel: ObservableObject {
    @Published var predictions: [FirePrediction] = []
    @Published var isLoading: Bool = false
    private let geocoder = CLGeocoder()
    
    init() {

    }
    
    func onAppear() {
        if predictions.isEmpty {
            loadDummyData()
        }
    }
    
    private func loadDummyData() {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isLoading = false

            self.predictions = [
                FirePrediction(timestamp: "2025-02-01 12:00:00", latitude: 45.5017, longitude: -73.5673, fireProb: 0.89, fireSeverity: "high"),
                FirePrediction(timestamp: "2025-02-01 13:00:00", latitude: 45.5088, longitude: -73.5540, fireProb: 0.75, fireSeverity: "high"),
                FirePrediction(timestamp: "2025-02-01 14:00:00", latitude: 45.5123, longitude: -73.5670, fireProb: 0.65, fireSeverity: "low")
            ]
        }
    }
}
