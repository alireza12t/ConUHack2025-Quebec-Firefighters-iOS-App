//
//  FireReportViewModel.swift
//  Quebec Firefighters
//
//  Created by Alireza on 2/1/25.
//

import Foundation

/// ViewModel for managing fire response report data.
class FireReportViewModel: ObservableObject {
    @Published var fireReport: FireReportModel?
    @Published var selectedSeverity: String?
    
    init(fireReport: FireReportModel? = nil, selectedSeverity: String? = nil) {
        self.fireReport = fireReport
        self.selectedSeverity = selectedSeverity
    }
    
    /// Returns filtered fire incidents addressed based on the selected severity.
    /// If no severity is selected, it returns all sorted by severity.
    var filteredFiresAddressed: [(String, Int)] {
        guard let selectedSeverity = selectedSeverity else {
            return fireReport?.firesAddressed.sorted { $0.key < $1.key } ?? []
        }
        return fireReport?.firesAddressed.filter { $0.key == selectedSeverity } ?? []
    }
}
