//
//  FireReportPopup.swift
//  Quebec Firefighters
//
//  Created by Alireza on 2/1/25.
//

//
//  FireReportPopup.swift
//  Quebec Firefighters
//
//  Created by Alireza on 2/1/25.
//

import SwiftUI

struct FireReportPopup: View {
    let severity: String
    let addressed: Int
    let delayed: Int
    let total: Int
    @Binding var showPopup: Bool
    var backgroundColor: Color
    
    init(severity: String, addressed: Int, delayed: Int, total: Int, showPopup: Binding<Bool>) {
        self.severity = severity
        self.addressed = addressed
        self.delayed = delayed
        self.total = total
        self._showPopup = showPopup
        #if os(iOS)
        self.backgroundColor = UIColor.systemGroupedBackground.swiftUIColor
        #else
        self.backgroundColor = NSColor.controlBackgroundColor.swiftUIColor
        #endif
    }

    var body: some View {
        ZStack {
            // Dimmed background effect
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    showPopup = false
                }

            VStack(spacing: 20) {
                Text(" \(severity.capitalized)" + LocalizationKeys.fireReport.localized)
                    .font(.title2)
                    .bold()

                HStack {
                    VStack {
                        Text(LocalizationKeys.addressedFire.localized)
                            .font(.headline)
                        Text("\(addressed)")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.green)
                    }
                    .frame(width: 100, height: 100)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(12)

                    VStack {
                        Text(LocalizationKeys.missedFire.localized)
                            .font(.headline)
                        Text("\(delayed)")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.red)
                    }
                    .frame(width: 100, height: 100)
                    .background(Color.red.opacity(0.2))
                    .cornerRadius(12)
                }

                Text(LocalizationKeys.totalFires.localized + " \(total)")
                    .font(.headline)
                    .foregroundColor(.orange)

                Button(action: {
                    showPopup = false
                }) {
                    Text(LocalizationKeys.close.localized)
                        .bold()
                        .padding()
                        .frame(width: 100)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            .background(
                Color(backgroundColor)
            )
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 2)
            )
            .shadow(radius: 10)
            .frame(maxWidth: 300)
        }
    }
}

#Preview {
    FireReportPopup(severity: "Medium", addressed: 12, delayed: 2, total: 14, showPopup: .constant(true))
}
