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

struct EnvironmentView: View {
    var body: some View {
        VStack {
            Text("Gryffindor")
                .font(.largeTitle) // Overrides Environment modifier
            Text("Hufflepuff")
            Text("Ravenclaw")
            Text("Slytherin")
        }
        .font(.title) // Environment modifier
        
        VStack {
            Text("Gryffindor")
                .blur(radius: 0) // No effect
            Text("Hufflepuff")
            Text("Ravenclaw")
            Text("Slytherin")
        }.blur(radius: 5) // Regular modifier
    }
}


struct ModifierOrderView: View {
    @State private var useRedText = false
    var body: some View {
        VStack {
            Button("Click mee!! see magic") {
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
