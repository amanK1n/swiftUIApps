//
//  LoginView.swift
//  Intellipaat_Aman
//
//  Created by Aman on 09/10/26.
//

import SwiftUI

struct LoginView: View {
    @State private var viewModel = LoginViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                TextField("Username", text: $viewModel.email)
                    .textContentType(.username)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding()
                    .background(.quaternary.opacity(0.4), in: RoundedRectangle(cornerRadius: 10))

                SecureField("Password", text: $viewModel.password)
                    .textContentType(.password)
                    .padding()
                    .background(.quaternary.opacity(0.4), in: RoundedRectangle(cornerRadius: 10))

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Button {
                    Task { await viewModel.login() }
                } label: {
                    Group {
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            Text("Login")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isLoading)

                Text("Use the dummy Username and Password:\nemilys / emilyspass")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fontWeight(.black)

                Spacer()
            }
            .padding()
            .navigationTitle("Login")
            .navigationDestination(isPresented: $viewModel.isLoggedIn) {
                CourseDashboardView()
            }
        }
    }
}
