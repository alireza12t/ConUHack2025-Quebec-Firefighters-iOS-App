//
//  CSVReaderView.swift
//  Quebec Firefighters
//
//  Created by Alireza on 2/1/25.
//

import SwiftUI
import UniformTypeIdentifiers

import SwiftUI
import UniformTypeIdentifiers

struct CSVReaderView: View {
    @StateObject private var viewModel = CSVReaderViewModel()
    @State private var showFilePicker = false
    @State private var urlInput: String = ""
    @State private var navigateToFireReport = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    FireLoadingView()
                } else if let fireReport = viewModel.fireReport {
                    NavigationLink(
                        destination: FireReportView(viewModel: FireReportViewModel(fireReport: fireReport))
                            .onDisappear {
                                // Reset fireReport when navigating back
                                viewModel.fireReport = nil
                                navigateToFireReport = false
                            },
                        isActive: $navigateToFireReport
                    ) { EmptyView() }
                    .hidden()
                    .onAppear {
                        navigateToFireReport = true
                    }
                } else {
                    Text("Upload CSV File")
                        .font(.title2)
                        .bold()

                    HStack {
                        urlTextField

                        loadFromLinkButton
                    }
                    
                    uploadFromFileButton

                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }

                    Spacer()
                }
            }
            .padding()
            .navigationTitle("CSV Reader")
            .alert(isPresented: $viewModel.showSettingsAlert) {
                openSettingsAlert
            }
        }
    }
    
    var urlTextField: some View {
        TextField("Enter file URL", text: $urlInput)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
    }
    
    var loadFromLinkButton: some View {
        Button("Load") {
            if let url = URL(string: urlInput) {
                Task {
                    await viewModel.processCSV(from: url)
                }
            }
        }
        .buttonStyle(.borderedProminent)
    }
    
    var openSettingsAlert: Alert {
        Alert(
            title: Text("Permission Required"),
            message: Text("This app does not have permission to access the file. Please enable file access in Settings."),
            primaryButton: .default(Text("Open Settings")) {
                viewModel.openSettings()
            },
            secondaryButton: .cancel()
        )
    }
    
    var uploadFromFileButton: some View {
        Button("Upload from Files") {
            showFilePicker.toggle()
        }
        .buttonStyle(.bordered)
        .fileImporter(isPresented: $showFilePicker, allowedContentTypes: [UTType.commaSeparatedText]) { result in
            switch result {
            case .success(let url):
                Task {
                    await viewModel.processCSV(from: url)
                }
            case .failure:
                DispatchQueue.main.async {
                    viewModel.errorMessage = "Failed to load file."
                }
            }
        }
    }
}

#Preview {
    CSVReaderView()
}
