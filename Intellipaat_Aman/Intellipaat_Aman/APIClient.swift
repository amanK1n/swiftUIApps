//
//  APIClient.swift
//  Intellipaat_Aman
//
//  Created by comviva on 09/10/26.
//


import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case server(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "Invalid URL."
        case .invalidResponse:
            "Something went wrong. Please try again."
        case .server(let message):
            message
        }
    }
}

private struct APIErrorBody: Decodable {
    let message: String
}

struct APIClient {
    func request<Response: Decodable>(
        urlString: String,
        method: HTTPMethod,
        body: Data? = nil
    ) async throws -> Response {
        try await perform(urlString: urlString, method: method, body: body)
    }

    func request<Body: Encodable, Response: Decodable>(
        urlString: String,
        method: HTTPMethod,
        body: Body
    ) async throws -> Response {
        let data = try JSONEncoder().encode(body)
        return try await perform(urlString: urlString, method: method, body: data)
    }

    private func perform<Response: Decodable>(
        urlString: String,
        method: HTTPMethod,
        body: Data?
    ) async throws -> Response {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200...299).contains(http.statusCode) else {
            let message = (try? JSONDecoder().decode(APIErrorBody.self, from: data))?.message
            throw APIError.server(message ?? "Request failed.")
        }

        do {
            return try JSONDecoder().decode(Response.self, from: data)
        } catch {
            throw APIError.invalidResponse
        }
    }
}
