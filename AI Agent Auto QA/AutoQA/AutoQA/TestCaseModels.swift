//
//  TestCaseModels.swift
//  AutoQA
//
//  Created by Sayed on 27/03/26.
//

import Foundation
import AppKit

struct ScreenshotItem: Identifiable {
    let id = UUID()
    var image: NSImage
    var description: String
}

struct TestCase: Identifiable, Codable {
    let id: UUID
    let title: String
    let steps: String
    let expectedResult: String
    let type: String

    enum CodingKeys: String, CodingKey {
        case title
        case steps
        case expectedResult
        case type
    }

    init(title: String, steps: String, expectedResult: String, type: String) {
        self.id = UUID()
        self.title = title
        self.steps = steps
        self.expectedResult = expectedResult
        self.type = type
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.steps = try container.decodeIfPresent(String.self, forKey: .steps) ?? ""
        self.expectedResult = try container.decodeIfPresent(String.self, forKey: .expectedResult) ?? ""
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        self.id = UUID() // 🔥 generate locally
    }
}
