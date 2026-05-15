//
//  GeminiFlowGenerator.swift
//  AIQATestRunner
//
//  Created by Codex on 24/04/26.
//

import AppKit
import Foundation
import UniformTypeIdentifiers

enum FlowGenerationMode: String, CaseIterable, Identifiable {
    case online = "Online"
    case offline = "Offline"

    var id: String { rawValue }
}

enum FlowGenerationError: LocalizedError {
    case invalidResponse
    case emptyResponse
    case userCancelledSave

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Gemini returned an unexpected response. Please try again."
        case .emptyResponse:
            return "No Maestro YAML could be generated from the provided steps."
        case .userCancelledSave:
            return "The generated YAML was not saved."
        }
    }
}

func generateOnlineMaestroYAML(flowDescription: String, appId: String, apiKey: String) async throws -> String {
    let endpoint = "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=\(apiKey)"

    guard let url = URL(string: endpoint) else {
        throw URLError(.badURL)
    }

    let prompt = """
    Convert the following natural-language mobile test flow into valid Maestro YAML.

    STRICT REQUIREMENTS:
    - Return ONLY valid YAML. No markdown, no explanation, no comments.
    - YAML must be directly runnable in Maestro without modification.
    - Use EXACTLY this structure:

    appId: \(appId)
    ---
    - launchApp

    SUPPORTED COMMANDS ONLY:
    - launchApp
    - tapOn
    - inputText
    - assertVisible
    - scrollUntilVisible
    - swipe
    - back
    - extendedWaitUntil

    EXTRA RULES:
    - Use exactly this appId: \(appId)
    - Prefer visible text selectors.
    - After any inputText step, add a tapOn: "Done" step when it makes sense for mobile keyboard handling.

    User flow:
    \(flowDescription)
    """

    let requestBody = GeminiGenerateContentRequest(
        contents: [
            GeminiContent(parts: [GeminiPart(text: prompt)])
        ],
        generationConfig: GeminiGenerationConfig(
            temperature: 0.2
        )
    )

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try JSONEncoder().encode(requestBody)

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
        throw FlowGenerationError.invalidResponse
    }

    guard (200...299).contains(httpResponse.statusCode) else {
        let apiMessage = (try? JSONDecoder().decode(GeminiErrorResponse.self, from: data))?.error.message
        throw NSError(
            domain: "GeminiFlowGenerator",
            code: httpResponse.statusCode,
            userInfo: [
                NSLocalizedDescriptionKey: apiMessage ?? "Gemini request failed with status code \(httpResponse.statusCode)."
            ]
        )
    }

    let decodedResponse = try JSONDecoder().decode(GeminiGenerateContentResponse.self, from: data)

    let combinedText = decodedResponse.candidates?
        .compactMap { candidate in
            candidate.content?.parts?
                .compactMap(\.text)
                .joined(separator: "\n")
        }
        .joined(separator: "\n")
        .trimmingCharacters(in: .whitespacesAndNewlines)

    guard let combinedText, !combinedText.isEmpty else {
        throw FlowGenerationError.emptyResponse
    }

    let cleanedYAML = extractMaestroYAML(from: combinedText)

    guard !cleanedYAML.isEmpty else {
        throw FlowGenerationError.emptyResponse
    }

    return cleanedYAML
}

func generateOfflineMaestroYAML(flowDescription: String, appId: String) throws -> String {
    let steps = normalizedOfflineSteps(from: flowDescription)

    guard !steps.isEmpty else {
        throw FlowGenerationError.emptyResponse
    }

    var yamlSteps: [String] = [
//        "- launchApp",
//        "- waitForAnimationToEnd"
    ]

    for step in steps {
        yamlSteps.append(contentsOf: maestroCommands(for: step))
    }

    return """
    appId: \(appId)
    ---
    \(yamlSteps.joined(separator: "\n"))
    """
}

@MainActor
func saveGeneratedYAMLToUserSelectedLocation(_ yaml: String, suggestedFileName: String) throws -> URL {
    let savePanel = NSSavePanel()
    savePanel.title = "Save YAML"
    savePanel.message = "Choose a file name and folder for the generated Maestro flow."
    savePanel.nameFieldLabel = "Flow Name:"
    savePanel.nameFieldStringValue = "\(suggestedFileName).yaml"
    savePanel.canCreateDirectories = true
    savePanel.isExtensionHidden = false

    if let yamlType = UTType(filenameExtension: "yaml"),
       let ymlType = UTType(filenameExtension: "yml") {
        savePanel.allowedContentTypes = [yamlType, ymlType]
    }

    savePanel.directoryURL = defaultSaveDirectory()

    guard savePanel.runModal() == .OK, let saveURL = savePanel.url else {
        throw FlowGenerationError.userCancelledSave
    }

    try yaml.write(to: saveURL, atomically: true, encoding: .utf8)
    return saveURL
}

