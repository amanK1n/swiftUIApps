//
//  ResponseModelGenerator.swift
//  RMAMaker
//
//  Created by Sayed on 18/03/26.
//

import Foundation
class ResponseModelGenerator {

    private var generatedModels: Set<String> = []

    func generateModels(from json: Any, rootName: String) -> String {

        var output = ""

        parseObject(
            json as! [String: Any],
            modelName: "\(rootName)ResponseModel",
            output: &output
        )

        return output
    }
}
extension ResponseModelGenerator {

    private func parseObject(
        _ dict: [String: Any],
        modelName: String,
        output: inout String
    ) {

        guard !generatedModels.contains(modelName) else { return }
        generatedModels.insert(modelName)

        var properties = ""
        var codingKeys = ""
        var decoding = ""

        for (key, value) in dict {

            let type = detectType(value, key: key, output: &output)

            properties += "    let \(key): \(type)?\n"
            codingKeys += "        case \(key)\n"

            decoding += """
                    \(key) = try container.decodeIfPresent(\(type).self, forKey: .\(key))

            """
        }

        let model = """
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

        output += model
    }

    private func detectType(
        _ value: Any,
        key: String,
        output: inout String
    ) -> String {

        switch value {

        case is Bool: return "Bool"
        case is Int: return "Int"
        case is Double: return "Double"
        case is String: return "String"

        case let dict as [String: Any]:

            let modelName = key.capitalized + "ResponseModel"
            parseObject(dict, modelName: modelName, output: &output)

            return modelName

        case let array as [Any]:

            if let first = array.first {

                if let dict = first as? [String: Any] {

                    let modelName = key.capitalized + "ItemResponseModel"
                    parseObject(dict, modelName: modelName, output: &output)

                    return "[\(modelName)]"
                }

                return "[\(detectType(first, key: key, output: &output))]"
            }

            return "[Any]"

        default:
            return "String"
        }
    }
}
