//
//  AuthService.swift
//  Intellipaat_Aman
//
//  Created by comviva on 09/10/26.
//

import Foundation

struct LoginResponse: Decodable {
    let id: Int
    let username: String
    let email: String
    let accessToken: String
    let refreshToken: String
}

private struct LoginRequest: Encodable {
    let username: String
    let password: String
    let expiresInMins: Int
}

protocol AuthServicing {
    func login(username: String, password: String) async throws -> LoginResponse
}

struct AuthService: AuthServicing {
    private let client = APIClient()

    
    func login(username: String, password: String) async throws -> LoginResponse {
        try await client.request(
            urlString: "https://dummyjson.com/auth/login",
            method: .post,
            body: LoginRequest(username: username, password: password, expiresInMins: 30)
        )
    }
}
