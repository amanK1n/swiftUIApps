//
//  ContentView.swift
//  slot-machine
//
//  Created by Sayed on 21/06/24.
//

import SwiftUI
struct Hexagon: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            let p1 = CGPoint(x: 0, y: 20)
            let p2 = CGPoint(x: 0, y: rect.height - 20)
            let p3 = CGPoint(x: rect.width / 2, y: rect.height)
            let p4 = CGPoint(x: rect.width, y: rect.height - 20)
            let p5 = CGPoint(x: rect.width, y: 20)
            let p6 = CGPoint(x: rect.width / 2, y: 0)
            
            path.move(to: p6)
            path.addArc(tangent1End: p1, tangent2End: p2, radius: 15)
            path.addArc(tangent1End: p2, tangent2End: p3, radius: 15)
            path.addArc(tangent1End: p3, tangent2End: p4, radius: 15)
            path.addArc(tangent1End: p4, tangent2End: p5, radius: 15)
            path.addArc(tangent1End: p5, tangent2End: p6, radius: 15)
            path.addArc(tangent1End: p6, tangent2End: p1, radius: 15)
            
        }
    }
}

enum Choice: Int, Identifiable {
    var id: Int {
        rawValue
    }
    case success
    case failure
}

struct ContentView: View {
    @State public var symobols = ["eating", "happy", "love", "scary", "sleeping"]
    @State public var numbers = [0, 1, 2, 3, 4]
    @State public var counter = 0
    @State private var showingAlert: Choice?
    
    var body: some View {
        ZStack {
            Image("sunshine")
                .resizable()
                .ignoresSafeArea()
            VStack(spacing: 10) {
                HStack {
                    Image("fire")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .shadow(color: .orange, radius: 5, y: 5)
                    Text("SLOT MACHINE")
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .font(.system(size: 30))
                        .shadow(color: .orange, radius: 5, y: 5)
                    Image("fire")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .shadow(color: .orange, radius: 5, y: 5)
                }.frame(width: .infinity, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Text("Turns Left: \(5 - counter)")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .shadow(color: .orange, radius: 5, y: 5)
                HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 40) {
                    Hexagon()
                        .fill(Color.white)
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 120, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 7,y: 7)
                        .opacity(0.8)
                        .overlay(Image(symobols[numbers[0]])
                            .resizable()
                            .frame(width: 90, height: 90, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        
                        )
                    Hexagon()
                        .fill(Color.white)
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 120, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 7,y: 7)
                        .opacity(0.8)
                        .overlay(Image(symobols[numbers[1]])
                        .resizable()
                        .frame(width: 90, height: 90, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/))
                    
                }
                Hexagon()
                    .fill(Color.white)
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 120, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 7,y: 7)
                    .opacity(0.8)
                    .overlay(Image(symobols[numbers[2]])
                    .resizable()
                    .frame(width: 90, height: 90, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/))
                HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 40) {
                    Hexagon()
                        .fill(Color.white)
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 120, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 7,y: 7)
                        .opacity(0.8)
                        .overlay(Image(symobols[numbers[1]])
                        .resizable()
                        .frame(width: 90, height: 90, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/))
                    Hexagon()
                        .fill(Color.white)
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 120, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 7,y: 7)
                        .opacity(0.8)
                        .overlay(Image(symobols[numbers[2]])
                        .resizable()
                        .frame(width: 90, height: 90, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/))
                    
                }
                VStack {
                    Text("")
                    Text("")
                    Text("")
                }
                Button(action: {
                    numbers[0] = Int.random(in: 0...self.symobols.count - 1)
                    numbers[1] = Int.random(in: 0...self.symobols.count - 1)
                    numbers[2] = Int.random(in: 0...self.symobols.count - 1)
                    
                    counter += 1
                    if numbers[0] == numbers[1] &&
                        numbers[1] == numbers[2]
                    
                    {
                        self.showingAlert = .success
                        counter = 0
                    }
                    if counter >= 5 {
                        self.showingAlert = .failure
                        counter = 0
                    }
                }, label: {
                    Hexagon()
                        .fill(Color(.color))
                        .frame(width: 350, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .overlay(
                        Text("SPIN")
                            .font(.system(size: 40))
                            .fontWeight(.bold)
                            .foregroundColor(.black)

                        )
                }).shadow(color: .gray, radius: 5, y: 5)
            }
            
            .alert(item: $showingAlert) { alert -> Alert in
                switch alert {
                case .success:
                    return Alert(title: Text("Yahh !! you won"), message: Text("Born to win"), dismissButton: .cancel())
                case .failure:
                    return Alert(title: Text("You Looose"), message: Text("Better luck next time"), dismissButton: .cancel())
                }
            }
            
        }
    }
}

#Preview {
    ContentView()
}
