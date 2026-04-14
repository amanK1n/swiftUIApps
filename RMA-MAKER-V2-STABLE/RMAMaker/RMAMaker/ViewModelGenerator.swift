//
//  ViewModelGenerator.swift
//  GreatRMAMaker
//
//  Created by Sayed on 18/03/26.
//

import Foundation

final class ViewModelGenerator {

    private var responseNameResolver: ModelNameResolver?
    private var requestNameResolver: ModelNameResolver?

    func generateViewModel(
        requestJSON: Any?,
        responseJSON: Any,
        rootName: String
    ) -> String {

        guard let responseDict = responseJSON as? [String: Any] else {
            return ""
        }

        let requestDict = requestJSON as? [String: Any]
        responseNameResolver = ModelNameResolver(schema: responseDict)
        requestNameResolver = requestDict.map { ModelNameResolver(schema: $0) }

        let requestKeys = requestDict?.keys.map { $0 } ?? []
        let lowerName = rootName.prefix(1).lowercased() + rootName.dropFirst()

        // MARK: - Request Mapping
        let requestBodyMapping = requestDict.map {
            generateRequestBodyMapping(
                from: $0,
                rootName: rootName,
                dependencyExpression: "self.component?.get\(rootName)Dependency()"
            )
        } ?? ""

        // MARK: - Response Mapping
        let responseModelMapping = generateResponseModelMapping(
            from: responseDict,
            rootName: rootName,
            responseVariableName: "response"
        )

        // MARK: - Dependency Properties
        let dependencyProps = requestDict.map {
            generateDependencyProperties(from: $0)
        } ?? ""

        // MARK: - Request Body Line (NEW ✅)
        let requestBodyLine: String
        if requestKeys.isEmpty {
            requestBodyLine = "let queryObj = \(rootName)API(parameterizedPath: {path to be set by user})"
        } else {
            requestBodyLine = requestBodyMapping
        }

        // MARK: - API Call Line (NEW ✅)
        let apiCallStart: String
        if requestKeys.isEmpty {
            apiCallStart = """
            self.dataSource.call\(rootName)API(
                body: queryObj,
                successCallBack: { [weak self] (response) in
            """
        } else {
            apiCallStart = """
            self.dataSource.call\(rootName)API(
                body: requestBody,
                successCallBack: { [weak self] (response) in
            """
        }

        let code = """

        /// \(rootName)FlowDelegate for \(rootName) feature
        public protocol \(rootName)FlowDelegate: AnyObject {
            func action\(rootName)Failed(error: \(rootName)ErrorUIModel)
            func action\(rootName)Successful(data: \(rootName)DataUIModel)
        }

        /// \(rootName)Dependency for \(rootName) feature
        public protocol \(rootName)Dependency: AnyObject {
            func get\(rootName)Dependency() -> \(rootName)ObjDependency
        }

        public class \(rootName)ViewModel {

            let dataSource: \(rootName)DataSource

            public weak var delegate: \(rootName)FlowDelegate?
            public weak var component: \(rootName)Dependency?

            init(delegate: \(rootName)FlowDelegate?,
                 component: \(rootName)Dependency?,
                 dataSource: \(rootName)DataSource) {

                self.dataSource = dataSource
                self.delegate = delegate
                self.component = component
            }

            public convenience init(delegate: \(rootName)FlowDelegate? = nil,
                                    component: \(rootName)Dependency? = nil) {
                self.init(delegate: delegate,
                          component: component,
                          dataSource: \(rootName)DataSource())
            }

            /// perform\(rootName)Action for executing API for feature
            public func perform\(rootName)Action() {

                \(requestBodyLine)

                \(apiCallStart)

                        \(responseModelMapping)

                        self?.delegate?.action\(rootName)Successful(data: \(lowerName)DataUIModel)

                    }, failureCallBack: { [weak self] (error) in

                        if let err = error as? {set error model manually} {

                            let errorModel = \(rootName)ErrorUIModel(
                                statusCode: "Error",
                                statusMessage: "Error"
                            )

                            self?.delegate?.action\(rootName)Failed(error: errorModel)

                        } else if let err = error as? APITimeError {

                            let errorModel = \(rootName)ErrorUIModel(
                                statusCode: err.errorCodeInResponse,
                                statusMessage: err.localizedDescription
                            )

                            self?.delegate?.action\(rootName)Failed(error: errorModel)

                        } else {

                            let errorModel = \(rootName)ErrorUIModel(
                                statusCode: String.empty
                            )

                            self?.delegate?.action\(rootName)Failed(error: errorModel)
                        }
                    }
                )
            }
        }

        public struct \(rootName)ObjDependency {

        \(dependencyProps)
        }

        """

        return code
    }
}

extension ViewModelGenerator {

    private var genericPathComponents: Set<String> {
        ["data", "result", "response", "payload", "item", "items", "list", "details", "detail", "info"]
    }

    private struct MappingResult {
        let statements: [String]
        let expression: String
    }

