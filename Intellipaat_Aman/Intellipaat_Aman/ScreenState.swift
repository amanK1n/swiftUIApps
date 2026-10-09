//
//  ScreenState.swift
//  Intellipaat_Aman
//
//  Created by Aman on 09/10/26.
//


import SwiftUI

enum ScreenState<Value> {
    case loading
    case success(Value)
    case empty
    case failure(String)
}

struct ScreenStateView<Value, Content: View>: View {
    let state: ScreenState<Value>
    let emptyTitle: String
    let failureTitle: String
    let retry: () -> Void
    @ViewBuilder let content: (Value) -> Content

    var body: some View {
        switch state {
        case .loading:
            ProgressView()
        case .success(let value):
            content(value)
        case .empty:
            ContentUnavailableView(emptyTitle, systemImage: "tray")
        case .failure(let message):
            ContentUnavailableView {
                Label(failureTitle, systemImage: "wifi.exclamationmark")
            } description: {
                Text(message)
            } actions: {
                Button("Retry", action: retry)
            }
        }
    }
}
