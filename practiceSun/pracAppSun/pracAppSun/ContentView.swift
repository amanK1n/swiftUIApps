//
//  ContentView.swift
//  pracAppSun
//
//  Created by comviva on 27/09/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            NavigationLink(destination: File1()) {
                Text("Go to Video '1' Demo Code")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(minWidth: 50, maxWidth: 280, minHeight: 20, maxHeight: 20, alignment: .center)
                    .padding()
                    .background(.purple)
                    .cornerRadius(10)
            }
            NavigationLink(destination: File2()) {
                Text("Go to Video '2' Demo Code")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(minWidth: 50, maxWidth: 280, minHeight: 20, maxHeight: 20, alignment: .center)
                    .padding()
                    .background(.purple)
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    ContentView()
}
