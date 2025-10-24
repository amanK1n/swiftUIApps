//
//  ContentView.swift
//  06-Animation
//
//  Created by Sayed on 20/10/25.
//

import SwiftUI

struct ContentView: View {
    @State private var animationAmount = 0.0
    var body: some View {
        Button("Tappu mehhhh!!") {
            withAnimation(.spring(duration: 1, bounce: 0.5)) {
                animationAmount += 360
            }
        }.padding(50)
            .background(.red)
            .foregroundStyle(.white)
            .clipShape(.circle)
            .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
    }
}



struct StepperButton: View {
    @State private var animationAmount = 1.0
    var body: some View {
        VStack {
            Stepper("Scale Amount", value: $animationAmount.animation(
                .easeInOut(duration: 1)
                .repeatCount(3, autoreverses: true)
            ), in: 1...10)
            Spacer()
            Button("Tappu Mehh!") {
                animationAmount += 1
            }.padding(40)
                .background(.red)
                .foregroundStyle(.white)
                .clipShape(.circle)
                .scaleEffect(animationAmount)
        }
    }
}

struct BlinkerButton: View {
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
