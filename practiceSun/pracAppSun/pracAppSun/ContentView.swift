//
//  ContentView.swift
//  pracAppSun
//
//  Created by comviva on 27/09/26.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var user: User5 = User5()
    @ObservedObject var account: Account = Account()
    var body: some View {
        NavigationStack {
            NavigationLink(destination: File1()) {
                Text("Go to Video '1' Declarative")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(minWidth: 50, maxWidth: 280, minHeight: 20, maxHeight: 20, alignment: .center)
                    .padding()
                    .background(.purple)
                    .cornerRadius(10)
            }
            NavigationLink(destination: File2()) {
                Text("Go to Video '2' HStack VStack")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(minWidth: 50, maxWidth: 280, minHeight: 20, maxHeight: 20, alignment: .center)
                    .padding()
                    .background(.pink)
                    .cornerRadius(10)
            }
            NavigationLink(destination: File3()) {
                Text("Go to video '3' State Wrapper")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(minWidth: 50, maxWidth: 280, minHeight: 20, maxHeight: 20, alignment: .center)
                    .padding()
                    .background(.purple)
                    .cornerRadius(10)
                
            }
            NavigationLink(destination: File4()) {
                Text("Go to video '5' Observable Wrapper")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(minWidth: 50, maxWidth: 280, minHeight: 20, maxHeight: 20, alignment: .center)
                    .padding()
                    .background(.pink)
                    .cornerRadius(10)
                
            }
            NavigationLink(destination: File5()) {
                Text("Go to video '6' Environment Wrapper")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(minWidth: 50, maxWidth: 280, minHeight: 20, maxHeight: 20, alignment: .center)
                    .padding()
                    .background(.purple)
                    .cornerRadius(10)
                
            }
            NavigationLink(destination: File6()) {
                Text("Go to video '8' List & NavView")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(minWidth: 50, maxWidth: 280, minHeight: 20, maxHeight: 20, alignment: .center)
                    .padding()
                    .background(.pink)
                    .cornerRadius(10)
                
            }
            NavigationLink(destination: File7()) {
                Text("Go to video '9' TabView")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(minWidth: 50, maxWidth: 280, minHeight: 20, maxHeight: 20, alignment: .center)
                    .padding()
                    .background(.purple)
                    .cornerRadius(10)
                
            }
            
            NavigationLink(destination: File8()) {
                Text("Go to video '10' SearchBar UIViewRepntable")
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .frame(width: 280, height: 20, alignment: .center)
                    .padding()
                    .background(.pink)
                    .cornerRadius(10)
            }
            
            NavigationLink(destination: File9()) {
                Text("Video '12' UIVCRptble UIImgPickrCtrl UIActivity")
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .frame(width: 310, height: 20, alignment: .center)
                    .padding()
                    .background(.purple)
                    .cornerRadius(10)
            }
            
            
        }.environmentObject(user)
         .environmentObject(account)
    }
}

#Preview {
    ContentView()
}
