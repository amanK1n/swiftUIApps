//
//  UIUtilities.swift
//  AutoQA
//
//  Created by Sayed on 06/04/26.
//

import Foundation
import SwiftUI
internal import Combine
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

struct APIKeyPromptView: View {
    
    @Binding var isPresented: Bool
    @State private var enteredAPIKey: String = ""
    @Environment(\.openURL) var openURL
    var onSave: ((String) -> Void)?
    
    var body: some View {
        EmptyView()
            .alert("Enter API Key", isPresented: $isPresented) {
                
                TextField("API Key", text: $enteredAPIKey)
                
                Button("Save") {
                    if !enteredAPIKey.isEmpty {
                        onSave?(enteredAPIKey.trimmingCharacters(in: .whitespacesAndNewlines))
                    }
                }
                
                

                Button("Generate API Key") {
                    if let url = URL(string: "https://aistudio.google.com/api-keys") {
                        openURL(url)
                    }
                }
                
                Button("Cancel", role: .cancel) {}
            }
    }
}
 class ThemeManager: ObservableObject {
    enum AppTheme {
        case light, dark
    }

    @Published var theme: AppTheme = .light

    var colorScheme: ColorScheme {
        theme == .light ? .light : .dark
    }
}
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let r, g, b: UInt64
        switch hex.count {
        case 6: // RGB
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 1)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}

struct SparklingLogo: View {
    @State private var sparkle = false
    var systemScheme: ColorScheme
    
    var body: some View {
        ZStack {
            // Main logo
            Image(systemScheme == .dark ? "logo_white_text" : "logo_black_text")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 40)
                .shadow(color: .purple.opacity(0.7), radius: sparkle ? 20 : 5)
                .scaleEffect(sparkle ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: sparkle)
            
            // Sparkle overlay
            ForEach(0..<12, id: \.self) { i in
                Circle()
                    .fill(LinearGradient(colors: [.white, .purple, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 4, height: 4)
                    .opacity(sparkle ? 1 : 0)
                    .offset(x: CGFloat.random(in: -90...90), y: CGFloat.random(in: -40...40))
                    .animation(.easeInOut(duration: Double.random(in: 0.6...1.5)).repeatForever(autoreverses: true).delay(Double(i) * 0.1), value: sparkle)
            }
        }
        .onAppear {
            sparkle = true
        }
    }
}

struct SparklingLogo_Previews: PreviewProvider {
    static var previews: some View {
        SparklingLogo(systemScheme: .dark)
            .preferredColorScheme(.dark)
        SparklingLogo(systemScheme: .light)
            .preferredColorScheme(.light)
    }
}


struct ErrorPopupView: View {
    
    var title: String
    var message: String
    var buttonTitle: String = "OK"
    var onDismiss: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 16) {
            
            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
           
            Button(action: {
                onDismiss?()
            }) {
                Text(buttonTitle)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }.buttonStyle(.plain)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .frame(maxWidth: 400)
        .shadow(radius: 10)
        .padding()
    }
}
struct PopupModifier: ViewModifier {
    
    @Binding var isPresented: Bool
    var title: String
    var message: String
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                ErrorPopupView(
                    title: title,
                    message: message,
                    onDismiss: {
                        isPresented = false
                    }
                )
            }
        }
    }
}
