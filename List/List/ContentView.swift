//
//  ContentView.swift
//  List
//
//  Created by comviva on 30/08/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            NavigationLink(destination: ListView()) {
                Text("Tap for List View Demo")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 220, height: 40, alignment: .center)
                    .padding()
                    .background(.blue)
                    .cornerRadius(10)
            }
            NavigationLink(destination: TabbarView()) {
                Text("Tap for Tabbar Demo")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 220, height: 40, alignment: .center)
                    .padding()
                    .background(.blue)
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    ContentView()
}
