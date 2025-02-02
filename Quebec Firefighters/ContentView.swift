//
//  ContentView.swift
//  Quebec Firefighters
//
//  Created by Alireza on 2/1/25.
//

import SwiftUI

/// Main app structure with a TabView containing the CSVReaderView.
struct ContentView: View {
    var body: some View {
        TabView {
            CSVReaderView()
                .tabItem {
                    Label("CSV Reader", systemImage: "doc.text.magnifyingglass")
                }
        }
    }
}

#Preview {
    ContentView()
}
