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

struct ViewAsProprties: View {
    let person1 = Text("Aman")
    let person2 = Text("Nikky")
    var person3: some View {
        Text("Nahid") // Won't return multiple views wrapped in a TupleView, @ViewBuilder --> not applied
    }
    // You have 3 options to send back multiple views as property - Stack, Group, @ViewBuilder
    var person4: some View {
        VStack { // 1. Stack is used here
            Text("1. This is wrapped using Stack")
            Text("into a Tuple view which says this TupleView contains multiple Text View\n")
        }.multilineTextAlignment(.leading)
    }
    var person5: some View {
        Group { // 2. Group is used here
            Text("2. This is wrapped using Group")
            Text("Else it will throw error\n")
        }
    }
    @ViewBuilder var person6: some View { // 3. @ViewBuilder is used here
        Text("3. This mimics the way actual body works in SwiftUI library")
        Text("This silently wraps multiple view in TupleView")
    }
     
    var body: some View {
        VStack {
            person1
                .foregroundStyle(.red)
            person2
                .foregroundStyle(.blue)
            person3
            person4
            person5
            person6
        }
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
