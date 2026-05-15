//
//  TestCaseModels.swift
//  AIQATestRunner
//
//  Created by Sayed on 26/04/26.
//

import Foundation
import AppKit

struct ScreenshotItem: Identifiable {
    let id = UUID()
    var image: NSImage
    var description: String
}
struct TestStep: Identifiable, Codable {
    let id: UUID
    let steps: String

    enum CodingKeys: String, CodingKey {
        case steps
    }
    init(steps: String) {
        self.id = UUID()
        self.steps = steps
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
          self.steps = try container.decodeIfPresent(String.self, forKey: .steps) ?? ""
          self.id = UUID()
    }
}
