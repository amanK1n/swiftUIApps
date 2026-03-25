//
//  RequestModelGenerator.swift
//  GreatRMAMaker
//
//  Created by Sayed on 16/03/26.
//

import Foundation

final class RequestModelGenerator {

    func generateRequestModel(from json: Any, rootName: String) -> String {

        guard let dict = json as? [String: Any] else { return "" }

        var properties = ""
        var codingKeys = ""
        var initParams = ""
        var initAssign = ""
        var encoding = ""

        for (key, value) in dict {

            let type = detectType(value)

            properties += "    var \(key): \(type)?\n"
            codingKeys += "        case \(key)\n"

            initParams += "\(key): \(type)?, "
            initAssign += "        self.\(key) = \(key)\n"

            encoding += "        try container.encodeIfPresent(\(key), forKey: .\(key))\n"
        }

        initParams = String(initParams.dropLast(2))

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

        let requestModel = """
        class \(rootName)RequestModel: CoreRequestModel {

        \(properties)

            enum CodingKeys: String, CodingKey {
        \(codingKeys)
            }

            internal init(\(initParams)) {
        \(initAssign)
            }

            override func encode(to encoder: Encoder) throws {

                var container = encoder.container(keyedBy: CodingKeys.self)

        \(encoding)
                try super.encode(to: encoder)
            }
        }

        """

        return apiStruct + "\n" + requestModel
    }

    private func detectType(_ value: Any) -> String {

        switch value {

        case is Int:
            return "Int"

        case is Double:
            return "Double"

        case is Bool:
            return "Bool"

        case is String:
            return "String"

        case is [Any]:
            return "[Any]"

        case is [String: Any]:
            return "[String: Any]"

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
