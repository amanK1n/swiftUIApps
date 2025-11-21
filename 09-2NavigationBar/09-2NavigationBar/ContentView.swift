//
//  ContentView.swift
//  09-2NavigationBar
//
//  Created by Sayed on 20/11/25.
//

import SwiftUI
import Foundation
struct ContentView: View {
    var body: some View {
        Example3()
    }
}

struct Example3: View {
   
    @AppStorage("titleBarName") private var title = "Hello, World!"
    var body: some View {
        NavigationStack {
            Text("Hello Aman!")
                .navigationTitle($title)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}




struct Example2: View {
    var body: some View {
        NavigationStack {
            Text("Hello Aman!!")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) { // Toolbar Item is placed for placment of btn ONLY
                        Button("Tappp meh!") {
                            print("Button tapped !")

                        }
                        
                    }
                    
                    
                    ToolbarItemGroup(placement: .topBarLeading) {
                        Button("Btn 1") {
                            print("Btn1 tapped!")
                        }
                        
                        Button("Btn 2") {
                            print("Btn2 tapped!")
                        }
                    }
                }
        }
    }
}




// Navigatin bar customization - BG color, Dark Scheme, hidden
struct Example1: View {
    var body: some View {
        NavigationStack {
            List(0..<100) { i in
                Text("Item \(i)")
            }
            .navigationTitle("Title goes here!!")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.blue, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}



#Preview {
    ContentView()
}
