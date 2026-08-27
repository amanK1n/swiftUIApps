//
//  Screen1.swift
//  SwiftUIBasics1
//
//  Created by comviva on 28/08/26.
//

import Foundation
import SwiftUI
struct Screen1: View {
    @State private var name: String = ""
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
