//
//  ContentView.swift
//  05-WordScramble
//
//  Created by Sayed on 15/10/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        List {
            Section("Aman") {
                Text("Sayed")
                Text("Sayed")
            }
            Section("NIKHAT") {
                ForEach(0..<5) {
                    Text("Dynamic Text \($0)")
                }
            }
        }.listStyle(.grouped)
    }
}




#Preview {
    ContentView()
}