    private enum ModelLayerSuffix: String {
        case request = "RequestModel"
        case response = "DataUIModel"
    }

    private func generateResponseModelMapping(
        from responseDict: [String: Any],
        rootName: String,
        responseVariableName: String
    ) -> String {

        let rootMappings = ModelShapeNaming.sortedEntries(in: responseDict).map { key, value in
            let mapping = generateMappingExpression(
                for: value,
                key: key,
                sourceExpression: "\(responseVariableName).\(key)",
                pathComponents: [key],
                isOptionalSource: true,
                modelLayer: .response
            )

            return (key: key, mapping: mapping)
        }

        let rootStatements = rootMappings
            .flatMap(\.mapping.statements)
            .joined(separator: "\n")
        let rootParameters = rootMappings.map {
            "\($0.key): \($0.mapping.expression)"
        }.joined(separator: ",\n                                                          ")

        return """
                        \(rootStatements.isEmpty ? "" : rootStatements + "\n")
                        let \(rootName.prefix(1).lowercased() + rootName.dropFirst())DataUIModel = \(rootName)DataUIModel(
                                                          \(rootParameters)
                        )
        """
    }

    private func generateRequestBodyMapping(
        from requestDict: [String: Any],
        rootName: String,
        dependencyExpression: String
    ) -> String {

        let dependencyVariableName = "dependency"

        let rootMappings = ModelShapeNaming.sortedEntries(in: requestDict).map { key, value in
            let mapping = generateMappingExpression(
                for: value,
                key: key,
                sourceExpression: "\(dependencyVariableName)?.\(key)",
                pathComponents: [key],
                isOptionalSource: true,
                modelLayer: .request
            )

            return (key: key, mapping: mapping)
        }

        let rootStatements = rootMappings
            .flatMap(\.mapping.statements)
            .joined(separator: "\n")
        let rootParameters = rootMappings.map {
            "\($0.key): \($0.mapping.expression)"
        }.joined(separator: ",\n                ")

        return """
            let \(dependencyVariableName) = \(dependencyExpression)
            \(rootStatements.isEmpty ? "" : rootStatements + "\n")
            let requestBody = \(rootName)RequestModel(
                \(rootParameters)
            )
            """
    }

    private func generateDependencyProperties(from requestDict: [String: Any]) -> String {
        ModelShapeNaming.sortedEntries(in: requestDict)
            .map { key, value in
                "    public let \(key): \(requestType(for: value, path: [key]))?"
            }
            .joined(separator: "\n")
    }

    private func generateMappingExpression(
        for value: Any,
        key: String,
        sourceExpression: String,
        pathComponents: [String],
        isOptionalSource: Bool,
        modelLayer: ModelLayerSuffix
    ) -> MappingResult {

        switch value {
        case is Bool, is Int, is Double, is String:
            let expression = isOptionalSource && modelLayer == .request
                ? "\(sourceExpression) ?? \(defaultValue(for: value))"
                : sourceExpression
            return MappingResult(statements: [], expression: expression)

        case let dict as [String: Any]:
            let modelName = modelName(for: dict, path: pathComponents, layer: modelLayer)
            let closureVariable = buildClosureVariableName(from: pathComponents)
            let localVariableName = buildLocalVariableName(from: pathComponents)

            let childMappings = ModelShapeNaming.sortedEntries(in: dict).map { childKey, childValue in
                let childMapping = generateMappingExpression(
                    for: childValue,
                    key: childKey,
                    sourceExpression: "\(closureVariable).\(childKey)",
                    pathComponents: pathComponents + [childKey],
                    isOptionalSource: true,
                    modelLayer: modelLayer
                )

                return (key: childKey, mapping: childMapping)
            }

            let childStatements = childMappings
                .flatMap(\.mapping.statements)
                .map { indent($0, level: 2) }
                .joined(separator: "\n")
            let parameters = childMappings.map {
                "\($0.key): \($0.mapping.expression)"
            }.joined(separator: ",\n            ")

            let initializerBody = """
            \(childStatements.isEmpty ? "" : childStatements + "\n")
            \(indent("return \(modelName)(", level: 2))
            \(indent(parameters, level: 3))
            \(indent(")", level: 2))
            """

            let expression = isOptionalSource
                ? "\(sourceExpression).map { \(closureVariable) in\n\(indent(initializerBody, level: 1))\n                                }"
                : "\(modelName)(\n\(indent(parameters, level: 1))\n)"

            let statements = isOptionalSource
                ? ["let \(localVariableName) = \(expression)"]
                : []

            return MappingResult(
                statements: statements,
                expression: isOptionalSource ? localVariableName : expression
            )

        case let array as [Any]:
            guard let first = array.first else {
                return MappingResult(
                    statements: [],
                    expression: isOptionalSource && modelLayer == .request ? "\(sourceExpression) ?? []" : sourceExpression
                )
            }

            if let dict = first as? [String: Any] {
                let modelName = modelName(for: dict, path: pathComponents + ["item"], layer: modelLayer)
                let closureVariable = buildClosureVariableName(from: pathComponents, suffix: "Item")
                let localVariableName = buildLocalVariableName(from: pathComponents)

                let childMappings = ModelShapeNaming.sortedEntries(in: dict).map { childKey, childValue in
                    let childMapping = generateMappingExpression(
                        for: childValue,
                        key: childKey,
                        sourceExpression: "\(closureVariable).\(childKey)",
                        pathComponents: pathComponents + [childKey],
                        isOptionalSource: true,
                        modelLayer: modelLayer
                    )

                    return (key: childKey, mapping: childMapping)
                }

                let childStatements = childMappings
                    .flatMap(\.mapping.statements)
                    .map { indent($0, level: 2) }
                    .joined(separator: "\n")
                let parameters = childMappings.map {
                    "\($0.key): \($0.mapping.expression)"
                }.joined(separator: ",\n            ")

                let initializerBody = """
                \(childStatements.isEmpty ? "" : childStatements + "\n")
                \(indent("return \(modelName)(", level: 2))
                \(indent(parameters, level: 3))
                \(indent(")", level: 2))
                """

                let expression = isOptionalSource
                    ? "\(sourceExpression)?.map { \(closureVariable) in\n\(indent(initializerBody, level: 1))\n                                }"
                    : "\(sourceExpression).map { \(closureVariable) in\n\(indent(initializerBody, level: 1))\n                                }"

                let statements = ["let \(localVariableName) = \(expression)"]

                return MappingResult(
                    statements: statements,
                    expression: localVariableName
                )
            }

            let expression = isOptionalSource && modelLayer == .request ? "\(sourceExpression) ?? []" : sourceExpression
            return MappingResult(statements: [], expression: expression)

        default:
            return MappingResult(statements: [], expression: sourceExpression)
        }
    }

