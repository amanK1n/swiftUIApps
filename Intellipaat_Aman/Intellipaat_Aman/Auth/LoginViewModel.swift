//
//  LoginViewModel.swift
//  Intellipaat_Aman
//
//  Created by Aman on 09/10/26.
//

import Foundation

@MainActor
@Observable
final class LoginViewModel {
    var email = ""
    var password = ""
    var isLoading = false
    var errorMessage: String?
    var isLoggedIn = false

    private let authService: AuthServicing

    init(authService: AuthServicing = AuthService()) {
        self.authService = authService
    }

    func login() async {
        errorMessage = nil
        let username = email.trimmingCharacters(in: .whitespacesAndNewlines)

        if let message = validationMessage(username: username, password: password) {
            errorMessage = message
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            _ = try await authService.login(username: username, password: password)
            isLoggedIn = true
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
    }

    private func validationMessage(username: String, password: String) -> String? {
        if username.isEmpty {
            return "Email is required."
        }
        if username.contains("@"), !isValidEmail(username) {
            return "Enter a valid email."
        }
        if password.isEmpty {
            return "Password is required."
        }
        if password.count < 6 {
            return "Password must be at least 6 characters."
        }
        return nil
    }

    private func isValidEmail(_ value: String) -> Bool {
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return value.range(of: pattern, options: .regularExpression) != nil
    }
}
