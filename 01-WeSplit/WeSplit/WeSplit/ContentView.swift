//
//  ContentView.swift
//  WeSplit
//
//  Created by Sayed on 29/09/25.
//

import SwiftUI

struct ContentView: View {
    @State private var tapCount = 0
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
            Form {
                Section {
                    Text("Hello, world!!")
                }
                Section {
                    Text("Hello, world!!")
                    Text("Hello, world!!")
                    Text("Hello, world!!")
                    Text("Hello, world!!")
                }
                Text("Hello, world!!")
                Text("Hello, world!!")
                Text("Hello, world!!")
                Text("Hello, world!!")
                Text("Hello, world!!")
                Text("Hello, world!!")
                Text("Hello, world!!")
                Text("Hello, world!!")
                Text("Hello, world!!")
                Text("Hello, world!!")
            }.navigationTitle("SwiftUI")
                Button("Count: \(tapCount)") {
                    tapCount += 1
                }
                NavigationLink("Go to Next View") {
                    NextView()
                } .buttonStyle(.bordered)
        }
    }
        
        
    }
}
struct NextView: View {
    @State private var name: String = ""
    var body: some View {
        
            Form {
                TextField("Entraré un name", text: $name)
                Text("Your name is \(name)!")
            }
        NavigationLink("Go to Next View") {
            LoopView()
        } .buttonStyle(.bordered)
        
    }
}
struct LoopView: View {
    let students = ["Harry", "Hermione", "Ron"]
    @State private var selectedStudent = "Harry"

    var body: some View {
        NavigationStack {
            Form {
                Picker("Select your student", selection: $selectedStudent) {
                    ForEach(students, id: \.self) {
                        Text($0)
                    }
                }
            }
        }
    }
}
#Preview {
    ContentView()
}
