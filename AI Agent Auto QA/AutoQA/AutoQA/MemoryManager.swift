//
//  MemoryManager.swift
//  AutoQA
//
//  Created by Sayed on 02/04/26.
//

import Foundation
struct AgentMemory: Codable {
    var logs: [String]
}

class MemoryManager {
    static let shared = MemoryManager()

    private let url = FileManager.default.homeDirectoryForCurrentUser
        .appendingPathComponent("agent_memory.json")

    func load() -> AgentMemory {
        guard let data = try? Data(contentsOf: url),
              let memory = try? JSONDecoder().decode(AgentMemory.self, from: data) else {
            return AgentMemory(logs: [])
        }
        return memory
    }

    func save(_ memory: AgentMemory) {
        if let data = try? JSONEncoder().encode(memory) {
            try? data.write(to: url)
        }
    }
}
