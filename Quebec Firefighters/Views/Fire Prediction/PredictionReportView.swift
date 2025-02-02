//
//  FirePredictionReportView.swift
//  Quebec Firefighters
//
//  Created by Alireza on 2/2/25.
//

import SwiftUI

// MARK: - PredictionReportView

/// The main view displaying the fire prediction report with a segmented control
/// to switch between a map view and a list view.
struct PredictionReportView: View {
    // The ViewModel provides prediction data.
    @ObservedObject var viewModel = FirePredictionsViewModel()
    
    // 0 for Map, 1 for List
    @State private var selectedView = 0
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    FireLoadingView()
                } else {
                    // Segmented control to select between map and list views.
                    Picker("Select View", selection: $selectedView) {
                        Text("List").tag(0)
                        Text("Map").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    // Display either the Map or the List view based on selection.
                    if selectedView == 1 {
                        // Map view fills the available space.
                        PredictionMapView(predictions: viewModel.predictions)
                            .edgesIgnoringSafeArea(.bottom)
                    } else {
                        // List view displays predictions in a scrollable list.
                        PredictionListView(predictions: viewModel.predictions)
                    }
                }
            }
            .onAppear() {
                viewModel.onAppear()
            }
        }
        .navigationTitle("Fire Predictions")
    }
}

#Preview {
    PredictionReportView()
}
