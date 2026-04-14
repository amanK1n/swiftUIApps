//
//  UIModelGenerator.swift
//  RMAMaker
//
//  Created by Sayed on 18/03/26.
//

import Foundation
class UIModelGenerator {

    private var generatedModels: Set<String> = []
    private var nameResolver: ModelNameResolver?

    func generateModels(from json: Any, rootName: String) -> String {

        var output = ""
        generatedModels = []
        nameResolver = ModelNameResolver(schema: json)

        parseObject(
            json as! [String: Any],
            modelName: "\(rootName)DataUIModel",
            path: [],
            output: &output
        )

        output += generateErrorUIModel(rootName: rootName)

        return output
    }
}
extension UIModelGenerator {

    private func parseObject(
        _ dict: [String: Any],
        modelName: String,
        path: [String],
        output: inout String
    ) {

        guard !generatedModels.contains(modelName) else { return }
        generatedModels.insert(modelName)

        var properties = ""

        for (key, value) in ModelShapeNaming.sortedEntries(in: dict) {

            let type = detectType(value, key: key, path: path + [key], output: &output)

            properties += """
                /// \(key) of API \(modelName) Response
                public let \(key): \(type)?

            """
        }

        let model = """
        public struct \(modelName) {

        \(properties)

        }

        """

        output += model
    }

    private func detectType(
        _ value: Any,
        key: String,
        path: [String],
        output: inout String
    ) -> String {

        switch value {

        case is Bool: return "Bool"
        case is Int: return "Int"
        case is Double: return "Double"
        case is String: return "String"

        case let dict as [String: Any]:

            let modelName = nameResolver?.modelName(
                for: dict,
                path: path,
                suffix: "DataUIModel"
            ) ?? "NestedDataUIModel"
            parseObject(dict, modelName: modelName, path: path, output: &output)

            return modelName

        case let array as [Any]:

            if let first = array.first {

                if let dict = first as? [String: Any] {

                    let modelName = nameResolver?.modelName(
                        for: dict,
                        path: path + ["item"],
                        suffix: "DataUIModel"
                    ) ?? "NestedItemDataUIModel"
                    parseObject(dict, modelName: modelName, path: path + ["item"], output: &output)

                    return "[\(modelName)]"
                }

                return "[\(detectType(first, key: key, path: path + ["item"], output: &output))]"
            }

            return "[Any]"

        default:
            return "String"
        }
    }

    private func generateErrorUIModel(rootName: String) -> String {

        return """

        /// \(rootName)ErrorUIModel for API Error Mapping
        public struct \(rootName)ErrorUIModel {

            public let statusCode: String
            public let statusMessage: String

            public init(statusCode: String, statusMessage: String = String.empty) {
                self.statusCode = statusCode
                self.statusMessage = statusMessage
            }
        }

        """
    }
}
