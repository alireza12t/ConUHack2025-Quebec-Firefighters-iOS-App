//
//  CSVReaderViewModel.swift
//  Quebec Firefighters
//
//  Created by Alireza on 2/1/25.
//

import SwiftUI
import UniformTypeIdentifiers

@MainActor
/// ViewModel responsible for handling CSV file uploads, conversion to JSON, and sending data to an API.
class CSVReaderViewModel: ObservableObject {
    @Published var csvContent: String = ""
    @Published var errorMessage: String? = nil
    @Published var showSettingsAlert: Bool = false
    @Published var fireReport: FireReportModel? = nil
    @Published var isLoading: Bool = false
    
    /// Processes a CSV file from a given URL.
    /// - Parameter url: The file URL of the CSV to be processed.
    func processCSV(from url: URL) async {
        isLoading = true
        
        do {
            // Use the CSVProcessor to get JSON data from the CSV.
            let jsonData = try await CSVProcessor.shared.processCSV(from: url)
            
            // Optionally, store the CSV content as a string (for UI display, etc.).
            csvContent = String(data: jsonData, encoding: .utf8) ?? ""
            
            // Send the JSON data to the API.
            try await sendDataToAPI(jsonData: jsonData)
        } catch {
            // If file access was denied, prompt the user to open settings.
            if let processorError = error as? CSVProcessorError,
               processorError == .fileAccessDenied {
                showSettingsAlert = true
            }
            errorMessage = "Failed to process CSV file: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    /// Sends JSON data to the API asynchronously and updates the fire report.
    /// - Parameter jsonData: The JSON-encoded data to be sent to the API.
    private func sendDataToAPI(jsonData: Data) async throws {
        guard let url = URL(string: "https://conuhack2025-4.onrender.com/api/makeFireReport") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode(FireReportResponse.self, from: data)
        fireReport = decodedResponse.report
    }
    
    /// Opens the app settings if the user does not have permission to access the file.
    func openSettings() {
        #if os(iOS)
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL)
            }
        }
        #elseif os(macOS)
        if let url = URL(string: "x-apple.systempreferences:") {
            NSWorkspace.shared.open(url)
        }
        #endif
    }
}
