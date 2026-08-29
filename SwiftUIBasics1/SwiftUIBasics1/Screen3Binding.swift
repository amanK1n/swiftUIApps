//
//  Screen3Binding.swift
//  SwiftUIBasics1
//
//  Created by comviva on 29/08/26.
//

import Foundation
import SwiftUI
public import Combine

struct Screen3: View {
    @State private var isOn: Bool = false// EX-1
    @StateObject public var user: User = User() // EX-2
    var body: some View {
        VStack {
            //EX-1 This is binding example
            Text("Screen 3 Binding")
                .foregroundStyle(isOn ? .red : Color.secondary)
                .font(.headline)
                .padding()
            Screen3ChildViewToggle(isOn: $isOn)
            //EX-1 Binding ENDS HERE
            //*****######********#######******
            
           //EX-2 START ObservedObject, Observable Object, Published
            Text("Your name is: \(user.name)")
            TextField("Enter your name", text: $user.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Tap", action: {
                debugPrint(user.name)
            })
            // EX-2 END
            
            
        }
    }
}


// For binding
// Assume This chlid is in another file
struct Screen3ChildViewToggle: View {
    @Binding var isOn: Bool
    var body: some View {
        VStack {
            
            Toggle("Toggle", isOn: $isOn)
           
        }
    }
}

// CLASS with Observable Object, Published
public class User: ObservableObject {
   @Published var name: String = String()
}
