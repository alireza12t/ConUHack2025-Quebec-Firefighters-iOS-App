//
//  FireLoadingView.swift
//  Quebec Firefighters
//
//  Created by Alireza on 2/1/25.
//

import SwiftUI

struct FireLoadingView: View {
    @State private var gradientOffset: CGFloat = -1.0

    let animationDuration: Double = 1.2

    var body: some View {
        ZStack {
            // Background fire gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.gray.opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                // Static Fire Icon with Gradient Fill
                Image(systemName: "flame.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.red, .orange, .blue, .red]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .opacity(0.8)
                    )
                    .mask(
                        LinearGradient(
                            gradient: Gradient(colors: [.clear, .white, .clear]),
                            startPoint: UnitPoint(x: gradientOffset, y: 0.5),
                            endPoint: UnitPoint(x: gradientOffset + 1, y: 0.5)
                        )
                    )
                    .animation(Animation.linear(duration: animationDuration).repeatForever(autoreverses: true), value: gradientOffset)

                // Loading text
                Text("Processing Fire Report...")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
            }
        }
        .onAppear {
            startColorAnimation()
        }
    }

    private func startColorAnimation() {
        gradientOffset = 1.0
    }
}

#Preview {
    FireLoadingView()
}
