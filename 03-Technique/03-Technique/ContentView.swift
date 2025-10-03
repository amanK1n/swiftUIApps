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
    var body: some View {
        VStack {
            Button("Hello, world!") {
                print(type(of: self.body))
            }
            .background(.red)
            .frame(width: 200, height: 200)
            Button("Hello, world!") {
                print(type(of: self.body))
            }
            .frame(width: 200, height: 200)
            .background(.blue)
            
            Text("Aman")
                .background(.purple)
                .padding()
                .background(.indigo)
                .padding()
                .background(.blue)
                .padding()
                .background(.green)
                .padding()
                .background(.yellow)
                .padding()
                .background(.orange)
                .padding()
                .background(.red)
        }
    }
}



#Preview {
    ContentView()
}
