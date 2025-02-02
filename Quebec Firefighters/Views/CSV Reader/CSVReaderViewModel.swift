//
//  CSVReaderViewModel.swift
//  Quebec Firefighters
//
//  Created by Alireza on 2/1/25.
//

import SwiftUI
import Charts
import UniformTypeIdentifiers

@MainActor
/// ViewModel responsible for handling CSV file uploads, conversion to JSON, and sending data to an API.
class CSVReaderViewModel: ObservableObject {
    @Published var csvContent: String = ""
    @Published var errorMessage: String? = nil
    @Published var showSettingsAlert: Bool = false
    @Published var fireReport: FireResponseModel? = nil
    @Published var isLoading: Bool = false
    
    /// Reads CSV content from a file URL, converts it to JSON, and sends it to the API.
    ///
    /// - Parameter url: The file URL of the CSV to be processed.
    /// - Note: This function is asynchronous and should be called using `await`.
    /// - Throws: An error if reading, converting, or sending data fails.
    func processCSV(from url: URL) async {
        guard checkFileAccess(for: url) else {
            showSettingsAlert = true
            return
        }
        
        do {
            let content = try String(contentsOf: url, encoding: .utf8)
            let jsonData = try convertToJSON(content: content)
            await sendDataToAPI(jsonData: jsonData)
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to process CSV file."
            }
        }
    }
    
    /// Converts CSV content into JSON data.
    ///
    /// - Parameter content: A string containing CSV-formatted data.
    /// - Throws: An error if the conversion process fails.
    /// - Returns: A `Data` object representing the JSON-encoded version of the CSV content.
    private func convertToJSON(content: String) throws -> Data {
        let rows = content.components(separatedBy: "\n").filter { !$0.isEmpty }
        guard let headers = rows.first?.components(separatedBy: ",") else {
            throw NSError(domain: "Invalid CSV format", code: 400, userInfo: nil)
        }
        
        let jsonArray = rows.dropFirst().map { row -> [String: String] in
            let values = row.components(separatedBy: ",")
            return Dictionary(uniqueKeysWithValues: zip(headers, values))
        }
        
        return try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
    }
    
    /// Sends JSON data to the API and retrieves the fire report.
    /// - Parameter jsonData: The JSON-encoded data to be sent to the API.
    /// - Note: This function is asynchronous and should be called using `await`.
    private func sendDataToAPI(jsonData: Data) async {
//        guard let url = URL(string: "https://example.com/api/fire-report") else {
//            DispatchQueue.main.async {
//                self.errorMessage = "Invalid API URL."
//            }
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = jsonData
//        
//        do {
//            let (data, response) = try await URLSession.shared.data(for: request)
//            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
//                throw NSError(domain: "Invalid response from server", code: 500, userInfo: nil)
//            }
//            
//            let decodedResponse = try JSONDecoder().decode(FireResponseModel.self, from: data)
//            DispatchQueue.main.async {
//                self.fireReport = decodedResponse
//            }
//        } catch {
//            DispatchQueue.main.async {
//                self.errorMessage = "Error communicating with server."
//            }
//        }
        fetchMockFireReport()
    }
    
    /// Checks if the app has permission to access the specified file URL.
    /// - Parameter url: The URL of the file that needs to be accessed.
    /// - Returns: A Boolean value indicating whether access to the file was granted.
    private func checkFileAccess(for url: URL) -> Bool {
        let accessGranted = url.startAccessingSecurityScopedResource()
        if !accessGranted {
            errorMessage = "Permission denied for file access."
        }
        return accessGranted
    }
    
    /// Opens the app settings if the user does not have permission.
    func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }
    
    private func fetchMockFireReport() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 3) {
            let mockReport = FireResponseModel(
                firesAddressed: ["low": 4, "medium": 12, "high": 12],
                firesDelayed: ["low": 1, "medium": 2, "high": 1],
                operationalCosts: 50000,
                estimatedDamageCosts: 350000
            )
            
            DispatchQueue.main.async {
                self.isLoading = false
                self.fireReport = mockReport
            }
        }
    }
}
