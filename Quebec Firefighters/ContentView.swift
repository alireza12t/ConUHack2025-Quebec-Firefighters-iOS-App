//
//  ContentView.swift
//  Quebec Firefighters
//
//  Created by Alireza on 2/1/25.
//

import SwiftUI

/// Main app structure with a TabView containing the CSVReaderView and PredictionReportView.
/// The TabView’s tab bar is styled with a background color and corner radius.
struct ContentView: View {
    // Configure the UITabBar appearance once when this view is initialized.
    init() {
        #if os(iOS)
        // Create a new appearance instance.
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // Set a background color with some opacity.
        appearance.backgroundColor = UIColor.systemBackground

        // Apply the customized appearance.
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        
        // Attempt to add corner radius to the tab bar.
        UITabBar.appearance().layer.cornerRadius = 16
        UITabBar.appearance().layer.masksToBounds = true
        #endif
    }
    
    var body: some View {
        TabView {
            CSVReaderView()
                .tabItem {
                    Label(LocalizationKeys.unitDeployment.localized, systemImage: "shield.fill")
                }
            
            PredictionReportView()
                .tabItem {
                    Label(LocalizationKeys.predictions.localized, systemImage: "flame.fill")
                }
        }
    }
}

#Preview {
    ContentView()
        .environment(\.locale, .init(identifier: "fr"))
}