    private func modelName(
        for dict: [String: Any],
        path: [String],
        layer: ModelLayerSuffix
    ) -> String {
        switch layer {
        case .request:
            return requestNameResolver?.modelName(
                for: dict,
                path: path,
                suffix: layer.rawValue
            ) ?? "NestedRequestModel"
        case .response:
            return responseNameResolver?.modelName(
                for: dict,
                path: path,
                suffix: layer.rawValue
            ) ?? "NestedDataUIModel"
        }
    }

    private func requestType(for value: Any, path: [String]) -> String {
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
            return requestNameResolver?.modelName(
                for: dict,
                path: path,
                suffix: ModelLayerSuffix.request.rawValue
            ) ?? "NestedRequestModel"
        case let array as [Any]:
            guard let first = array.first else {
                return "[Any]"
            }

            if let dict = first as? [String: Any] {
                let modelName = requestNameResolver?.modelName(
                    for: dict,
                    path: path + ["item"],
                    suffix: ModelLayerSuffix.request.rawValue
                ) ?? "NestedItemRequestModel"
                return "[\(modelName)]"
            }

            return "[\(requestType(for: first, path: path + ["item"]))]"
        default:
            return "String"
        }
    }

    private func buildLocalVariableName(from pathComponents: [String]) -> String {
        let meaningfulComponents = pathComponents.filter {
            !genericPathComponents.contains($0.lowercased())
        }

        let componentsToUse = meaningfulComponents.isEmpty ? pathComponents : meaningfulComponents
        let sanitizedComponents = componentsToUse.map(sanitizeIdentifierComponent)

        let joined = sanitizedComponents
            .enumerated()
            .map { index, component in
                index == 0
                    ? component.prefix(1).lowercased() + component.dropFirst()
                    : component
            }
            .joined()

        return joined + "DataUIModel"
    }

    private func sanitizeIdentifierComponent(_ rawValue: String) -> String {
        let pieces = rawValue
            .split { !$0.isLetter && !$0.isNumber }
            .map { fragment in
                let lowercased = fragment.lowercased()
                return lowercased.prefix(1).uppercased() + lowercased.dropFirst()
            }

        let combined = pieces.joined()
        return combined.isEmpty ? "Value" : combined
    }

    private func indent(_ text: String, level: Int) -> String {
        let prefix = String(repeating: "    ", count: level)

        return text
            .split(separator: "\n", omittingEmptySubsequences: false)
            .map { prefix + $0 }
            .joined(separator: "\n")
    }

    private func buildClosureVariableName(from pathComponents: [String], suffix: String = "Response") -> String {
        pathComponents
            .enumerated()
            .map { index, component in
                index == 0 ? component.lowercased() : component.capitalized
            }
            .joined()
            + suffix
    }

    private func defaultValue(for value: Any) -> String {
        switch value {
        case is Bool: return "false"
        case is Int: return "0"
        case is Double: return "0.0"
        case is String: return "\"\""
        case is [Any]: return "[]"
        default: return "nil"
        }
    }
}
