//
//  ContentView.swift
//  05-WordScramble
//
//  Created by Sayed on 15/10/25.
//

import SwiftUI

struct ContentView: View {
    var people = ["AMAN", "NIKHAT"]
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
            Section("Fur itch") {
                
                ForEach(people, id: \.self) {
                    Text($0)
                }
            }
        }.listStyle(.grouped)
    }
}


struct ListViewExample: View {
    var people = ["AMAN", "NIKHAT"]
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
            Section("Fur itch") {
                
                ForEach(people, id: \.self) {
                    Text($0)
                }
            }
        }.listStyle(.grouped)
    }
    
    func testBundles() {
        if let fileURL = Bundle.main.url(forResource: "nameOfYourFile", withExtension: "txt") {
            if let fileContent = try? String(contentsOf: fileURL) {
                // We load ed file as string
            }
        }
    }
}

#Preview {
    ContentView()
}
