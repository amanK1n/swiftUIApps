//
//  ViewModelGenerator.swift
//  GreatRMAMaker
//
//  Created by Sayed on 18/03/26.
//

import Foundation

final class ViewModelGenerator {

    func generateViewModel(
        requestJSON: Any?,
        responseJSON: Any,
        rootName: String
    ) -> String {

        guard let responseDict = responseJSON as? [String: Any] else {
            return ""
        }

        let requestDict = requestJSON as? [String: Any]

        let requestKeys = requestDict?.keys.map { $0 } ?? []
        let responseKeys = Array(responseDict.keys)

        let lowerName = rootName.prefix(1).lowercased() + rootName.dropFirst()

        // MARK: - Request Mapping
        let requestParams = requestKeys.map {
            "\($0): self.component?.get\(rootName)Dependency().\($0) ?? \(defaultValue(for: requestDict?[$0] ?? ""))"
        }.joined(separator: ",\n       ")

        // MARK: - Response Mapping
        let responseMapping = responseKeys.map {
            "\($0): response.\($0)"
        }.joined(separator: ",\n                                                          ")

        // MARK: - Dependency Properties
        let dependencyProps = requestDict?.map { key, value in
            "let \(key): \(detectType(value))?"
        }.joined(separator: "\n") ?? ""

        // MARK: - Request Body Line (NEW ✅)
        let requestBodyLine: String
        if requestKeys.isEmpty {
            requestBodyLine = "let queryObj = \(rootName)API(parameterizedPath: {path to be set by user})"
        } else {
            requestBodyLine = """
            let requestBody = \(rootName)RequestModel(
                \(requestParams)
            )
            """
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

                        let \(lowerName)DataUIModel = \(rootName)DataUIModel(
                                                          \(responseMapping)
                        )

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

    private func detectType(_ value: Any) -> String {
        switch value {
        case is Int: return "Int"
        case is Double: return "Double"
        case is Bool: return "Bool"
        case is String: return "String"
        default: return "String"
        }
    }

    private func defaultValue(for value: Any) -> String {
        switch value {
        case is Int: return "0"
        case is Double: return "0.0"
        case is Bool: return "false"
        case is String: return "\"\""
        default: return "nil"
        }
    }
}
