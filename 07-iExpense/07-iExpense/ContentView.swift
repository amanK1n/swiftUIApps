//
//  ContentView.swift
//  07-iExpense
//
//  Created by Sayed on 26/10/25.
//

import SwiftUI
struct SecondScreen: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Text("Second screen")
        Button("Tap me to dismiss this screen!") {
            dismiss()
        }
    }
}
struct ContentView: View {
    @State private var showNXTScreen: Bool = false
    var body: some View {
        Button("Present NXT screen") {
            showNXTScreen.toggle()
        }
        .sheet(isPresented: $showNXTScreen) {
            SecondScreen()
        }
    }
}

#Preview {
    ContentView()
}
