//
//  UIExtension.swift
//  RMAMaker
//
//  Created by Sayed on 19/03/26.
//

import SwiftUI
import SwiftUI
import SceneKit
struct MainContentView: View {
    
    @Binding var requestJSON: String
    @Binding var responseJSON: String
    
    var body: some View {
        HStack(spacing: 12) {
            
            Button {
                if !requestJSON.isEmpty {
                    let cleaned = MainContentView.normalizeQuotes(requestJSON)
                    requestJSON = beautifyJSON(cleaned)
                }
                if !responseJSON.isEmpty {
                    let cleaned = MainContentView.normalizeQuotes(responseJSON)
                    responseJSON = beautifyJSON(cleaned)
                }
            } label: {
                Label("Beautify All", systemImage: "sparkles")
                    .font(.custom("Roboto-Regular", size: 18))
            }
        }
    }
    public static func normalizeQuotes(_ text: String) -> String {
          return text
              .replacingOccurrences(of: "“", with: "\"")
              .replacingOccurrences(of: "”", with: "\"")
              .replacingOccurrences(of: "‘", with: "'")
              .replacingOccurrences(of: "’", with: "'")
      }
    func beautifyJSON(_ jsonString: String) -> String {
        guard let data = jsonString.data(using: .utf8) else { return jsonString }
        
        do {
            let object = try JSONSerialization.jsonObject(with: data, options: [])
            let prettyData = try JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted])
            return String(data: prettyData, encoding: .utf8) ?? jsonString
        } catch {
            return "❌ Invalid JSON\n\(error.localizedDescription)"
        }
    }
}

struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.system(size: 13, weight: .medium))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)
            .cornerRadius(8)
            .shadow(radius: 4)
    }
}
struct AIBadgeView: View {
    
    @State private var glow = false
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "sparkles")
            Text("AI Enabled")
                .font(.caption)
                .bold()
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.blue.opacity(glow ? 0.9 : 0.3), lineWidth: 1.5)
                .shadow(color: Color.blue.opacity(glow ? 0.8 : 0.2), radius: glow ? 8 : 2)
        )
        .scaleEffect(glow ? 1.03 : 1.0)
        .animation(
            .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
            value: glow
        )
        .onAppear {
            glow.toggle()
        }
    }
}

public struct ActionButtonsView: View {
    @Binding var rootName: String
    @Binding var outputCode: String
    @Binding var requestJSON: String
    @Binding var responseJSON: String
    @Binding var aiAnalysisResult: String
    @Binding var isLoading: Bool
    @Binding var folderURL: URL?
    private let service = GeminiService()
    @State private var showToast = false
    public var body: some View {
        // MARK: - Action Buttons

            HStack(spacing: 12) {
                
                Button(action: {generateAndSaveFiles(requestJSON: requestJSON,
                                                     responseJSON: responseJSON,
                                                     outputCode: &outputCode,
                                                     rootName: rootName,
                                                     folderURL: &folderURL)}
                       
                       
                ) {
                    Label("Generate & Save", systemImage: "gearshape.fill")
                        .padding(.horizontal)
                        .font(.custom("Roboto-Regular", size: 18))
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(hex: "#08F177"))
                
                Button {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(outputCode, forType: .string)
                } label: {
                    Label("Copy", systemImage: "doc.on.doc")
                        .font(.custom("Roboto-Regular", size: 18))
                }
                
                Divider().frame(height: 20)
                
                
                
                ZStack {
                    HStack(spacing: 16) {
                        Button {
                            guard !responseJSON.isEmpty else {
                                aiAnalysisResult = "Please enter JSON"
                                return
                            }
                            isLoading = true
                            aiAnalysisResult = ""
                            
                            service.analyzeJSON(input: responseJSON) { response in
                                DispatchQueue.main.async {
                                    self.aiAnalysisResult = response
                                    self.isLoading = false
                                }
                            }
                        } label: {
                            Label("Analyze JSON", systemImage: "brain")
                                .frame(width: 150)
                                .font(.custom("Roboto-Regular", size: 18))
                        }
                        .disabled(isLoading)
                        if !aiAnalysisResult.isEmpty {
                            ZStack(alignment: .topTrailing) {
                                
                                ScrollView {
                                    Text(aiAnalysisResult)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .multilineTextAlignment(.leading)
                                        .font(.system(.body, design: .monospaced))
                                        .padding()
                                }
                                .frame(maxWidth: .infinity, minHeight: 100) // ✅ KEY FIX
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.blue.opacity(0.08))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.blue.opacity(0.3))
                                )
                                
                                HStack {
                                    Button(action: {
                                        NSPasteboard.general.clearContents()
                                        NSPasteboard.general.setString(aiAnalysisResult, forType: .string)
                                        withAnimation {
                                            showToast = true
                                        }
                                        
                                        // Hide after 2 sec
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            withAnimation {
                                                showToast = false
                                            }
                                        }
                                    }) {
                                        Image(systemName: "doc.on.doc")
                                            .padding(8)
                                    }
                                    
                                    Button {
                                        withAnimation {
                                            aiAnalysisResult = ""
                                        }
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                            .background(Color.white.clipShape(Circle()))
                                    }
                                    .buttonStyle(.plain)
                                    .padding(8)
                                }
                                
                            }
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, minHeight: 100) // ✅ VERY IMPORTANT
                    .padding()
                    .blur(radius: isLoading ? 3 : 0)
                    .disabled(isLoading)
                    if showToast {
                        
                        VStack {
                            Spacer()
                            ToastView(message: "Copied AI generated content!")
                                
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                }
                .animation(.easeInOut, value: isLoading)
                Button {
                    // Future AI optimization
                } label: {
                    Label("Optimize Models", systemImage: "sparkles")
                        .font(.custom("Roboto-Regular", size: 18))
                }
                
                Spacer()
            }
            
        
    }
}

