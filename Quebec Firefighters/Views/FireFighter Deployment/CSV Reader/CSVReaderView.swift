//
//  CSVReaderView.swift
//  Quebec Firefighters
//
//  Created by Alireza on 2/1/25.
//

import SwiftUI
import UniformTypeIdentifiers

enum InputMethod: String, CaseIterable, Identifiable {
    case file = "file"
    case link = "link"
    
    var localizedDescription: String {
        self.rawValue.localized
    }

    var id: Self { self }
}

struct CSVReaderView: View {
    @StateObject private var viewModel = CSVReaderViewModel()
    @State private var showFilePicker = false
    @State private var urlInput: String = ""
    @State private var navigateToFireReport = false
    @State private var selectedInputMethod: InputMethod = .file

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    FireLoadingView(loadingText: .constant(LocalizationKeys.deployingUnits.localized))
                } else if let fireReport = viewModel.fireReport {
                    NavigationLink(
                        destination: FireReportView(viewModel: FireReportViewModel(fireReport: fireReport))
                            .onDisappear {
                                // Reset fireReport when navigating back
                                viewModel.fireReport = nil
                                navigateToFireReport = false
                            },
                        isActive: $navigateToFireReport
                    ) {
                        EmptyView()
                    }
                    .hidden()
                    .onAppear {
                        navigateToFireReport = true
                    }
                } else {
                    Text(LocalizationKeys.uploadCSVFile.localized)
                        .font(.title2)
                        .bold()
                    
                    Text(LocalizationKeys.uploadCSVDescription.localized)
                        .font(.body)
                    
                    // Picker to switch between Link and File input methods
                    Picker(LocalizationKeys.inputMethod.localized, selection: $selectedInputMethod) {
                        ForEach(InputMethod.allCases) { method in
                            Text(method.localizedDescription).tag(method)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    // Show different views depending on the selected input method
                    if selectedInputMethod == .link {
                        linkInputView
                    } else {
                        fileInputView
                    }
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                }
            }
            .padding()
            .navigationTitle(LocalizationKeys.unitDeployment.localized)
            .alert(isPresented: $viewModel.showSettingsAlert) {
                openSettingsAlert
            }
        }
    }
    
    // MARK: - Subviews

    private var linkInputView: some View {
        VStack(spacing: 10) {
            TextField(LocalizationKeys.enterFileURL.localized, text: $urlInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button(LocalizationKeys.load.localized) {
                if let url = URL(string: urlInput) {
                    Task {
                        await viewModel.processCSV(from: url)
                    }
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    private var fileInputView: some View {
        Button(LocalizationKeys.uploadFromFiles.localized) {
            showFilePicker.toggle()
        }
        .buttonStyle(.bordered)
        .fileImporter(isPresented: $showFilePicker,
                      allowedContentTypes: [UTType.commaSeparatedText]) { result in
            switch result {
            case .success(let url):
                Task {
                    await viewModel.processCSV(from: url)
                }
            case .failure:
                DispatchQueue.main.async {
                    viewModel.errorMessage = LocalizationKeys.failedToLoadFile.localized
                }
            }
        }
    }
    
    private var openSettingsAlert: Alert {
        Alert(
            title: Text(LocalizationKeys.permissionRequired.localized),
            message: Text(LocalizationKeys.permissionDeniedMessage.localized),
            primaryButton: .default(Text(LocalizationKeys.openSettings.localized)) {
                viewModel.openSettings()
            },
            secondaryButton: .cancel()
        )
    }
}

#Preview {
    CSVReaderView()
}
