//
//  AIFeatures.swift
//  RMAMaker
//
//  Created by Sayed on 19/03/26.
//

import Foundation
import SwiftUI

public func suggestRootName(
    rootName: inout String,
    requestJSON: String,
    responseJSON: String
) {
   
    // Prefer response JSON (more reliable)
    let jsonString = requestJSON.isEmpty ? responseJSON : requestJSON
    
    guard let data = jsonString.data(using: .utf8),
          let json = try? JSONSerialization.jsonObject(with: data),
          let dict = json as? [String: Any] else {
        return
    }
    
    let keys = Array(dict.keys)
    
    // Step 1: Try to find meaningful keywords
    let priorityKeywords = [
        "user", "customer", "person", "employee", "emp",
        "order", "product", "item", "account", "profile"
    ]
    
    for key in keys {
        let lower = key.lowercased()
        
        if let match = priorityKeywords.first(where: { lower.contains($0) }) {
            rootName = capitalize(match)
            return
        }
    }
    
    // Step 2: Use first key as fallback
    if let firstKey = keys.first {
        rootName = capitalize(firstKey)
        return
    }
    
    // Step 3: Default fallback
    rootName = "Response"
}
private func capitalize(_ text: String) -> String {
    return text.prefix(1).uppercased() + text.dropFirst()
}

final class GeminiService {
    
    func analyzeJSON(input: String, completion: @escaping (String) -> Void) {
        guard let apiKey = APIKeyManager.get(), !apiKey.isEmpty else {
            return
        }
        let urlString = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 60
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let prompt = """
        Analyze the following JSON:

        \(input)

        You are a JSON expert.

        Your task:
        - Validate the provided JSON.
        - If the JSON is valid, return text "1. JSON is Valid" and give "2. A suitable name (2-3 words related to json, CamelCase)".
        - If the JSON is invalid, fix all errors and return a valid JSON.

        Rules:
        - Return valid JSON ONLY if INPUT json is INVALID.
        - Do NOT include explanations, comments, or extra text.
        - Do NOT wrap the response in code blocks.
        - Preserve the original structure and data as much as possible.
        - Do not add new fields unless required to fix the JSON or include the name.

        """

        let body: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ]
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion("Request body error: \(error.localizedDescription)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in

            // 🔴 Network error
            if let error = error {
                completion("Network Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                completion("No data received")
                return
            }

            // 🧪 DEBUG (optional - remove later)
            if let raw = String(data: data, encoding: .utf8) {
                print("RAW RESPONSE:\n\(raw)")
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

                // 🔴 1. Handle API error response
                if let errorObj = json?["error"] as? [String: Any],
                   let message = errorObj["message"] as? String {
                    completion("API Error: \(message)")
                    return
                }

                // 🟡 2. Extract candidates safely
                if let candidates = json?["candidates"] as? [[String: Any]],
                   let firstCandidate = candidates.first {

                    if let content = firstCandidate["content"] as? [String: Any],
                       let parts = content["parts"] as? [[String: Any]] {

                        // ✅ Combine ALL parts (important fix)
                        let fullText = parts
                            .compactMap { $0["text"] as? String }
                            .joined(separator: "\n")

                        if !fullText.isEmpty {
                            completion(fullText)
                            return
                        }
                    }
                }

                // 🔴 3. Fallback → show raw response (VERY IMPORTANT)
                let rawResponse = String(data: data, encoding: .utf8) ?? "Unknown response"
                completion("Failed to parse response\n\nRaw Response:\n\(rawResponse)")

            } catch {
                completion("Parsing error: \(error.localizedDescription)")
            }

        }.resume()
    }
}
