//
//  AIAgent.swift
//  AutoQA
//
//  Created by Sayed on 02/04/26.
//

import Foundation
import AppKit
internal import Combine
enum AgentAction {
    case generate
    case export
    case done
}

class AIAgent: ObservableObject {
   

    @Published var testCases: [TestCase] = []
    var screenshots: [ScreenshotItem] = []
    var featureName: String = ""
    var isLoading: ((Bool) -> Void)?
    var running = true
    var hasGenerated = false
    init() {}
    func decide() -> AgentAction {
        if !hasGenerated {
            return .generate
        } else {
            return .export
        }
    }

    func run() {
        Task {
            let action = decide()
            print("action::", action)
            print("hasGenerated::", hasGenerated)
            switch action {
            case .generate:
                isLoading?(true)
                await generateTestCases()
            case .export:
                if !testCases.isEmpty {
                    exportCSV()
                    running = false
                } else {
                    try? await Task.sleep(nanoseconds: 200_000_000)
                }
            case .done:
                running = false
            }
        }
    }

    // MARK: - Gemini Call

    func generateTestCases() async {
        guard !hasGenerated else { return }
        guard !screenshots.isEmpty else { return }

        let apiKey = ""

        let imagesPayload: [[String: Any]] = screenshots.compactMap { item -> [[String: Any]]? in
            guard let base64 = imageToBase64(item.image) else { return nil }
            return [
                ["text": item.description.isEmpty ? "Analyze screen" : item.description],
                ["inline_data": ["mime_type": "image/png", "data": base64]]
            ]
        }.flatMap { $0 }
        let descriptions = screenshots.map { $0.description }.joined(separator: "\n")
        
        let prompt = """
        You are a QA AI Agent.
        Generate test cases in JSON format.
        Feature: \(featureName)
        Descriptions: \(descriptions)
        Return output strictly in JSON array format:
        "title" should contain title ONLY, NOT type(positive/negative/edge)
        [
         {
           "title": "",
           "steps": "",
           "expectedResult": "",
           "type": "positive/negative/edge"
         }
        ]
        """

        let body: [String: Any] = [
            "contents": [[
                "parts": [["text": prompt]] + imagesPayload
            ]]
        ]

        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-pro:generateContent?key=\(apiKey)") else { return }
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 120   // 2 minutes
        config.timeoutIntervalForResource = 180  // 3 minutes
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        do {
            let session = URLSession(configuration: config)
            let (data, response) = try await session.data(for: request)
            print("FETCHED DATA:++LL")
            dump(data)
            if let httpResponse = response as? HTTPURLResponse {
                    if !(200...299).contains(httpResponse.statusCode) {
                        isLoading?(false)
                        print("❌ HTTP Error:", httpResponse.statusCode)
                        print(String(data: data, encoding: .utf8) ?? "")
                        return
                    }
                }
            if let text = parseGeminiResponse(data: data) {
                print("Enter to parse")
                await parseTestCases(text)
            }
            isLoading?(false)
            hasGenerated = true
            var memory = MemoryManager.shared.load()
            memory.logs.append("Generated at \(Date())")
            MemoryManager.shared.save(memory)
            
        } catch {
            print("Error:", error)
        }
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

    func parseTestCases(_ jsonString: String) async {
        print("Inside parse testcases##$$")
        let cleaned = jsonString
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard let data = cleaned.data(using: .utf8),
              let decoded = try? JSONDecoder().decode([TestCase].self, from: data) else {
            print("Decode failed")
            return
        }

        DispatchQueue.main.async {
            print("added testcases##$$")
            self.testCases = decoded
            print("ROW#::")
            print(self.testCases.count)
            self.exportCSV()
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

    // MARK: - CSV Export
    func escapeCSV(_ text: String) -> String {
        var escaped = text.replacingOccurrences(of: "\"", with: "\"\"")
        return "\"\(escaped)\""
    }
    func exportCSV() {
        var csv = "Title,Steps,Expected Result,Type\n"
        print("ROW#::ExportCSSVV--")
        print(self.testCases.count)
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
