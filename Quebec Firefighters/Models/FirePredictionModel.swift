//
//  FirePredictionModel.swift
//  Quebec Firefighters
//
//  Created by Alireza on 2/2/25.
//

import Foundation

/// Represents a fire prediction data point.
struct FirePrediction: Identifiable, Codable {
    var id: String {
        return "\(timestamp), \(latitude), \(longitude)"
    }
    let timestamp: String
    let latitude: Double
    let longitude: Double
    let fireProb: Double
    let fireSeverity: String
    var address: String? = nil  // New: Address fetched via reverse geocoding
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case latitude
        case longitude
        case fireProb = "fire_prob"
        case fireSeverity = "fire_severity"
    }
}

struct FirePredictionModel {
    let modelInfo: ModelInfo
    let predictions: [FirePrediction]
    
    enum CodingKeys: String, CodingKey {
        case modelInfo = "model_info"
        case predictions
    }
}

struct ModelInfo: Decodable {
    let averageAccuracy: Double
    let averageF1Score: Double
    let numberOfIterations: Int
    
    enum CodingKeys: String, CodingKey {
        case averageAccuracy = "average_accuracy"
        case averageF1Score = "average_f1_score"
        case numberOfIterations = "number_of_iterations"
    }
}
