//
//  TestStepsGenerator.swift
//  AIQATestRunner
//
//  Created by Sayed on 26/04/26.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct TestStepsGenerator: View {
    @Binding var featureName: String
    @Binding var screenshots: [ScreenshotItem]
    @Binding var isLoading: Bool
    @Binding var testSteps: [TestStep]
    @Binding var flowDescription: String

    var body: some View {
        ZStack {
            VStack {
                TextField("Feature under Test", text: $featureName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Upload Screenshots") {
                    openImagePicker()
                }
                // Screenshot View START
                ScrollView(.horizontal) {
                    HStack {
                        ForEach($screenshots) { $item in
                            VStack {
                                
                                ZStack(alignment: .topTrailing) {
                                    Image(nsImage: item.image)
                                        .resizable()
                                        .frame(width: 100, height: 200)
                                        .cornerRadius(8)
                                        .border(.foreground, width: 2.0)
                                    
                                    Button(action: {
                                        removeScreenshot(item)
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.red)
                                            .background(Color.white.clipShape(Circle()))
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .offset(x: 8, y: 0)
                                }
                                
                                ZStack(alignment: .topLeading) {
                                    if item.description.isEmpty {
                                        Text("Description(Optional)")
                                            .foregroundColor(.gray)
                                            .padding(.top, 8)
                                            .padding(.leading, 2)
                                            .zIndex(1)
                                    }
                                    TextEditor(text: $item.description)
                                        .padding(8)
                                }
                                .frame(width: 150, height: 100)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.5))
                                )
                            }
                        }
                    }
                }// Screenshot View END
                
                // Generate button
                Button(action: generateTestCases) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Generate Test Steps")
                    }
                }
            }
        }
        
    }
    // To OPEN the image picker PANEL
    func openImagePicker() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.png, .jpeg]
        panel.allowsMultipleSelection = true

        if panel.runModal() == .OK {
            for url in panel.urls {
                if let img = NSImage(contentsOf: url) {
                    screenshots.append(ScreenshotItem(image: img, description: ""))
                }
            }
        }
    }
    // To DELETE the selected screenshot
    func removeScreenshot(_ item: ScreenshotItem) {
        screenshots.removeAll { $0.id == item.id }
    }
    
    // Online API Call FOR INFERENCE
    func generateTestCases() {
        isLoading = true
        
        let apiKey = "api_key"
       
        
        let imagesPayload: [[String: Any]] = screenshots.compactMap { item -> [[String: Any]]? in
            guard let base64 = imageToBase64(item.image) else { return nil }
            
            return [
                [
                    "text": item.description.isEmpty
                    ? "Analyze this screen and generate steps to complete flow."
                    : "Screen description: \(item.description)"
                ],
                [
                    "inline_data": [
                        "mime_type": "image/png",
                        "data": base64
                    ]
                ]
            ]
        }.flatMap { $0 }
        
        let descriptions = screenshots.enumerated().map { index, shot in
            "Screen \(index + 1): \(shot.description)"
        }.joined(separator: "\n")
        
        let prompt = """
        You are a mobile test automation expert.
        Your job is to analyze mobile app screenshots and generate sequential steps.
        COMMAND REFERENCE:
        - Tap <label>          → Tap a visible labeled element
        - Tap <label> <index>  → Tap when multiple elements share the same label (0-based index)
        - TapIcon <x%,y%>      → Tap an icon-only element with no readable label
        - Visible <label>      → Assert element is visible (use as screen boundary check)
        - Enter <value>        → Type into the currently focused input field
        - runflow <label>      → Conditional tap: only if element is visible
        
        RULES FOR OUTPUT:
        1. Output ONLY the steps, one per line. No explanation, no markdown, no numbering.
        2. Always insert a Visible <landmark> command when transitioning to a new screen.
        3. For input fields: always Tap the field first, then Enter the value on the next line.
        4. If multiple elements share the same label, use index (0-based): Tap Login 1
        5. For icon-only elements (no readable text), use TapIcon with percentage coordinates.
        6. Use runflow for elements that may or may not appear (conditional screens like Continue, Skip, Allow).
        7. Follow the logical order: fill all fields before tapping submit/login/confirm.
        8. Use the screen hints provided by the user to understand context and field meaning.
        
        Module under test: \(featureName)
        
        Screen Descriptions:
        \(descriptions)
        
        Return output strictly in JSON array format:
        [
          {
            "steps": ""
          }
        ]
        """
        
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt]
                    ] + imagesPayload
                ]
            ]
        ]
        
        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=\(apiKey)") else {
            return
        }
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 120   // 2 minutes
        config.timeoutIntervalForResource = 180  // 3 minutes

         
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        
        let session = URLSession(configuration: config)
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            if let error = error {
                print("❌ ERROR:", error.localizedDescription)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Status Code:", httpResponse.statusCode)
            }
            
            if let data = data {
                print("📦 Response:", String(data: data, encoding: .utf8) ?? "nil")
            }
            guard let data = data else { return }
            
            if let jsonString = parseGeminiResponse(data: data) {
                parseTestCases(jsonString)
            }
        }.resume()
    }
    
    // Encode image to Base64
    func imageToBase64(_ image: NSImage) -> String? {
        guard let tiffData = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let pngData = bitmap.representation(using: .png, properties: [:]) else {
            return nil
        }
        return pngData.base64EncodedString()
    }
// PARSE the RESPONSE of GEMINI
    func parseGeminiResponse(data: Data) -> String? {
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let candidates = json["candidates"] as? [[String: Any]],
              let content = candidates.first?["content"] as? [String: Any],
              let parts = content["parts"] as? [[String: Any]],
              let text = parts.first?["text"] as? String else {
            return nil
        }
        return text
    }
    // Clean the MESSY Strings
    func parseTestCases(_ jsonString: String) {
        let cleaned = jsonString
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard let data = cleaned.data(using: .utf8),
              let decoded = try? JSONDecoder().decode([TestStep].self, from: data) else {
            print("❌ Decoding failed")
            print(cleaned)
            return
        }

        DispatchQueue.main.async {
            self.testSteps = decoded
            let steps = decoded.map {
                $0.steps
            }.joined(separator: "\n")
            self.flowDescription = steps
        }
    }
}
