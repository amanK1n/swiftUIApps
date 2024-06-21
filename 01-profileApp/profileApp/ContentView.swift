//
//  ContentView.swift
//  profileApp
//
//  Created by Sayed on 20/06/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .center) {
                
                VStack(alignment: .center, spacing: 20) {
                    Spacer()
                    Image("MaleUser")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 180, height: 180, alignment: .top)
                        .clipShape(Circle())
                        .shadow(color: .blue, radius: 20, x: 20, y: 20)
                    Text("Aman")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    Text("iOS | Full stack developer")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .font(.body)
                    HStack(spacing: 20) {
                        Image(systemName: "heart.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Image(systemName: "network")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Image(systemName: "message.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Image(systemName: "phone.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                    }
                    .foregroundColor(.white)
                    .frame(width: 250, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .shadow(radius: 5, y: 8)
                    
                    Spacer()
                    VStack(alignment: .center, spacing: 30) {
                        RoundedRectangle(cornerRadius: 125)
                            .frame(width: 200, height: 50, alignment: .top)
                            .foregroundColor(.white)
                            .shadow(color: .blue, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, y: 8)
                            .overlay(Text("Follow")
                                .foregroundColor(.blue)
                                .font(.system(size: 20))
                                .italic()
                                .fontWeight(.heavy)
                            
                            )
                        HStack(alignment: .center, spacing: 10) {
                            VStack {
                                Text("222")
                                    .foregroundColor(.white)
                                    .font(.title)
                                Text("Appreciations")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            }
                            VStack {
                                Text("222")
                                    .foregroundColor(.white)
                                    .font(.title)
                                Text("Followers")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            }
                            VStack {
                                Text("222")
                                    .foregroundColor(.white)
                                    .font(.title)
                                Text("Following")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            }
                            
                        }
                    
                        Text("About You")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                            .italic()
                            .shadow(color: .white, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 8)
                        Text("I am a fullstack iOS App developer. \nWelcome to the series of iOS Apps")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                            .opacity(0.8)
                        
                    }
                    Spacer()
                }
                
            }
        }
    }
}

#Preview {
    ContentView()
}
