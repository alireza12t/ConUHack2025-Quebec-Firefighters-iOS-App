//
//  LocalizationKeys.swift
//  Quebec Firefighters
//
//  Created by Alireza on 2/2/25.
//

import Foundation

final class LocalizationKeys {
    static let predictions = "predictions"
    static let unitDeployment = "unit_deployment"
    
    static let addressed = "addressed"
    static let missed = "missed"
    static let severity = "severity" // Use once even if you need it in multiple places.
    static let total = "total"
    static let type = "type"
    static let value = "value"
    
    static let csvEmpty = "csv_empty"
    static let csvRowError = "csv_row_error"
    static let permissionDenied = "permission_denied"
    
    static let fireReport = "fire_report"         // e.g. "%@ Fire Report"
    static let totalFires = "total_fires"           // e.g. "🔥 Total Fires: %d"
    
    static let addressedFire = "addressed_fire"     // e.g. "✅ Addressed"
    static let missedFire = "missed_fire"           // e.g. "🚨 Missed"
    static let close = "close"
    
    static let firesBySeverity = "fires_by_severity"
    static let noDataAvailable = "no_data_available"
    static let fireResponseReport = "fire_response_report"
    static let generalStatistics = "general_statistics"
    
    static let totalFiresAddressed = "total_fires_addressed" // "Total Fires Addressed: %d"
    static let totalFiresDelayed = "total_fires_delayed"       // "Total Fires Delayed: %d"
    static let totalFiresNoEmojie = "total_fires_no_emojie"                      // "Total Fires: %d"
    static let operationalCosts = "operational_costs"          // "Operational Costs: $%.2f"
    static let damageCosts = "damage_costs"                    // "Damage Costs: $%.2f"

    static let uploadCSVFile = "upload_csv_file"
    static let uploadCSVDescription = "upload_csv_description"
    static let inputMethod = "input_method" // used in multiple places
    static let deployingUnits = "deploying_units"
    static let enterFileURL = "enter_file_url"
    static let uploadFromFiles = "upload_from_files"
    static let failedToLoadFile = "failed_to_load_file"
    
    // Permission related keys
    static let permissionRequired = "permission_required"
    static let permissionDeniedMessage = "permission_denied_message"
    static let openSettings = "open_settings"
    
    static let file = "file"
    static let link = "link"
    static let load = "load"
    
    static let fetchingAddress = "fetching_address"
    static let addressNotAvailable = "address_not_available"
    static let location = "location"
    static let probability = "probability"

    static let fetchingFirePredictions = "fetching_fire_predictions"
    static let selectView = "select_view"
    static let list = "list"
    static let map = "map"
    static let firePredictions = "fire_predictions"
    static let time = "time"
}
