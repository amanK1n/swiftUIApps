//
//  UIUtilities.swift
//  AutoQA
//
//  Created by Sayed on 06/04/26.
//

import Foundation
import SwiftUI
struct AILoaderView: View {

    @State private var animate = false
    @State private var currentIndex = 0

        private let messages = [
            "AI is thinking...",
        ]
    var body: some View {
        
        ZStack {
            // Background blur
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                
                // Animated glowing ring
                ZStack {
                    Circle()
                        .stroke(Color.black.opacity(0.3), lineWidth: 8)
                        .frame(width: 70, height: 70)
                    Text("AiDG")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 70, height: 70) // 👈 keeps it inside
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.5)
                            .shadow(color: .white, radius: animate ? 6 : 2)
                            .shadow(color: .orange, radius: animate ? 10 : 4)
                            .scaleEffect(animate ? 1.05 : 0.95)
                            .animation(
                                .easeInOut(duration: 1).repeatForever(autoreverses: true),
                                value: animate
                            )
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [Color.indigo ,.blue, .cyan, .white],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 70, height: 70)
                        .rotationEffect(.degrees(animate ? 360 : 0))
                        .animation(
                            .linear(duration: 1)
                            .repeatForever(autoreverses: false),
                            value: animate
                        )
                }
               
                // AI text with pulse
                Text(messages[currentIndex])
                    .font(.headline)
                    .foregroundColor(.white)
                    .opacity(animate ? 1 : 0.5)
                    .id(currentIndex)
                    .animation(
                        .easeInOut,
                        value: currentIndex
                    )
            }
            .padding(30)
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .shadow(radius: 20)
        }
        .onAppear {
            animate = true
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
                currentIndex = (currentIndex + 1) % messages.count
            }
        }
    }
}
