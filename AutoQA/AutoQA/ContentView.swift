//
//  ContentView.swift
//  AutoQA
//
//  Created by Sayed on 27/03/26.
//


import SwiftUI
internal import UniformTypeIdentifiers

struct ContentView: View {
    @State private var featureName: String = ""
    @State private var screenshots: [ScreenshotItem] = []
    @State private var isLoading = false
    @State private var testCases: [TestCase] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("AI Test Case Generator")
                .font(.largeTitle)
                .bold()

            TextField("Feature / Module Name (Optional)", text: $featureName)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Upload Screenshots") {
                openImagePicker()
            }

            ScrollView(.horizontal) {
                HStack {
                    ForEach($screenshots) { $item in
                        VStack {
                            
                            ZStack(alignment: .topTrailing) {
                                Image(nsImage: item.image)
                                    .resizable()
                                    .frame(width: 150, height: 100)
                                    .cornerRadius(8)

                                Button(action: {
                                    removeScreenshot(item)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                        .background(Color.white.clipShape(Circle()))
                                }
                                .buttonStyle(PlainButtonStyle())
                                .offset(x: 8, y: -8)
                            }

                            TextField("Description (Optional)", text: $item.description)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 150)
                        }
                    }
                }
            }
            

            Button(action: generateTestCases) {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Generate Test Cases")
                }
            }
            .disabled(isLoading)

            List(testCases) { test in
                VStack(alignment: .leading) {
                    Text(test.title).bold()
                    Text("Steps: \(test.steps)")
                    Text("Expected: \(test.expectedResult)")
                    Text("Type: \(test.type)")
                }
            }

            Button("Export to Excel") {
                exportToCSV()
            }
            .disabled(testCases.isEmpty)

        }
        .padding()
        .frame(width: 900, height: 600)
    }
    func removeScreenshot(_ item: ScreenshotItem) {
        screenshots.removeAll { $0.id == item.id }
    }
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
    func imageToBase64(_ image: NSImage) -> String? {
        guard let tiffData = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let pngData = bitmap.representation(using: .png, properties: [:]) else {
            return nil
        }
        return pngData.base64EncodedString()
    }
    func generateTestCases() {
        isLoading = true
        
        let apiKey = "your_api_key"
        // After scanning is done from accurascan, this page will be filled with user data and doc images
        //        let imagesPayload = screenshots.compactMap { item -> [String: Any]? in
        //            guard let base64 = imageToBase64(item.image) else { return nil }
        //
        //            return [
        //
        //                "inline_data": [
        //                    "mime_type": "image/png",
        //                    "data": base64
        //                ]
        //            ]
        //        }
        
        let imagesPayload: [[String: Any]] = screenshots.compactMap { item -> [[String: Any]]? in
            guard let base64 = imageToBase64(item.image) else { return nil }
            
            return [
                [
                    "text": item.description.isEmpty
                    ? "Analyze this screen and generate test cases."
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
        
        
        
        
        
        
        
        let descriptions = screenshots.map { $0.description }.joined(separator: "\n")
        
        let prompt = """
        Generate exhaustive QA test cases for the given feature.
        
        Feature: \(featureName)
        
        Descriptions:
        \(descriptions)
        
        Return output strictly in JSON array format:
        [
          {
            "title": "",
            "steps": "",
            "expectedResult": "",
            "type": "positive/negative/edge"
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
    

    func parseTestCases(_ jsonString: String) {
        let cleaned = jsonString
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard let data = cleaned.data(using: .utf8),
              let decoded = try? JSONDecoder().decode([TestCase].self, from: data) else {
            print("❌ Decoding failed")
            print(cleaned)
            return
        }

        DispatchQueue.main.async {
            self.testCases = decoded
        }
    }
    func escapeCSV(_ text: String) -> String {
        var escaped = text.replacingOccurrences(of: "\"", with: "\"\"")
        return "\"\(escaped)\""
    }

    func exportToCSV() {
        var csv = "Title,Steps,Expected Result,Type\n"

        for test in testCases {
            let title = escapeCSV(test.title)
            
            let stepsFormatted = test.steps.replacingOccurrences(of: "\n", with: "\r\n")
            let expectedFormatted = test.expectedResult.replacingOccurrences(of: "\n", with: "\r\n")

            let steps = escapeCSV(stepsFormatted)
            let expected = escapeCSV(expectedFormatted)
            let type = escapeCSV(test.type)

            csv += "\(title),\(steps),\(expected),\(type)\n"
        }

        let savePanel = NSSavePanel()
        savePanel.nameFieldStringValue = "TestCases.csv"

        if savePanel.runModal() == .OK {
            do {
                try csv.write(to: savePanel.url!, atomically: true, encoding: .utf8)
            } catch {
                print("❌ Failed to save CSV:", error)
            }
        }
    }
}

#Preview {
    ContentView()
}