public func generateAndSaveFiles(requestJSON: String, responseJSON: String, outputCode: inout String, rootName: String, folderURL: inout URL?) {
    let requestCleaned = MainContentView.normalizeQuotes(requestJSON)
    let responseCleaned = MainContentView.normalizeQuotes(responseJSON)
    
    guard let requestData = requestCleaned.data(using: .utf8),
          let responseData = responseCleaned.data(using: .utf8) else {
        outputCode = "Invalid JSON Encoding"
        return
    }

    do {
        let requestObj: Any?
        let responseObj: Any

        // Handle request (optional)
        if requestJSON.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            requestObj = nil
        } else {
            requestObj = try JSONSerialization.jsonObject(with: requestData)
        }

        // Handle response (mandatory)
        responseObj = try JSONSerialization.jsonObject(with: responseData)

        
        let responseGenerator = ResponseModelGenerator()
        let uiGenerator = UIModelGenerator()
        let requestGenerator = RequestModelGenerator()
        let viewModelGenerator = ViewModelGenerator()

        let responseCode = responseGenerator.generateModels(from: responseObj, rootName: rootName)
        let uiCode = uiGenerator.generateModels(from: responseObj, rootName: rootName)
       
        
        let requestCode: String
        if let requestObj = requestObj {
            requestCode = requestGenerator.generateRequestModel(from: requestObj, rootName: rootName)
        } else {
            requestCode = requestGenerator.generateGetAPI(rootName: rootName)
        }
        
        
        let viewModelCode = viewModelGenerator.generateViewModel(
            requestJSON: requestObj,
            responseJSON: responseObj,
            rootName: rootName
        )

        // 👇 Ask user where to save
        let panel = NSOpenPanel()
        panel.title = "Select Folder to Save Files"
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false

        if panel.runModal() == .OK, let selectedURL = panel.url {
            // 🔐 START secure access
            guard selectedURL.startAccessingSecurityScopedResource() else {
                outputCode = "Permission denied"
                return
            }
            
            defer {
                selectedURL.stopAccessingSecurityScopedResource()
            }
             folderURL = selectedURL.appendingPathComponent("\(rootName)-rma")
            
            let fileManager = FileManager.default
            
            if !fileManager.fileExists(atPath: folderURL?.path ?? "") {
                try fileManager.createDirectory(at: folderURL ?? URL(fileURLWithPath: ""), withIntermediateDirectories: true)
            }
            
            // Headers
            let responseHeader = generateFileHeader(fileName: "\(rootName)ResponseModel")
            let dataUIModelHeader = generateFileHeader(fileName: "\(rootName)DataUIModel")
            let requestHeader = generateFileHeader(fileName: "\(rootName)RequestModel")
            let viewModelHeader = generateFileHeader(fileName: "\(rootName)ViewModel")
            
            // File URLs
            let responseFileURL = folderURL?.appendingPathComponent("\(rootName)ResponseModel.swift") ?? URL(fileURLWithPath: "")
            let dataUIModelFileURL = folderURL?.appendingPathComponent("\(rootName)DataUIModel.swift") ?? URL(fileURLWithPath: "")
            let requestFileURL = folderURL?.appendingPathComponent("\(rootName)RequestModel.swift") ?? URL(fileURLWithPath: "")
            let viewModelFileURL = folderURL?.appendingPathComponent("\(rootName)ViewModel.swift") ?? URL(fileURLWithPath: "")
            
            // Write files
            try (responseHeader + responseCode).write(to: responseFileURL, atomically: true, encoding: .utf8)
            try (dataUIModelHeader + uiCode).write(to: dataUIModelFileURL, atomically: true, encoding: .utf8)
            try (requestHeader + requestCode).write(to: requestFileURL, atomically: true, encoding: .utf8)
            try (viewModelHeader + viewModelCode).write(to: viewModelFileURL, atomically: true, encoding: .utf8)
            
            outputCode = "✅ Files saved successfully in \(folderURL?.path ?? "")"
        }

    } catch {
        outputCode = "Error: \(error.localizedDescription)"
    }
}
private func generateFileHeader(fileName: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    let dateString = formatter.string(from: Date())
    let userName = NSFullUserName()
    
    return """
    //
    //  \(fileName).swift
    //
    //  Created by \(userName) on \(dateString)
    //
    
    """
}


struct AILoaderView: View {

    @State private var animate = false
    @State private var currentIndex = 0

        private let messages = [
            "AI is thinking...",
            "Analyzing JSON...",
            "Almost there..."
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
