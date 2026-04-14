//
//  ModelShapeNaming.swift
//  RMAMaker
//
//  Created by Codex on 14/04/26.
//

import Foundation

enum ModelShapeNaming {

    static func sortedEntries(in dict: [String: Any]) -> [(String, Any)] {
        dict.keys.sorted().map { ($0, dict[$0]!) }
    }
}

final class ModelNameResolver {

    private let genericPathKeys: Set<String> = [
        "data", "result", "response", "payload", "item", "items", "list", "details", "detail", "info"
    ]

    private var signatureToBaseName: [String: String] = [:]
    private var usedBaseNames: Set<String> = []

    init(schema: Any) {
        traverse(value: schema, path: [])
    }

    func modelName(
        for dict: [String: Any],
        path: [String],
        suffix: String
    ) -> String {
        let signature = shapeSignature(for: dict)

        if let baseName = signatureToBaseName[signature] {
            return baseName + suffix
        }

        let candidate = candidateBaseName(for: dict, path: path)
        let uniqueBaseName = makeUnique(candidate)
        signatureToBaseName[signature] = uniqueBaseName
        return uniqueBaseName + suffix
    }

    private func traverse(value: Any, path: [String]) {
        if let dict = value as? [String: Any] {
            _ = modelName(for: dict, path: path, suffix: "")

            for (key, childValue) in ModelShapeNaming.sortedEntries(in: dict) {
                traverse(value: childValue, path: path + [key])
            }
            return
        }

        if let array = value as? [Any], let first = array.first {
            traverse(value: first, path: path + ["item"])
        }
    }

    private func candidateBaseName(
        for dict: [String: Any],
        path: [String]
    ) -> String {
        let keys = ModelShapeNaming.sortedEntries(in: dict).map(\.0)

        if Set(keys) == Set(["min", "max"]) {
            return rangeBaseName(for: dict)
        }

        if let pathName = preferredPathName(from: path) {
            return pathName
        }

        if keys.count <= 2 {
            return keys
                .map { sanitize($0) }
                .joined()
        }

        if let lastPath = path.last {
            return sanitize(lastPath) + "Group"
        }

        return "NestedObject"
    }

    private func rangeBaseName(for dict: [String: Any]) -> String {
        let primitiveTypes = ModelShapeNaming.sortedEntries(in: dict).map { primitiveTypeName(for: $0.1) }
        let distinctTypes = Array(Set(primitiveTypes)).sorted()

        if distinctTypes.count == 1, let type = distinctTypes.first {
            return type + "Range"
        }

        return "MixedRange"
    }

    private func primitiveTypeName(for value: Any) -> String {
        switch value {
        case is Bool:
            return "Bool"
        case is Int:
            return "Int"
        case is Double:
            return "Double"
        case is String:
            return "String"
        default:
            return "Value"
        }
    }

    private func preferredPathName(from path: [String]) -> String? {
        for component in path.reversed() {
            let lowered = component.lowercased()
            if !genericPathKeys.contains(lowered) {
                return sanitize(component)
            }
        }

        return nil
    }

    private func makeUnique(_ candidate: String) -> String {
        let safeCandidate = candidate.isEmpty ? "NestedObject" : candidate

        if !usedBaseNames.contains(safeCandidate) {
            usedBaseNames.insert(safeCandidate)
            return safeCandidate
        }

        var index = 2
        while usedBaseNames.contains("\(safeCandidate)\(index)") {
            index += 1
        }

        let uniqueName = "\(safeCandidate)\(index)"
        usedBaseNames.insert(uniqueName)
        return uniqueName
    }

    private func shapeSignature(for dict: [String: Any]) -> String {
        ModelShapeNaming.sortedEntries(in: dict)
            .map { key, value in
                "\(key):\(typeToken(for: value))"
            }
            .joined(separator: "|")
    }

    private func typeToken(for value: Any) -> String {
        switch value {
        case is Bool:
            return "Bool"
        case is Int:
            return "Int"
        case is Double:
            return "Double"
        case is String:
            return "String"
        case let dict as [String: Any]:
            return "{\(shapeSignature(for: dict))}"
        case let array as [Any]:
            guard let first = array.first else {
                return "[Any]"
            }

            return "[\(typeToken(for: first))]"
        default:
            return "String"
        }
    }

    private func sanitize(_ rawValue: String) -> String {
        let pieces = rawValue
            .split { !$0.isLetter && !$0.isNumber }
            .map { fragment in
                let lowercased = fragment.lowercased()
                return lowercased.prefix(1).uppercased() + lowercased.dropFirst()
            }

        let combined = pieces.joined()
        return combined.isEmpty ? "Field" : combined
    }
}
