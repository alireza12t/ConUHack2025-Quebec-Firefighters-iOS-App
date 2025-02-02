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
            fetchFirePredictions()
        }
    }
    
    /// Fetches fire prediction data from the API
    func fetchFirePredictions() {
        isLoading = true
        
        Task {
            do {
                let response = try await getFirePredictionsFromAPI()
                DispatchQueue.main.async {
                    self.predictions = response.predictions
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    print("Failed to fetch fire predictions: \(error.localizedDescription)")
                    self.isLoading = false
                }
            }
        }
    }
    
        
    /// Sends JSON data to the API asynchronously and updates the fire report.
    /// - Parameter jsonData: The JSON-encoded data to be sent to the API.
    private func getFirePredictionsFromAPI() async throws -> FirePredictionResponse {
        guard let url = URL(string: "https://conuhack2025-4.onrender.com/api/getFirePrediction") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(FirePredictionResponse.self, from: data)
    }
}
