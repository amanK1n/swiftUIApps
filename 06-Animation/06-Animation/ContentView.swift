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
          //  animScale += 1
            
        }.padding(50)
         .foregroundStyle(.white)
         .background(.red)
         .clipShape(.circle)
//         .scaleEffect(animScale)
         .overlay(
            Circle()
                .stroke(.red)
                .scaleEffect(animScale)
                .opacity(2 - animScale)
                .animation(.easeOut(duration: 1)
                    .repeatForever(autoreverses: false), value: animScale)
         ).onAppear {
             animScale = 2
         }
         
        // .blur(radius: (animScale - 1) * 3)
        
        
        
        
        
    }
}

#Preview {
    ContentView()
}
