//
//  ContentView.swift
//  06-Animation
//
//  Created by Sayed on 20/10/25.
//

import SwiftUI


struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(active: CornerRotateModifier(amount: -90, anchor: .topLeading), identity: CornerRotateModifier(amount: 0, anchor: .topLeading))
    }
}



struct ContentView: View {
    @State private var isRedShown: Bool = false
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 200, height: 200)
            
            if isRedShown {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 200, height: 200)
                    .transition(.pivot)
            }
        }.onTapGesture {
            withAnimation {
                isRedShown.toggle()
            }
        }
    }
    
}


struct RectangleView: View {
    @State private var isRed: Bool = false
    var body: some View {
        VStack {
            Button("Tap me!!") {
                withAnimation {
                    isRed.toggle()
                }
            }
            
            if isRed {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 200, height: 200)
                    .transition(.scale)
                
            }
        }
    
    }
}


struct SnakeLetters: View {
    let letters = Array("Hello SwiftUI")
    @State private var enabled = false
    @State private var dragAmount: CGSize = .zero
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<letters.count, id: \.self) { num in
                Text(String(letters[num]))
                    .padding(5)
                    .font(.title)
                    .background(enabled ? .blue : .red)
                    .offset(dragAmount)
                    .animation(.linear.delay(Double(num) / 20), value: dragAmount)
            }
        }.gesture(
            DragGesture()
                .onChanged { dragAmount = $0.translation }
                .onEnded { _ in
                    dragAmount = .zero
                    enabled.toggle()
                }
            
        )
    }
}


struct CardDrag: View {
    @State private var dragAmount = CGSize.zero
    var body: some View {
        LinearGradient(colors: [.yellow, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
            .frame(width: 300, height: 200)
            .clipShape(.rect(cornerRadius: 10))
            .offset(dragAmount)
            .gesture(DragGesture()
                .onChanged { dragAmount = $0.translation }
                .onEnded({ _ in
                    withAnimation(.bouncy) {   // anim applied only on return, easy to drag
                        dragAmount = .zero
                    }
                })
            )
          //  .animation(.bouncy, value: dragAmount) /// HEAVY to drag, anim applied to strt end drag
    }
}
struct WobbleButton: View {
    @State private var enabled = false
    var body: some View {
        Button("Tappuu mui !!eheh") {
            enabled.toggle()
        }
        .frame(width: 200, height: 200)
        .background(enabled ? Color.green : Color.red)
        .foregroundStyle(.white)
        .animation(.default, value: enabled)
        .clipShape(.rect(cornerRadius: enabled ? 60 : 0))
        .animation(.spring(duration: 1, bounce: 0.9), value: enabled)
        
    }
}
struct _3DAnimationButton: View {
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
