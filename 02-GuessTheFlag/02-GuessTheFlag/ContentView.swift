//
//  ContentView.swift
//  02-GuessTheFlag
//
//  Created by Sayed on 30/09/25.
//

import SwiftUI

struct ContentView: View {
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
            VStack(spacing: 15) {
                VStack {
                    Text("Tap the flag of..")
                        .foregroundStyle(.secondary)
                        .font(.subheadline.weight(.heavy))
                    
                    Text(countries[correctAnswer])
                        .font(.largeTitle.weight(.semibold))
                }
                ForEach(0..<3) { item in
                    Button {
                        flagTapped(item)
                    } label: {
                        Image(countries[item])
                            .clipShape(.buttonBorder)
                            .shadow(radius: 10)
                    }
                }
            }.frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(.rect(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score: ???")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Spacer()
            }.padding()
        }.alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is ???")
        }
        .ignoresSafeArea()
        
        
    }
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
        } else {
            scoreTitle = "Wrong"
        }

        showingScore = true
    }
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

#Preview {
    ContentView()
}




















/// Below codes are for syntax only
struct CustomAlertView: View {
    @State private var showingAlert = false
    var body: some View {
        Button("Show alert") {
            showingAlert = true
        }.buttonStyle(.bordered)
            .alert("Important Message !!!", isPresented: $showingAlert) {
                
                Button("Deletois", role: .destructive) {}
                Button("Cancelois", role: .cancel) {}
            }
    }
}
struct ButtonView: View {
    var body: some View {
        /// Type-1
        Button("Button 1") {
            print("Now deleting...1")
        }.buttonStyle(.bordered)
        /// Type-2
        Button("Button 2", role: .destructive, action: execDlt)
            .buttonStyle(.bordered)
        /// Type-3
        Button("Button 3", role: .destructive) {}
            .buttonStyle(.borderedProminent)
        /// Type-4
        Button("Button 4") {}
            .buttonStyle(.borderedProminent)
            .tint(.purple)
        /// Type-5
        Button {
            print("Custom Button-5 clicked !!")
        } label: {
            Text("Button 6")
                .padding()
                .foregroundStyle(.white)
                .background(.red)
        }
        /// Type-6
        Button {
            print("Only img in btn-6")
        } label: {
            Image(systemName: "pencil.circle")
        }
        /// Type-7
        Button("Button 7", systemImage: "pencil.circle") {
            print("img with txt in btn-7")
        }
        /// Type-8
        Button {
            print("img with txt in btn-8")
        } label: {
            HStack {
                Text("Edit-8")
                Image(systemName: "pencil.circle")
            }
        }
        /// Type-9
        Button {
            print("img with txt in btn-9")
        } label: {
            Label("Edit-9", systemImage: "pencil")
        }
    }
    func execDlt() {
        print("Now deleting...2")
    }
}





struct GradientView1: View {
    var body: some View {
        /// Style -1
        // LinearGradient(colors: [.purple, .mint], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
        
        /// Style -2
        // LinearGradient(stops: [Gradient.Stop(color: .white, location: 0.40), Gradient.Stop(color: .black, location: 0.60)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
        /// Style -3
       // RadialGradient(colors: [.blue, .black], center: .top, startRadius: 20, endRadius: 200).ignoresSafeArea()
        /// Style -4
      ///  AngularGradient(colors: [.red, .yellow, .green, .blue, .purple, .red], center: .center).ignoresSafeArea()
        Text("Your Text")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundStyle(.white)
            .background(.mint.gradient)
    }
}





struct PracticeView3: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Color.red
                Color.blue
                
            }
        Text("Sayed Aman Konen")
                .foregroundStyle(.secondary)
                .padding(50)
                .frame(maxWidth: .infinity, maxHeight: 244)
                .background(.ultraThinMaterial)
                
        
        }.ignoresSafeArea()
    }
}

struct PracticeView2: View {
    var body: some View {
        ZStack {
           
            Text("ZStack-1")
        }.background(Color.red)
        
        ZStack {
            Text("ZStack-2")
                .background(Color.green)
        }
        
        ZStack {
            
            
            Color.mint
            Text("ZStack-3")
        }.ignoresSafeArea()
        ZStack {
            
           
            Color.secondary
                .frame(minWidth: 200, maxWidth: .infinity, maxHeight: 200)
            Text("ZStack-4")
                .font(.largeTitle)
                .foregroundColor(.primary)
        }
    }
}

struct PracticeView: View {
    var body: some View {
        Spacer()
        VStack {
           Text("Hello, world!")
           Text("This is another line\n")
        }
       
        VStack(spacing: 13) {
           Text("This used spacing 13!")
           Text("This is another line\n")
        }
        Spacer()
        VStack(alignment: .leading) {
           Text("This used leading alignment!")
           Text("This is another line\n")
        }
        Spacer()
        HStack(spacing: -10) {
           Text("This HStack!")
           Text("This is another line")
        }
        Spacer()
    }
}
