//
//  ContentView.swift
//  09-HandleNav
//
//  Created by Sayed on 05/11/25.
//

import SwiftUI

struct DetailsView: View {
    var num: Int
    var body: some View {
        Text("Details \(num)")
    }
    init(num: Int) {
        self.num = num
        print("Creating DetailsView \(num)")
    }
}


struct ContentView: View {
    var body: some View {
        NavigationStack {
            List(0..<200) { num in
            NavigationLink("Tap muei") {
               
                    DetailsView(num: num)
                }
                
            }
        }
    }
}

#Preview {
    ContentView()
}