private func defaultSaveDirectory() -> URL {
    let fileManager = FileManager.default
    let desktopE2EPath = (NSHomeDirectory() as NSString).appendingPathComponent("Desktop/e2e")

    if fileManager.fileExists(atPath: desktopE2EPath) {
        return URL(fileURLWithPath: desktopE2EPath, isDirectory: true)
    }

    return fileManager.homeDirectoryForCurrentUser.appendingPathComponent("Desktop", isDirectory: true)
}

private func extractMaestroYAML(from text: String) -> String {
    let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)

    if trimmed.hasPrefix("```"), let fencedYAML = extractFirstCodeBlock(from: trimmed) {
        return fencedYAML.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    if let appIdRange = trimmed.range(of: "appId:") {
        return String(trimmed[appIdRange.lowerBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
    }

    return trimmed
}

private func extractFirstCodeBlock(from text: String) -> String? {
    guard let openingFenceRange = text.range(of: "```") else {
        return nil
    }

    let afterOpeningFence = text[openingFenceRange.upperBound...]
    guard let closingFenceRange = afterOpeningFence.range(of: "```") else {
        return nil
    }

    var codeBlock = String(afterOpeningFence[..<closingFenceRange.lowerBound])
        .trimmingCharacters(in: .whitespacesAndNewlines)

    if codeBlock.lowercased().hasPrefix("yaml") {
        codeBlock = String(codeBlock.dropFirst(4)).trimmingCharacters(in: .whitespacesAndNewlines)
    }

    return codeBlock
}

private func normalizedOfflineSteps(from description: String) -> [String] {
    let rawLines = description
        .replacingOccurrences(of: "\r\n", with: "\n")
        .components(separatedBy: .newlines)
        .flatMap { line -> [String] in
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return [] }
            if trimmed.contains("\n") { return [trimmed] }
            return trimmed
                .split(separator: ".")
                .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
        }

    return rawLines
        .map {
            $0.replacingOccurrences(
                of: #"^((\d+[\).\s-]*)|([-*]\s+))"#,
                with: "",
                options: .regularExpression
            )
        }
        .filter { !$0.isEmpty }
}

private func maestroCommands(for originalStep: String) -> [String] {
    let step = originalStep.trimmingCharacters(in: .whitespacesAndNewlines)
    let lowercased = step.lowercased()

    if lowercased.hasPrefix("tap below ") {
        let target = extractedQuotedText(from: step)
            ?? extractedText(afterKeyword: "tap below", in: step)
            ?? "Target"
        return [
            "- tapOn:",
            "    below:",
            "      text: \"\(escapeYAML(target))\""
        ]
    }

    if lowercased.hasPrefix("runflow ") {
        let target = extractedQuotedText(from: step)
            ?? extractedText(afterKeyword: "runflow", in: step)
            ?? "Expected text"
        return [
            "- runFlow:",
            "    when:",
            "      visible:",
            "        text: \"\(assertPattern(for: target))\"",
            "    commands:",
            "      - tapOn: \"\(assertPattern(for: target))\""
        ]
    }
    if lowercased.hasPrefix("visible ") {
        let target = extractedQuotedText(from: step)
            ?? extractedText(afterKeyword: "visible", in: step)
            ?? "Expected text"
        return [
            "- assertVisible:",
            "    text: \"\(assertPattern(for: target))\""
        ]
    }
    
    if lowercased.hasPrefix("tapicon ") {
        let value = extractedQuotedText(from: step)
            ?? extractedText(afterKeyword: "tapicon", in: step)
            ?? "Expected text"
        return [
            "- tapOn:",
            "    point: \"\(escapeYAML(value))\""
        ]
    }

    if lowercased.hasPrefix("enter ") {
        let value = extractedQuotedText(from: step)
            ?? extractedText(afterKeyword: "enter", in: step)
            ?? "Sample text"
        return [
            "- inputText: \"\(escapeYAML(value))\"",
            "- tapOn:",
            "    text: \"Done\"",
            "    optional: true"
        ]
    }

    if lowercased.hasPrefix("tap ") {
        var target = extractedQuotedText(from: step)
            ?? extractedText(afterKeyword: "tap", in: step)
            ?? "Target"
        
        var indexLine: String? = nil
        
        let components = target.split(separator: " ")
        
        if let last = components.last, let index = Int(last) {
            target = components.dropLast().joined(separator: " ")
            indexLine = "    index: \(index)"
        }
        
        var yaml = [
            "- tapOn:",
            "    text: \"\(escapeYAML(target))\""
        ]
        
        if let indexLine {
            yaml.append(indexLine)
        }
        
        return yaml
    }

    if lowercased.contains("launch") || lowercased.contains("open app") {
        return ["- launchApp",
                "- waitForAnimationToEnd"
        ]
    }
    

    if lowercased.contains("wait") {
        
        // Extract full raw target string (may include timeout at end)
        if var target = extractedQuotedText(from: step) ??
            extractedText(afterKeywords: ["for", "until"], in: step) {
            
            var timeout = 20000 // default
            
            // Check if last word is a number (timeout)
            let parts = target.split(separator: " ")
            if let last = parts.last, let value = Int(last) {
                timeout = value
                target = parts.dropLast().joined(separator: " ")
            }
            
            return [
                "- extendedWaitUntil:",
                "    visible: \"\(assertPattern(for: target))\"",
                "    timeout: \(timeout)"
            ]
        }
        
        return ["- waitForAnimationToEnd"]
    }

    if lowercased.contains("assert") || lowercased.contains("verify") || lowercased.contains("ensure") || lowercased.contains("confirm") {
        let target = extractedQuotedText(from: step)
            ?? extractedText(afterKeywords: ["verify", "ensure", "confirm", "assert"], in: step)
            ?? "Expected text"
        return [
            "- assertVisible:",
            "    text: \"\(assertPattern(for: target))\""
        ]
    }

    if lowercased.contains("scroll") {
        let target = extractedQuotedText(from: step)
            ?? extractedText(afterKeywords: ["to", "until"], in: step)
            ?? "Target element"
        return [
            "- scrollUntilVisible:",
            "    element: \"\(escapeYAML(target))\"",
            "    direction: DOWN"
        ]
    }

    if lowercased.contains("swipe left") {
        return ["- swipe:", "    direction: LEFT"]
    }

    if lowercased.contains("swipe right") {
        return ["- swipe:", "    direction: RIGHT"]
    }

    if lowercased.contains("swipe up") {
        return ["- swipe:", "    direction: UP"]
    }

    if lowercased.contains("swipe down") {
        return ["- swipe:", "    direction: DOWN"]
    }

    if lowercased.contains("back") {
        return ["- back"]
    }

    if lowercased.contains("enter ") || lowercased.contains("type ") || lowercased.contains("input ") {
        let value = extractedQuotedText(from: step)
            ?? extractedText(afterKeywords: ["enter", "type", "input"], in: step)
            ?? "Sample text"
        return [
            "- inputText: \"\(escapeYAML(value))\"",
            "- tapOn: \"Done\""
        ]
    }

    if lowercased.contains("tap") || lowercased.contains("click") || lowercased.contains("select") || lowercased.contains("press") {
        let target = extractedQuotedText(from: step)
            ?? extractedText(afterKeywords: ["tap", "click", "select", "press"], in: step)
            ?? "Target"
        return [
            "- tapOn:",
            "    text: \"\(escapeYAML(target))\""
        ]
    }

    return [
        "- assertVisible:",
        "    text: \"\(assertPattern(for: step))\""
    ]
}

private func extractedQuotedText(from text: String) -> String? {
    guard let range = text.range(of: "\"([^\"]+)\"", options: .regularExpression) else {
        return nil
    }
    return String(text[range]).trimmingCharacters(in: CharacterSet(charactersIn: "\""))
}

private func extractedText(afterKeywords keywords: [String], in text: String) -> String? {
    let lowered = text.lowercased()
    for keyword in keywords {
        guard let range = lowered.range(of: keyword) else { continue }
        let extracted = text[range.upperBound...]
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: CharacterSet(charactersIn: ":,-"))
        if !extracted.isEmpty {
            return extracted
        }
    }
    return nil
}

