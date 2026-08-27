//
//  ContentView.swift
//  SwiftUIBasics1
//
//  Created by comviva on 28/08/26.
//

import SwiftUI

struct ContentView: View {
    @State var name: String = String()
    var body: some View {
        VStack {
            TextField("Enter your name", text: $name)
            Button("Login") {
                print("Hello \(name)")
            }.disabled(name.count < 4)
            
            Button(action: {
                debugPrint("Hello \(name) signup")
            }, label: {
                Text("Sign up")
            }).disabled(name.count < 5)
        }
    }
}

#Preview {
    ContentView()
}
