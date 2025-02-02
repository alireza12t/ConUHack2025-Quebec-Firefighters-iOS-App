//
//  CSVProcessor.swift
//  Quebec Firefighters
//
//  Created by Alireza on 2/1/25.
//

import Foundation

// MARK: - CSV Parsing Errors

enum CSVError: Error, LocalizedError {
    case emptyFile
    case invalidRow(row: Int, expected: Int, found: Int)
    
    var errorDescription: String? {
        switch self {
        case .emptyFile:
            return LocalizationKeys.csvEmpty.localized
        case .invalidRow(let row, let expected, let found):
            return "Row \(row) has \(found) columns; expected \(expected)."
        }
    }
}

// MARK: - CSV Processor Errors

enum CSVProcessorError: Error, LocalizedError {
    case fileAccessDenied
    
    var errorDescription: String? {
        switch self {
        case .fileAccessDenied:
            return LocalizationKeys.permissionDenied.localized
        }
    }
}

// MARK: - CSVProcessor

/// A singleton class that processes CSV files and converts them to JSON data.
/// This processor uses a custom parser that supports CSV fields enclosed in quotes
/// (allowing commas within fields).
final class CSVProcessor {
    
    /// Shared instance of CSVProcessor.
    static let shared = CSVProcessor()
    
    /// Private initializer to enforce singleton usage.
    private init() { }
    
    /// Processes a CSV file from the given URL and returns JSON data.
    ///
    /// - Parameter url: The URL of the CSV file.
    /// - Throws: A `CSVProcessorError` or `CSVError` if something goes wrong.
    /// - Returns: A JSON-encoded `Data` object representing the CSV records.
    func processCSV(from url: URL) async throws -> Data {
        // Check file access.
        guard checkFileAccess(for: url) else {
            throw CSVProcessorError.fileAccessDenied
        }
        
        // Read CSV content.
        let content = try String(contentsOf: url, encoding: .utf8)
        
        // Parse CSV content into an array of dictionaries.
        let records = try parseCSV(content: content)
        
        // Convert records to JSON data.
        let jsonData = try JSONSerialization.data(withJSONObject: records, options: .prettyPrinted)
        return jsonData
    }
    
    // MARK: - Private Helper Methods
    
    /// Checks if the app has access to the file at the specified URL.
    private func checkFileAccess(for url: URL) -> Bool {
        // Begin security scoped access if needed.
        return url.startAccessingSecurityScopedResource()
    }
    
    /// Parses CSV content into an array of dictionaries.
    ///
    /// Each dictionary corresponds to a row where keys are derived from the header row.
    private func parseCSV(content: String) throws -> [[String: String]] {
        // Split content into non-empty lines.
        let lines = content.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        // Ensure there is at least one header row.
        guard let headerLine = lines.first else {
            throw CSVError.emptyFile
        }
        
        let headers = parseCSVLine(headerLine).map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        
        var records = [[String: String]]()
        
        // Process each subsequent data row.
        for (index, line) in lines.dropFirst().enumerated() {
            let values = parseCSVLine(line).map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            guard values.count == headers.count else {
                throw CSVError.invalidRow(row: index + 2, expected: headers.count, found: values.count)
            }
            let record = Dictionary(uniqueKeysWithValues: zip(headers, values))
            records.append(record)
        }
        
        return records
    }
    
    /// Parses a single CSV line into an array of field values.
    ///
    /// This parser supports fields enclosed in quotes so that commas inside quoted
    /// fields are not treated as delimiters. Double quotes inside a quoted field are
    /// interpreted as an escaped quote.
    private func parseCSVLine(_ line: String) -> [String] {
        var fields: [String] = []
        var currentField = ""
        var insideQuotes = false
        let characters = Array(line)
        var i = 0
        
        while i < characters.count {
            let char = characters[i]
            if char == "\"" {
                if insideQuotes {
                    // Look ahead: if next char is also a quote, it's an escaped quote.
                    if i + 1 < characters.count && characters[i + 1] == "\"" {
                        currentField.append("\"")
                        i += 1
                    } else {
                        insideQuotes = false
                    }
                } else {
                    insideQuotes = true
                }
            } else if char == "," && !insideQuotes {
                // Field delimiter found.
                fields.append(currentField)
                currentField = ""
            } else {
                currentField.append(char)
            }
            i += 1
        }
        // Append the final field.
        fields.append(currentField)
        return fields
    }
}
