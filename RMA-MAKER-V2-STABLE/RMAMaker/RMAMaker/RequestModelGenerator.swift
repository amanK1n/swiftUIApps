//
//  RequestModelGenerator.swift
//  GreatRMAMaker
//
//  Created by Sayed on 16/03/26.
//

import Foundation

final class RequestModelGenerator {

    private var generatedModels: Set<String> = []
    private var nameResolver: ModelNameResolver?

    func generateRequestModel(from json: Any, rootName: String) -> String {

        guard let dict = json as? [String: Any] else { return "" }

        generatedModels = []
        nameResolver = ModelNameResolver(schema: dict)

        var output = ""
        parseObject(
            dict,
            modelName: "\(rootName)RequestModel",
            path: [],
            output: &output
        )

        let apiStruct = """
        struct \(rootName)API: RequestType {

            var endPoint: String {
                return EndpointsHelper.getEndPoint(endpointId: "{manually set by user}")
            }

            typealias ErrorResponseType = {to be manually set by user, varies from project to project}
            typealias ResponseType = \(rootName)ResponseModel
            typealias RequestBodyType = \(rootName)RequestModel
        }

        """

        return apiStruct + "\n" + output
    }

    private func parseObject(
        _ dict: [String: Any],
        modelName: String,
        path: [String],
        output: inout String
    ) {

        guard !generatedModels.contains(modelName) else { return }
        generatedModels.insert(modelName)

        var properties = ""
        var codingKeys = ""
        var initParams: [String] = []
        var initAssign = ""
        var encoding = ""

        for (key, value) in ModelShapeNaming.sortedEntries(in: dict) {

            let type = detectType(value, key: key, path: path + [key], output: &output)

            properties += "    var \(key): \(type)?\n"
            codingKeys += "        case \(key)\n"
            initParams.append("\(key): \(type)?")
            initAssign += "        self.\(key) = \(key)\n"
            encoding += "        try container.encodeIfPresent(\(key), forKey: .\(key))\n"
        }

        let requestModel = """
        class \(modelName): CoreRequestModel {

        \(properties)

            enum CodingKeys: String, CodingKey {
        \(codingKeys)
            }

            internal init(\(initParams.joined(separator: ", "))) {
        \(initAssign)
            }

            override func encode(to encoder: Encoder) throws {

                var container = encoder.container(keyedBy: CodingKeys.self)

        \(encoding)
                try super.encode(to: encoder)
            }
        }

        """

        output += requestModel
    }

    private func detectType(
        _ value: Any,
        key: String,
        path: [String],
        output: inout String
    ) -> String {

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
                suffix: "RequestModel"
            ) ?? "NestedRequestModel"
            parseObject(dict, modelName: modelName, path: path, output: &output)
            return modelName

        case let array as [Any]:
            guard let first = array.first else {
                return "[Any]"
            }

            if let dict = first as? [String: Any] {
                let modelName = nameResolver?.modelName(
                    for: dict,
                    path: path + ["item"],
                    suffix: "RequestModel"
                ) ?? "NestedItemRequestModel"
                parseObject(dict, modelName: modelName, path: path + ["item"], output: &output)
                return "[\(modelName)]"
            }

            return "[\(detectType(first, key: key, path: path + ["item"], output: &output))]"

        default:
            return "String"
        }
    }
    func generateGetAPI(rootName: String) -> String {
        return """
        struct \(rootName)API: GetRequestType {

            var requestParams: [String: String]?
            var parameterizedPath: String

            var endPoint: String {
                return self.parameterizedPath
            }

            init(parameterizedPath: String) {
                self.parameterizedPath = parameterizedPath
            }

            typealias ErrorResponseType = {to be set by user}
            typealias ResponseType = \(rootName)ResponseModel
        }
        """
    }
}