private func extractedText(afterKeyword keyword: String, in text: String) -> String? {
    extractedText(afterKeywords: [keyword], in: text)
}

private func assertPattern(for value: String) -> String {
    let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimmed.hasPrefix(".*") || trimmed.hasSuffix(".*") {
        return escapeYAML(trimmed)
    }
    return ".*" + escapeYAML(trimmed) + ".*"
}

private func escapeYAML(_ value: String) -> String {
    value
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .replacingOccurrences(of: "\"", with: "\\\"")
}

private struct GeminiGenerateContentRequest: Encodable {
    let contents: [GeminiContent]
    let generationConfig: GeminiGenerationConfig
}

private struct GeminiContent: Encodable {
    let parts: [GeminiPart]
}

private struct GeminiPart: Encodable, Decodable {
    let text: String?

    init(text: String) {
        self.text = text
    }
}

private struct GeminiGenerationConfig: Encodable {
    let temperature: Double
}

private struct GeminiGenerateContentResponse: Decodable {
    let candidates: [GeminiCandidate]?
}

private struct GeminiCandidate: Decodable {
    let content: GeminiCandidateContent?
}

private struct GeminiCandidateContent: Decodable {
    let parts: [GeminiPart]?
}

private struct GeminiErrorResponse: Decodable {
    let error: GeminiAPIError
}

private struct GeminiAPIError: Decodable {
    let message: String
}
