//
//  ContentView.swift
//  SwiftUIBasics1
//
//  Created by comviva on 28/08/26.
//

import SwiftUI

struct ContentView: View {
   
    var body: some View {
        NavigationStack {

            NavigationLink(destination: Screen1()) {
                Text("Go to Screen 1")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(minWidth: 50, maxWidth: 200, minHeight: 20, maxHeight: 20, alignment: .center)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            NavigationLink(destination: Screen2()) {
                Text("Go to Screen 2")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(minWidth: 50, maxWidth: 200, minHeight: 20, maxHeight: 20, alignment: .center)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            NavigationLink(destination: Screen3()) {
                Text("Go to Screen 3")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(minWidth: 50, maxWidth: 200, minHeight: 20, maxHeight: 20, alignment: .center)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
        }
    }
}

#Preview {
    ContentView()
}
