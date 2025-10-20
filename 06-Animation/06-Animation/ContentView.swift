//
//  ContentView.swift
//  06-Animation
//
//  Created by Sayed on 20/10/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var animScale = 1.0
    var body: some View {
        Button("Tappu meh!!") {
            animScale += 1
            
        }.padding(50)
        .foregroundStyle(.white)
         .background(.blue)
         .clipShape(.capsule)
         .scaleEffect(animScale)
         .animation(.default, value: animScale)
         .blur(radius: (animScale - 1) * 3)
        
    }
}

#Preview {
    ContentView()
}
