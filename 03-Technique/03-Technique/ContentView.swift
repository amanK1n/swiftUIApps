//
//  ContentView.swift
//  03-Technique
//
//  Created by Sayed on 03/10/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("kk")
    }
}

struct ModifierOrderView: View {
    @State private var useRedText = false
    var body: some View {
        VStack {
            Button("Hello, world!") {
                print(type(of: self.body))
                useRedText.toggle()
            }
            .background(useRedText ? .red : .green)
            .frame(width: 200, height: 200)
            Button("Hello, world!") {
                print(type(of: self.body))
            }
            .frame(width: 200, height: 200)
            .background(.blue)
            
            Text("Aman")
                .background(useRedText ? .purple : .red)
                .padding()
                .background(useRedText ? .indigo : .orange)
                .padding()
                .background(useRedText ? .blue : .yellow)
                .padding()
                .background(useRedText ? .green : .green)
                .padding()
                .background(useRedText ? .yellow : .blue)
                .padding()
                .background(useRedText ? .orange : .indigo)
                .padding()
                .background(useRedText ? .red : .purple)
        }
    }
}



#Preview {
    ContentView()
}
