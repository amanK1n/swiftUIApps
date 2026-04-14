//
//  JSONModelGenerator.swift
//  GreatRMAMaker
//
//  Created by Sayed on 13/03/26.
//

import Foundation

class JSONModelGenerator {

    private var generatedModels: Set<String> = []
    private var nameResolver: ModelNameResolver?

    func generateModels(from json: Any, rootName: String, isOnlyResponseModel: Bool) -> String {

        var output = ""
        generatedModels = []
        nameResolver = ModelNameResolver(schema: json)

        parseObject(
            json as! [String: Any],
            modelName: "\(rootName)ResponseModel",
            uiModelName: "\(rootName)DataUIModel",
            path: [],
            output: &output, isOnlyResponseModel: isOnlyResponseModel
        )

        if isOnlyResponseModel {
            
        } else {
            output += generateErrorUIModel(rootName: rootName)
        }
        

        return output
    }
}

extension JSONModelGenerator {

    private func parseObject(
        _ dict: [String: Any],
        modelName: String,
        uiModelName: String,
        path: [String],
        output: inout String,
        isOnlyResponseModel: Bool
    ) {

        guard !generatedModels.contains(modelName) else { return }
        generatedModels.insert(modelName)

        var properties = ""
        var codingKeys = ""
        var decoding = ""
        var uiProperties = ""

        for (key, value) in ModelShapeNaming.sortedEntries(in: dict) {

            let type = detectType(value, key: key, path: path + [key], output: &output, isOnlyResponseModel: isOnlyResponseModel)

            // ResponseModel property
            properties += "    let \(key): \(type)?\n"

            codingKeys += "        case \(key)\n"

            decoding += """
                    \(key) = try container.decodeIfPresent(\(type).self, forKey: .\(key))

            """

            // UI Model property (non optional)
            uiProperties += """
                /// \(key) of API \(uiModelName) Response
                public let \(key): \(type)?

            """
        }

        let responseModel = """
        class \(modelName): CoreResponseModel {

        \(properties)

            enum CodingKeys: String, CodingKey {
        \(codingKeys)
            }

            required init(from decoder: Decoder) throws {

                let container = try decoder.container(keyedBy: CodingKeys.self)

        \(decoding)

                try super.init(from: decoder)
            }
        }

        """

        let uiModel = """
        public struct \(uiModelName) {

        \(uiProperties)

        }

        """
       
        if isOnlyResponseModel {
            output += responseModel
        } else {
            output += uiModel
        }
    }

    private func detectType(_ value: Any, key: String, path: [String], output: inout String, isOnlyResponseModel: Bool) -> String {

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

            let modelName = nameResolver?.modelName(
                for: dict,
                path: path,
                suffix: "ResponseModel"
            ) ?? "NestedResponseModel"
            let uiName = nameResolver?.modelName(
                for: dict,
                path: path,
                suffix: "DataUIModel"
            ) ?? "NestedDataUIModel"

            parseObject(dict, modelName: modelName, uiModelName: uiName, path: path, output: &output, isOnlyResponseModel: isOnlyResponseModel)

            return isOnlyResponseModel ? modelName : uiName

        case let array as [Any]:

            if let first = array.first {

                if let dict = first as? [String: Any] {

                    let modelName = nameResolver?.modelName(
                        for: dict,
                        path: path + ["item"],
                        suffix: "ResponseModel"
                    ) ?? "NestedItemResponseModel"
                    let uiName = nameResolver?.modelName(
                        for: dict,
                        path: path + ["item"],
                        suffix: "DataUIModel"
                    ) ?? "NestedItemDataUIModel"

                    parseObject(dict, modelName: modelName, uiModelName: uiName, path: path + ["item"], output: &output, isOnlyResponseModel: isOnlyResponseModel)

                    return isOnlyResponseModel ? "[\(modelName)]" : "[\(uiName)]"
                }

                return "[\(detectType(first, key: key, path: path + ["item"], output: &output, isOnlyResponseModel: isOnlyResponseModel))]"
            }

            return "[Any]"

        default:
            return "String"
        }
    }

    private func generateErrorUIModel(rootName: String) -> String {

        return """

        /// \(rootName)ErrorUIModel for API Success Response Mapping to View Elements
        public struct \(rootName)ErrorUIModel {

            /// statusCode of API Error Response
            public let statusCode: String

            /// statusMessage of API Error Response
            public let statusMessage: String

            /// constructor for \(rootName)ErrorUIModel
            public init(statusCode: String, statusMessage: String = String.empty) {
                self.statusCode = statusCode
                self.statusMessage = statusMessage
            }
        }

        """
    }
}
